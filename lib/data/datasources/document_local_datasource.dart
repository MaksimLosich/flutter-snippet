import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:test_task/data/database/app_database.dart';

abstract interface class DocumentLocalDataSource {
  Stream<List<DocumentRecord>> watchDocuments();

  Future<List<DocumentRecord>> getDocumentsByIds(Set<int> ids);

  Future<List<String>> getDocumentTitles();

  Future<void> insertDocument({
    required String title,
    required String pdfPath,
    required String firstPreviewPath,
    required String? lastPreviewPath,
  });

  Future<void> setDocumentSigned({required int id, required bool isSigned});

  Future<void> deleteDocumentsByIds(List<int> ids);
}

@LazySingleton(as: DocumentLocalDataSource)
final class DriftDocumentLocalDataSource implements DocumentLocalDataSource {
  const DriftDocumentLocalDataSource(this._database);

  final AppDatabase _database;

  @override
  Stream<List<DocumentRecord>> watchDocuments() {
    final query = _database.select(_database.documentRecords)
      ..orderBy([
        (table) => OrderingTerm(expression: table.createdAt, mode: OrderingMode.desc),
        (table) => OrderingTerm(expression: table.id, mode: OrderingMode.desc),
      ]);
    return query.watch();
  }

  @override
  Future<List<DocumentRecord>> getDocumentsByIds(Set<int> ids) {
    if (ids.isEmpty) {
      return Future.value(const []);
    }

    return (_database.select(_database.documentRecords)..where((table) => table.id.isIn(ids))).get();
  }

  @override
  Future<List<String>> getDocumentTitles() async {
    final title = _database.documentRecords.title;
    final query = _database.selectOnly(_database.documentRecords)..addColumns([title]);
    final rows = await query.get();
    return rows.map((row) => row.read(title) ?? (throw StateError('Document title is missing'))).toList();
  }

  @override
  Future<void> insertDocument({
    required String title,
    required String pdfPath,
    required String firstPreviewPath,
    required String? lastPreviewPath,
  }) {
    return _database
        .into(_database.documentRecords)
        .insert(
          DocumentRecordsCompanion.insert(
            title: title,
            pdfPath: pdfPath,
            firstPreviewPath: firstPreviewPath,
            lastPreviewPath: Value(lastPreviewPath),
            createdAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<void> setDocumentSigned({required int id, required bool isSigned}) {
    return (_database.update(
      _database.documentRecords,
    )..where((table) => table.id.equals(id))).write(DocumentRecordsCompanion(isSigned: Value(isSigned)));
  }

  @override
  Future<void> deleteDocumentsByIds(List<int> ids) {
    if (ids.isEmpty) {
      return Future.value();
    }

    return (_database.delete(_database.documentRecords)..where((table) => table.id.isIn(ids))).go();
  }
}
