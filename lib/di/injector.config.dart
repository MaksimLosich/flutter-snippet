// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;
import 'package:test_task/data/database/app_database.dart' as _i120;
import 'package:test_task/data/datasources/document_file_datasource.dart'
    as _i870;
import 'package:test_task/data/datasources/document_local_datasource.dart'
    as _i996;
import 'package:test_task/data/datasources/document_picker_datasource.dart'
    as _i179;
import 'package:test_task/data/datasources/document_print_datasource.dart'
    as _i352;
import 'package:test_task/data/datasources/document_scanner_datasource.dart'
    as _i856;
import 'package:test_task/data/datasources/document_share_datasource.dart'
    as _i666;
import 'package:test_task/data/repositories/document_repository_impl.dart'
    as _i967;
import 'package:test_task/di/modules/app_module.dart' as _i458;
import 'package:test_task/domain/repositories/document_repository.dart'
    as _i1013;
import 'package:test_task/domain/usecases/delete_documents_usecase.dart'
    as _i362;
import 'package:test_task/domain/usecases/import_pdf_documents_usecase.dart'
    as _i536;
import 'package:test_task/domain/usecases/import_photo_documents_usecase.dart'
    as _i25;
import 'package:test_task/domain/usecases/print_document_usecase.dart' as _i921;
import 'package:test_task/domain/usecases/scan_document_usecase.dart' as _i554;
import 'package:test_task/domain/usecases/share_documents_usecase.dart'
    as _i470;
import 'package:test_task/domain/usecases/toggle_document_signature_usecase.dart'
    as _i886;
import 'package:test_task/domain/usecases/watch_documents_usecase.dart'
    as _i995;
import 'package:test_task/presentation/home/cubit/home_cubit.dart' as _i610;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i120.AppDatabase>(() => appModule.appDatabase);
    gh.lazySingleton<_i183.ImagePicker>(() => appModule.imagePicker);
    gh.lazySingleton<_i856.DocumentScannerDataSource>(
      () => _i856.CunningDocumentScannerDataSource(),
    );
    gh.lazySingleton<_i666.DocumentShareDataSource>(
      () => _i666.PlatformDocumentShareDataSource(),
    );
    gh.lazySingleton<_i352.DocumentPrintDataSource>(
      () => _i352.PlatformDocumentPrintDataSource(),
    );
    gh.lazySingleton<_i179.DocumentPickerDataSource>(
      () => _i179.PluginDocumentPickerDataSource(gh<_i183.ImagePicker>()),
    );
    gh.lazySingleton<_i870.DocumentFileDataSource>(
      () => _i870.LocalDocumentFileDataSource(),
    );
    gh.lazySingleton<_i996.DocumentLocalDataSource>(
      () => _i996.DriftDocumentLocalDataSource(gh<_i120.AppDatabase>()),
    );
    gh.lazySingleton<_i1013.DocumentRepository>(
      () => _i967.DocumentRepositoryImpl(
        gh<_i179.DocumentPickerDataSource>(),
        gh<_i856.DocumentScannerDataSource>(),
        gh<_i352.DocumentPrintDataSource>(),
        gh<_i666.DocumentShareDataSource>(),
        gh<_i870.DocumentFileDataSource>(),
        gh<_i996.DocumentLocalDataSource>(),
      ),
    );
    gh.factory<_i362.DeleteDocumentsUseCase>(
      () => _i362.DeleteDocumentsUseCase(gh<_i1013.DocumentRepository>()),
    );
    gh.factory<_i536.ImportPdfDocumentsUseCase>(
      () => _i536.ImportPdfDocumentsUseCase(gh<_i1013.DocumentRepository>()),
    );
    gh.factory<_i25.ImportPhotoDocumentsUseCase>(
      () => _i25.ImportPhotoDocumentsUseCase(gh<_i1013.DocumentRepository>()),
    );
    gh.factory<_i921.PrintDocumentUseCase>(
      () => _i921.PrintDocumentUseCase(gh<_i1013.DocumentRepository>()),
    );
    gh.factory<_i554.ScanDocumentUseCase>(
      () => _i554.ScanDocumentUseCase(gh<_i1013.DocumentRepository>()),
    );
    gh.factory<_i470.ShareDocumentsUseCase>(
      () => _i470.ShareDocumentsUseCase(gh<_i1013.DocumentRepository>()),
    );
    gh.factory<_i886.ToggleDocumentSignatureUseCase>(
      () =>
          _i886.ToggleDocumentSignatureUseCase(gh<_i1013.DocumentRepository>()),
    );
    gh.factory<_i995.WatchDocumentsUseCase>(
      () => _i995.WatchDocumentsUseCase(gh<_i1013.DocumentRepository>()),
    );
    gh.factory<_i610.HomeCubit>(
      () => _i610.HomeCubit(
        gh<_i995.WatchDocumentsUseCase>(),
        gh<_i536.ImportPdfDocumentsUseCase>(),
        gh<_i25.ImportPhotoDocumentsUseCase>(),
        gh<_i554.ScanDocumentUseCase>(),
        gh<_i886.ToggleDocumentSignatureUseCase>(),
        gh<_i362.DeleteDocumentsUseCase>(),
        gh<_i470.ShareDocumentsUseCase>(),
        gh<_i921.PrintDocumentUseCase>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i458.AppModule {}
