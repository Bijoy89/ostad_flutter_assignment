import 'package:flutter/material.dart';

class InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  const InputBar({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 10,
        bottom: bottom > 0 ? bottom : 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Input row
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.attach_file_rounded,
                  color: Color(0xFFBBBBBB),
                  size: 22,
                ),
                onPressed: () {},
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                  ),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (_) => onSend(),
                    textInputAction: TextInputAction.send,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1A1A1A),
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Message',
                      hintStyle: TextStyle(
                        color: Color(0xFFBBBBBB),
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 11,
                      ),
                      suffixIcon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: Color(0xFFCCCCCC),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _SendButton(isLoading: isLoading, onTap: onSend),
            ],
          ),
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _SendButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isLoading ? const Color(0xFFD0D0D0) : const Color(0xFF4ECBA0),
          shape: BoxShape.circle,
          boxShadow: isLoading
              ? []
              : [
            BoxShadow(
              color: const Color(0xFF4ECBA0).withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isLoading
            ? const Padding(
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.mic_rounded, color: Colors.white, size: 22),
      ),
    );
  }
}
