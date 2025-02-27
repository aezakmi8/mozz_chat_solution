import 'package:flutter/material.dart';
import 'package:mozz_chat_solution/startup.dart';

import 'app.dart';
import 'injection/injection.dart';

Future<void> main() async {
  await registerDependencies();
  configureDependencies();

  runApp(const ChatSolutionApp());
}
