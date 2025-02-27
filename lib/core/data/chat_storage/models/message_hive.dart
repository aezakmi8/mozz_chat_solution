import 'package:hive/hive.dart';
import 'package:mozz_chat_solution/core/data/chat_provider/entities/message.dart';

part 'message_hive.g.dart';

@HiveType(typeId: 1)
class MessageHive extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String chatId;

  @HiveField(2)
  final String sender;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final String? text;

  @HiveField(5)
  final String? photoPath;

  MessageHive(
    this.id,
    this.chatId,
    this.sender,
    this.timestamp,
    this.text,
    this.photoPath,
  );

  static MessageHive fromMessage(MessageC message) => MessageHive(
        message.id,
        message.chatId,
        message.sender,
        message.timestamp,
        message.text,
        message.photoPath,
      );
}
