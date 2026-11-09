// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SignDocs';

  @override
  String get appTitle => 'SignDocs';

  @override
  String get homeActionsAddDocument => 'Add Document';

  @override
  String get homeActionsAddDocumentFrom => 'Add Document From';

  @override
  String get homeActionsSearch => 'Search';

  @override
  String get homeMenuSelect => 'Select';

  @override
  String get homeMenuAddDocument => 'Add Document';

  @override
  String get homeSelectionSelectAll => 'Select All';

  @override
  String homeSelectionDeselectAll(int count) {
    return 'Deselect All ($count)';
  }

  @override
  String get homeDocumentActionsPrint => 'Print';

  @override
  String get homeDocumentActionsShare => 'Share';

  @override
  String get homeDocumentActionsDelete => 'Delete';

  @override
  String get homeFiltersAll => 'All';

  @override
  String get homeFiltersSigned => 'Signed';

  @override
  String get homeFiltersUnsigned => 'Unsigned';

  @override
  String get homeEmptyTitle => 'No Documents Yet';

  @override
  String get homeEmptySubtitle => 'You can add documents from:';

  @override
  String get homeNoMatchingDocuments => 'No matching documents';

  @override
  String get homeSourcesFiles => 'Files';

  @override
  String get homeSourcesPhotos => 'Photos';

  @override
  String get homeSourcesScanner => 'Scanner';

  @override
  String get homeErrorsLoad => 'Could not load documents.';

  @override
  String get homeErrorsImport => 'Could not import documents.';

  @override
  String get homeErrorsScan => 'Could not scan the document.';

  @override
  String get homeErrorsUpdate => 'Could not update the document.';

  @override
  String get homeErrorsDelete => 'Could not delete documents.';

  @override
  String get homeErrorsShare => 'Could not share documents.';

  @override
  String get homeErrorsPrint => 'Could not print the document.';

  @override
  String get homeErrorsUnexpected => 'Something went wrong. Please try again.';
}
