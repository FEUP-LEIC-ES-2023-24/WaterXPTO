
import "package:flutter/material.dart";
import 'package:fl_chart/fl_chart.dart';
import 'BaseChart.dart';
class WeekChart extends BaseChart {

  const WeekChart({required List<double> liters, Key? key})
      : super(liters: liters, key: key);


  @override
  State<WeekChart> createState() => _WeekChartState();

}

class _WeekChartState extends State<WeekChart> {


  final titles = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return BarChart(


        BarChartData(

            minY: 0,
            maxY: 60,

            barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (color) => Colors.transparent,
                  tooltipPadding: EdgeInsets.zero,
                  tooltipMargin: 0,
                  getTooltipItem: (
                      BarChartGroupData group,
                      int groupIndex,
                      BarChartRodData rod,
                      int rodIndex,
                      ) {
                    return BarTooltipItem(
                      rod.toY.round().toString(),
                      const TextStyle(
                        color: Color.fromRGBO(49, 137, 156, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },

                )
            ),


            gridData: FlGridData(show: false),
            borderData: FlBorderData(
              border: Border(

              ),
            ),
            barGroups: _groupData(),
            titlesData: FlTitlesData(
                leftTitles: AxisTitles( sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles( sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles( sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(sideTitles: _groupSideTitles())
            )


        )
    );


  }

  List<BarChartGroupData> _groupData() {
    List<BarChartGroupData> res = <BarChartGroupData>[];

    for (var i = 0; i < 7; i++) {

      res.add(BarChartGroupData(

          x: i,
          showingTooltipIndicators: [0],

          barRods: [
            BarChartRodData(toY: widget.liters[i],
                color: Color.fromRGBO(2, 112, 136, 0.65),
                width: 20,
                borderRadius: BorderRadius.all(Radius.circular(3))
            )

          ]

      ));
    }


    return res;

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