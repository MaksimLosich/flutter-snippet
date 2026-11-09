import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract interface class DocumentScannerDataSource {
  Future<List<String>> scanImages();

  Future<void> deleteScannedImages(Iterable<String> imageAbsolutePaths);
}

@LazySingleton(as: DocumentScannerDataSource)
final class CunningDocumentScannerDataSource implements DocumentScannerDataSource {
  @override
  Future<List<String>> scanImages() async {
    return await CunningDocumentScanner.getPictures() ?? const [];
  }

  @override
  Future<void> deleteScannedImages(Iterable<String> imageAbsolutePaths) async {
    if (imageAbsolutePaths.isNotEmpty) {
      try {
        final documentsRoot = await (await getApplicationDocumentsDirectory()).resolveSymbolicLinks();
        final scannerOutputRoots = await _scannerOutputRoots();
        for (final path in imageAbsolutePaths.toSet()) {
          try {
            await _deleteIfOwned(path, documentsRoot, scannerOutputRoots);
          } on FileSystemException {
            continue;
          }
        }
      } on Exception {
        return;
      }
    }
  }

  Future<List<String>> _scannerOutputRoots() async {
    final directories = <Directory>[await getTemporaryDirectory()];
    if (Platform.isAndroid) {
      directories.addAll(await getExternalCacheDirectories() ?? const []);
      directories.addAll(await getExternalStorageDirectories(type: StorageDirectory.pictures) ?? const []);
    }
    return Future.wait(directories.map((directory) => directory.resolveSymbolicLinks()));
  }

  Future<void> _deleteIfOwned(String path, String documentsRoot, List<String> scannerOutputRoots) async {
    final isAbsolutePath = p.isAbsolute(path);
    final isImageFile = {'.jpg', '.jpeg', '.png'}.contains(p.extension(path).toLowerCase());
    if (isAbsolutePath && isImageFile) {
      final file = File(path);
      final exists = await file.exists();
      if (exists) {
        final resolvedPath = await file.resolveSymbolicLinks();
        final isInDocumentsRoot = p.equals(p.dirname(resolvedPath), documentsRoot);
        final isInScannerOutputRoot = scannerOutputRoots.any((root) => p.isWithin(root, resolvedPath));
        if (isInDocumentsRoot || isInScannerOutputRoot) {
          await file.delete();
        }
      }
    }
  }
}
