import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/document_records.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [DocumentRecords])
final class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'test_task_documents'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          await migrator.addColumn(documentRecords, documentRecords.isSigned);
        }
      },
    );
  }
}
