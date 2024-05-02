import 'package:flutter/material.dart';

import '../database.dart';
import 'BaseChart.dart';
import 'MonthChart.dart';
import 'WeekChart.dart';
import 'YearChart.dart';



class StatisticsContent extends StatelessWidget {
  final DatabaseHelper db = DatabaseHelper.instance;
  final int nationalAverage = 184;
  final int monthNationalAverage = 310; // Arbitrary national average for a month
  final int yearNationalAverage = 400; // Arbitrary national average for a year

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50, // Adjust the height as needed
                child: Center(
                  child: Text("Your History", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                ),
              ),
              Container(
                height: 50, // Adjust the height as needed
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
                    ]
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: TabBarView(
                  children: [
                    // Week Chart
                    FutureBuilder<List<double>>(
                      future: db.getWaterConsumptionForWeek(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return StatisticsTab(w: WeekChart(liters: snapshot.data!), nationalAverage: nationalAverage,);
                        } else {
                          return CircularProgressIndicator(); // Show a loading spinner while waiting for data
                        }
                      },
                    ),
                    // Month Chart
                    FutureBuilder<List<double>>(
                      future: db.getWaterConsumptionForMonth(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return StatisticsTab(w: MonthChart(liters: snapshot.data!), nationalAverage: monthNationalAverage,);
                        } else {
                          return CircularProgressIndicator(); // Show a loading spinner while waiting for data
                        }
                      },
                    ),
                    // Year Chart
                    FutureBuilder<List<double>>(
                      future: db.getWaterConsumptionForYear(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return StatisticsTab(w: YearChart(liters: snapshot.data!), nationalAverage: yearNationalAverage,);
                        } else {
                          return CircularProgressIndicator(); // Show a loading spinner while waiting for data
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
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
          borderRadius: BorderRadius.circular(500),
          color:  Color.fromRGBO(202, 244, 251, 1),
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
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.5,
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
          Text("$nBelowNationalAvg Below National Average ($nationalAverage L)", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w400),)
        ],
      ),
    );
  }
}
