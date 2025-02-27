part of 'chat_bloc.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.loading() = _Loading;
  const factory ChatState.loaded() = _Loaded;
}
