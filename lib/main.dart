import 'package:flutter/material.dart';
import 'package:mozz_chat_solution/startup.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/core.dart';
import 'injection/injection.dart';

Future<void> main() async {
  await registerDependencies();
  configureDependencies();

  // ---           mock init section           ---
  final chatStorage = locator<IChatStorage>();
  if (await chatStorage.getChats().then((onValue) => onValue.isEmpty)) {
    await chatStorage.storeChat(ChatEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      contactName: "Виктор Власов",
      avatar: "ВВ",
    ));
    await chatStorage.storeChat(ChatEntity(
      id: (DateTime.now().millisecondsSinceEpoch).toString(),
      contactName: "Саша Алексеев",
      avatar: "СА",
    ));
    await chatStorage.storeChat(ChatEntity(
      id: (DateTime.now().millisecondsSinceEpoch).toString(),
      contactName: "Петр Жаринов",
      avatar: "ПЖ",
    ));
    await chatStorage.storeChat(ChatEntity(
      id: (DateTime.now().millisecondsSinceEpoch).toString(),
      contactName: "Алина Жукова",
      avatar: "АЖ",
    ));
  }
  // ---           mock init section           ---

  initializeDateFormatting('ru_RU', null).then((_) => runApp(const ChatSolutionApp()));
}
