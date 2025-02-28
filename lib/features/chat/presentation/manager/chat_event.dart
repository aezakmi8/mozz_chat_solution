part of 'chat_bloc.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.load({required String chatId, required UserEntity user}) = _Load;

  const factory ChatEvent.messagesUpdated({required Iterable<MessageEntity> messages}) = _MessagesUpdated;

  const factory ChatEvent.sendClicked(String text, MessageType type) = _SendClicked;

  const factory ChatEvent.pickImageClicked() = _PickImageClicked;
}
