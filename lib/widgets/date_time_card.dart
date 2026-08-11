import 'package:flutter/material.dart';

class DateTimeCard extends StatelessWidget {
  final String currentDate;
  final String currentTime;

  const DateTimeCard({
    super.key,
    required this.currentDate,
    required this.currentTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: const Icon(Icons.calendar_month, color: Color(0xFF8D6E63)),
            title: Text(
              currentDate,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),

        const SizedBox(height: 10),

        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: const Icon(Icons.access_time, color: Color(0xFF8D6E63)),
            title: Text(
              currentTime,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
