import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this)!;
}
