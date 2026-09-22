import 'package:flutter/material.dart';

import '../services/settings_service.dart';
import '../services/backup_service.dart';
import '../widgets/settings/bakery_info_card.dart';
import 'about_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsService _settingsService = SettingsService();

  String get _currencyLabel {
    return _settingsService.currencyDisplay;
  }

  double get _profitMargin {
    return _settingsService.profitMargin;
  }

  Future<void> _selectCurrency() async {
    final currentCurrency = _settingsService.currency;

    final selected = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Moneda de trabajo'),
          children: [
            RadioGroup<String>(
              groupValue: currentCurrency,
              onChanged: (value) {
                if (value != null) {
                  Navigator.pop(context, value);
                }
              },
              child: const Column(
                children: [
                  RadioListTile<String>(
                    value: 'VES',
                    title: Text('Bolívar venezolano (Bs.)'),
                  ),
                  RadioListTile<String>(
                    value: 'COP',
                    title: Text('Peso colombiano (\$)'),
                  ),
                  RadioListTile<String>(
                    value: 'BRL',
                    title: Text('Real brasileño (R\$)'),
                  ),
                  RadioListTile<String>(
                    value: 'PEN',
                    title: Text('Sol peruano (S/)'),
                  ),
                  RadioListTile<String>(
                    value: 'CLP',
                    title: Text('Peso chileno (\$)'),
                  ),
                  RadioListTile<String>(
                    value: 'MXN',
                    title: Text('Peso mexicano (\$)'),
                  ),
                  RadioListTile<String>(
                    value: 'ARS',
                    title: Text('Peso argentino (\$)'),
                  ),
                  RadioListTile<String>(
                    value: 'BOB',
                    title: Text('Boliviano (Bs.)'),
                  ),
                  RadioListTile<String>(
                    value: 'USD',
                    title: Text('Dólar estadounidense (\$)'),
                  ),
                  RadioListTile<String>(
                    value: 'EUR',
                    title: Text('Euro (€)'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    if (selected == null || selected == currentCurrency) {
      return;
    }

    await _settingsService.saveCurrency(selected);

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Moneda cambiada a $_currencyLabel',
        ),
      ),
    );
  }

  Future<void> _editProfitMargin() async {
    final controller = TextEditingController(
      text: _profitMargin.toStringAsFixed(0),
    );

    final value = await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Margen de ganancia'),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Margen (%)',
              suffixText: '%',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCELAR'),
            ),
            FilledButton(
              onPressed: () {
                final value = double.tryParse(
                  controller.text.trim().replaceAll(',', '.'),
                );
                if (value == null || value < 0) return;
                Navigator.pop(context, value);
              },
              child: const Text('GUARDAR'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (value == null) return;

    await _settingsService.saveProfitMargin(value);

    if (!mounted) return;
    setState(() {});
  }

  void _showAbout() {
    showDialog<void>(
      context: context,
      builder: (context) => const AboutPage(),
    );
  }

  Future<void> _createBackup() async {
    try {
      final backupService = BackupService();
      final file = await backupService.createBackup();

      if (!mounted || file == null) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Respaldo creado correctamente.'),
        ),
      );

      await backupService.shareBackup(file);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo crear el respaldo: $e'),
        ),
      );
    }
  }

  Future<void> _restoreBackup() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Restaurar respaldo'),
          content: const Text(
            'Esta acción reemplazará los datos actuales de ControlPan '
            'por los datos contenidos en el respaldo seleccionado. '
            '¿Deseas continuar?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCELAR'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('RESTAURAR'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    try {
      final backupService = BackupService();
      final restored = await backupService.restoreBackup();

      if (!mounted) return;

      if (!restored) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Respaldo restaurado correctamente. '
            'Reinicia ControlPan para cargar todos los datos.',
          ),
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo restaurar el respaldo: $e'),
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const BakeryInfoCard(),

        const SizedBox(height: 16),

        ListTile(
          leading: const Icon(Icons.attach_money),
          title: const Text('Moneda'),
          subtitle: Text(_currencyLabel),
          trailing: const Icon(Icons.chevron_right),
          onTap: _selectCurrency,
        ),

        ListTile(
          leading: const Icon(Icons.percent),
          title: const Text('Margen de ganancia'),
          subtitle: Text('${_profitMargin.toStringAsFixed(0)} %'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _editProfitMargin,
        ),

        const Divider(),

        ListTile(
          leading: const Icon(Icons.backup),
          title: const Text('Respaldo'),
          subtitle: const Text('Exportar datos de ControlPan'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _createBackup,
        ),

        ListTile(
          leading: const Icon(Icons.restore),
          title: const Text('Restaurar respaldo'),
          subtitle: const Text('Importar datos desde un archivo ZIP'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _restoreBackup,
        ),

        const Divider(),

        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Acerca de'),
          subtitle: const Text('ControlPan versión 1.0'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _showAbout,
        ),
      ],
    );
  }
}
