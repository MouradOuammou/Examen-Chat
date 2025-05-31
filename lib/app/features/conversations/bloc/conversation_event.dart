import 'package:equatable/equatable.dart';
import '../models/message.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object> get props => [];
}

class LoadConversations extends ConversationEvent {}

class SelectConversation extends ConversationEvent {
  final String conversationId;

  const SelectConversation(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}

class SendMessage extends ConversationEvent {
  final Message message;

  const SendMessage(this.message);

  @override
  List<Object> get props => [message];
}

class ReceiveMessage extends ConversationEvent {
  final Message message;

  const ReceiveMessage(this.message);

  @override
  List<Object> get props => [message];
}

class StartNewConversation extends ConversationEvent {
  final String contactName;

  const StartNewConversation(this.contactName);

  @override
  List<Object> get props => [contactName];
}