import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scattegories/features/5_secend_rules/player_management_feature/presentation/screens/define_player_screen.dart';
import 'package:scattegories/home/home_page.dart';

import 'features/5_secend_rules/game_feature/presentation/screens/five_seceond_rules_screen.dart';
import 'features/5_secend_rules/game_feature/presentation/screens/points_screen.dart';
import 'features/5_secend_rules/player_management_feature/presentation/bloc/player_bloc.dart';
import 'features/5_secend_rules/player_management_feature/presentation/getx/player_getx.dart';
import 'features/scattegories/game_feature/presentation/screens/scattegories_screen.dart';
import 'features/scattegories/letter_picker_wheel/presentation/letter_picker_screen.dart';
import 'package:get/get.dart';
void main() {
  runApp(BlocProvider(

      create: (BuildContext context)=> PlayersBloc()  ,
      child: const MyApp()));
  }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(PlayersController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time\'s Up!',
      localizationsDelegates: [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('fa'), // Spanish
      ],
      locale: Locale('en'),
      initialRoute: '/homepage',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/homepage': (context) => const HomePage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/5second_rules': (context) => const FiveSecondRules(),
        '/scattegories': (context) => const Scattegories(),
        '/Players': (context) => Players(),
        '/Points' : (context) => PointsScreen(),
        '/LetterPicker' : (context) => Scattegories()
      },

    );
  }
}


