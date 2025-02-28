import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_entity.freezed.dart';

@freezed
class MessageEntity with _$MessageEntity {
  factory MessageEntity({
    required String id,
    required String chatId,
    required String sender,
    required String? text,
    required DateTime timestamp,
    String? photoPath,
    int? photoSize,
  }) = _MessageEntity;
}
