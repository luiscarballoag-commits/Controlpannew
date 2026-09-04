import 'package:hive/hive.dart';

import '../models/depreciation_asset.dart';

class DepreciationService {
  static const String boxName = 'depreciation_assets';

  static const double monthsPerYear = 12;

  Box<DepreciationAsset> get _box =>
      Hive.box<DepreciationAsset>(boxName);

  List<DepreciationAsset> getAllAssets() {
    return _box.values.toList();
  }

  List<DepreciationAsset> getActiveAssets() {
    return _box.values
        .where((asset) => asset.active)
        .toList();
  }

  void addAsset(DepreciationAsset asset) {
    _box.add(asset);
  }

  void updateAsset(int index, DepreciationAsset asset) {
    _box.putAt(index, asset);
  }

  void deleteAsset(int index) {
    _box.deleteAt(index);
  }

  DepreciationAsset? getAsset(int index) {
    if (index < 0 || index >= _box.length) {
      return null;
    }

    return _box.getAt(index);
  }

  double getAnnualDepreciation(DepreciationAsset asset) {
    if (asset.purchaseValue <= 0 || asset.usefulLifeYears <= 0) {
      return 0;
    }

    return asset.purchaseValue / asset.usefulLifeYears;
  }

  double getMonthlyDepreciation(DepreciationAsset asset) {
    final annual = getAnnualDepreciation(asset);

    if (annual <= 0) {
      return 0;
    }

    return annual / monthsPerYear;
  }

  double getHourlyDepreciation(DepreciationAsset asset) {
    if (asset.productiveHoursPerMonth <= 0) {
      return 0;
    }

    return getMonthlyDepreciation(asset) /
        asset.productiveHoursPerMonth;
  }

  double getProductionDepreciation({
    required DepreciationAsset asset,
    required double hours,
  }) {
    if (!asset.active || hours <= 0) {
      return 0;
    }

    return getHourlyDepreciation(asset) * hours;
  }

  double getTotalProductionDepreciation({
    required double hours,
  }) {
    if (hours <= 0) {
      return 0;
    }

    double total = 0;

    for (final asset in getActiveAssets()) {
      total += getProductionDepreciation(
        asset: asset,
        hours: hours,
      );
    }

    return total;
  }
}
