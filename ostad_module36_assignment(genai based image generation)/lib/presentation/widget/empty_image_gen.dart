import 'package:flutter/material.dart';

class EmptyImageGen extends StatelessWidget {
  const EmptyImageGen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_outlined, size: 64, color: Colors.grey),
        SizedBox(height: 16),
        Text(
          'No image generated',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
