import 'package:flutter/material.dart';

import 'BaseChart.dart';
import 'MonthChart.dart';
import 'WeekChart.dart';
import 'YearChart.dart';



class StatisticsContent extends StatelessWidget {

  //Stubs for user data from database
  final int avg = 10;
  //Week
  final List<double> liters = [10, 35, 42, 53, 28, 41, 60];
  final int nBelowNationalAvg = 40;
  final int nationalAverage = 184;

  //Month
  final List<double> monthLiters = [
    40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135,
    140, 145, 150, 155, 160, 165, 170, 175, 180, 185
  ];
  final int monthBelowNationalAvg = 100; // Arbitrary number of liters below the national average
  final int monthNationalAverage = 310; // Arbitrary national average for a month

  //Year
  final List<double> yearLiters = [
    200, 220, 240, 260, 280, 300, 320, 340, 360, 380, 400, 420
  ];
  final int yearBelowNationalAvg = 160; // Arbitrary number of liters below the national average
  final int yearNationalAverage = 400; // Arbitrary national average for a year

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

      length: 3,
      child: Column(

        children: [
          //Text
          Text("Your History", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),

          Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: TabBar(


              indicator: BoxDecoration(),
              dividerColor: Colors.transparent,
              labelColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              overlayColor: null,

              tabs: [
                StatisticsTabButton(text: "week"),
                StatisticsTabButton(text: "month"),
                StatisticsTabButton(text: "year"),

              ],
            ),
          ),
          //Tab for Week Month Year
          //TabBarView to display different charts based on selected tab
          SizedBox(
            height: 600,
            child: TabBarView(
              children: [
                // Week Chart
                StatisticsTab(w: WeekChart(liters: liters), nationalAverage: nationalAverage,),
                StatisticsTab(w: MonthChart(liters: monthLiters), nationalAverage: monthNationalAverage,),
                StatisticsTab(w: YearChart(liters: yearLiters), nationalAverage: yearNationalAverage,),

              ],
            ),
          ),

        ],
      ),
    );
  }
}

class StatisticsTabButton extends StatelessWidget {
  final String text;
  const StatisticsTabButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return Tab(

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(500), // Adjust the radius as needed
          color:  Color.fromRGBO(202, 244, 251, 1), // Color of the tab button
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Padding of the tab button
        child: Text(
          text,
          style: TextStyle(color: Color.fromRGBO(0, 33, 40, 1), fontWeight: FontWeight.w600, fontSize: 12, fontFamily: "Inter"), // Text style of the tab button
        ),
      ),
    );
  }
}

class StatisticsTab extends StatelessWidget {
  final BaseChart w;
  int nationalAverage;


  StatisticsTab({required this.w, required this.nationalAverage});

  @override
  Widget build(BuildContext context) {
    int avg = w.getAverage();
    int nBelowNationalAvg = nationalAverage - avg;
    return SizedBox(


      child: Column(
        children: [
          Container(

            margin: EdgeInsets.only(left: 20.0, right: 20.0,top: 10, bottom: 20),
            //decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            decoration: BoxDecoration(
              color: Color.fromRGBO(202, 244, 251, 1),
              borderRadius: BorderRadius.circular(12),
              shape: BoxShape.rectangle, // Add this line
            ),

            child: Padding(
              padding: const EdgeInsets.all(15),
              child: AspectRatio(
                  aspectRatio: 2,
                  // Adjust the height as needed
                child: w,

              ),
            ),
          ),
          Text("Average: $avg L", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
          Text("$nBelowNationalAvg Below National Average ($nationalAverage L)", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),)
        ],
      ),
    );
  }
}
