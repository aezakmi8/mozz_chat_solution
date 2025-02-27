part of 'chat_bloc.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.load({required String chatId, required ChatController chatController}) = _Load;

  const factory ChatEvent.messageChanged({required String message}) = _MessageChanged;

  const factory ChatEvent.sendPhotoClicked({required String message}) = _SendPhotoClicked;

  const factory ChatEvent.sendClicked() = _SendClicked;
}
