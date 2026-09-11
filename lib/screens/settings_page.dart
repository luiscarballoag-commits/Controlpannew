import 'package:flutter/material.dart';

import '../services/settings_service.dart';
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

  void _showAbout() {
    showDialog<void>(
      context: context,
      builder: (context) => const AboutPage(),
    );
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

        const Divider(),

        const ListTile(
          leading: Icon(Icons.backup),
          title: Text('Respaldo'),
          subtitle: Text('Exportar e importar datos'),
          trailing: Icon(Icons.chevron_right),
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
