import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'BaseChart.dart';

class MonthChart extends BaseChart {
  const MonthChart({required List<double> liters, Key? key})
      : super(liters: liters, key: key);

  @override
  State<MonthChart> createState() => _MonthChartState();
}

class _MonthChartState extends State<MonthChart> {

  List<FlSpot> waterUsageData = [];

  @override
  void initState() {
    super.initState();
    waterUsageData = List.generate(widget.liters.length, (index) {
      double dayOfMonth = index + 1;
      double waterUsage = widget.liters[index];
      return FlSpot(dayOfMonth, waterUsage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
        LineChartData(
            maxY: 60,
            minY: 0,

            borderData: FlBorderData(
                border: const Border(bottom: BorderSide(), left: BorderSide())),
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),


            lineBarsData: [
              LineChartBarData(

                spots: waterUsageData,
                dotData: FlDotData(show: false),
              )
            ]
        )
    );
  }
}
