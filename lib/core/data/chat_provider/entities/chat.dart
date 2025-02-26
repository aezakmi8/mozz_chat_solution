import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat.freezed.dart';

@freezed
class Chat with _$Chat {
  factory Chat({
    required String id,
    required String contactName,
    required String avatar,
    String? lastMessageId,
    DateTime? lastMessageTime,
    String? lastMessagePreview,
  }) = _Chat;
}
