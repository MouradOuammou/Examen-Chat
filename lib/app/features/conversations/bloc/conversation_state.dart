import 'package:equatable/equatable.dart';
import '../models/conversation.dart';
import '../models/message.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationLoading extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final List<Conversation> conversations;
  final String? selectedConversationId;
  final List<Message>? messages;

  const ConversationLoaded({
    required this.conversations,
    this.selectedConversationId,
    this.messages,
  });

  ConversationLoaded copyWith({
    List<Conversation>? conversations,
    String? selectedConversationId,
    List<Message>? messages,
  }) {
    return ConversationLoaded(
      conversations: conversations ?? this.conversations,
      selectedConversationId: selectedConversationId ?? this.selectedConversationId,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object> get props => [conversations, selectedConversationId ?? '', messages ?? []];
}

class ConversationError extends ConversationState {
  final String message;

  const ConversationError(this.message);

  @override
  List<Object> get props => [message];
}