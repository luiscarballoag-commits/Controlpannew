import 'package:hive_flutter/hive_flutter.dart';

import '../../models/elaboration/elaboration_record.dart';

class ElaborationRecordService {
  final Box<ElaborationRecord> box = Hive.box<ElaborationRecord>(
    'elaboration_records',
  );

  Future<void> saveRecord({
    required String productionId,
    required String productName,
    required int quantity,
  }) async {
    final record = ElaborationRecord(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      productionId: productionId,
      productName: productName,
      quantity: quantity,
      date: DateTime.now(),
    );

    await box.add(record);
  }

  List<ElaborationRecord> getAll() {
    return box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }
}
