class ChatMessage {
  final String sender;
  final String receiver;
  final String message;
  final DateTime time;

  ChatMessage({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.time,
  });
}