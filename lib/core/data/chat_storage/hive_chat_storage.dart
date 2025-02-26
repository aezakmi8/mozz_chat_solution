import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

import '../../core.dart';

class HiveLoggerStorage implements IChatStorage {
  static Future<bool>? _initFuture;
  static LazyBox<ChatHive>? _chatBox;

  final String messagesChatPostfix = "_chat";
  static const String chatsHiveKey = "Chats";

  HiveLoggerStorage();

  void init() async {
    if (_initFuture != null) {
      return;
    }

    _initFuture = _initHive().then((_) => _openChatsBox()).then((_) => true).onError((error, stackTrace) {
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
    await _getBoxById<MessageHive>(
      _getMessagesKey(message.chatId),
      action: (box) => box.add(MessageHive.fromMessage(message)),
      closeAfterRetrieve: true,
    );

    updateChatPreview(message.chatId);
  }

  @override
  Future<List<Chat>> getChats() async {
    var collection = <Chat>[];

    await _getBoxById<ChatHive>(
      chatsHiveKey,
      action: (box) async {
        for (var key in box.keys) {
          var chat = await box.get(key);

          if (chat == null) continue;

          collection.add(toChat(chat));
          break;
        }
      },
    );
    return collection;
  }

  @override
  Future<List<Message>> getMessages(String chatId) async {
    var collection = <Message>[];

    await _getBoxById<MessageHive>(
      _getMessagesKey(chatId),
      action: (box) async {
        for (var key in box.keys) {
          var message = await box.get(key);

          if (message == null || message.chatId != chatId) continue;

          collection.add(toMessage(message));
          break;
        }
      },
      closeAfterRetrieve: true,
    );
    return collection;
  }

  @override
  Future<void> deleteChat(String chatId) async {
    await _getBoxById<ChatHive>(chatsHiveKey, action: (box) => box.delete(chatId));

    await _getBoxById<MessageHive>(_getMessagesKey(chatId), action: (box) async {
      for (var key in box.keys) {
        var message = await box.get(key);

        if (message == null || message.chatId != chatId) continue;

        box.delete(key);
        break;
      }
    });
  }

  @override
  Future<void> deleteMessage(message) async {
    await _getBoxById<MessageHive>(_getMessagesKey(message.chatId), action: (box) {
      box.delete(message.id);
    }, closeAfterRetrieve: true);

    updateChatPreview(message.chatId);
  }

  Future<void> updateChatPreview(String chatId) async {
    MessageHive? lastMessage;

    await _getBoxById<MessageHive>(_getMessagesKey(chatId), action: (box) {
      lastMessage = box.keys.last;
    }, closeAfterRetrieve: true);

    if (lastMessage == null) return;

    await _getBoxById<ChatHive>(chatsHiveKey, action: (box) async {
      for (var key in box.keys) {
        var chat = await box.get(key);

        if (chat == null || chatId != chat.id) continue;

        final chatModel = toChat(chat).copyWith(
          lastMessageId: lastMessage!.id,
          lastMessagePreview: lastMessage!.photoPath,
          lastMessageTime: lastMessage!.timestamp,
        );

        box.put(key, ChatHive.fromChat(chatModel));
        break;
      }
    });
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter<ChatHive>(ChatHiveAdapter());
    Hive.registerAdapter<MessageHive>(MessageHiveAdapter());
  }

  Future<void> _openChatsBox() async {
    _chatBox = await Hive.openLazyBox<ChatHive>(chatsHiveKey);
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
  }

  Future<void> _getBoxById<T>(String boxId, {Function(LazyBox<T> box)? action, bool closeAfterRetrieve = false}) async {
    await _ensureStorageInitialized();

    LazyBox<T> box = Hive.isBoxOpen(boxId) ? Hive.lazyBox(boxId) : await Hive.openLazyBox<T>(boxId);

    action?.call(box);
    if (closeAfterRetrieve) box.close();
  }

  String _getMessagesKey(String chatId) => chatId + messagesChatPostfix;

  Message toMessage(MessageHive message) {
    return Message(
      id: message.id,
      chatId: message.chatId,
      sender: message.sender,
      text: message.text,
      photoPath: message.photoPath,
      timestamp: message.timestamp,
    );
  }

  Chat toChat(ChatHive message) {
    return Chat(
      id: message.id,
      contactName: message.contactName,
      avatar: message.avatarUrl,
      lastMessageTime: message.lastMessageTime,
    );
  }
}
