# mozz_chat_solution

# Задача:
[Тестовое задание_ Разработка прототипа мессенджера на Flutter (2).docx](https://github.com/user-attachments/files/19839304/_.Flutter.2.docx)

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

## Figma макеты

https://www.figma.com/design/Qk8fQdKGgEoT2jK1vggftl/Untitled--Copy-?node-id=0-1&t=kXqffJv7UJU2iAK7-1
