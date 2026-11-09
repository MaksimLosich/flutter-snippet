import 'dart:typed_data';

final class DocumentPreviewImages {
  const DocumentPreviewImages({required this.first, this.last});

  final Uint8List first;
  final Uint8List? last;
}
