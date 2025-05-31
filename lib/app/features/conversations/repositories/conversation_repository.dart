import 'dart:async';
import '../models/conversation.dart';
import '../models/message.dart';

class ConversationRepository {
  final List<Conversation> _mockConversations = [
    // Mock data here
  ];

  final List<Message> _mockMessages = [
    // Mock data here
  ];

  final StreamController<Message> _messageController = StreamController<Message>.broadcast();

  Future<List<Conversation>> getConversations() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return _mockConversations;
  }

  Future<List<Message>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockMessages.where((m) => m.conversationId == conversationId).toList();
  }

  Future<void> sendMessage(Message message) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockMessages.add(message);
    _messageController.add(message);
  }

  Stream<Message> messageStream(String conversationId) {
    return _messageController.stream.where((m) => m.conversationId == conversationId);
  }

  Future<Conversation> createConversation(String contactName) async {
    await Future.delayed(const Duration(seconds: 1));
    final newConversation = Conversation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      contactName: contactName,
      lastMessage: '',
      timestamp: DateTime.now(),
    );
    _mockConversations.add(newConversation);
    return newConversation;
  }
}