import 'package:flutter/material.dart';
import 'package:waterxpto/models/User.dart';
import '../Controller/database.dart';
import '../models/WaterActivity.dart';
import '../models/WaterConsumption.dart';
import 'BaseChart.dart';
import 'MonthChart.dart';
import 'WeekChart.dart';
import 'YearChart.dart';



class StatisticsContent extends StatelessWidget {
  final DatabaseHelper db = DatabaseHelper.instance;
  final AuthService authService = AuthService();
  final WaterConsumptionService waterConsumptionService = WaterConsumptionService();
  final WaterActivityService waterActivityService = WaterActivityService();

  final int nationalAverage = 184;
  final int monthNationalAverage = 310;
  final int yearNationalAverage = 400;

  StatisticsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
                child: const Center(
                  child: Text("Your History", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                ),
              ),
              Container(
                height: 50,
                child: const TabBar(
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
                    FutureBuilder<bool>(
                      future: authService.isUserLoggedIn(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return FutureBuilder<List<double>>(
                            future: getWaterConsumptionForWeekFromFirebase(),
                            builder: (BuildContext context, AsyncSnapshot<List<double>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return StatisticsTab(
                                  w: WeekChart(liters: snapshot.data!),
                                  nationalAverage: nationalAverage,
                                );
                              }
                            },
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    // Month Chart
                    FutureBuilder<bool>(
                    future: authService.isUserLoggedIn(),
                    builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return FutureBuilder<List<double>>(
                            future: getWaterConsumptionForMonthFromFirebase(),
                            builder: (BuildContext context, AsyncSnapshot<List<double>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return StatisticsTab(
                                  w: MonthChart(liters: snapshot.data!),
                                  nationalAverage: monthNationalAverage,
                                );
                              }
                            },
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    // Year Chart
                    FutureBuilder<bool>(
                      future: authService.isUserLoggedIn(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return FutureBuilder<List<double>>(
                            future: getWaterConsumptionForYearFromFirebase(),
                            builder: (BuildContext context, AsyncSnapshot<List<double>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return StatisticsTab(
                                  w: YearChart(liters: snapshot.data!),
                                  nationalAverage: yearNationalAverage,
                                );
                              }
                            },
                          );
                        } else {
                          return const CircularProgressIndicator();
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

  Future<List<double>> getWaterConsumptionForYearFromFirebase() async {
    if (await authService.isUserLoggedIn()) {
      List<List<WaterConsumption>> yearValues = await waterConsumptionService.getUserWaterConsumptionsInAYear(authService.getCurrentUser()!.userID);
      List<double> result = [];

      await Future.forEach(yearValues, (val) async {
        double sum = 0;
        await Future.forEach(val, (val) async {
          WaterActivity? w = await waterActivityService.getWaterActivityByID(val.waterActivityID);
          sum += (w!.waterFlow * (val.duration.toDouble() / 60));
        });
        result.add(sum);
      });

      return result;
    } else {
      return db.getWaterConsumptionForYear();
    }
  }

  Future<List<double>> getWaterConsumptionForWeekFromFirebase() async {
    if (await authService.isUserLoggedIn()) {
      List<List<WaterConsumption>> weekValues = await waterConsumptionService.getUserWaterConsumptionInAWeek(authService.getCurrentUser()!.userID);
      List<double> result = [];

      await Future.forEach(weekValues, (val) async {
        double sum = 0;
        await Future.forEach(val, (val) async {
          WaterActivity? w = await waterActivityService.getWaterActivityByID(val.waterActivityID);
          sum += (w!.waterFlow * (val.duration.toDouble() / 60));
        });
        result.add(sum);
      });
      return result;
    } else {
      return db.getWaterConsumptionForWeek();
    }
  }

  Future<List<double>> getWaterConsumptionForMonthFromFirebase() async {
    if (await authService.isUserLoggedIn()) {
      List<List<WaterConsumption>> monthValues = await waterConsumptionService.getUserWaterConsumptionsInAMonth(authService.getCurrentUser()!.userID);
      List<double> result = [];

      await Future.forEach(monthValues, (val) async {
        double sum = 0;
        await Future.forEach(val, (val) async {
          WaterActivity? w = await waterActivityService.getWaterActivityByID(val.waterActivityID);
          sum += (w!.waterFlow * (val.duration.toDouble() / 60));
        });
        result.add(sum);
      });
      return result;
    } else {
      return db.getWaterConsumptionForMonth();
    }
  }
}

class StatisticsTabButton extends StatelessWidget {
  final String text;
  const StatisticsTabButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Tab(

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(500),
          color:  const Color.fromRGBO(202, 244, 251, 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          text,
          style: const TextStyle(color: Color.fromRGBO(0, 33, 40, 1), fontWeight: FontWeight.w600, fontSize: 12, fontFamily: "Inter"),
        ),
      ),
    );
  }
}

class StatisticsTab extends StatelessWidget {
  final BaseChart w;
  int nationalAverage;


  StatisticsTab({super.key, required this.w, required this.nationalAverage});

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

            margin: const EdgeInsets.only(left: 20.0, right: 20.0,top: 10, bottom: 20),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(202, 244, 251, 1),
              borderRadius: BorderRadius.circular(12),
              shape: BoxShape.rectangle,
            ),

            child: Padding(
              padding: const EdgeInsets.all(15),
              child: AspectRatio(
                  aspectRatio: 2,
                child: w,

              ),
            ),
          ),
          Text("Average: $avg L", style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
          Text("$nBelowNationalAvg Below National Average ($nationalAverage L)", style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w400),)
        ],
      ),
    );
  }
}
