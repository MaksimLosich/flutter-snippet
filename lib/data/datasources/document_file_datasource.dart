import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:test_task/data/models/preview_page.dart';
import 'package:test_task/data/models/stored_document_path.dart';

abstract interface class DocumentFileDataSource {
  Future<StoredDocumentPath> copyPdfToStorage(String sourceAbsolutePath);

  Future<StoredDocumentPath> writePdf(Uint8List pdfBytes);

  Future<StoredDocumentPath> writePreview(
    Uint8List jpegBytes, {
    required StoredDocumentPath pdfPath,
    required PreviewPage page,
  });

  Future<String> resolveStoredPath(StoredDocumentPath storedPath);

  Future<void> deleteStoredFiles(Iterable<StoredDocumentPath> storedPaths);
}

@LazySingleton(as: DocumentFileDataSource)
final class LocalDocumentFileDataSource implements DocumentFileDataSource {
  LocalDocumentFileDataSource();

  static const _documentsDirectoryName = 'documents';
  static const _previewsDirectoryName = 'document_previews';
  static const _fallbackFileName = 'document';
  static const _pdfExtension = '.pdf';

  @override
  Future<StoredDocumentPath> copyPdfToStorage(String sourceAbsolutePath) async {
    if (!p.isAbsolute(sourceAbsolutePath)) {
      throw ArgumentError.value(sourceAbsolutePath, 'sourceAbsolutePath');
    }

    final storedPath = _newStoredPath(
      _documentsDirectoryName,
      p.basenameWithoutExtension(sourceAbsolutePath),
      _pdfExtension,
    );
    return _writeAtomically(storedPath, (temporaryFile) async {
      await File(sourceAbsolutePath).copy(temporaryFile.path);
    });
  }

  @override
  Future<StoredDocumentPath> writePdf(Uint8List pdfBytes) {
    final storedPath = _newStoredPath(_documentsDirectoryName, _fallbackFileName, _pdfExtension);
    return _writeAtomically(storedPath, (temporaryFile) => temporaryFile.writeAsBytes(pdfBytes, flush: true));
  }

  @override
  Future<StoredDocumentPath> writePreview(
    Uint8List jpegBytes, {
    required StoredDocumentPath pdfPath,
    required PreviewPage page,
  }) {
    final storedPath = _newStoredPath(
      _previewsDirectoryName,
      '${p.basenameWithoutExtension(pdfPath.value)}_${page.name}',
      '.jpg',
    );
    return _writeAtomically(storedPath, (temporaryFile) => temporaryFile.writeAsBytes(jpegBytes, flush: true));
  }

  @override
  Future<String> resolveStoredPath(StoredDocumentPath storedPath) async {
    final value = storedPath.value;
    if (value.isEmpty) {
      throw ArgumentError.value(value, 'storedPath');
    }

    final root = p.normalize(await _rootPath);
    final String absolutePath;
    if (p.isAbsolute(value)) {
      final normalized = p.normalize(value);
      absolutePath = _isManagedPath(root, normalized) ? normalized : _recoverLegacyAbsolutePath(root, normalized);
    } else {
      if (p.split(value).contains('..')) {
        throw ArgumentError.value(value, 'storedPath');
      }
      absolutePath = p.normalize(p.join(root, value));
    }

    if (!_isManagedPath(root, absolutePath)) {
      throw ArgumentError.value(value, 'storedPath');
    }
    return absolutePath;
  }

  @override
  Future<void> deleteStoredFiles(Iterable<StoredDocumentPath> storedPaths) async {
    final existingPaths = <String>{};
    for (final storedPath in storedPaths) {
      final absolutePath = await resolveStoredPath(storedPath);
      if (await File(absolutePath).exists()) {
        await _validateManagedParent(absolutePath);
        existingPaths.add(absolutePath);
      }
    }

    for (final absolutePath in existingPaths) {
      await File(absolutePath).delete();
    }
  }

  Future<StoredDocumentPath> _writeAtomically(
    StoredDocumentPath storedPath,
    Future<void> Function(File temporaryFile) write,
  ) async {
    final destination = File(await resolveStoredPath(storedPath));
    await destination.parent.create(recursive: true);
    await _validateManagedParent(destination.path);
    final temporaryFile = File('${destination.path}.${_uniqueToken()}.tmp');

    try {
      await write(temporaryFile);
      await temporaryFile.rename(destination.path);
      return storedPath;
    } catch (_) {
      if (await temporaryFile.exists()) {
        await temporaryFile.delete();
      }
      rethrow;
    }
  }

  Future<void> _validateManagedParent(String absolutePath) async {
    final root = await Directory(await _rootPath).resolveSymbolicLinks();
    final parent = await Directory(p.dirname(absolutePath)).resolveSymbolicLinks();
    if (!p.isWithin(root, parent)) {
      throw FileSystemException('Path leaves app storage', absolutePath);
    }
  }

  Future<String> get _rootPath async {
    final root = await getApplicationDocumentsDirectory();
    return root.path;
  }

  bool _isManagedPath(String root, String path) {
    return p.isWithin(p.join(root, _documentsDirectoryName), path) ||
        p.isWithin(p.join(root, _previewsDirectoryName), path);
  }

  String _recoverLegacyAbsolutePath(String root, String path) {
    final extension = p.extension(path).toLowerCase();
    final directoryName = switch (extension) {
      _pdfExtension => _documentsDirectoryName,
      '.jpg' || '.jpeg' || '.png' => _previewsDirectoryName,
      _ => null,
    };
    if (directoryName == null || p.basename(p.dirname(path)) != directoryName) {
      throw ArgumentError.value(path, 'storedPath');
    }
    return p.join(root, directoryName, p.basename(path));
  }

  StoredDocumentPath _newStoredPath(String directoryName, String rawName, String extension) {
    final safeName = rawName.trim().replaceAll(RegExp(r'[^a-zA-Z0-9-]+'), '_');
    final name = safeName.isEmpty ? _fallbackFileName : safeName;
    return StoredDocumentPath(p.join(directoryName, '${_uniqueToken()}_$name$extension'));
  }

  String _uniqueToken() {
    final random = math.Random.secure().nextInt(1 << 32).toRadixString(16);
    return '${DateTime.now().microsecondsSinceEpoch}_$random';
  }
}
