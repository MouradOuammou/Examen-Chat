// ==========================================
// 1. CORRECTION: conversation_repository.dart
// ==========================================

import 'dart:async';
import '../models/conversation.dart';
import '../models/message.dart';

class ConversationRepository {
  // AJOUT: Données mockées complètes
  final List<Conversation> _mockConversations = [
    Conversation(
      id: '1',
      contactName: 'Bonjour loubna',
      lastMessage: 'Salut ! Comment ça va ?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
    ),
    Conversation(
      id: '2',
      contactName: 'mourad ouammouu',
      lastMessage: 'À demain pour la réunion',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 0,
    ),
    Conversation(
      id: '3',
      contactName: 'Claire Loubna',
      lastMessage: 'Merci pour ton aide !',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      unreadCount: 1,
    ),
    Conversation(
      id: '4',
      contactName: 'jamal mawane',
      lastMessage: 'Le projet avance bien',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
    ),
  ];

  // AJOUT: Messages mockés complets
  final List<Message> _mockMessages = [
    Message(
      id: '1',
      conversationId: '1',
      content: 'Salut  ! Ça va bien et toi ?',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Message(
      id: '2',
      conversationId: '1',
      content: 'Salut ! Comment ça va ?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Message(
      id: '3',
      conversationId: '1',
      content: 'Tu es libre ce weekend ?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    ),

    // Messages pour conversation avec Bob (id: '2')
    Message(
      id: '4',
      conversationId: '2',
      content: 'Parfait pour la réunion de demain',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Message(
      id: '5',
      conversationId: '2',
      content: 'À demain pour la réunion',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),

    // Messages pour conversation avec Claire (id: '3')
    Message(
      id: '6',
      conversationId: '3',
      content: 'De rien, c\'était un plaisir !',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    Message(
      id: '7',
      conversationId: '3',
      content: 'Merci pour ton aide !',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  final StreamController<Message> _messageController = StreamController<Message>.broadcast();

  Future<List<Conversation>> getConversations() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_mockConversations);
  }

  Future<List<Message>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockMessages
        .where((m) => m.conversationId == conversationId)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp)); // Tri par timestamp
  }

  Future<void> sendMessage(Message message) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockMessages.add(message);

    // AJOUT: Mettre à jour le dernier message de la conversation
    final conversationIndex = _mockConversations.indexWhere((c) => c.id == message.conversationId);
    if (conversationIndex != -1) {
      _mockConversations[conversationIndex] = Conversation(
        id: _mockConversations[conversationIndex].id,
        contactName: _mockConversations[conversationIndex].contactName,
        lastMessage: message.content,
        timestamp: message.timestamp,
        unreadCount: _mockConversations[conversationIndex].unreadCount,
      );
    }

    _messageController.add(message);

    // AJOUT: Simuler une réponse automatique après 2 secondes
    Timer(const Duration(seconds: 2), () {
      final responseMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_response',
        conversationId: message.conversationId,
        content: 'Message reçu ! Merci.',
        isMe: false,
        timestamp: DateTime.now(),
      );
      _mockMessages.add(responseMessage);
      _messageController.add(responseMessage);
    });
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
      unreadCount: 0,
    );
    _mockConversations.add(newConversation);
    return newConversation;
  }

  void dispose() {
    _messageController.close();
  }
}
