import 'package:flutter/material.dart';

import 'injection/injection.dart';
import 'router/app_router.dart';

class ChatSolutionApp extends StatelessWidget {
  const ChatSolutionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mozz Chat Solution',
      routerConfig: locator<AppRouter>().config(),
    );
  }
}
