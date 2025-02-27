import 'dart:async';

import '../../core.dart';
import 'chat_provider_interface.dart';

class ChatProvider implements IChatProvider {
  final IChatStorage _storage;
  final StreamController<List<Chat>> _chatsStreamController = StreamController.broadcast();
  final Map<String, StreamController<List<MessageC>>> _messagesStreamControllers = {};

  ChatProvider(this._storage);

  Future<void> init() async {
    final chats = await _storage.getChats();
    _chatsStreamController.add(chats);
  }

  @override
  Stream<List<Chat>> get chatsStream => _chatsStreamController.stream;

  @override
  Stream<List<MessageC>> messagesStream(String chatId) {
    if (!_messagesStreamControllers.containsKey(chatId)) {
      _messagesStreamControllers[chatId] = StreamController.broadcast();
      _updateMessagesStream(chatId);
    }
    return _messagesStreamControllers[chatId]!.stream;
  }

  @override
  Future<void> storeChat(Chat chat) async {
    await _storage.storeChat(chat);
    _updateChatsStream();
  }

  @override
  Future<void> storeMessage(MessageC message) async {
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
  Future<void> deleteMessage(MessageC message) async {
    await _storage.deleteMessage(message);
    _updateMessagesStream(message.chatId);
    _updateChatsStream();
  }

  void _updateChatsStream() async {
    final chats = await _storage.getChats();
    _chatsStreamController.add(chats);
  }

  void _updateMessagesStream(String chatId) async {
    final messages = await _storage.getMessages(chatId);
    _messagesStreamControllers[chatId]?.add(messages);
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
}
