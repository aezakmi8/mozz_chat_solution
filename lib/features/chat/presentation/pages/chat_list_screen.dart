import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozz_chat_solution/core/core.dart';
import 'package:mozz_chat_solution/core/data/chat_provider/entities/chat_entity.dart';
import 'package:mozz_chat_solution/features/chat/presentation/manager/chat_list_bloc.dart';

import '../../../../app.dart';
import '../../../../injection/injection.dart';
import '../../../../router/app_router.dart';
import '../widgets/custom_list_tile.dart';

@RoutePage()
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<ChatListBloc>()..add(const ChatListEvent.load()),
      child: Scaffold(
        body: BlocBuilder<ChatListBloc, ChatListState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                CustomAppbar(
                  searchWidget: TextField(
                    decoration: InputDecoration(
                      hintText: 'Поиск',
                      hintStyle: const TextStyle(color: Color(0xFF9DB7CB)),
                      filled: true,
                      fillColor: strokeColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF9DB7CB),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onChanged: (query) => context.read<ChatListBloc>().add(ChatListEvent.filter(query: query)),
                  ),
                ),
                state.map(
                  loading: (_) => const _LoadingContent(),
                  loaded: (loadedState) => _LoadedContent(loadedState.filteredChats),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
  }
}

class _LoadedContent extends StatelessWidget {
  final Iterable<ChatEntity> chats;

  const _LoadedContent(this.chats);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final chat = chats.elementAt(index);
          return Dismissible(
            key: Key(chat.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              context.read<ChatListBloc>().add(ChatListEvent.delete(chatId: chat.id));
            },
            child: buildChatListTile(
              chat,
              () => AutoRouter.of(context).push(ChatRoute(
                chat: chat,
                user: UserEntity(name: "user_name"),
              )),
            ),
          );
        },
        childCount: chats.length,
      ),
    );
  }

  Widget buildChatListTile(ChatEntity chat, GestureTapCallback? onTap) {
    return CustomListTile(
      avatarText: chat.avatar,
      titleText: chat.contactName,
      subtitleText: chat.lastMessagePreview ?? " ",
      trailingText: chat.lastMessageTime == null ? null : _formatTimestamp(chat.lastMessageTime!),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} минут назад';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} часов назад';
    } else {
      return '${timestamp.day}.${timestamp.month}.${timestamp.year}';
    }
  }
}

class CustomAppbar extends StatelessWidget {
  final Widget searchWidget;

  const CustomAppbar({super.key, required this.searchWidget});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      flexibleSpace: const FlexibleSpaceBar(
        expandedTitleScale: 1,
        titlePadding: EdgeInsets.only(
          left: 16,
          bottom: kTextTabBarHeight + 16 + 6,
          top: 14,
        ),
        title: Text('Чаты'),
      ),
      shape: const Border(bottom: BorderSide(color: Color(0xFFEDF2F6), width: 1)),
      expandedHeight: 125,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(42 + 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
          child: SizedBox(
            height: 42,
            child: searchWidget,
          ),
        ),
      ),
    );
  }
}
