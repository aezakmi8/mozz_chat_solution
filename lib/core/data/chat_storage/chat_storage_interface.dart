import '../../core.dart';

abstract interface class IChatStorage {
  Future<void> storeChat(ChatEntity chat);

  Future<void> storeMessage(MessageEntity chat);

  Future<Iterable<ChatEntity>> getChats();

  Future<Iterable<MessageEntity>> getMessages(String chatId, {int? take, int? skip});

  Future<void> deleteChat(String chatId);

  Future<void> deleteMessage(MessageEntity message);

  void dispose();
}
