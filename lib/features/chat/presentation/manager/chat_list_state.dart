part of 'chat_list_bloc.dart';

@freezed
class ChatListState with _$ChatListState {
  const factory ChatListState.loading() = _Loading;

  const factory ChatListState.loaded(List<Chat> chats) = _Loaded;
}
