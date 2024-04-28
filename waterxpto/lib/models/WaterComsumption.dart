import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';



class WaterConsumption {

  late String id;

  String waterActivityID; //Foreign key to water activity

  DateTime finishDate;
  UnsignedLong duration;

  WaterConsumption(
      {required this.waterActivityID, required this.finishDate, required this.duration});

  // Convert WaterConsumption object to Map
  Map<String, dynamic> toMap() {
    return {
      'water_activity_id': waterActivityID,
      'finish_date': finishDate,
      'duration': duration,
    };
  }


  factory WaterConsumption.fromMap(String id, Map<String, dynamic> map) {
    return WaterConsumption(
      finishDate: map['finish_date'].toDate(),
      duration: map['duration'],
      waterActivityID: map['water_activity_id'],
    )
      ..id = id;
  }

}


class WaterConsumptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addWaterConsumption(String userId, WaterConsumption waterConsumption) async {
    try {
      await _firestore.collection('users').doc(userId).collection('water_consumptions').add(waterConsumption.toMap());
    } catch (e) {
      print("Error adding water consumption: $e");
    }
  }
}
