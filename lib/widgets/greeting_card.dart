import 'package:flutter/material.dart';

class GreetingCard extends StatelessWidget {
  final String greeting;
  final String bakeryName;

  const GreetingCard({
    super.key,
    required this.greeting,
    required this.bakeryName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        Text(
          bakeryName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8D6E63),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
