import 'entities/entities.dart';

abstract interface class IChatProvider {
  Stream<List<Chat>> get chatsStream;

  Stream<List<MessageC>> messagesStream(String chatId);

  Future<void> storeChat(Chat chat);

  Future<void> storeMessage(MessageC chat);

  Future<void> deleteChat(String chatId);

  Future<void> deleteMessage(MessageC message);

  void dispose();

  Future<List<Chat>> getChats();
}
