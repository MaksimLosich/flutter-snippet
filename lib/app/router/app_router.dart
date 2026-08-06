import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';
import 'app_routes.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(page: HomeRoute.page, path: AppRoutes.home, initial: true),
    ];
  }
}
