import 'package:flutter/material.dart';

import 'injection/injection.dart';
import 'router/app_router.dart';

class ChatSolutionApp extends StatelessWidget {
  const ChatSolutionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
        textTheme: ThemeData.light()
            .textTheme
            .copyWith(
              bodySmall: const TextStyle(
                color: Color(0xFF5E7A90),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              bodyMedium: const TextStyle(
                color: Color(0xFF2B333E),
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
              bodyLarge: const TextStyle(
                color: Color(0xFF2B333E),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              headlineMedium: const TextStyle(
                color: Color(0xFF2B333E),
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
              titleLarge: const TextStyle(
                color: Color(0xFF2B333E),
                fontWeight: FontWeight.w700,
                fontSize: 32,
              ),
              titleMedium: const TextStyle(
                color: Color(0xFF2B333E),
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            )
            .apply(fontFamily: 'Gilroy'),
      ),
      title: 'Mozz Chat Solution',
      routerConfig: locator<AppRouter>().config(),
    );
  }
}
