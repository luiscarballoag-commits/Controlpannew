import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/settings_service.dart';

import '../widgets/app_footer.dart';
import '../widgets/dashboard_banner.dart';
import '../widgets/date_time_card.dart';
import '../widgets/greeting_card.dart';
import '../widgets/message_card.dart';
import '../widgets/summary_cards.dart';

import 'costs_page.dart';
import 'inventory_page.dart';
import 'settings_page.dart';
import 'new_production_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SettingsService settingsService = SettingsService();

  int _selectedIndex = 0;

  final List<String> _titles = [
    'Inicio',
    'Inventario',
    'Producción',
    'Costos',
    'Configuración',
  ];

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "🌅 Buenos días";
    } else if (hour < 18) {
      return "☀️ Buenas tardes";
    } else {
      return "🌙 Buenas noches";
    }
  }

  String getMessage() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Todo listo para comenzar una excelente jornada de producción.";
    } else if (hour < 18) {
      return "La producción continúa. ¡Que tengas una excelente jornada!";
    } else {
      return "Buen trabajo hoy. Revisa los indicadores antes de finalizar la jornada.";
    }
  }

  String getDate() {
    return DateFormat(
      "EEEE, d 'de' MMMM 'de' y",
      "es",
    ).format(DateTime.now());
  }

  String getTime() {
    return DateFormat(
      "hh:mm a",
      "es",
    ).format(DateTime.now());
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),

      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
      ),

      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeDashboard(
            greeting: getGreeting(),
            bakeryName: settingsService.bakeryName,
            message: getMessage(),
            currentDate: getDate(),
            currentTime: getTime(),
          ),

          InventoryPage(),

          const NewProductionPage(),

          CostsPage(),

          const SettingsPage(),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [

          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Inicio",
          ),

          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: "Inventario",
          ),

          NavigationDestination(
            icon: Icon(Icons.bakery_dining_outlined),
            selectedIcon: Icon(Icons.bakery_dining),
            label: "Producción",
          ),

          NavigationDestination(
            icon: Icon(Icons.attach_money_outlined),
            selectedIcon: Icon(Icons.attach_money),
            label: "Costos",
          ),

          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: "Configuración",
          ),

        ],
      ),
    );
  }
}

class HomeDashboard extends StatelessWidget {
  final String greeting;
  final String bakeryName;
  final String message;
  final String currentDate;
  final String currentTime;

  const HomeDashboard({
    super.key,
    required this.greeting,
    required this.bakeryName,
    required this.message,
    required this.currentDate,
    required this.currentTime,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
        children: [

        GreetingCard(
          greeting: greeting,
          bakeryName: bakeryName,
        ),

        DateTimeCard(
          currentDate: currentDate,
          currentTime: currentTime,
        ),

        MessageCard(
          message: message,
        ),

        const DashboardBanner(),

        const SizedBox(height: 25),

        const Text(
          "Resumen del día",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        const SummaryCards(),

        const SizedBox(height: 30),

        const AppFooter(),

        const SizedBox(height: 20),
      ],
    );
  }
}
