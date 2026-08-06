import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

abstract interface class DocumentPickerDataSource {
  Future<List<String>> pickPdfFiles();

  Future<List<String>> pickImageFiles();
}

@LazySingleton(as: DocumentPickerDataSource)
final class PluginDocumentPickerDataSource implements DocumentPickerDataSource {
  PluginDocumentPickerDataSource(this._imagePicker);

  final ImagePicker _imagePicker;

  @override
  Future<List<String>> pickPdfFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
      allowMultiple: true,
      withData: false,
    );

    return result?.files.map((file) => file.path).nonNulls.toList() ?? const [];
  }

  @override
  Future<List<String>> pickImageFiles() async {
    final images = await _imagePicker.pickMultiImage();
    return images.map((image) => image.path).toList();
  }
}
