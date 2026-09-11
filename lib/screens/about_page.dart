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
        vertical: 24,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 430,
          maxHeight: 600,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/controlpan_logo.jpg',
                width: 85,
                height: 85,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              const Text(
                'ControlPan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'La forma inteligente de gestionar tu panadería.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 13),
              const Text(
                'ControlPan es una aplicación diseñada para facilitar '
                'la gestión de panaderías y pastelerías, permitiendo '
                'controlar ingredientes, inventario, producción y costos '
                'desde un solo lugar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 11),
              const Text(
                'Desarrollado por un maestro panadero para ayudar a '
                'los panaderos a tomar mejores decisiones y conocer '
                'realmente cuánto cuesta producir.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 13),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Funciones principales',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
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
              const SizedBox(height: 9),
              Text(
                'Versión 1.0',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'CERRAR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
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
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 17,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
