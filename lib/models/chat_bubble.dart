import 'dart:io';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.text,
    this.imageUrl,
    required this.isCurrentUser,
    required this.color,
  }) : super(key: key);

  final String text;
  final String? imageUrl;
  final bool isCurrentUser;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // asymmetric padding
      padding: EdgeInsets.fromLTRB(
        isCurrentUser ? 64.0 : 16.0,
        4,
        isCurrentUser ? 16.0 : 64.0,
        4,
      ),
      child: Align(
        // align the child within the container
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          // chat bubble decoration
          decoration: BoxDecoration(
            color: isCurrentUser ? color : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: imageUrl != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            )
                : Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: isCurrentUser ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
