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

    await Hive.close();

    try {
      final archive = Archive();

      for (final boxName in _boxNames) {
        final hiveFile = File(
          '${appDirectory.path}/$boxName.hive',
        );

        final compactedFile = File(
          '${appDirectory.path}/$boxName.hivec',
        );

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

      final metadata = ArchiveFile(
        'backup_info.txt',
        backupVersion.length,
        backupVersion.codeUnits,
      );

      archive.addFile(metadata);

      final zipBytes = ZipEncoder().encode(archive);

      if (zipBytes == null || zipBytes.isEmpty) {
        return null;
      }

      final backupBytes = Uint8List.fromList(zipBytes);

      final result = await FilePicker.saveFile(
        dialogTitle: 'Guardar respaldo de ControlPan',
        fileName:
            'ControlPan_Respaldo_${DateTime.now().millisecondsSinceEpoch}.zip',
        bytes: backupBytes,
        mimeType: 'application/zip',
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (result == null) {
        return null;
      }

      return File(result.toFilePath());
    } finally {
      await _reopenBoxes();
    }
  }

  Future<void> shareBackup(File file) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'Respaldo de ControlPan',
        text: 'Respaldo de datos de ControlPan',
      ),
    );
  }

  Future<void> _reopenBoxes() async {
    for (final boxName in _boxNames) {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox(boxName);
      }
    }
  }
}
