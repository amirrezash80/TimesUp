import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scattegories/core/utils/constants.dart';
import 'package:scattegories/features/5_secend_rules/player_management_feature/data/models/player_class.dart';

import '../../../../../core/utils/categories/english_questions.dart';
import '../../../player_management_feature/presentation/bloc/player_bloc.dart';

class FiveSecondRules extends StatefulWidget {
  const FiveSecondRules({Key? key}) : super(key: key);

  @override
  _FiveSecondRulesState createState() => _FiveSecondRulesState();
}

class _FiveSecondRulesState extends State<FiveSecondRules>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _secondsRemaining = 5;
  bool _isTimerActive = false;
  AnimationController? _animationController;
  int _elapsedSeconds = 0; // Variable to track elapsed seconds
  List<String> randomCategories = [];
  bool _isCardRevealed = false;
  Animation<double>? _spinAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController?.addListener(() {
      setState(() {}); // Redraw the widget when the animation updates
    });

    // Generate the first set of random categories on initialization
    randomCategories = EnglishCategories.getRandomCategories(number: 1);

    _spinAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    )?.animate(_animationController!);
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          // Timer is done, show alert dialog
          _isTimerActive = false;
          _elapsedSeconds = 0;
          _animationController?.reset();
          _isCardRevealed = false;

          // Generate a new set of random categories
          randomCategories = EnglishCategories.getRandomCategories(number: 1);

          _showAlertDialog();

          // Reset the timer
          _secondsRemaining = 5;
        }
      });
    });
  }

  void _showInstructionsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Instructions'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1. Press the "Start" button to begin the game.'),
              Text('2. A random question will appear at the center.'),
              Text('3. Quickly tap the card to reveal the question.'),
              Text('4. You have 5 seconds to answer.'),
              Text('5. After 5 seconds, tap "Yes" if the answer is correct.'),
              Text('6. If the answer is incorrect or the time is up, tap "No".'),
              Text('7. The timer and question card can be stopped or resumed by tapping the "Start" button.'),
              Text('8. Players take turns, and their points are tracked.'),
              Text('9. To see the points, tap "See The Points".'),
            ],
          ),
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


  void _showAlertDialog() {
    final currentPlayerName =
    context.read<PlayersBloc>().getCurrentPlayerName();

    showDialog(
      context: context,
      barrierDismissible: false,
      // Prevent dismissing the dialog by tapping outside
      builder: (context) {
        _timer?.cancel();
        return AlertDialog(
          title: Image.asset('assets/images/WhiteGoldLogo.png'),
          content: Text(
              'Did $currentPlayerName get the answer right within 5 seconds?'),
          actions: [
            TextButton(
              onPressed: () {
                context.read<PlayersBloc>().addPlayerPoint();
                Navigator.pop(context);
                // Handle the user's response here (e.g., correct or incorrect answer)
                _isTimerActive = false; // Set the timer as inactive
                _elapsedSeconds = 0; // Reset elapsed seconds
                _animationController?.reset();
                context
                    .read<PlayersBloc>()
                    .moveToNextPlayer(); // Move to the next player
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Handle the user's response here (e.g., correct or incorrect answer)
                _isTimerActive = false; // Set the timer as inactive
                _elapsedSeconds = 0; // Reset elapsed seconds
                _animationController?.reset();
                context
                    .read<PlayersBloc>()
                    .moveToNextPlayer(); // Move to the next player
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFE8DEB2),
        // backgroundColor: LightGoldColor,
        body: Column(
          children: [
            BlocBuilder<PlayersBloc, List<PlayersInfo>>(
              builder: (context, playersList) {
                if (playersList.isEmpty) {
                  return const Center(
                    child: Text('No players available'),
                  );
                }
                final currentPlayerName =
                context.watch<PlayersBloc>().getCurrentPlayerName();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Question for ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          "$currentPlayerName",
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: GoldColor),
                        )
                      ],
                    ),
                    Image.asset(
                      'assets/images/GoldLogo.png',
                      width: 80,
                      height: 80,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                color: Colors.transparent,
                // Set the container color to transparent
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Spinning clock icon with shrinking lines effect
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: _animationController!,
                                builder: (context, child) {
                                  double lineWidth = (size.width - 80) /
                                      2; // Adjust for clock icon width (80)
                                  if (_isTimerActive) {
                                    // Calculate the line width based on the animation progress
                                    lineWidth *=
                                    (1 - _animationController!.value);

                                  }
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: lineWidth,
                                        height: 12,
                                        // Adjust line thickness here
                                        color: LightGoldColor,
                                      ),
                                      RotationTransition(
                                        turns: _spinAnimation!,
                                        child: Icon(
                                          Icons.access_time,
                                          size: 80,
                                          color: Colors.teal.shade700,
                                          // color:  Colors.brown,
                                        ),
                                      ),
                                      Container(
                                        width: lineWidth,
                                        height: 12,
                                        // Adjust line thickness here
                                        color: LightGoldColor,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _isTimerActive
                                ? '$_secondsRemaining seconds'
                                : 'Press the Start!',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: GoldColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Improved UI for displaying the question
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (!_isCardRevealed) {
                                  _isCardRevealed = true;
                                  _animationController?.forward();
                                }
                              });
                            },
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: _isCardRevealed
                                  ? Container(
                                key: const ValueKey(1),
                                width: size.width * 0.7,
                                height: size.height * 0.5,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: GoldColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: DefaultTextStyle(
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                  ),
                                  child: Wrap(
                                    children: [
                                      const Center(
                                        child: Text("Name 3"),
                                      ),
                                      const Divider(),
                                      Align(
                                        alignment: Alignment.center,
                                        child: AnimatedTextKit(
                                          repeatForever: true,
                                          isRepeatingAnimation: true,
                                          animatedTexts: [
                                            ColorizeAnimatedText(
                                              randomCategories.first,
                                              textStyle: colorizeTextStyle,
                                              colors: colorizeColors,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                                  : Container(
                                key: const ValueKey(2),
                                width: size.width * 0.7,
                                height: size.height * 0.5,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.brown,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.help_outline , size: 40,color: LightGoldColor),
                                      onPressed: () {
                                        _showInstructionsDialog();
                                      },
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Tap To Reveal The Card",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: LightGoldColor,
                                        ),
                                      ),
                                    ),

                                    // Gesture Detector at the bottom
                                    ElevatedButton(
                                      child: Text("See The Points"),
                                      onPressed: () => Navigator.pushNamed(context, "/Points"),
                                      style: ElevatedButton.styleFrom(
                                        primary: LightGoldColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: size.width * 0.7,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_isTimerActive) {
                            // Stop the timer and show the dialog
                            randomCategories =
                                EnglishCategories.getRandomCategories(
                                    number: 1);
                            _isCardRevealed = false;
                            _timer?.cancel();
                            _secondsRemaining = 0;
                            _isTimerActive = false;
                            _elapsedSeconds += (5 - _secondsRemaining);
                            _animationController?.stop();
                            _showAlertDialog();
                          } else {
                            // Start or resume the timer
                            _isTimerActive = true;
                            if (_secondsRemaining == 0) {
                              _secondsRemaining = 5 - _elapsedSeconds;
                            }
                            _animationController?.duration =
                                Duration(seconds: _secondsRemaining);
                            _animationController?.reset();
                            _animationController?.forward();
                            startTimer();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: _isTimerActive ? Colors.red : Colors.teal,
                        ),
                        child: Text(
                          _isTimerActive ? 'Stop' : 'Start',
                          style: const TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

