import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

import '../../core.dart';

class HiveLoggerStorage implements IChatStorage {
  static Future<bool>? _initFuture;
  static LazyBox<ChatHive>? _chatBox;
  static LazyBox<MessageHive>? _messageBox;

  HiveLoggerStorage();

  void init() async {
    if (_initFuture != null) {
      return;
    }

    _initFuture = _initHive().then((_) => _openCurrentBox()).then((_) => true).onError((error, stackTrace) {
      if (kDebugMode) {
        print("error: ${error.toString()}, stackTrace:${stackTrace.toString()}");
      }
      return false;
    });
  }

  @override
  Future<void> storeChat(Chat chat) async {
    if (!await _ensureStorageInitialized()) {
      return;
    }

    try {
      await _chatBox!.add(ChatHive.fromChat(chat));
    } catch (e, s) {
      if (kDebugMode) {
        print("error: ${e.toString()}, stackTrace:${s.toString()}");
      }
    }
  }

  @override
  Future<void> storeMessage(Message message) async {
    if (!await _ensureStorageInitialized()) {
      return;
    }

    try {
      await _messageBox!.add(MessageHive.fromMessage(message));
    } catch (e, s) {
      if (kDebugMode) {
        print("error: ${e.toString()}, stackTrace:${s.toString()}");
      }
    }
  }

  @override
  Future<List<Chat>> getChats() async {
    final box = await _getBoxById<ChatHive>("Chats");

    var collection = <Chat>[];

    for (var key in box.keys) {
      var message = await box.get(key);

      if (message == null) continue;

      collection.add(
        Chat(
          id: message.id,
          contactName: message.contactName,
          avatar: message.avatarUrl,
          lastMessageTime: message.lastMessageTime,
        ),
      );
    }

    return collection;
  }

  @override
  Future<List<Message>> getMessages(String chatId) async {
    final box = await _getBoxById<MessageHive>("Messages");

    var collection = <Message>[];

    for (var key in box.keys) {
      var message = await box.get(key);

      if (message == null || message.chatId != chatId) continue;

      collection.add(
        Message(
          id: message.id,
          chatId: message.chatId,
          sender: message.sender,
          text: message.text,
          photoPath: message.photoPath,
          timestamp: message.timestamp,
        ),
      );
    }

    return collection;
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final chatBox = await _getBoxById<ChatHive>("Chats");

    chatBox.delete(chatId);

    final messagesBox = await _getBoxById<MessageHive>("Messages");

    for (var key in messagesBox.keys) {
      var message = await messagesBox.get(key);

      if (message == null || message.chatId != chatId) continue;

      messagesBox.delete(key);
    }
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    final messagesBox = await _getBoxById<MessageHive>("Messages");

    messagesBox.delete(messageId);
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter<ChatHive>(ChatHiveAdapter());
    Hive.registerAdapter<MessageHive>(MessageHiveAdapter());
  }

  Future<void> _openCurrentBox() async {
    _chatBox = await Hive.openLazyBox<ChatHive>("Chats");
    _messageBox = await Hive.openLazyBox<MessageHive>("Messages");
  }

  Future<bool> _ensureStorageInitialized() {
    if (_initFuture == null) {
      return Future.value(false);
    }

    return _initFuture!;
  }

  @override
  void dispose() {
    _chatBox?.close();
    _messageBox?.close();
  }

  Future<LazyBox<T>> _getBoxById<T>(String boxId) async {
    await _ensureStorageInitialized();

    return Hive.isBoxOpen(boxId) ? Future.value(Hive.lazyBox(boxId)) : await Hive.openLazyBox<T>(boxId);
  }
}
