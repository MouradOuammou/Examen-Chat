class Message {
  final String id;
  final String conversationId;
  final String content;
  final bool isMe;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.isMe,
    required this.timestamp,
  });
}