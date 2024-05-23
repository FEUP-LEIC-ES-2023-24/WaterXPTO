import 'package:flutter/material.dart';
import 'package:waterxpto/models/User.dart';
import '../Controller/database.dart';
import '../models/WaterActivity.dart';
import '../models/WaterConsumption.dart';
import 'BaseChart.dart';
import 'MonthChart.dart';
import 'WeekChart.dart';
import 'YearChart.dart';

class StatisticsContent extends StatefulWidget {
  StatisticsContent({super.key});

  @override
  _StatisticsContentState createState() => _StatisticsContentState();
}

class _StatisticsContentState extends State<StatisticsContent> {
  final DatabaseHelper db = DatabaseHelper.instance;
  final AuthService authService = AuthService();
  final WaterConsumptionService waterConsumptionService = WaterConsumptionService();
  final WaterActivityService waterActivityService = WaterActivityService();
  String selectedCountry = "Portugal";
  Map<String, double> waterConsumptionMap = {
    "Afghanistan": 189.5,
    "Albania": 79.7,
    "Algeria": 45.2,
    "Angola": 6.6,
    "Antigua and Barbuda": 23.9,
    "Argentina": 166.2,
    "Armenia": 182.3,
    "Australia": 121.7,
    "Austria": 76.3,
    "Azerbaijan": 231.7,
    "Bahrain": 56.3,
    "Bangladesh": 45.1,
    "Barbados": 54.9,
    "Belarus": 27.3,
    "Belgium": 101.5,
    "Belize": 76.7,
    "Benin": 3.3,
    "Bhutan": 89.5,
    "Bolivia": 37.9,
    "Bosnia and Herzegovina": 16.5,
    "Botswana": 15.6,
    "Brazil": 56.1,
    "Bulgaria": 140.7,
    "Burkina Faso": 10.8,
    "Burundi": 8.3,
    "Cabo Verde": 8.6,
    "Cambodia": 29.6,
    "Cameroon": 11.7,
    "Canada": 182.7,
    "Central African Republic": 3.1,
    "Chad": 16.1,
    "Chile": 396.2,
    "China": 78.4,
    "Colombia": 49.1,
    "Comoros": 3.5,
    "Congo": 2.5,
    "Costa Rica": 119.2,
    "Croatia": 26.9,
    "Cuba": 112.3,
    "Cyprus": 48.3,
    "Czech Republic": 28.3,
    "Côte d'Ivoire": 9.2,
    "Denmark": 21.3,
    "Djibouti": 4.7,
    "Dominica": 53.1,
    "Dominican Republic": 133.7,
    "DR Congo": 2.2,
    "Ecuador": 131.5,
    "Egypt": 139.1,
    "El Salvador": 64.1,
    "Equatorial Guinea": 4.7,
    "Eritrea": 38.5,
    "Estonia": 239.0,
    "Eswatini": 184.7,
    "Ethiopia": 18.3,
    "Fiji": 17.7,
    "Finland": 227.6,
    "France": 83.8,
    "Gabon": 17.4,
    "Gambia": 11.5,
    "Georgia": 85.8,
    "Germany": 56.7,
    "Ghana": 9.1,
    "Greece": 158.6,
    "Grenada": 21.8,
    "Guatemala": 45.3,
    "Guinea": 11.9,
    "Guinea-Bissau": 26.0,
    "Guyana": 352.9,
    "Haiti": 27.2,
    "Honduras": 40.7,
    "Hungary": 93.0,
    "Iceland": 153.5,
    "India": 112.1,
    "Indonesia": 155.3,
    "Iran": 246.7,
    "Iraq": 181.9,
    "Ireland": 30.7,
    "Israel": 54.1,
    "Italy": 103.7,
    "Jamaica": 88.3,
    "Japan": 116.1,
    "Jordan": 19.1,
    "Kazakhstan": 230.1,
    "Kenya": 15.4,
    "Kuwait": 81.5,
    "Kyrgyzstan": 278.7,
    "Laos": 109.0,
    "Latvia": 20.8,
    "Lebanon": 52.5,
    "Lesotho": 4.0,
    "Liberia": 8.3,
    "Libya": 181.4,
    "Lithuania": 174.1,
    "Luxembourg": 13.8,
    "Madagascar": 128.0,
    "Malawi": 19.4,
    "Malaysia": 78.9,
    "Maldives": 3.2,
    "Mali": 69.5,
    "Malta": 24.5,
    "Mauritania": 81.9,
    "Mauritius": 106.6,
    "Mexico": 130.1,
    "Moldova": 50.2,
    "Monaco": 28.2,
    "Mongolia": 27.9,
    "Montenegro": 46.6,
    "Morocco": 58.7,
    "Mozambique": 10.0,
    "Myanmar": 133.3,
    "Namibia": 27.9,
    "Nepal": 65.4,
    "Netherlands": 96.1,
    "New Zealand": 218.5,
    "Nicaragua": 47.5,
    "Niger": 15.3,
    "Nigeria": 14.1,
    "North Korea": 65.6,
    "North Macedonia": 48.3,
    "Norway": 117.3,
    "Oman": 99.2,
    "Pakistan": 180.3,
    "Panama": 54.9,
    "Papua New Guinea": 11.0,
    "Paraguay": 74.4,
    "Peru": 86.6,
    "Philippines": 148.3,
    "Poland": 50.1,
    "Portugal": 158.2,
    "Puerto Rico": 204.0,
    "Qatar": 95.5,
    "Romania": 58.8,
    "Russia": 87.5,
    "Rwanda": 3.4,
    "Saint Kitts & Nevis": 59.7,
    "Saint Lucia": 46.8,
    "Sao Tome & Principe": 36.5,
    "Saudi Arabia": 124.7,
    "Senegal": 39.9,
    "Serbia": 114.7,
    "Seychelles": 29.1,
    "Sierra Leone": 6.8,
    "Slovakia": 18.0,
    "Slovenia": 77.5,
    "Somalia": 61.7,
    "South Africa": 52.5,
    "South Korea": 111.4,
    "South Sudan": 11.7,
    "Spain": 129.1,
    "Sri Lanka": 120.2,
    "St. Vincent & Grenadines": 14.5,
    "State of Palestine": 14.5,
    "Sudan": 142.9,
    "Suriname": 215.5,
    "Sweden": 52.3,
    "Switzerland": 45.8,
    "Syria": 164.7,
    "Tajikistan": 297.3,
    "Tanzania": 26.1,
    "Thailand": 156.7,
    "Timor-Leste": 226.3,
    "Togo": 5.9,
    "Trinidad and Tobago": 49.3,
    "Tunisia": 75.4,
    "Turkey": 132.9,
    "Turkmenistan": 1059.2,
    "Uganda": 3.8,
    "Ukraine": 40.2,
    "United Arab Emirates": 52.5,
    "United Kingdom": 23.4,
    "United States": 250.3,
    "Uruguay": 298.9,
    "Uzbekistan": 444.1,
    "Vanuatu": 1.7,
    "Venezuela": 32.7,
    "Vietnam": 179.5,
    "Yemen": 70.1,
    "Zambia": 9.1,
    "Zimbabwe": 5.8
  };

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
                height: MediaQuery.of(context).size.height * 0.5,
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
                                  nationalAverage: waterConsumptionMap[selectedCountry]!.round(),
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
                                  nationalAverage: waterConsumptionMap[selectedCountry]!.round(),
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
                                  nationalAverage: waterConsumptionMap[selectedCountry]!.round(),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Color(int.parse('0xFF027088')), // Blue shade color
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCountry,
                    style: TextStyle(color: Colors.white),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCountry = newValue!;
                      });
                    },
                    items: waterConsumptionMap.keys.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: value == selectedCountry ? Colors.white : Colors.black,),
                        ),
                      );
                    }).toList(),
                  ),
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
