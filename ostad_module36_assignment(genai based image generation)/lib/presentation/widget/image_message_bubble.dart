import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/image_message_entity.dart';

class ImageMessageBubble extends StatelessWidget {
  final ImageMessage message;
  const ImageMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return message.isUser
        ? _UserPromptBubble(message: message)
        : _AssistantImageBubble(message: message);
  }
}

class _UserPromptBubble extends StatelessWidget {
  final ImageMessage message;
  const _UserPromptBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(left: 64, right: 16, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.userBubble,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.prompt,
              style: const TextStyle(
                color: AppColors.userText,
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.time),
              style: const TextStyle(color: AppColors.timestamp, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

class _AssistantImageBubble extends StatelessWidget {
  final ImageMessage message;
  const _AssistantImageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final hasImage = message.hasImage;
    final hasText =
        message.textContent != null && message.textContent!.isNotEmpty;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 64, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.botBubble,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasImage) _buildImage(message.imageUrl!),
            if (hasImage && hasText) const SizedBox(height: 8),
            if (hasText)
              Text(
                message.textContent!,
                style: const TextStyle(
                  color: AppColors.botText,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                _formatTime(message.time),
                style: const TextStyle(
                  color: AppColors.timestamp,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    // Gemini image models return base64 data URIs — decode and use Image.memory
    if (url.startsWith('data:')) {
      try {
        final base64Str = url.substring(url.indexOf(',') + 1);
        final bytes = base64Decode(base64Str);
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            bytes,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _errorWidget(),
          ),
        );
      } catch (_) {
        return _errorWidget();
      }
    }

    // Regular HTTPS image URL
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            height: 180,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        },
        errorBuilder: (_, __, ___) => _errorWidget(),
      ),
    );
  }

  Widget _errorWidget() {
    return Container(
      height: 120,
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, size: 40, color: Colors.grey),
          SizedBox(height: 6),
          Text('Failed to load image', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}