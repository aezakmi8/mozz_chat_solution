import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/core.dart';

part 'chat_event.dart';
part 'chat_state.dart';
part 'chat_bloc.freezed.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final IChatProvider _chatProvider;
  StreamSubscription? _subscription;
  UserEntity? user;
  String? chatId;
  int page = 0;

  ChatBloc(this._chatProvider) : super(const ChatState.loading()) {
    on<_Load>(_onLoad);
    on<_MessagesUpdated>(_onMessagesUpdated);
    on<_SendClicked>(_onSendClicked);
    on<_PickImageClicked>(_onPickImageClicked);
  }

  Future<void> _onLoad(_Load event, Emitter<ChatState> emit) async {
    _subscription?.cancel();
    user = event.user;
    chatId = event.chatId;

    final messages = await _chatProvider.getMessages(event.chatId, take: 10, skip: page);
    add(ChatEvent.messagesUpdated(messages: messages));

    _subscription = _chatProvider.messagesStream(event.chatId).listen((messages) {
      add(ChatEvent.messagesUpdated(messages: messages));
    });
  }

  FutureOr<void> _onMessagesUpdated(_MessagesUpdated event, Emitter<ChatState> emit) {
    emit(ChatState.loaded(
      messages: event.messages.map(_toMessage).toList(),
      user: _toUser(user!),
    ));
  }

  Future<void> _onSendClicked(_SendClicked event, Emitter<ChatState> emit) async {
    final newMessage = MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId!,
      sender: user!.name,
      text: event.text,
      timestamp: DateTime.now(),
    );

    await _chatProvider.storeMessage(newMessage);
  }

  Future<void> _onPickImageClicked(_PickImageClicked event, Emitter<ChatState> emit) async {
    final picker = ImagePicker();
    final result = await picker.pickImage(imageQuality: 70, maxWidth: 1440, source: ImageSource.gallery);

    if (result == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedImage = await File(result.path).copy('${directory.path}/$fileName');
    final bytes = await result.readAsBytes();

    final newMessage = MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId!,
      sender: user!.name,
      timestamp: DateTime.now(),
      photoPath: savedImage.path,
      photoSize: bytes.length,
      text: null,
    );

    await _chatProvider.storeMessage(newMessage);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Message _toMessage(MessageEntity message) {
    if (message.photoPath == null) {
      return TextMessage(
        author: _toUser(user!),
        id: message.id,
        text: message.text!,
        createdAt: message.timestamp.millisecondsSinceEpoch,
        type: MessageType.text,
      );
    }

    return ImageMessage(
      author: _toUser(user!),
      id: message.id,
      uri: message.photoPath!,
      name: 'picture',
      size: message.photoSize!,
    );
  }

  User _toUser(UserEntity user) {
    return User(
      id: user.name,
      firstName: user.name,
    );
  }
}
