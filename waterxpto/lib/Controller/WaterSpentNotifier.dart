import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class WaterSpentNotifier extends ChangeNotifier {
  double waterSpent;
  int lastUpdatedDay;

  WaterSpentNotifier({
    required this.waterSpent,
  }) : lastUpdatedDay = DateTime.now().day;

  void updateWaterSpent(double newWaterSpent) {
    waterSpent = waterSpent + newWaterSpent;
    notifyListeners();
  }

  static WaterSpentNotifier of(BuildContext context, {bool listen = false}) {
    return Provider.of<WaterSpentNotifier>(context, listen: listen);
  }
}