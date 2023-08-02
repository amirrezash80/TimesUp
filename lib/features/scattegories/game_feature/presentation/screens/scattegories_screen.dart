import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:scattegories/core/utils/categories/english_questions.dart';
import 'package:scattegories/core/utils/constants.dart';

import '../widgets/setting.dart';

class Scattegories extends StatefulWidget {
  const Scattegories({Key? key}) : super(key: key);

  @override
  _ScattegoriesState createState() => _ScattegoriesState();
}

class _ScattegoriesState extends State<Scattegories>
    with SingleTickerProviderStateMixin {
  late String pickedLetter = '';
  bool isStarted = false;
  bool showQuestions = false;
  int _elapsedSeconds = 0;
  int timerDuration = 5; // Default timer duration, you can change this value
  int numberOfCategories = 10; // Default number of categories, you can change this value

  Timer? _timer;
  int _secondsRemaining = 5;
  bool _isTimerActive = false;
  AnimationController? _animationController;
  Animation<double>? _spinAnimation;
  bool _isCardRevealed = false;
  List<String> randomCategories = [];

  String generateRandomLetter() {
    final alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final randomIndex = DateTime.now().millisecondsSinceEpoch % 26;
    return alphabet[randomIndex];
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController?.addListener(() {
      setState(() {}); // Redraw the widget when the animation updates
    });

    _spinAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    )?.animate(_animationController!);
  }
  void updateTimerDuration(int newDuration) {
    setState(() {
      timerDuration = newDuration;
    });
  }

  // Function to update number of categories
  void updateNumberOfCategories(int newNumberOfCategories) {
    setState(() {
      numberOfCategories = newNumberOfCategories;
    });
  }
  void updateSettings(int newTimerDuration, int newNumberOfCategories) {
    setState(() {
      timerDuration = newTimerDuration;
      numberOfCategories = newNumberOfCategories;
      _secondsRemaining = newTimerDuration; // Update the timer immediately
    });
  }


  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          _elapsedSeconds++;
        } else {
          // Timer is done, show alert dialog
          _isTimerActive = false;
          _animationController?.reset();
          _isCardRevealed = false;

          // Generate a new set of random categories based on the user's input
          randomCategories = EnglishCategories.getRandomCategories(number: numberOfCategories);

          _showAlertDialog();

          // Reset the timer
          _secondsRemaining = timerDuration;
        }
      });
    });
  }



  void _showAlertDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Time\'s Up!'),
          content: Text('Your time is up.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      // Move the state-modifying code here
      _timer?.cancel();
      _isTimerActive = false;
      _animationController?.reset();
      setState(() {
        isStarted = false;
        showQuestions = false;
      });
    });
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GoldColor,
        title: Text('Scattegories'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showSettingsDialog(context, (newTimerDuration, newNumberOfCategories) {
                updateSettings(newTimerDuration, newNumberOfCategories);
              });
            },
          ),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Text(
              'Letter: $pickedLetter',
              style: TextStyle(fontSize: 24),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _animationController!,
                builder: (context, child) {
                  double lineWidth = (size.width - 80) /
                      2; // Adjust for clock icon width (80)
                  if (_isTimerActive && _secondsRemaining > 0) {
                    lineWidth *= (_secondsRemaining / timerDuration); // Use timerDuration instead of 5
                  } else {
                    lineWidth = 0.0;
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

            ),
            const SizedBox(height: 10),
            Text(
              _isTimerActive
                  ? '$_secondsRemaining seconds'
                  : 'Press Start!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: GoldColor,
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: randomCategories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Card(
                      color: showQuestions
                          ? GoldColor.withOpacity(0.6)
                          : Colors.grey.withOpacity(0.3),
                      elevation: 4,
                      child: ImageFiltered(
                        imageFilter: showQuestions
                            ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                            : ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            randomCategories[index],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (!isStarted) {
                    isStarted = true;
                    showQuestions = true;
                    pickedLetter = generateRandomLetter();
                    randomCategories = EnglishCategories.getRandomCategories(number: numberOfCategories);
                    _isTimerActive = true;
                    startTimer();
                  } else {
                    _timer?.cancel();
                    _isTimerActive = false;
                    _animationController?.reset();
                    _secondsRemaining = timerDuration; // Reset the timer to user's input
                    isStarted = false;
                    showQuestions = false;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                primary: isStarted ? Colors.red : Colors.green,
              ),
              child: Text(isStarted ? 'Stop' : 'Start'),
            ),


            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

