import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

@freezed
class Message with _$Message {
  factory Message({
    required String id,
    required String chatId,
    required String sender,
    required String? text,
    required String? photoPath,
    required DateTime timestamp,
  }) = _Message;
}
