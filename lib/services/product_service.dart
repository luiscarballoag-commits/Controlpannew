import 'package:hive/hive.dart';

import '../models/product.dart';

class ProductService {
  static const String boxName = 'products';

  Box<Product> get _box => Hive.box<Product>(boxName);

  List<Product> getAllProducts() {
    return _box.values.toList();
  }

  void addProduct(Product product) {
    _box.add(product);
  }

  void updateProduct(int index, Product product) {
    _box.putAt(index, product);
  }

  void deleteProduct(int index) {
    _box.deleteAt(index);
  }

  Product? getProduct(int index) {
    if (index < 0 || index >= _box.length) {
      return null;
    }

    return _box.getAt(index);
  }

  Product? findById(String id) {
    try {
      return _box.values.firstWhere((product) => product.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Product> getActiveProducts() {
    return _box.values.where((product) => product.isActive).toList();
  }

  int get count => _box.length;

  bool get isEmpty => _box.isEmpty;

  bool get isNotEmpty => _box.isNotEmpty;

  void clear() {
    _box.clear();
  }

  void save(Product product) {
    _box.add(product);
  }

  void saveAll(List<Product> products) {
    _box.clear();

    for (final product in products) {
      _box.add(product);
    }
  }
}
