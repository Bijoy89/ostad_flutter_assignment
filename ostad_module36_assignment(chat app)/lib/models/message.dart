enum MessageRole { user, assistant }

class Message {
  final String text;
  final MessageRole role;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.role,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'role': role == MessageRole.user ? 'user' : 'assistant',
    'content': text,
  };
}