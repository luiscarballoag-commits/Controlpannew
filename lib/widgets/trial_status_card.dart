import 'package:flutter/material.dart';

import '../services/settings_service.dart';

class TrialStatusCard extends StatelessWidget {
  const TrialStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = SettingsService();
    final daysRemaining = settings.trialDaysRemaining;
    final expired = settings.trialExpired;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              expired ? Icons.timer_off : Icons.timer_outlined,
              size: 32,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expired
                        ? 'Período de prueba finalizado'
                        : 'Período de prueba',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expired
                        ? 'Tu período de prueba de 30 días ha terminado.'
                        : '$daysRemaining ${daysRemaining == 1 ? 'día' : 'días'} restantes de prueba gratuita.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
