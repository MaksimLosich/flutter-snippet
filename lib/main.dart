import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_setup.dart';

import 'app/app.dart';
import 'di/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();

  configureDependencies();

  runApp(LiquidGlassWidgets.wrap(child: const App()));
}
