import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../../core/getx/language_getx.dart';
import '../../../../../core/utils/constants.dart';
import '../bloc/player_bloc.dart';
import '../widgets/player_game_container.dart';
import '../widgets/player_list.dart';

class Players extends StatelessWidget {
  final languageController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: GoldColor,
        centerTitle: true,
        title:
            Text(languageController.isEnglish.value ? "Players" : "بازیکن ها"),
      ),
      body: Directionality(
        textDirection: languageController.isEnglish.value
            ? TextDirection.ltr
            : TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocProvider(
            create: (context) => PlayersBloc(),
            child: Column(
              children: [
                Expanded(child: PlayersList()),
                SizedBox(height: 20),
                // Add some space between PlayersList and PlayGameContainer
                PlayGameContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
