import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../provider/image_gen_provider.dart';
import '../widget/chat_input_field.dart';
import '../widget/empty_image_gen.dart';
import '../widget/image_message_bubble.dart';
import '../widget/typing_indicator.dart';

class ImageGenScreen extends StatefulWidget {
  const ImageGenScreen({super.key});

  @override
  State<ImageGenScreen> createState() => _ImageGenScreenState();
}

class _ImageGenScreenState extends State<ImageGenScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_outlined, size: 22),
            ),
            Row(
              children: [
                Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Online',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Consumer<ImageGenProvider>(
        builder: (context, provider, _) {
          if (provider.messages.isNotEmpty || provider.isLoading) {
            _scrollToBottom();
          }

          return Column(
            children: [
              // Error banner
              if (provider.errorMessage != null)
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          provider.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: provider.clearError,
                      ),
                    ],
                  ),
                ),

              Expanded(
                child: provider.messages.isEmpty && !provider.isLoading
                    ? const EmptyImageGen()
                    : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount:
                  provider.messages.length +
                      (provider.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == provider.messages.length) {
                      return const TypingIndicator();
                    }
                    return ImageMessageBubble(
                      message: provider.messages[index],
                    );
                  },
                ),
              ),

              ChatInputField(
                onSend: provider.generateImage,
                isLoading: provider.isLoading,
                hintText: AppStrings.imageGenInputHint,
                sendIcon: Icons.auto_awesome,
              ),
            ],
          );
        },
      ),
    );
  }
}