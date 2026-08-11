import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "ControlPan v1.0\n"
        "La forma inteligente de gestionar tu panadería\n\n"
        "Desarrollado por Producciones Lcarballog",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
      ),
    );
  }
}
