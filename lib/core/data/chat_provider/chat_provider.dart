import 'dart:async';

import '../../core.dart';
import 'chat_provider_interface.dart';

class ChatProvider implements IChatProvider {
  final IChatStorage _storage;
  final StreamController<Iterable<ChatEntity>> _chatsStreamController = StreamController.broadcast();
  final Map<String, StreamController<Iterable<MessageEntity>>> _messagesStreamControllers = {};

  ChatProvider(this._storage);

  Future<void> init() async {
    final chats = await _storage.getChats();
    _chatsStreamController.add(chats);
  }

  @override
  Stream<Iterable<ChatEntity>> get chatsStream => _chatsStreamController.stream;

  @override
  Stream<Iterable<MessageEntity>> messagesStream(String chatId) {
    if (!_messagesStreamControllers.containsKey(chatId)) {
      _messagesStreamControllers[chatId] = StreamController.broadcast();
      _updateMessagesStream(chatId);
    }
    return _messagesStreamControllers[chatId]!.stream;
  }

  @override
  Future<void> storeChat(ChatEntity chat) async {
    await _storage.storeChat(chat);
    _updateChatsStream();
  }

  @override
  Future<void> storeMessage(MessageEntity message) async {
    await _storage.storeMessage(message);
    _updateChatsStream();
    _updateMessagesStream(message.chatId);
  }

  @override
  Future<void> deleteChat(String chatId) async {
    await _storage.deleteChat(chatId);
    _updateChatsStream();
    _messagesStreamControllers[chatId]?.close();
    _messagesStreamControllers.remove(chatId);
  }

  @override
  Future<void> deleteMessage(MessageEntity message) async {
    await _storage.deleteMessage(message);
    _updateMessagesStream(message.chatId);
    _updateChatsStream();
  }

  @override
  void dispose() {
    _chatsStreamController.close();
    for (var controller in _messagesStreamControllers.values) {
      controller.close();
    }
    _messagesStreamControllers.clear();
    _storage.dispose();
  }

  @override
  Future<Iterable<ChatEntity>> getChats() {
    return _storage.getChats().then((onValue) => onValue.toList()
      ..sort(
        (a, b) => (b.lastMessageTime ?? DateTime(0)).compareTo(a.lastMessageTime ?? DateTime(0)),
      ));
  }

  void _updateChatsStream() async {
    final chats = await getChats();
    _chatsStreamController.add(chats);
  }

  void _updateMessagesStream(String chatId) async {
    final messages = await getMessages(chatId);
    _messagesStreamControllers[chatId]?.add(messages);
  }

  @override
  Future<Iterable<MessageEntity>> getMessages(String chatId, {int? take, int? skip}) async {
    final messages = await _storage.getMessages(chatId, take: take, skip: skip);
    return messages.map((value) => value.copyWith(timestamp: value.timestamp.toLocal())).toList().reversed;
  }
}
