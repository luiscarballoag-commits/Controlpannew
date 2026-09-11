import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 28,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 430,
          maxHeight: 650,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/controlpan_logo.jpg',
                width: 105,
                height: 105,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 12),
              const Text(
                'ControlPan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'La forma inteligente de gestionar tu panadería.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'ControlPan es una aplicación diseñada para facilitar '
                'la gestión de panaderías y pastelerías, permitiendo '
                'controlar ingredientes, inventario, producción y costos '
                'desde un solo lugar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Desarrollado por un maestro panadero para ayudar a '
                'los panaderos a tomar mejores decisiones y conocer '
                'realmente cuánto cuesta producir.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Funciones principales',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 7),
              const _FeatureItem(
                icon: Icons.inventory_2_outlined,
                text: 'Gestión inteligente de inventario',
              ),
              const _FeatureItem(
                icon: Icons.factory_outlined,
                text: 'Control de producción',
              ),
              const _FeatureItem(
                icon: Icons.calculate_outlined,
                text: 'Cálculo de costos',
              ),
              const _FeatureItem(
                icon: Icons.people_outline,
                text: 'Mano de obra',
              ),
              const _FeatureItem(
                icon: Icons.receipt_long_outlined,
                text: 'Gastos operativos',
              ),
              const _FeatureItem(
                icon: Icons.precision_manufacturing_outlined,
                text: 'Depreciación de equipos',
              ),
              const _FeatureItem(
                icon: Icons.assessment_outlined,
                text: 'Reportes de producción, inventario y costos',
              ),
              const SizedBox(height: 14),
              Text(
                'Versión 1.0',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'CERRAR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 19,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
