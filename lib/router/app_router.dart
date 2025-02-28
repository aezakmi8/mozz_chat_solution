import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../features/features.dart';
import '../core/core.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: ChatListRoute.page, path: '/'),
        AutoRoute(page: ChatRoute.page, path: '/chat'),
      ];
}
