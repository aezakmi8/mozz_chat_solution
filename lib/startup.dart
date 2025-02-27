import 'package:mozz_chat_solution/core/core.dart';
import 'package:mozz_chat_solution/injection/injection.dart';

import 'core/data/chat_provider/chat_provider.dart';

Future<void> registerDependencies() async {
  locator.registerLazySingleton<IChatStorage>(() {
    final hiveChatStorage = HiveChatStorage();
    hiveChatStorage.init();
    return hiveChatStorage;
  });

  locator.registerLazySingleton<IChatProvider>(() => ChatProvider(locator()));
}
