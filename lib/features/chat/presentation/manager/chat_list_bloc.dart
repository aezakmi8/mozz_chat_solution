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
  String _currentFilter = '';

  ChatListBloc(this._chatProvider) : super(const ChatListState.loading()) {
    on<_Load>(_onLoad);
    on<_Update>(_onUpdate);
    on<_Delete>(_onDelete);
    on<_Filter>(_onFilter);
  }

  Future<void> _onLoad(_Load event, Emitter<ChatListState> emit) async {
    _subscription?.cancel();

    final currentChats = await _chatProvider.getChats();
    add(ChatListEvent.update(chats: currentChats));

    _subscription = _chatProvider.chatsStream.listen((chats) {
      add(ChatListEvent.update(chats: chats));
    });
  }

  FutureOr<void> _onUpdate(_Update event, Emitter<ChatListState> emit) {
    final filteredChats = _filterChats(event.chats, _currentFilter);
    emit(ChatListState.loaded(filteredChats));
  }

  Future<void> _onDelete(_Delete event, Emitter<ChatListState> emit) async {
    await _chatProvider.deleteChat(event.chatId);
  }

  FutureOr<void> _onFilter(_Filter event, Emitter<ChatListState> emit) {
    _currentFilter = event.query.toLowerCase();
    if (state is _Loaded) {
      final loadedState = state as _Loaded;
      final filteredChats = _filterChats(loadedState.chats, _currentFilter);
      emit(ChatListState.loaded(filteredChats));
    }
  }

  List<Chat> _filterChats(List<Chat> chats, String query) {
    if (query.isEmpty) return chats;
    return chats.where((chat) => chat.contactName.toLowerCase().contains(query)).toList();
  }
}
