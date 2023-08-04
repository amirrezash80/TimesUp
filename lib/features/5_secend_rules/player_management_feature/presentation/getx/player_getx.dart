import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart'; // Import the uuid package

import '../../data/models/player_class.dart';

class PlayersController extends GetxController {
  RxList<PlayersInfo> playersList = <PlayersInfo>[].obs;
  int _currentPlayerIndex = 0;

  PlayersController() {
    initPlayers();
  }


  Future<void> initPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final playerNames = prefs.getStringList('playerNames') ?? ['Player 1', 'Player 2'];
    final playerList = playerNames.map((name) => PlayersInfo(id: Uuid().v4(), name: name, points: 0)).toList();
    playersList.assignAll(playerList);
  }

  List<String> getPlayersNames() {
    return playersList.map((player) => player.name).toList();
  }

  void addPlayer() {
    playersList.add(PlayersInfo(id: Uuid().v4(), name: 'Player ${playersList.length + 1}', points: 0));
    _savePlayers();
  }

  void updatePlayerName(int index, String newName) {
    if (index >= 0 && index < playersList.length) {
      playersList[index].name = newName;
      _savePlayers();
    }
  }

  PlayersInfo getCurrentPlayer() {
    if (playersList.isEmpty) {
      throw Exception("No players available");
    } else {
      return playersList[_currentPlayerIndex];
    }
  }

  Future<void> _savePlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final playerNames = playersList.map((player) => player.name).toList();
    prefs.setStringList('playerNames', playerNames);
  }


  void removePlayer(int index) {
    try {
      final updatedList = playersList.toList();
      updatedList.removeAt(index);
      playersList.assignAll(updatedList);
      _savePlayers();
    } catch (e) {
      // Handle error
    }
  }


  void moveToNextPlayer() {
    _currentPlayerIndex++;
    if (_currentPlayerIndex >= playersList.length) {
      _currentPlayerIndex = 0;
    }
  }

  String getCurrentPlayerName() {
    if (playersList.isEmpty) {
      throw Exception("No players available");
    } else {
      return playersList[_currentPlayerIndex].name;
    }
  }

  void addPlayerPoint() {
    if (playersList.isNotEmpty) {
      playersList[_currentPlayerIndex].points++;
    }
  }

  int getPlayersPoint() {
    if (playersList.isNotEmpty) {
      return playersList[_currentPlayerIndex].points;
    } else {
      return 0;
    }
  }

  void resetAllPlayerPoints() {
    final updatedList = playersList
        .map((player) => PlayersInfo(name: player.name, points: 0))
        .toList();
    playersList.assignAll(updatedList); // Assign the updated list
    _savePlayers(); // Call _savePlayers without arguments
  }


}
