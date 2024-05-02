import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'BaseChart.dart';



class YearChart extends BaseChart {
  const YearChart({required List<double> liters, Key? key})
      : super(liters: liters, key: key);

  @override
  State<YearChart> createState() => _YearChartState();
}

class _YearChartState extends State<YearChart> {

  List<FlSpot> waterUsageData = [];

  @override
  void initState() {
    super.initState();
    waterUsageData = List.generate(widget.liters.length, (index) {
      double monthOfYear = index + 1;
      double waterUsage = widget.liters[index];
      return FlSpot(monthOfYear, waterUsage);
    });
  }

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
          if (value - 1 >= 0 && value - 1 < 12) {
           return Text(titles[value.toInt() - 1], style: TextStyle(color: Color.fromRGBO(2, 112, 136, 0.65),));
          }
          else {
            return Text("");
          }
        }

    );
  }




}
