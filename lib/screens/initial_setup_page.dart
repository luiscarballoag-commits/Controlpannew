import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class InitialSetupPage extends StatefulWidget {
  const InitialSetupPage({super.key});

  @override
  State<InitialSetupPage> createState() => _InitialSetupPageState();
}

class _InitialSetupPageState extends State<InitialSetupPage> {
  final SettingsService settings = SettingsService();

  late final TextEditingController nameController;
  late final TextEditingController addressController;
  late final TextEditingController phoneController;
  late final TextEditingController ownerController;
  late final TextEditingController marginController;

  String selectedCurrency = 'USD';

  final List<Map<String, String>> currencies = const [
    {'code': 'USD', 'name': 'Dólar estadounidense'},
    {'code': 'VES', 'name': 'Bolívar venezolano'},
    {'code': 'COP', 'name': 'Peso colombiano'},
    {'code': 'BRL', 'name': 'Real brasileño'},
    {'code': 'PEN', 'name': 'Sol peruano'},
    {'code': 'CLP', 'name': 'Peso chileno'},
    {'code': 'MXN', 'name': 'Peso mexicano'},
    {'code': 'ARS', 'name': 'Peso argentino'},
    {'code': 'BOB', 'name': 'Boliviano'},
    {'code': 'EUR', 'name': 'Euro'},
  ];

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    ownerController = TextEditingController();
    marginController = TextEditingController(text: '30');
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    ownerController.dispose();
    marginController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final name = nameController.text.trim();
    final margin = double.tryParse(marginController.text.trim());

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa el nombre de la panadería'),
        ),
      );
      return;
    }

    if (margin == null || margin < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa un margen válido'),
        ),
      );
      return;
    }

    await settings.saveBakeryName(name);
    await settings.saveBakeryAddress(addressController.text.trim());
    await settings.saveBakeryPhone(phoneController.text.trim());
    await settings.saveBakeryOwner(ownerController.text.trim());
    await settings.saveCurrency(selectedCurrency);
    await settings.saveProfitMargin(margin);
    await settings.completeInitialSetup();

    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración inicial'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.storefront,
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'Bienvenido a ControlPan',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Configura los datos básicos de tu panadería para comenzar.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre de la panadería *',
              prefixIcon: Icon(Icons.store),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: addressController,
            decoration: const InputDecoration(
              labelText: 'Dirección',
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: 'Teléfono',
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: ownerController,
            decoration: const InputDecoration(
              labelText: 'Propietario',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            initialValue: selectedCurrency,
            decoration: const InputDecoration(
              labelText: 'Moneda predeterminada',
              prefixIcon: Icon(Icons.attach_money),
            ),
            items: currencies.map((currency) {
              return DropdownMenuItem<String>(
                value: currency['code'],
                child: Text(
                  '${currency['name']} (${currency['code']})',
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                selectedCurrency = value;
              });
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: marginController,
            decoration: const InputDecoration(
              labelText: 'Margen predeterminado (%)',
              prefixIcon: Icon(Icons.percent),
            ),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: save,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Comenzar a usar ControlPan'),
            ),
          ),
        ],
      ),
    );
  }
}
