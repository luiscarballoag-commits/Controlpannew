import 'package:flutter/material.dart';

import '../models/ingredient_catalog.dart';
import '../core/inventory/unit_converter.dart';
import '../services/ingredient_service.dart';
import '../services/inventory_movement_service.dart';
import '../models/inventory_movement.dart';

class IngredientEditorPage extends StatefulWidget {
  final IngredientCatalog? ingredient;
  final int? index;

  const IngredientEditorPage({super.key, this.ingredient, this.index});

  @override
  State<IngredientEditorPage> createState() => _IngredientEditorPageState();
}

class _IngredientEditorPageState extends State<IngredientEditorPage> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _unitController = TextEditingController();

  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _minimumController = TextEditingController();

  final _packageSizeController = TextEditingController();

  final _purchaseUnitController = TextEditingController();

  final _packageUnitController = TextEditingController();

  final _notesController = TextEditingController();

  String? selectedCategory;
  String? selectedUnit;

  String? selectedPurchaseUnit;
  String? selectedPackageUnit;

  final categories = [
    "Harinas",
    "Agua",
    "Azúcares",
    "Grasas",
    "Levaduras",
    "Lácteos",
    "Huevos",
    "Esencias",
    "Mejoradores",
    "Rellenos",
    "Otros",
  ];

  final purchaseUnits = [
    "Saco",
    "Caja",
    "Bolsa",
    "Bidón",
    "Botella",
    "Paquete",
    "Bandeja",
    "Cubeta",
    "Unidad",
  ];

  final packageUnits = ["kg", "g", "L", "ml"];

  final units = ["kg", "g", "L", "ml", "Unidad"];

  final IngredientService ingredientService = IngredientService();
  final InventoryMovementService movementService = InventoryMovementService();
  @override
  void initState() {
    super.initState();

    if (widget.ingredient != null) {
      _nameController.text = widget.ingredient!.name;

      selectedCategory = widget.ingredient!.category;

      selectedUnit = widget.ingredient!.unit;

      selectedPurchaseUnit = widget.ingredient!.purchaseUnit;

      selectedPackageUnit = widget.ingredient!.packageUnit;

      _priceController.text = widget.ingredient!.purchasePrice.toString();

      _stockController.text = widget.ingredient!.stock.toString();

      _packageSizeController.text = widget.ingredient!.packageSize.toString();

      _minimumController.text = widget.ingredient!.minimumStock.toString();

      _notesController.text = widget.ingredient!.notes;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _unitController.dispose();

    _priceController.dispose();
    _stockController.dispose();
    _minimumController.dispose();

    _packageSizeController.dispose();
    _purchaseUnitController.dispose();
    _packageUnitController.dispose();

    _notesController.dispose();

    super.dispose();
  }

  void saveIngredient() {
    if (_nameController.text.trim().isEmpty) {
      return;
    }

    final stock = double.tryParse(_stockController.text) ?? 0;

    final packageSize = double.tryParse(_packageSizeController.text) ?? 0;

    final normalizedStock = UnitConverter.normalize(
      quantity: stock,
      packageSize: packageSize,
      packageUnit: selectedPackageUnit ?? "",
      consumptionUnit: selectedUnit ?? "",
    );

    final ingredient = IngredientCatalog(
      id:
          widget.ingredient?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),

      name: _nameController.text.trim(),

      category: selectedCategory ?? "",

      unit: selectedUnit ?? "",

      purchasePrice: double.tryParse(_priceController.text) ?? 0,

      stock: stock,

      minimumStock: double.tryParse(_minimumController.text) ?? 0,

      purchaseUnit: selectedPurchaseUnit ?? "",

      packageSize: packageSize,

      packageUnit: selectedPackageUnit ?? "",

      normalizedStock: normalizedStock,

      notes: _notesController.text.trim(),
    );

    if (widget.index == null) {
      ingredientService.addIngredient(ingredient);

      // El stock inicial de un ingrediente nuevo se registra
      // automáticamente como una compra.
      if (stock > 0) {
        movementService.addMovement(
          InventoryMovement(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            date: DateTime.now(),
            ingredientId: ingredient.id,
            ingredientName: ingredient.name,
            quantity: stock,
            unit: ingredient.purchaseUnit,
            type: 'Compra',
            reference: 'Compra inicial',
            notes: ingredient.notes,
          ),
        );
      }
    } else {
      ingredientService.updateIngredient(widget.index!, ingredient);
    }

    Navigator.pop(context);
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.index == null ? "Nuevo Ingrediente" : "Editar Ingrediente",
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildField("Nombre", _nameController),

            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: const InputDecoration(
                labelText: "Categoría",
                border: OutlineInputBorder(),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              initialValue: selectedPurchaseUnit,
              decoration: const InputDecoration(
                labelText: "Unidad de compra",
                border: OutlineInputBorder(),
              ),
              items: purchaseUnits.map((unit) {
                return DropdownMenuItem(value: unit, child: Text(unit));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPurchaseUnit = value;
                });
              },
            ),

            const SizedBox(height: 14),

            buildField(
              "Contenido del envase",
              _packageSizeController,
              keyboard: const TextInputType.numberWithOptions(decimal: true),
            ),

            DropdownButtonFormField<String>(
              initialValue: selectedPackageUnit,
              decoration: const InputDecoration(
                labelText: "Unidad del contenido",
                border: OutlineInputBorder(),
              ),
              items: packageUnits.map((unit) {
                return DropdownMenuItem(value: unit, child: Text(unit));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPackageUnit = value;
                });
              },
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              initialValue: selectedUnit,
              decoration: const InputDecoration(
                labelText: "Unidad de consumo",
                border: OutlineInputBorder(),
              ),
              items: units.map((unit) {
                return DropdownMenuItem(value: unit, child: Text(unit));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedUnit = value;
                });
              },
            ),

            const SizedBox(height: 14),
            buildField(
              "Precio de compra",
              _priceController,
              keyboard: const TextInputType.numberWithOptions(decimal: true),
            ),

            buildField(
              "Stock actual",
              _stockController,
              keyboard: const TextInputType.numberWithOptions(decimal: true),
            ),

            buildField(
              "Stock mínimo",
              _minimumController,
              keyboard: const TextInputType.numberWithOptions(decimal: true),
            ),

            buildField("Observaciones", _notesController),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: saveIngredient,
                child: Text(
                  widget.index == null
                      ? "GUARDAR INGREDIENTE"
                      : "ACTUALIZAR INGREDIENTE",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
