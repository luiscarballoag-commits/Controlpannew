import 'package:hive_flutter/hive_flutter.dart';

class SettingsService {
  static const String _boxName = 'settings';

  static const String bakeryNameKey = 'bakery_name';
  static const String bakeryAddressKey = 'bakery_address';
  static const String bakeryPhoneKey = 'bakery_phone';
  static const String bakeryOwnerKey = 'bakery_owner';

  Box get _box => Hive.box(_boxName);

  String get bakeryName {
    return _box.get(
          bakeryNameKey,
          defaultValue: 'Panadería y Pastelería Carballog FP',
        )
        as String;
  }

  String get bakeryAddress {
    return _box.get(bakeryAddressKey, defaultValue: '') as String;
  }

  String get bakeryPhone {
    return _box.get(bakeryPhoneKey, defaultValue: '') as String;
  }

  String get bakeryOwner {
    return _box.get(bakeryOwnerKey, defaultValue: '') as String;
  }

  Future<void> saveBakeryName(String name) async {
    await _box.put(bakeryNameKey, name);
  }

  Future<void> saveBakeryAddress(String address) async {
    await _box.put(bakeryAddressKey, address);
  }

  Future<void> saveBakeryPhone(String phone) async {
    await _box.put(bakeryPhoneKey, phone);
  }

  Future<void> saveBakeryOwner(String owner) async {
    await _box.put(bakeryOwnerKey, owner);
  }
}
