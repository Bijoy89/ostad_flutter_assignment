import 'package:flutter/material.dart';
import 'bot_avatar.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const BotAvatar(size: 90),
          const SizedBox(height: 28),
          _buildGreetingBubble('Hello! 👋'),
          const SizedBox(height: 10),
          _buildGreetingBubble('How can I help?'),
        ],
      ),
    );
  }

  Widget _buildGreetingBubble(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF333333),
        ),
      ),
    );
  }
}