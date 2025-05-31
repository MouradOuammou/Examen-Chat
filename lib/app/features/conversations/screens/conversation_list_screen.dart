import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/conversation_bloc.dart';
import '../models/conversation.dart';
import 'conversation_detail_screen.dart';
import '../widgets/conversation_item.dart';
import '../widgets/new_conversation_dialog.dart';

class ConversationListScreen extends StatelessWidget {
  const ConversationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
      ),
      body: BlocBuilder<ConversationBloc, ConversationState>(
        builder: (context, state) {
          if (state is ConversationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ConversationError) {
            return Center(child: Text(state.message));
          } else if (state is ConversationLoaded) {
            return ListView.builder(
              itemCount: state.conversations.length,
              itemBuilder: (context, index) {
                final conversation = state.conversations[index];
                return ConversationItem(
                  conversation: conversation,
                  onTap: () {
                    context.read<ConversationBloc>().add(
                      SelectConversation(conversation.id),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConversationDetailScreen(
                          conversation: conversation,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final contactName = await showDialog<String>(
            context: context,
            builder: (context) => const NewConversationDialog(),
          );
          if (contactName != null && contactName.isNotEmpty) {
            context.read<ConversationBloc>().add(
              StartNewConversation(contactName),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}