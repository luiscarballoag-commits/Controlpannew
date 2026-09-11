import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 40,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 430,
          maxHeight: 700,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Center(
                  child: Text(
                    'C',
                    style: TextStyle(
                      fontSize: 82,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'ControlPan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'La forma inteligente de gestionar tu panadería.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'ControlPan es una aplicación diseñada para facilitar '
                'la gestión de panaderías y pastelerías, permitiendo '
                'controlar ingredientes, inventario, producción y costos '
                'desde un solo lugar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.55,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Desarrollado por un maestro panadero para ayudar a '
                'los panaderos a tomar mejores decisiones y conocer '
                'realmente cuánto cuesta producir.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.55,
                ),
              ),

              const SizedBox(height: 28),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Funciones principales',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

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

              const SizedBox(height: 24),

              Text(
                'Versión 1.0',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'CERRAR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
