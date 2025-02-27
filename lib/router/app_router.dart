import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: ChatListRoute.page,
          path: '/chatlist',
          children: [
            AutoRoute(page: ChatRoute.page, path: 'chat'),
          ],
        ),
      ];
}
