import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'injection/injection.dart';
import 'router/app_router.dart';

class ChatSolutionApp extends StatelessWidget {
  const ChatSolutionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
        ),
        textTheme: ThemeData.light()
            .textTheme
            .copyWith(
              bodySmall: const TextStyle(
                color: blackColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              bodyMedium: const TextStyle(
                color: blackColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              bodyLarge: const TextStyle(
                color: blackColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              headlineMedium: const TextStyle(
                color: blackColor,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
              titleLarge: const TextStyle(
                color: blackColor,
                fontWeight: FontWeight.w700,
                fontSize: 32,
              ),
              titleMedium: const TextStyle(
                color: blackColor,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            )
            .apply(fontFamily: 'Gilroy'),
      ),
      title: 'Mozz Chat Solution',
      routerConfig: locator<AppRouter>().config(),
    );
  }
}

const TextStyle textStyle = TextStyle(
  color: blackColor,
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  fontFamily: 'Gilroy',
);

const Color blackColor = Color(0xFF2B333E);
const Color grayColor = Color(0xFF9DB7CB);
const Color darkGreenColor = Color(0xFF00521C);
const Color greenColor = Color(0xFF3CED78);
const Color strokeColor = Color(0xFFEDF2F6);
const Color backgroundColor = Colors.white;

final chatTheme = DefaultChatTheme(
  attachmentButtonIcon: const Icon(Icons.attach_file, color: blackColor, size: 24),
  attachmentButtonMargin: const EdgeInsets.all(4),
  backgroundColor: backgroundColor,
  bubbleMargin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
  dateDividerMargin: const EdgeInsets.symmetric(vertical: 16),
  dateDividerTextStyle: textStyle.copyWith(
    color: grayColor,
    fontSize: 14,
  ),
  emptyChatPlaceholderTextStyle: textStyle,
  inputBackgroundColor: backgroundColor,
  inputContainerDecoration: const BoxDecoration(
    color: strokeColor,
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
  inputMargin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
  inputPadding: const EdgeInsets.symmetric(vertical: 8),
  inputTextColor: blackColor,
  inputTextDecoration: InputDecoration(
    hintText: 'Сообщение',
    hintStyle: textStyle.copyWith(
      fontWeight: FontWeight.w600,
    ),
    border: InputBorder.none,
  ),
  inputTextStyle: textStyle.copyWith(
    fontWeight: FontWeight.w600,
  ),
  primaryColor: greenColor,
  receivedMessageBodyTextStyle: textStyle.copyWith(
    color: darkGreenColor,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
  receivedMessageCaptionTextStyle: textStyle.copyWith(
    color: darkGreenColor,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  ),
  secondaryColor: strokeColor,
  sendButtonIcon: const Icon(Icons.send, color: blackColor, size: 24.0),
  sendButtonMargin: const EdgeInsets.all(8.0),
  sentMessageBodyBoldTextStyle: textStyle.copyWith(
    color: darkGreenColor,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
  sentMessageBodyTextStyle: textStyle.copyWith(
    color: darkGreenColor,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  ),
);
