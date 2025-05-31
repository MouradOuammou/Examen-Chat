import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/conversation_bloc.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../widgets/message_bubble.dart';

class ConversationDetailScreen extends StatelessWidget {
  final Conversation conversation;

  const ConversationDetailScreen({
    super.key,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(conversation.contactName),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ConversationBloc, ConversationState>(
              builder: (context, state) {
                if (state is ConversationLoaded && state.messages != null) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: state.messages!.length,
                    itemBuilder: (context, index) {
                      final message = state.messages![index];
                      return MessageBubble(
                        message: message,
                        isMe: message.isMe,
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      final message = Message(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        conversationId: conversation.id,
                        content: textController.text,
                        isMe: true,
                        timestamp: DateTime.now(),
                      );
                      context.read<ConversationBloc>().add(
                        SendMessage(message),
                      );
                      textController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}