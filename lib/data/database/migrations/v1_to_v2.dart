part of '../app_database.dart';

Future<void> _migrateV1ToV2(Migrator migrator, AppDatabase database) {
  return migrator.addColumn(
    database.documentRecords,
    database.documentRecords.isSigned,
  );
}
