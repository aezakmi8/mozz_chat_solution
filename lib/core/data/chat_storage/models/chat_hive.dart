import 'package:hive/hive.dart';
import 'package:mozz_chat_solution/core/data/chat_provider/entities/chat.dart';

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
  final DateTime? lastMessageTime;

  @HiveField(4)
  final String? lastMessagePreview;

  ChatHive(
    this.id,
    this.contactName,
    this.avatarUrl,
    this.lastMessageTime,
    this.lastMessagePreview,
  );

  static ChatHive fromChat(Chat chat) => ChatHive(
        chat.id,
        chat.contactName,
        chat.avatar,
        chat.lastMessageTime,
        chat.lastMessagePreview,
      );
}
