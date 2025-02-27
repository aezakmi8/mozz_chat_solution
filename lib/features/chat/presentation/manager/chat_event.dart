part of 'chat_bloc.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.load({required String chatId, required ChatController chatController}) = _Load;

  const factory ChatEvent.messagesUpdated({required List<MessageC> messages}) = _MessagesUpdated;

  const factory ChatEvent.sendClicked(String message, ReplyMessage replyMessage, MessageType messageType) = _SendClicked;
}
