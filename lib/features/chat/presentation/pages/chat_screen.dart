import 'package:auto_route/auto_route.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../injection/injection.dart';
import '../manager/chat_bloc.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({
    super.key,
    required this.chat,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatController _chatController;

  @override
  void initState() {
    super.initState();
    _chatController = ChatController(
      initialMessageList: [],
      scrollController: ScrollController(),
      currentUser: ChatUser(
        id: widget.chat.contactName,
        name: widget.chat.contactName,
      ),
      otherUsers: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<ChatBloc>()
        ..add(ChatEvent.load(
          chatId: widget.chat.id,
          chatController: _chatController,
        )),
      child: Scaffold(
        appBar: AppBar(title: const Text('Чат')),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return state.map(
              loading: (_) => const _LoadingContent(),
              loaded: (loadedState) => _LoadedContent(_chatController),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
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
  final ChatController _chatController;

  const _LoadedContent(this._chatController);

  @override
  Widget build(BuildContext context) {
    return ChatView(
        chatController: _chatController,
        onSendTap: (message, replyMessage, messageType) {
          context.read<ChatBloc>().add(ChatEvent.sendClicked(
                message,
                replyMessage,
                messageType,
              ));
        },
        chatViewState: ChatViewState.hasMessages);
  }
}
