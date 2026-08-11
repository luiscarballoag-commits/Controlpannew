import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  final String message;

  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: const Color(0xFFFFF8E1),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.amber),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(message, style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
