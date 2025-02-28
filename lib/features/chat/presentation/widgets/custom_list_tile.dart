import 'package:flutter/material.dart';

import '../../../../app.dart';

class CustomListTile extends StatelessWidget {
  final String avatarText;
  final String titleText;
  final String subtitleText;
  final String? trailingText;
  final GestureTapCallback? onTap;
  final EdgeInsets? contentPadding;

  const CustomListTile({
    super.key,
    required this.avatarText,
    required this.titleText,
    required this.subtitleText,
    this.trailingText,
    this.onTap,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFF1FDB5F),
              Color(0xFF31C764),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Text(
            avatarText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ),
      ),
      title: Text(
        titleText,
        style: const TextStyle(
          color: blackColor,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subtitleText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: trailingText == null ? null : Text(trailingText!),
      contentPadding: contentPadding,
      shape: const Border(bottom: BorderSide(color: strokeColor, width: 1)),
      onTap: onTap,
    );
  }
}
