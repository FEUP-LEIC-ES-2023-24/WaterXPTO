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

      // Perform asynchronous work outside of setState()
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
}
