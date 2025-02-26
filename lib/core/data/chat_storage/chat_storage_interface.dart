import '../../core.dart';

abstract interface class IChatStorage {
  Future<void> storeChat(Chat chat);

  Future<void> storeMessage(Message chat);

  Future<List<Chat>> getChats();

  Future<List<Message>> getMessages(String chatId);

  Future<void> deleteChat(String chatId);

  Future<void> deleteMessage(Message message);

  void dispose();
}
