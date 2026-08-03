import 'package:flutter/material.dart';

class InventoryCategoryStyle {
  static IconData icon(String category) {
    switch (category) {
      case 'Harinas':
        return Icons.grain;
      case 'Agua':
        return Icons.water_drop;
      case 'Azúcares':
        return Icons.icecream;
      case 'Grasas':
        return Icons.bakery_dining;
      case 'Levaduras':
        return Icons.science;
      case 'Lácteos':
        return Icons.local_drink;
      case 'Huevos':
        return Icons.egg;
      case 'Esencias':
        return Icons.spa;
      case 'Mejoradores':
        return Icons.biotech;
      case 'Rellenos':
        return Icons.cake;
      default:
        return Icons.inventory_2;
    }
  }

  static Color color(String category) {
    switch (category) {
      case 'Harinas':
        return Colors.amber;
      case 'Agua':
        return Colors.blue;
      case 'Azúcares':
        return Colors.pink;
      case 'Grasas':
        return Colors.brown;
      case 'Levaduras':
        return Colors.deepOrange;
      case 'Lácteos':
        return Colors.lightBlue;
      case 'Huevos':
        return Colors.orange;
      case 'Esencias':
        return Colors.green;
      case 'Mejoradores':
        return Colors.purple;
      case 'Rellenos':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
