class YieldEngine {
  double calculate({required double totalMass, double bakingLoss = 10}) {
    return totalMass * ((100 - bakingLoss) / 100);
  }
}
