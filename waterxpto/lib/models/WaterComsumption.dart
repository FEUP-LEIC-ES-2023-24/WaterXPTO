import 'package:cloud_firestore/cloud_firestore.dart';



class WaterConsumption {
  String userID;
  DateTime finishDate;
  Timestamp duration;

  WaterConsumption({required this.userID, required this.finishDate, required this.duration});

  // Convert WaterConsumption object to Map
  Map<String, dynamic> toMap() {
    return {
      'userID' : userID,
      'finishDate': Timestamp.fromDate(finishDate),
      'duration': duration,
    };

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
