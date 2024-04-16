import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthChart extends StatefulWidget {
  const MonthChart({super.key});

  @override
  State<MonthChart> createState() => _MonthChartState();
}

class _MonthChartState extends State<MonthChart> {

  List<FlSpot> waterUsageData = List.generate(13, (index) {
    // Assuming random water usage between 1 and 10 liters per day
    double waterUsage = Random().nextDouble() * 100 + 1;
    // Day of the month (1-indexed)
    double dayOfMonth = index + 1;
    return FlSpot(dayOfMonth, waterUsage);
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
        LineChartData(
            maxY: 150,
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
