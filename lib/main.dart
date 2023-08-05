import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scattegories/features/5_secend_rules/player_management_feature/presentation/screens/define_player_screen.dart';
import 'package:scattegories/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/Theme/app_theme.dart';
import 'config/Theme/theme_notifier.dart';
import 'features/5_secend_rules/game_feature/presentation/screens/five_seceond_rules_screen.dart';
import 'features/5_secend_rules/game_feature/presentation/screens/points_screen.dart';
import 'features/5_secend_rules/player_management_feature/presentation/bloc/player_bloc.dart';
import 'features/5_secend_rules/player_management_feature/presentation/getx/player_getx.dart';
import 'features/scattegories/game_feature/presentation/screens/scattegories_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var lighModeOn = prefs.getBool('lightMode') ?? true;

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => PlayersBloc()),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(lighModeOn ? lightTheme : darkTheme),
        ),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    Get.put(PlayersController());

    return GetMaterialApp(
      theme: themeNotifier.getTheme(),

      // theme: ThemeData(
      //   textTheme: PersianFonts.sahelTextTheme,
      // ),
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      title: 'Time\'s Up!',
      initialRoute: '/homepage',
      routes: {
// When navigating to the "/" route, build the FirstScreen widget.
        '/homepage': (context) => HomePage(),
// When navigating to the "/second" route, build the SecondScreen widget.
        '/5second_rules': (context) => const FiveSecondRules(),
        '/scattegories': (context) => const Scattegories(),
        '/Players': (context) => Players(),
        '/Points': (context) => PointsScreen(),
        '/LetterPicker': (context) => Scattegories()
      },
    );
  }
}

// Dark theme
