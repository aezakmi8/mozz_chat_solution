import 'entities/entities.dart';

abstract interface class IChatProvider {
  Stream<Iterable<ChatEntity>> get chatsStream;

  Stream<Iterable<MessageEntity>> messagesStream(String chatId);

  Future<void> storeChat(ChatEntity chat);

  Future<void> storeMessage(MessageEntity chat);

  Future<void> deleteChat(String chatId);

  Future<void> deleteMessage(MessageEntity message);

  void dispose();

  Future<Iterable<ChatEntity>> getChats();

  Future<Iterable<MessageEntity>> getMessages(String chatId, {int? take, int? skip});
}
