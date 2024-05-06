import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/User.dart';
import '../models/WaterConsumption.dart';

class WaterSpentNotifier extends ChangeNotifier {
  double waterSpent = 0.0;
  final WaterConsumptionService _waterConsumptionService = WaterConsumptionService();
  final AuthService _authService = AuthService();

  double get todayLitersSpent => waterSpent;

  Future<void> updateTodayLitersSpent() async {
    if (await _authService.isUserLoggedIn()) {
      double newValue = await _waterConsumptionService.updateTodayLitersSpent();
      print('New value from database: $newValue');  // Debug print
      waterSpent = newValue;
    } else {
      waterSpent = 0;
    }
    print('Updated waterSpent: $waterSpent');  // Debug print
    notifyListeners();
  }

  void setTodayLitersSpent(double value) {
    waterSpent = value;
    notifyListeners();
  }

  static WaterSpentNotifier of(BuildContext context, {bool listen = false}) {
    return Provider.of<WaterSpentNotifier>(context, listen: listen);
  }
}