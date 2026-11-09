import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SignDocs'**
  String get appName;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SignDocs'**
  String get appTitle;

  /// No description provided for @homeActionsAddDocument.
  ///
  /// In en, this message translates to:
  /// **'Add Document'**
  String get homeActionsAddDocument;

  /// No description provided for @homeActionsAddDocumentFrom.
  ///
  /// In en, this message translates to:
  /// **'Add Document From'**
  String get homeActionsAddDocumentFrom;

  /// No description provided for @homeActionsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get homeActionsSearch;

  /// No description provided for @homeMenuSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get homeMenuSelect;

  /// No description provided for @homeMenuAddDocument.
  ///
  /// In en, this message translates to:
  /// **'Add Document'**
  String get homeMenuAddDocument;

  /// No description provided for @homeSelectionSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get homeSelectionSelectAll;

  /// No description provided for @homeSelectionDeselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All ({count})'**
  String homeSelectionDeselectAll(int count);

  /// No description provided for @homeDocumentActionsPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get homeDocumentActionsPrint;

  /// No description provided for @homeDocumentActionsShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get homeDocumentActionsShare;

  /// No description provided for @homeDocumentActionsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get homeDocumentActionsDelete;

  /// No description provided for @homeFiltersAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get homeFiltersAll;

  /// No description provided for @homeFiltersSigned.
  ///
  /// In en, this message translates to:
  /// **'Signed'**
  String get homeFiltersSigned;

  /// No description provided for @homeFiltersUnsigned.
  ///
  /// In en, this message translates to:
  /// **'Unsigned'**
  String get homeFiltersUnsigned;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Documents Yet'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can add documents from:'**
  String get homeEmptySubtitle;

  /// No description provided for @homeNoMatchingDocuments.
  ///
  /// In en, this message translates to:
  /// **'No matching documents'**
  String get homeNoMatchingDocuments;

  /// No description provided for @homeSourcesFiles.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get homeSourcesFiles;

  /// No description provided for @homeSourcesPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get homeSourcesPhotos;

  /// No description provided for @homeSourcesScanner.
  ///
  /// In en, this message translates to:
  /// **'Scanner'**
  String get homeSourcesScanner;

  /// No description provided for @homeErrorsLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load documents.'**
  String get homeErrorsLoad;

  /// No description provided for @homeErrorsImport.
  ///
  /// In en, this message translates to:
  /// **'Could not import documents.'**
  String get homeErrorsImport;

  /// No description provided for @homeErrorsScan.
  ///
  /// In en, this message translates to:
  /// **'Could not scan the document.'**
  String get homeErrorsScan;

  /// No description provided for @homeErrorsUpdate.
  ///
  /// In en, this message translates to:
  /// **'Could not update the document.'**
  String get homeErrorsUpdate;

  /// No description provided for @homeErrorsDelete.
  ///
  /// In en, this message translates to:
  /// **'Could not delete documents.'**
  String get homeErrorsDelete;

  /// No description provided for @homeErrorsShare.
  ///
  /// In en, this message translates to:
  /// **'Could not share documents.'**
  String get homeErrorsShare;

  /// No description provided for @homeErrorsPrint.
  ///
  /// In en, this message translates to:
  /// **'Could not print the document.'**
  String get homeErrorsPrint;

  /// No description provided for @homeErrorsUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get homeErrorsUnexpected;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
