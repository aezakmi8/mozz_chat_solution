import 'package:flutter/material.dart';
import 'package:mozz_chat_solution/startup.dart';

import 'app.dart';
import 'core/core.dart';
import 'injection/injection.dart';

Future<void> main() async {
  await registerDependencies();
  configureDependencies();

  // ---           mock init section           ---
  final chatStorage = locator<IChatStorage>();
  if (await chatStorage.getChats().then((onValue) => onValue.isEmpty)) {
    await chatStorage.storeChat(Chat(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      contactName: "Виктор Власов",
      avatar: "ВВ",
    ));
    await chatStorage.storeChat(Chat(
      id: (DateTime.now().millisecondsSinceEpoch - 441).toString(),
      contactName: "Саша Алексеев",
      avatar: "СА",
    ));
    await chatStorage.storeChat(Chat(
      id: (DateTime.now().millisecondsSinceEpoch - 452).toString(),
      contactName: "Петр Жаринов",
      avatar: "ПЖ",
    ));
    await chatStorage.storeChat(Chat(
      id: (DateTime.now().millisecondsSinceEpoch - 45).toString(),
      contactName: "Алина Жукова",
      avatar: "АЖ",
    ));
  }
  // ---           mock init section           ---

  runApp(const ChatSolutionApp());
}
