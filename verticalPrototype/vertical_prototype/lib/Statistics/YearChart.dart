import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';



class Yearchart extends StatefulWidget {
  const Yearchart({super.key});

  @override
  State<Yearchart> createState() => _YearchartState();
}

class _YearchartState extends State<Yearchart> {

  List<FlSpot> waterUsageData = List.generate(13, (index) {
    // Assuming random water usage between 1 and 10 liters per day
    double waterUsage = Random().nextDouble() * 100 + 1;
    // Day of the month (1-indexed)
    double dayOfMonth = index + 1;
    return FlSpot(dayOfMonth, waterUsage);
  });

  List<String> titles= [
    'J', // January
    'F', // February
    'M', // March
    'A', // April
    'M', // May
    'J', // June
    'J', // July
    'A', // August
    'S', // September
    'O', // October
    'N', // November
    'D', // December
  ];
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
              bottomTitles: AxisTitles(sideTitles: _groupSideTitles()),
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


  SideTitles _groupSideTitles() {
    return SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          return Text(titles[value.toInt()], style: TextStyle(color: Color.fromRGBO(2, 112, 136, 0.65),));
        }

    );
  }


}
