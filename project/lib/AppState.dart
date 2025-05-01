import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  int missionsInProgress = 0;
  int totalMissionsCompleted = 125; // Tracks the total number of completed missions
  List<String> completedMissions = [];
  Map<String, int> equipmentStock = {
    'Defibrillator': 10,
    'Oxygen Tank': 5,
    'First Aid Kit': 8,
  };

  void incrementMissionsInProgress() {
    missionsInProgress++;
    notifyListeners();
  }

  void completeMission() {
    if (missionsInProgress > 0) {;
      totalMissionsCompleted++; // Increment total completed missions
      completedMissions.add('Mission completed at ${DateTime.now()}');
      notifyListeners();
    }
  }

  void incrementMissions() {
    missionsInProgress++;
    completedMissions.add('Mission completed at ${DateTime.now()}');
    notifyListeners();
  }

  void updateEquipment(String item, int quantity) {
    equipmentStock[item] = (equipmentStock[item] ?? 0) + quantity;
    notifyListeners();
  }

  int getEquipmentStock(String item) {
    return equipmentStock[item] ?? 0;
  }
}