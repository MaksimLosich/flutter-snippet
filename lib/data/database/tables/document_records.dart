import 'package:drift/drift.dart';

class DocumentRecords extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get pdfPath => text()();

  TextColumn get firstPreviewPath => text()();

  TextColumn get lastPreviewPath => text().nullable()();

  BoolColumn get isSigned => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();
}
