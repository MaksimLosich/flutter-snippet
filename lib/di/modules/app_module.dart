import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:test_task/data/database/app_database.dart';

@module
abstract class AppModule {
  @lazySingleton
  AppDatabase get appDatabase => AppDatabase();

  @lazySingleton
  ImagePicker get imagePicker => ImagePicker();
}
