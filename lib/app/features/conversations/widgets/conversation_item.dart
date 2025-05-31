import 'package:flutter/material.dart';
import '../models/conversation.dart';

class ConversationItem extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationItem({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(conversation.contactName[0]),
      ),
      title: Text(conversation.contactName),
      subtitle: Text(
        conversation.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: conversation.unreadCount > 0
          ? CircleAvatar(
        radius: 12,
        child: Text(
          conversation.unreadCount.toString(),
          style: const TextStyle(fontSize: 12),
        ),
      )
          : null,
      onTap: onTap,
    );
  }
}