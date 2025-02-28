import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatview/chatview.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';

part 'chat_event.dart';
part 'chat_state.dart';
part 'chat_bloc.freezed.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final IChatProvider _chatProvider;
  StreamSubscription? _subscription;
  String? chatId;
  ChatController? _chatController;

  ChatBloc(this._chatProvider) : super(const ChatState.loading()) {
    on<_Load>(_onLoad);
    on<_MessagesUpdated>(_onMessagesUpdated);
    on<_SendClicked>(_onSendClicked);
  }

  FutureOr<void> _onLoad(_Load event, Emitter<ChatState> emit) {
    chatId = event.chatId;
    _chatController = event.chatController;

    _subscription?.cancel();
    _subscription = _chatProvider.messagesStream(event.chatId).listen((messages) {
      add(ChatEvent.messagesUpdated(messages: messages));
    });
  }

  Future<void> _onMessagesUpdated(_MessagesUpdated event, Emitter<ChatState> emit) async {
    final messages = event.messages;

    final chatMessages = messages.map((msg) {
      return Message(
        id: msg.id,
        message: msg.text ?? '',
        createdAt: msg.timestamp,
        sentBy: msg.sender,
        messageType: msg.photoPath != null ? MessageType.image : MessageType.text,
      );
    }).toList();

    _chatController?.initialMessageList = chatMessages;

    emit(const ChatState.loaded());
  }

  Future<void> _onSendClicked(_SendClicked event, Emitter<ChatState> emit) async {
    if (chatId == null || _chatController == null) return;

    final newMessage = MessageC(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId!,
      sender: _chatController!.currentUser.id,
      text: event.message,
      photoPath: event.messageType == MessageType.image ? event.message : null,
      timestamp: DateTime.now(),
    );

    await _chatProvider.storeMessage(newMessage);

    final chatMessage = Message(
      id: newMessage.id,
      message: newMessage.text ?? '',
      createdAt: newMessage.timestamp,
      sentBy: newMessage.sender,
      messageType: event.messageType,
      replyMessage: event.replyMessage,
    );

    _chatController?.addMessage(chatMessage);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
