import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/User.dart';
import '../models/WaterComsumption.dart';

class WaterSpentNotifier extends ChangeNotifier {
  double waterSpent = 0.0;
  final WaterConsumptionService _waterConsumptionService = WaterConsumptionService();
  final AuthService _authService = AuthService();

  double get todayLitersSpent => waterSpent;

  void updateTodayLitersSpent() async {
    if (await _authService.isUserLoggedIn()) {
      waterSpent = await _waterConsumptionService.updateTodayLitersSpent();
    } else {
      waterSpent = 0;
    }
    notifyListeners();
  }


  static WaterSpentNotifier of(BuildContext context, {bool listen = false}) {
    return Provider.of<WaterSpentNotifier>(context, listen: listen);
  }
}