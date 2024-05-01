import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';



class WaterConsumption {

  late String id;

  String waterActivityID; //Foreign key to water activity
  String userID;

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
      duration: snapshot['duration'].toDouble(),
    )..id = snapshot.id;
  }
}


class WaterConsumptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addWaterConsumption(WaterConsumption waterConsumption) async {
    try {
      await _firestore.collection('water_consumptions').add(waterConsumption.toMap());
    } catch (e) {
      print("Error adding water consumption: $e");
    }
  }
}
