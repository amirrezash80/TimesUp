import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scattegories/core/utils/constants.dart';

import '../../../../../core/getx/language_getx.dart';

class PlayGameContainer extends StatelessWidget {
  final languageController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/5second_rules");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: GoldColor, // Set your desired button color here
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            languageController.isEnglish.value
                ? "Play Game"
                : "شروع  بازی",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Set text color to white
            ),
          ),
        ),
      ),
    );
  }
}
