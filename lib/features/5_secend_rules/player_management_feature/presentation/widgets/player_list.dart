import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../getx/player_getx.dart';
import 'player_card.dart'; // Make sure to import your PlayerCard widget

class PlayersList extends StatelessWidget {
  final PlayersController _playersController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GetX<PlayersController>(
        builder: (controller) {
          final playersList = controller.playersList;
          if (playersList.isEmpty) {
            return Center(
              child: Text(
                'No players available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }
          return ListView.builder(
            itemCount: playersList.length + 1,
            itemBuilder: (context, index) {
              if (index < playersList.length) {
                final player = playersList[index];
                return PlayerCard(
                  player: player,
                  playerId: player.id,
                  onNameChanged: (newName) {
                    _playersController.updatePlayerName(index, newName);
                  },
                  onDeletePlayer: (playerId) {
                    final index = playersList
                        .indexWhere((player) => player.id == playerId);
                    if (index != -1) {
                      _playersController.removePlayer(index);
                    }
                  },
                );
              } else {
                return Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _playersController.addPlayer();
                    },
                    icon: Icon(Icons.add),
                    label: Text("Add new player"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
