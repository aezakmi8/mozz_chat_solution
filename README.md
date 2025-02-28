# mozz_chat_solution

## Описание архитектуры

Приложение мессенджера на Flutter использует паттерн BLoC для управления состоянием, обеспечивая реактивное обновление интерфейса через подписки на стримы. Локальное хранилище реализовано с помощью Hive, где чаты и сообщения сохраняются в отдельных боксах. Стримы в ChatProvider автоматически обновляют список чатов и сообщений, через подписку в слое презентации. Работа чата реализована с помощью плагина flutter_chat_ui, все сообщения сохраняются в Hive хранилище.

# Скрины

![image](https://github.com/user-attachments/assets/da26c987-da34-47ba-97be-2c9da55b1fb3)
![image](https://github.com/user-attachments/assets/bd59d5d2-4970-4057-9b0b-2890d3d77a0a)
![image](https://github.com/user-attachments/assets/87468c0f-f249-492e-8f1d-c40ac8434c03)

## Инструкция запуска
Версия Flutter 3.29.0

После вытягивания ветки develop
выполнить команды 

`flutter pub get`

`dart run build_runner build --delete-conflicting-outputs`

Запуск по команде 

`flutter run`


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
