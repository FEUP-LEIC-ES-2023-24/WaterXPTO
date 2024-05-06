import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'User.dart';
import 'WaterActivity.dart';



class WaterConsumption {

  late String id;

  String waterActivityID; //Foreign key to water activity
  String? userID;

  DateTime finishDate;
  int duration;

  WaterConsumption(
      {required this.waterActivityID, required this.userID, required this.finishDate, required this.duration});

  // Convert WaterConsumption object to Map
  Map<String, dynamic> toMap() {
    return {
      'water_activity_id': waterActivityID,
      'user_id' : userID,
      'finish_date': finishDate,
      'duration': duration,
    };
  }


  factory WaterConsumption.fromSnapshot(DocumentSnapshot snapshot) {
    return WaterConsumption(
      userID: snapshot['user_id'],
      waterActivityID: snapshot['water_activity_id'],
      finishDate: snapshot['finish_date'].toDate(),
      duration: snapshot['duration'],
    )..id = snapshot.id;
  }
}


class WaterConsumptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService authService = AuthService();
  final WaterActivityService waterActivityService = WaterActivityService();


  Future<void> addWaterConsumption(WaterConsumption waterConsumption) async {
    try {
      await _firestore.collection('water_consumptions').add(waterConsumption.toMap());
    } catch (e) {
      print("Error adding water consumption: $e");
    }
  }

  Future<double> updateTodayLitersSpent() async {
    double sum = 0;
    if (await authService.isUserLoggedIn()) {
      List<WaterConsumption> todayValues = await getUserWaterConsumptionsInADay(authService.getCurrentUser()!.userID, DateUtils.dateOnly(DateTime.now()));

      await Future.forEach(todayValues, (val) async {
        WaterActivity? w = await waterActivityService.getWaterActivityByID(val.waterActivityID);
        sum += (w!.waterFlow * (val.duration.toDouble() / 60));
      });
    }
    return sum;
  }

  Future<List<WaterConsumption>> getUserWaterConsumptionsInADay(String? userID, DateTime date) async {
    List<WaterConsumption> result = [];
    try {
      QuerySnapshot snapshot = await _firestore.collection('water_consumptions').where('user_id', isEqualTo: userID).get();
      if(snapshot.docs.isNotEmpty) {
        for(var doc in snapshot.docs) {
          if(DateUtils.dateOnly(doc['finish_date'].toDate()) == date){
              result.add(WaterConsumption.fromSnapshot(doc));
          }
        }
      }
      return result;
    } catch (e) {
      print("Error adding water consumption: $e");
      return result;
    }
  }

  Future<List<List<WaterConsumption>>> getUserWaterConsumptionInAWeek(String? userID) async {
    List<List<WaterConsumption>> result = List.generate(7, (index) => []);
    DateTime now = DateTime.now();
    DateTime sevenDaysAgo = now.subtract(Duration(days: 7));
    try {
      QuerySnapshot snapshot = await _firestore.collection('water_consumptions')
          .where('user_id', isEqualTo: userID)
          .where('finish_date', isGreaterThanOrEqualTo: sevenDaysAgo)
          .get();
      if(snapshot.docs.isNotEmpty) {
        for(var doc in snapshot.docs) {
          DateTime finishDate = doc['finish_date'].toDate();
          int dayOfWeek = finishDate.weekday - 1;
          result[dayOfWeek].add(WaterConsumption.fromSnapshot(doc));
        }
      }
      return result;
    } catch (e) {
      print("Error getting water consumption: $e");
      return result;
    }
  }

  bool isDateInLastWeek(DateTime date, DateTime now) {
    final lastWeek = now.subtract(Duration(days: 7));
    return date.isAfter(lastWeek) && date.isBefore(now);
  }

  int daysInMonth(int year, int month) {
    return month < 12 ? DateTime(year, month + 1, 0).day : DateTime(year + 1, 1, 0).day;
  }

  Future<List<List<WaterConsumption>>> getUserWaterConsumptionsInAMonth(String? userID,) async {
    List<List<WaterConsumption>> result = List.generate(daysInMonth(DateTime.now().year, DateTime.now().month), (index) => []);
    DateTime now = DateTime.now();
    try {
      QuerySnapshot snapshot = await _firestore.collection('water_consumptions').where('user_id', isEqualTo: userID).get();
      if(snapshot.docs.isNotEmpty) {
        for(var doc in snapshot.docs) {
          DateTime finishDate = doc['finish_date'].toDate();
          if(finishDate.month == now.month && finishDate.year == now.year){
            int dayOfMonth = finishDate.day - 1;
            result[dayOfMonth].add(WaterConsumption.fromSnapshot(doc));
          }
        }
      }
      return result;
    } catch (e) {
      print("Error getting water consumption: $e");
      return result;
    }
  }

  Future<List<List<WaterConsumption>>> getUserWaterConsumptionsInAYear(String? userID) async {
    List<List<WaterConsumption>> result = List.generate(12, (index) => []);
    DateTime now = DateTime.now();
    try {
      QuerySnapshot snapshot = await _firestore.collection('water_consumptions').where('user_id', isEqualTo: userID).get();
      if(snapshot.docs.isNotEmpty) {
        for(var doc in snapshot.docs) {
          DateTime finishDate = doc['finish_date'].toDate();
          if(finishDate.year == now.year){
            int monthOfYear = finishDate.month - 1;
            result[monthOfYear].add(WaterConsumption.fromSnapshot(doc));
          }
        }
      }
      return result;
    } catch (e) {
      print("Error getting water consumption: $e");
      return result;
    }
  }
}
