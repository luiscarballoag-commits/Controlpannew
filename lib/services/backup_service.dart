import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BackupService {
  static const String backupVersion = '1.0';

  static const List<String> _boxNames = [
    'ingredients',
    'recipes',
    'productions',
    'elaboration_records',
    'inventory_movements',
    'inventory',
    'costs',
    'products',
    'product_components',
    'labor_workers',
    'depreciation_assets',
    'operating_expenses',
    'elaboration_recipes',
    'elaboration_productions',
    'settings',
  ];

  Future<File?> createBackup() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final tempDirectory = await getTemporaryDirectory();

    late Uint8List backupBytes;

    await Hive.close();

    try {
      final archive = Archive();

      for (final boxName in _boxNames) {
        final hiveFile = File('${appDirectory.path}/$boxName.hive');
        final compactedFile = File('${appDirectory.path}/$boxName.hivec');

        if (await hiveFile.exists()) {
          final bytes = await hiveFile.readAsBytes();
          archive.addFile(
            ArchiveFile(
              '$boxName.hive',
              bytes.length,
              bytes,
            ),
          );
        }

        if (await compactedFile.exists()) {
          final bytes = await compactedFile.readAsBytes();
          archive.addFile(
            ArchiveFile(
              '$boxName.hivec',
              bytes.length,
              bytes,
            ),
          );
        }
      }

      const metadata = 'ControlPan Backup\nVersion: $backupVersion\n';
      final metadataBytes = Uint8List.fromList(metadata.codeUnits);

      archive.addFile(
        ArchiveFile(
          'backup_info.txt',
          metadataBytes.length,
          metadataBytes,
        ),
      );

      final zipBytes = ZipEncoder().encode(archive);

      if (zipBytes == null || zipBytes.isEmpty) {
        return null;
      }

      backupBytes = Uint8List.fromList(zipBytes);
    } finally {
      await _reopenBoxes();
    }

    if (backupBytes.isEmpty) {
      return null;
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final temporaryFile = File(
      '${tempDirectory.path}/ControlPan_Respaldo_$timestamp.zip',
    );

    await temporaryFile.writeAsBytes(
      backupBytes,
      flush: true,
    );

    final result = await FilePicker.saveFile(
      dialogTitle: 'Guardar respaldo de ControlPan',
      fileName: 'ControlPan_Respaldo_$timestamp.zip',
      bytes: backupBytes,
      mimeType: 'application/zip',
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result == null) {
      return null;
    }

    return temporaryFile;
  }

  Future<void> shareBackup(File file) async {
    if (!await file.exists()) {
      throw Exception('El archivo temporal del respaldo no existe.');
    }

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'Respaldo de ControlPan',
        text: 'Respaldo de datos de ControlPan',
      ),
    );
  }

  Future<bool> restoreBackup() async {
    final result = await FilePicker.pickFiles(
      dialogTitle: 'Seleccionar respaldo de ControlPan',
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result.isEmpty) {
      return false;
    }

    final selectedFile = result.single;
    final bytes = await selectedFile.readAsBytes();

    if (bytes.isEmpty) {
      throw Exception(
        'No se pudo leer el archivo de respaldo seleccionado.',
      );
    }

    final archive = ZipDecoder().decodeBytes(bytes);

    final metadataFile = _findArchiveFile(
      archive,
      'backup_info.txt',
    );

    if (metadataFile == null) {
      throw Exception(
        'El archivo seleccionado no contiene un respaldo válido de ControlPan.',
      );
    }

    final metadata = utf8.decode(
      metadataFile.content as List<int>,
      allowMalformed: true,
    );

    if (!metadata.contains('ControlPan Backup') ||
        !metadata.contains('Version: $backupVersion')) {
      throw Exception(
        'La versión del respaldo no es compatible con ControlPan.',
      );
    }

    final backupFiles = <ArchiveFile>[];

    for (final boxName in _boxNames) {
      final hiveFile = _findArchiveFile(
        archive,
        '$boxName.hive',
      );

      final compactedFile = _findArchiveFile(
        archive,
        '$boxName.hivec',
      );

      if (hiveFile != null) {
        backupFiles.add(hiveFile);
      }

      if (compactedFile != null) {
        backupFiles.add(compactedFile);
      }
    }

    if (backupFiles.isEmpty) {
      throw Exception(
        'El respaldo no contiene datos de ControlPan.',
      );
    }

    final appDirectory = await getApplicationDocumentsDirectory();
    final tempDirectory = await getTemporaryDirectory();
    final rollbackDirectory = Directory(
      '${tempDirectory.path}/controlpan_restore_rollback',
    );

    if (await rollbackDirectory.exists()) {
      await rollbackDirectory.delete(recursive: true);
    }

    await rollbackDirectory.create(recursive: true);

    await Hive.close();

    try {
      await _createRollback(
        appDirectory,
        rollbackDirectory,
      );

      await _removeHiveFiles(appDirectory);

      for (final archiveFile in backupFiles) {
        final outputFile = File(
          '${appDirectory.path}/${archiveFile.name}',
        );

        await outputFile.writeAsBytes(
          archiveFile.content as List<int>,
          flush: true,
        );
      }

      await _reopenBoxes();

      await rollbackDirectory.delete(recursive: true);

      return true;
    } catch (error) {
      await _restoreRollback(
        appDirectory,
        rollbackDirectory,
      );

      await _reopenBoxes();

      if (await rollbackDirectory.exists()) {
        await rollbackDirectory.delete(recursive: true);
      }

      throw Exception(
        'No se pudo restaurar el respaldo. '
        'Los datos anteriores fueron conservados. '
        'Detalle: $error',
      );
    }
  }

  ArchiveFile? _findArchiveFile(
    Archive archive,
    String name,
  ) {
    for (final file in archive.files) {
      if (file.name == name && file.isFile) {
        return file;
      }
    }

    return null;
  }

  Future<void> _createRollback(
    Directory appDirectory,
    Directory rollbackDirectory,
  ) async {
    for (final boxName in _boxNames) {
      for (final extension in ['hive', 'hivec']) {
        final source = File(
          '${appDirectory.path}/$boxName.$extension',
        );

        if (await source.exists()) {
          final destination = File(
            '${rollbackDirectory.path}/$boxName.$extension',
          );

          await source.copy(destination.path);
        }
      }
    }
  }

  Future<void> _removeHiveFiles(
    Directory appDirectory,
  ) async {
    for (final boxName in _boxNames) {
      for (final extension in ['hive', 'hivec']) {
        final file = File(
          '${appDirectory.path}/$boxName.$extension',
        );

        if (await file.exists()) {
          await file.delete();
        }
      }
    }
  }

  Future<void> _restoreRollback(
    Directory appDirectory,
    Directory rollbackDirectory,
  ) async {
    await _removeHiveFiles(appDirectory);

    if (!await rollbackDirectory.exists()) {
      return;
    }

    await for (final entity in rollbackDirectory.list()) {
      if (entity is File) {
        final destination = File(
          '${appDirectory.path}/${entity.uri.pathSegments.last}',
        );

        await entity.copy(destination.path);
      }
    }
  }

  Future<void> _reopenBoxes() async {
    for (final boxName in _boxNames) {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox(boxName);
      }
    }
  }
}
