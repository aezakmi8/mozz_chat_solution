import 'package:hive/hive.dart';
import 'package:mozz_chat_solution/core/data/chat_provider/entities/chat_entity.dart';

part 'chat_hive.g.dart';

@HiveType(typeId: 0)
class ChatHive extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String contactName;

  @HiveField(2)
  final String avatarUrl;

  @HiveField(3)
  final String? lastMessageId;

  @HiveField(4)
  final DateTime? lastMessageTime;

  @HiveField(5)
  final String? lastMessagePreview;

  ChatHive(
    this.id,
    this.contactName,
    this.avatarUrl,
    this.lastMessageId,
    this.lastMessageTime,
    this.lastMessagePreview,
  );

  static ChatHive fromChat(ChatEntity chat) => ChatHive(
        chat.id,
        chat.contactName,
        chat.avatar,
        chat.lastMessageId,
        chat.lastMessageTime,
        chat.lastMessagePreview,
      );
}
