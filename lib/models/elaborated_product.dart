class ElaboratedProduct {
  final String id;
  final String name;
  final String category;
  final double defaultWeight;

  const ElaboratedProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.defaultWeight,
  });
}

const List<ElaboratedProduct> elaboratedProducts = [
  // Pan salado
  ElaboratedProduct(
    id: "canilla",
    name: "Canilla",
    category: "Pan Salado",
    defaultWeight: 250,
  ),

  ElaboratedProduct(
    id: "gallego",
    name: "Pan Gallego",
    category: "Pan Salado",
    defaultWeight: 450,
  ),

  ElaboratedProduct(
    id: "campesino",
    name: "Pan Campesino",
    category: "Pan Salado",
    defaultWeight: 500,
  ),

  ElaboratedProduct(
    id: "hamburguesa",
    name: "Pan Hamburguesa",
    category: "Pan Salado",
    defaultWeight: 80,
  ),

  ElaboratedProduct(
    id: "hotdog",
    name: "Pan Hot Dog",
    category: "Pan Salado",
    defaultWeight: 70,
  ),

  // Pan dulce

  ElaboratedProduct(
    id: "golfeado",
    name: "Golfeado",
    category: "Pan Dulce",
    defaultWeight: 150,
  ),

  ElaboratedProduct(
    id: "cachito",
    name: "Cachito",
    category: "Pan Dulce",
    defaultWeight: 120,
  ),

  ElaboratedProduct(
    id: "tunja",
    name: "Tunja",
    category: "Pan Dulce",
    defaultWeight: 120,
  ),

  ElaboratedProduct(
    id: "pan_jamon",
    name: "Pan de Jamón",
    category: "Pan Dulce",
    defaultWeight: 1000,
  ),
];
