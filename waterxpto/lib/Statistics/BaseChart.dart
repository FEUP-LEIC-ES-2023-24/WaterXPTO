import 'package:flutter/material.dart';

abstract class BaseChart extends StatefulWidget {
  final List<double> liters;

  const BaseChart({required this.liters, Key? key}) : super(key: key);

  @override
  State<BaseChart> createState();

  int getAverage() {
    List<double> filteredList = liters.where((liters) => liters != 0).toList();
    if (filteredList.isEmpty) return 0;
    double sum = filteredList.reduce((value, element) => value + element);
    return (sum / filteredList.length).toInt();
  }

}

abstract class _BaseChartState extends State<BaseChart> {
  // Common logic for all chart states can go here
}
