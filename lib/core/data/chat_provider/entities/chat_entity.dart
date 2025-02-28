import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_entity.freezed.dart';

@freezed
class ChatEntity with _$ChatEntity {
  factory ChatEntity({
    required String id,
    required String contactName,
    required String avatar,
    String? lastMessageId,
    DateTime? lastMessageTime,
    String? lastMessagePreview,
  }) = _ChatEntity;
}
