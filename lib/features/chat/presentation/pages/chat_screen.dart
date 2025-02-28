import 'package:auto_route/auto_route.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as flyer;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mozz_chat_solution/features/chat/chat.dart';

import '../../../../app.dart';
import '../../../../core/core.dart';
import '../../../../injection/injection.dart';
import '../manager/chat_bloc.dart';

@RoutePage()
class ChatScreen extends StatelessWidget {
  final ChatEntity chat;
  final UserEntity user;

  const ChatScreen({
    super.key,
    required this.chat,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<ChatBloc>()
        ..add(ChatEvent.load(
          chatId: chat.id,
          user: user,
        )),
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 24,
          title: CustomListTile(
            avatarText: chat.avatar,
            titleText: chat.contactName,
            subtitleText: "В сети",
          ),
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return state.map(
              loading: (_) => const _LoadingContent(),
              loaded: (loadedState) => _LoadedContent(
                loadedState.messages,
                loadedState.user,
              ),
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
  final List<types.Message> messages;
  final types.User user;

  const _LoadedContent(this.messages, this.user);

  @override
  Widget build(BuildContext context) {
    return flyer.Chat(
      theme: chatTheme,
      messages: messages,
      onSendPressed: (message) => context.read<ChatBloc>().add(ChatEvent.sendClicked(message.text, types.MessageType.text)),
      user: user,
      l10n: const flyer.ChatL10nRu(),
      onAttachmentPressed: () => context.read<ChatBloc>().add(const ChatEvent.pickImageClicked()),
      dateLocale: 'ru',
      showUserNames: true,
      timeFormat: DateFormat('HH:mm', "ru"),
      dateFormat: DateFormat('d MMMM', 'ru'),
    );
  }
}
