import 'package:hive/hive.dart';

class SettingsService {
  static const String boxName = 'settings';

  static const String bakeryNameKey = 'bakery_name';
  static const String currencyKey = 'currency';

  late Box _box;

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox(boxName);
    } else {
      _box = Hive.box(boxName);
    }
  }

  String get bakeryName {
    return _box.get(
      bakeryNameKey,
      defaultValue: '',
    ) as String;
  }

  Future<void> saveBakeryName(String value) async {
    await _box.put(bakeryNameKey, value);
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
