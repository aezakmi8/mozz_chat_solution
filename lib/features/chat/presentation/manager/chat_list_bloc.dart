import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';
part 'chat_list_bloc.freezed.dart';

@injectable
class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final IChatProvider _chatProvider;
  StreamSubscription? _subscription;

  ChatListBloc(this._chatProvider) : super(const ChatListState.loading()) {
    on<_Load>(_onLoad);
    on<_Update>(_onUpdate);
    on<_Delete>(_onDelete);
  }

  FutureOr<void> _onLoad(_Load event, Emitter<ChatListState> emit) {
    _subscription?.cancel();
    _subscription = _chatProvider.chatsStream.listen((chats) {
      add(ChatListEvent.update(chats: chats));
    });
  }

  FutureOr<void> _onUpdate(_Update event, Emitter<ChatListState> emit) {
    final sortedChats = event.chats..sort((a, b) => (b.lastMessageTime ?? DateTime(0)).compareTo(a.lastMessageTime ?? DateTime(0)));
    emit(ChatListState.loaded(sortedChats));
  }

  Future<void> _onDelete(_Delete event, Emitter<ChatListState> emit) async {
    await _chatProvider.deleteChat(event.chatId);
  }
}
