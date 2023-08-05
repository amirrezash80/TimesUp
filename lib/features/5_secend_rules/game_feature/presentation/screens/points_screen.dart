import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/getx/language_getx.dart';
import '../../../../../core/utils/constants.dart';
import '../../../player_management_feature/presentation/getx/player_getx.dart';

class PointsScreen extends StatelessWidget {
  final PlayersController _playersController = Get.find<PlayersController>();
  final languageController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: GoldColor,
        title: Text(
          languageController.isEnglish.value
              ? 'Player Points'
              : "امتیازات بازیکن ها",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 5),
            icon: const Icon(
              Icons.restore,
              size: 35,
            ),
            onPressed: () {
              _playersController.resetAllPlayerPoints();
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: languageController.isEnglish.value
            ? TextDirection.ltr
            : TextDirection.rtl,
        child: Center(
          child: GetX<PlayersController>(
            builder: (controller) {
              final playersList = controller.playersList;

              if (playersList.isEmpty) {
                return const Center(
                  child: Text(
                    'No players available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }
              return ListView.builder(
                itemCount: playersList.length,
                itemBuilder: (context, index) {
                  final player = playersList[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: LightGoldColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            player.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            languageController.isEnglish.value
                                ? 'Points: ${player.points}'
                                : "امتیاز : ${player.points} ",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
