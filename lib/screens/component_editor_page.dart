import 'package:flutter/material.dart';

class ComponentEditorPage extends StatelessWidget {
  const ComponentEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        title: const Text("Nuevo Componente"),
        centerTitle: true,
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "Editor de Componentes\n(Próximo paso)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
