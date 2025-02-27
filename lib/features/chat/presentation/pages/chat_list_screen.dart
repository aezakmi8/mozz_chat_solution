import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozz_chat_solution/core/data/chat_provider/entities/chat.dart';
import 'package:mozz_chat_solution/features/chat/presentation/manager/chat_list_bloc.dart';

import '../../../../injection/injection.dart';
import '../../../../router/app_router.dart';

@RoutePage()
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<ChatListBloc>()..add(const ChatListEvent.load()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Чаты')),
        body: BlocBuilder<ChatListBloc, ChatListState>(
          builder: (context, state) {
            return state.map(
              loading: (_) => const _LoadingContent(),
              loaded: (loadedState) => _LoadedContent(loadedState.chats),
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
    return const Center(child: CircularProgressIndicator());
  }
}

class _LoadedContent extends StatelessWidget {
  final List<Chat> chats;

  const _LoadedContent(this.chats);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return Dismissible(
          key: Key(chat.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            context.read<ChatListBloc>().add(ChatListEvent.delete(chatId: chat.id));
          },
          child: ListTile(
            leading: CircleAvatar(child: Text(chat.contactName[0])),
            title: Text(chat.contactName),
            subtitle: chat.lastMessagePreview == null ? null : Text(chat.lastMessagePreview!), // todo: add me:
            trailing: null, //todo: format it Text(_formatTimestamp(chat.lastMessageTime)),
            onTap: () => AutoRouter.of(context).push(ChatRoute(chat: chat)),
          ),
        );
      },
    );
  }
}
