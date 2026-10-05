import 'package:hive_flutter/hive_flutter.dart';

class SettingsService {
  static const String _boxName = 'settings';

  static const String bakeryNameKey = 'bakery_name';
  static const String bakeryAddressKey = 'bakery_address';
  static const String bakeryPhoneKey = 'bakery_phone';
  static const String bakeryOwnerKey = 'bakery_owner';
  static const String currencyKey = 'currency';
  static const String profitMarginKey = 'profit_margin';
  static const String initialSetupCompletedKey = 'initial_setup_completed';
  static const String trialStartDateKey = 'trial_start_date';

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

  double get profitMargin {
    return (_box.get(
      profitMarginKey,
      defaultValue: 30.0,
    ) as num).toDouble();
  }

  Future<void> saveProfitMargin(double value) async {
    await _box.put(profitMarginKey, value);
  }

  bool get initialSetupCompleted {
    return _box.get(
      initialSetupCompletedKey,
      defaultValue: false,
    ) as bool;
  }

  Future<void> completeInitialSetup() async {
    await _box.put(initialSetupCompletedKey, true);

    if (!_box.containsKey(trialStartDateKey)) {
      await _box.put(trialStartDateKey, DateTime.now().toIso8601String());
    }
  }

  DateTime? get trialStartDate {
    final value = _box.get(trialStartDateKey);

    if (value is! String) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  int get trialDaysRemaining {
    final startDate = trialStartDate;

    if (startDate == null) {
      return 30;
    }

    final startDay = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );

    final today = DateTime.now();
    final currentDay = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final elapsedDays = currentDay.difference(startDay).inDays;
    final remaining = 30 - elapsedDays;

    return remaining.clamp(0, 30);
  }

  bool get trialExpired => trialDaysRemaining <= 0;

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

  String formatCurrency(double value, {int decimals = 2}) {
    return '$currencySymbol${value.toStringAsFixed(decimals)}';
  }
}
