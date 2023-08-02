
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/player_class.dart';

class PlayersBloc extends Cubit<List<PlayersInfo>> {
  PlayersBloc() : super([]) {
    initPlayers();
  }

  int _currentPlayerIndex = 0;


  Future<void> initPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final playerNames = prefs.getStringList('playerNames') ?? ['Player 1', 'Player 2'];
    final playerList = playerNames.map((name) => PlayersInfo(name: name, points: 0)).toList();
    emit(playerList);

  }

  void addPlayer() {
    final updatedList = [...state, PlayersInfo(name: 'Player ${state.length + 1}', points: 0)];
    // _currentPlayerIndex = updatedList.length - 1; // Update the current player index
    emit(updatedList);
    _savePlayers(updatedList);
  }


  void updatePlayerName(int index, String newName) {
    if (index >= 0 && index < state.length) {
      List<PlayersInfo> updatedList = List.from(state);
      updatedList[index] = PlayersInfo(name: newName, points: updatedList[index].points);
      emit(updatedList);
      _savePlayers(updatedList);
    }
  }

  PlayersInfo getCurrentPlayer() {
    if (state.isEmpty) {
      throw Exception("No players available");
    } else {
      return state[_currentPlayerIndex];
    }
  }

  Future<void> _savePlayers(List<PlayersInfo> playerList) async {
    final prefs = await SharedPreferences.getInstance();
    final playerNames = playerList.map((player) => player.name).toList();
    prefs.setStringList('playerNames', playerNames);
  }

  void removePlayer(int index, BuildContext context) {
    try {
      if (index >= 0 && index < state.length) {
        List<PlayersInfo> updatedList = List.from(state);
        updatedList.removeAt(index);

        // Update _currentPlayerIndex if needed
        if (_currentPlayerIndex >= updatedList.length) {
          _currentPlayerIndex = updatedList.length - 1;
        }

        emit(updatedList);
        _savePlayers(updatedList);
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while removing the player.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }






  void moveToNextPlayer() {
    _currentPlayerIndex++;
    if (_currentPlayerIndex >= state.length) {
      _currentPlayerIndex = 0; // Start from the first player if all players have played once
    }
  }

  getCurrentPlayerName() {
    if (state.isEmpty) {
      throw Exception("No players available");
    } else {
      return state[_currentPlayerIndex].name;
    }

  }

  addPlayerPoint(){
    if (state.isEmpty) {
      throw Exception("No players available");
    } else {
      return state[_currentPlayerIndex].points++;
    }
  }

  getPlayersPoint()
  {
    if (state.isEmpty) {
      throw Exception("No players available");
    } else {
      return state[_currentPlayerIndex].points;
    }
  }

  void resetAllPlayerPoints() {
    final updatedList = state.map((player) => PlayersInfo(name: player.name, points: 0)).toList();
    emit(updatedList);
    _savePlayers(updatedList);
    _currentPlayerIndex = 0;
  }


}
