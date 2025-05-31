import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../repositories/conversation_repository.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import 'conversation_event.dart';
import 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final ConversationRepository conversationRepository;
  StreamSubscription? _messagesSubscription;

  ConversationBloc({required this.conversationRepository}) : super(ConversationLoading()) {
    on<LoadConversations>(_onLoadConversations);
    on<SelectConversation>(_onSelectConversation);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<StartNewConversation>(_onStartNewConversation);
  }

  Future<void> _onLoadConversations(
      LoadConversations event,
      Emitter<ConversationState> emit,
      ) async {
    try {
      final conversations = await conversationRepository.getConversations();
      emit(ConversationLoaded(conversations: conversations));
    } catch (e) {
      emit(ConversationError('Failed to load conversations'));
    }
  }

  Future<void> _onSelectConversation(
      SelectConversation event,
      Emitter<ConversationState> emit,
      ) async {
    if (state is ConversationLoaded) {
      final currentState = state as ConversationLoaded;
      final messages = await conversationRepository.getMessages(event.conversationId);

      emit(currentState.copyWith(
        selectedConversationId: event.conversationId,
        messages: messages,
      ));

      // Simulate receiving messages
      _messagesSubscription?.cancel();
      _messagesSubscription = conversationRepository
          .messageStream(event.conversationId)
          .listen((message) {
        add(ReceiveMessage(message));
      });
    }
  }

  Future<void> _onSendMessage(
      SendMessage event,
      Emitter<ConversationState> emit,
      ) async {
    if (state is ConversationLoaded) {
      await conversationRepository.sendMessage(event.message);
    }
  }

  Future<void> _onReceiveMessage(
      ReceiveMessage event,
      Emitter<ConversationState> emit,
      ) async {
    if (state is ConversationLoaded) {
      final currentState = state as ConversationLoaded;
      final updatedMessages = List<Message>.from(currentState.messages ?? [])
        ..add(event.message);

      emit(currentState.copyWith(messages: updatedMessages));
    }
  }

  Future<void> _onStartNewConversation(
      StartNewConversation event,
      Emitter<ConversationState> emit,
      ) async {
    try {
      final newConversation = await conversationRepository.createConversation(event.contactName);
      final currentState = state as ConversationLoaded;
      final updatedConversations = List<Conversation>.from(currentState.conversations)
        ..add(newConversation);

      emit(currentState.copyWith(conversations: updatedConversations));
    } catch (e) {
      emit(ConversationError('Failed to create new conversation'));
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}