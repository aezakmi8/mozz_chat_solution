part of 'chat_list_bloc.dart';

@freezed
class ChatListEvent with _$ChatListEvent {
  const factory ChatListEvent.load() = _Load;

  const factory ChatListEvent.update({required List<Chat> chats}) = _Update;

  const factory ChatListEvent.delete({required String chatId}) = _Delete;

  const factory ChatListEvent.filter({required String query}) = _Filter;
}
