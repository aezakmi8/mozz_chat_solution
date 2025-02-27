import '../../core.dart';

abstract interface class IChatStorage {
  Future<void> storeChat(Chat chat);

  Future<void> storeMessage(MessageC chat);

  Future<List<Chat>> getChats();

  Future<List<MessageC>> getMessages(String chatId);

  Future<void> deleteChat(String chatId);

  Future<void> deleteMessage(MessageC message);

  void dispose();
}
