import 'entities/entities.dart';

abstract interface class IChatProvider {
  Stream<List<Chat>> get chatsStream;

  Stream<List<Message>> messagesStream(String chatId);

  Future<void> storeChat(Chat chat);

  Future<void> storeMessage(Message chat);

  Future<void> deleteChat(String chatId);

  Future<void> deleteMessage(Message message);

  void dispose();
}
