import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/getx/language_getx.dart';
import '../getx/player_getx.dart';
import 'player_card.dart'; // Make sure to import your PlayerCard widget

class PlayersList extends StatelessWidget {
  final PlayersController _playersController = Get.find();
  final languageController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GetX<PlayersController>(
        builder: (controller) {
          final playersList = controller.playersList;
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
                    label: Text(
                        languageController.isEnglish.value?
                        "Add new player":"اضافه کردن بازیکن جدید"),
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
