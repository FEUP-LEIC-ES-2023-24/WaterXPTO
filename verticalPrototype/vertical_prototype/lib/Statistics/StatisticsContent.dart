import 'package:flutter/material.dart';


class StatisticsContent extends StatelessWidget {

  final List<double> liters = [10, 35, 42, 53, 28, 41, 60];
  final int avg = 144;
  final int nBelowNationalAvg = 40;
  final int nationalAverage = 184;

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
                Tab(

                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(500), // Adjust the radius as needed
                      color:  Color.fromRGBO(202, 244, 251, 1), // Color of the tab button
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Padding of the tab button
                    child: Text(
                      'Week',
                      style: TextStyle(color: Color.fromRGBO(0, 33, 40, 1), fontWeight: FontWeight.w600, fontSize: 12, fontFamily: "Inter"), // Text style of the tab button
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(500), // Adjust the radius as needed
                      color: Color.fromRGBO(202, 244, 251, 1), // Color of the tab button
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Padding of the tab button
                    child: Text(
                      'Month',
                      style: TextStyle(color: Color.fromRGBO(0, 33, 40, 1), fontWeight: FontWeight.w600, fontSize: 12, fontFamily: "Inter"), // Text style of the tab button
                    ),
                  ),
                ),
                Tab(
                  child: Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(500), // Adjust the radius as needed
                      color:  Color.fromRGBO(202, 244, 251, 1), // Color of the tab button
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Padding of the tab button
                    child: Text(
                      'Year',
                      style: TextStyle(color: Color.fromRGBO(0, 33, 40, 1), fontWeight: FontWeight.w600, fontSize: 12, fontFamily: "Inter"), // Text style of the tab button
                    ),
                  ),
                ),
              ],
            ),
          ),
          //Tab for Week Month Year
          //TabBarView to display different charts based on selected tab
          SizedBox(
            height: 200,
            child: TabBarView(

              children: [
                // Week Chart
                SizedBox(
                  height: 10,
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0,top: 10, bottom: 20),
                    //decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(202, 244, 251, 1),
                      borderRadius: BorderRadius.circular(12),
                      shape: BoxShape.rectangle, // Add this line
                    ),

                    child: AspectRatio(
                      aspectRatio: 1,
                      // Adjust the height as needed
                      child: WeekChart(liters: liters),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0,top: 10, bottom: 20),
                    //decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(202, 244, 251, 1),
                      borderRadius: BorderRadius.circular(12),
                      shape: BoxShape.rectangle, // Add this line
                    ),

                    child: AspectRatio(
                      aspectRatio: 1,
                      // Adjust the height as needed
                      child: WeekChart(liters: liters),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0,top: 10, bottom: 20),
                    //decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(202, 244, 251, 1),
                      borderRadius: BorderRadius.circular(12),
                      shape: BoxShape.rectangle, // Add this line
                    ),

                    child: AspectRatio(
                      aspectRatio: 1,
                      // Adjust the height as needed
                      child: WeekChart(liters: liters),
                    ),
                  ),
                ),


              ],
            ),
          ),
          Text("Average: $avg L", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
          Text("$nBelowNationalAvg Below National Average ($nationalAverage L)", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),)
        ],
      ),
    );
  }
}