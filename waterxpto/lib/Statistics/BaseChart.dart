import 'package:flutter/material.dart';

abstract class BaseChart extends StatefulWidget {
  final List<double> liters;

  const BaseChart({required this.liters, Key? key}) : super(key: key);

  @override
  State<BaseChart> createState();

  int getAverage() {
    if (liters.isEmpty) return 0;

    double sum = liters.reduce((value, element) => value + element);
    return (sum / liters.length).toInt();
  }

}

abstract class _BaseChartState extends State<BaseChart> {
  // Common logic for all chart states can go here
}
