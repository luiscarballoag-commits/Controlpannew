import 'package:hive_flutter/hive_flutter.dart';

class SettingsService {
  static const String _boxName = 'settings';

  static const String bakeryNameKey = 'bakery_name';
  static const String bakeryAddressKey = 'bakery_address';
  static const String bakeryPhoneKey = 'bakery_phone';
  static const String bakeryOwnerKey = 'bakery_owner';
  static const String currencyKey = 'currency';

  Box get _box => Hive.box(_boxName);

  String get bakeryName {
    return _box.get(
      bakeryNameKey,
      defaultValue: 'Panadería y Pastelería Carballog FP',
    ) as String;
  }

  String get bakeryAddress {
    return _box.get(
      bakeryAddressKey,
      defaultValue: '',
    ) as String;
  }

  String get bakeryPhone {
    return _box.get(
      bakeryPhoneKey,
      defaultValue: '',
    ) as String;
  }

  String get bakeryOwner {
    return _box.get(
      bakeryOwnerKey,
      defaultValue: '',
    ) as String;
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

  String get currency {
    return _box.get(
      currencyKey,
      defaultValue: 'USD',
    ) as String;
  }

  Future<void> saveCurrency(String value) async {
    await _box.put(currencyKey, value);
  }

  String get currencyName {
    switch (currency) {
      case 'VES':
        return 'Bolívar venezolano';
      case 'COP':
        return 'Peso colombiano';
      case 'BRL':
        return 'Real brasileño';
      case 'PEN':
        return 'Sol peruano';
      case 'CLP':
        return 'Peso chileno';
      case 'MXN':
        return 'Peso mexicano';
      case 'ARS':
        return 'Peso argentino';
      case 'BOB':
        return 'Boliviano';
      case 'EUR':
        return 'Euro';
      case 'USD':
      default:
        return 'Dólar estadounidense';
    }
  }

  String get currencySymbol {
    switch (currency) {
      case 'VES':
        return 'Bs.';
      case 'COP':
        return r'$';
      case 'BRL':
        return r'R$';
      case 'PEN':
        return 'S/';
      case 'CLP':
        return r'$';
      case 'MXN':
        return r'$';
      case 'ARS':
        return r'$';
      case 'BOB':
        return 'Bs.';
      case 'EUR':
        return '€';
      case 'USD':
      default:
        return r'$';
    }
  }

  String get currencyDisplay {
    return '$currencyName ($currencySymbol)';
  }
}
