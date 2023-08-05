import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scattegories/core/utils/categories/english_questions.dart';
import 'package:scattegories/core/utils/categories/farsi_quetions.dart';
import 'package:scattegories/core/utils/constants.dart';

import '../../../../../core/getx/language_getx.dart';
import '../widgets/setting.dart';

class Scattegories extends StatefulWidget {
  const Scattegories({Key? key}) : super(key: key);

  @override
  _ScattegoriesState createState() => _ScattegoriesState();
}

class _ScattegoriesState extends State<Scattegories>
    with SingleTickerProviderStateMixin {
  final languageController = Get.find<LanguageController>();
  late String pickedLetter = '';
  bool isStarted = false;
  bool showQuestions = false;
  int _elapsedSeconds = 0;
  int timerDuration = 60;
  int numberOfCategories = 6;

  Timer? _timer;
  int _secondsRemaining = 60;
  bool _isTimerActive = false;
  AnimationController? _animationController;
  Animation<double>? _spinAnimation;
  bool _isCardRevealed = false;
  List<String> randomCategories = []; // Initialize as an empty list
  late AudioPlayer _audioPlayer;
  late AudioPlayer _tictocPlayer;
  bool _isMuted = false;

  @override
  String generateRandomLetter() {
    final alphabet = languageController.isEnglish.value
        ? 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        : 'الفبپتثجچحخدذرزژسشصضطظعغفقکگلمنوهی';
    final randomIndex = DateTime.now().millisecondsSinceEpoch % 26;
    return alphabet[randomIndex];
  }

  @override
  @override
  void initState() {
    super.initState();
    randomCategories = languageController.isEnglish.value
        ? EnglishCategories.getRandomCategories(number: numberOfCategories)
        : FarsiCategories.getRandomCategories(number: numberOfCategories);

    _audioPlayer = AudioPlayer();
    _tictocPlayer = AudioPlayer(); // Initialize _tictocPlayer
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
          randomCategories = languageController.isEnglish.value
              ? EnglishCategories.getRandomCategories(
                  number: numberOfCategories)
              : FarsiCategories.getRandomCategories(number: numberOfCategories);

          _showAlertDialog();

// Reset the timer
          _secondsRemaining = timerDuration;
        }
      });
    });
  }

  void _showEnglishInstructionsDialog() {
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
              Text('2. A random letter will be displayed at the top.'),
              Text(
                  '3. Quickly answer the categories with words that start with the displayed letter.'),
              Text(
                  '4. The timer will count down; finish before time runs out!'),
              Text(
                  '5. If you need to adjust game settings, press the "Settings" button.'),
              Text('6. Press "Stop" to end the game and see your results.'),
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

  void _showFarsiInstructionsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text('دستورالعمل‌ها'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. برای شروع بازی، دکمه "شروع" را فشار دهید.'),
                  Text('2. یک حرف تصادفی در بالا نمایش داده می‌شود.'),
                  Text(
                      '3. به سرعت به دسته‌بندی‌ها با کلماتی که با حرف نمایش داده شده شروع می‌شوند پاسخ دهید.'),
                  Text(
                      '4. تایمر شمارش معکوس را شروع کنید؛ قبل از پایان زمان پایان دهید!'),
                  Text(
                      '5. اگر نیاز به تنظیمات بازی دارید، دکمه "تنظیمات" را فشار دهید.'),
                  Text(
                      '6. دکمه "پایان" را برای پایان دادن بازی و مشاهده نتایج فشار دهید.'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('قبول'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        _tictocPlayer.stop();
        _playTickTockSound(false);
        _playClockSound(); // Play the clock sound here
        _timer?.cancel();
        return Directionality(
          textDirection: languageController.isEnglish.value
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: AlertDialog(
            title: Image.asset(
                Theme.of(context).brightness == Brightness.light?
                'assets/images/WhiteGoldLogo.png' :
'assets/images/DarkAlert.png'
            ),
            content: Text(languageController.isEnglish.value
                ? 'Your time is up.'
                : "وقت تمومه ! کاغذا بالا , قلما پایین  "),
            actions: [
              TextButton(
                onPressed: () {
                  _audioPlayer.stop();
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
    ).then((_) {
// Move the state-modifying code here
      _playTickTockSound(
          false); // Stop the tick-tock sound when the dialog is dismissed
      _timer?.cancel();
      _isTimerActive = false;
      _animationController?.reset();
      setState(() {
        isStarted = false;
        showQuestions = false;
      });
    });
  }

  void _playClockSound() async {
    _audioPlayer.dispose(); // Dispose of the previous audio player
    _audioPlayer = AudioPlayer(); // Create a new audio player instance
    await _audioPlayer
        .play(AssetSource('sounds/Counter_effect.wav')); // Play the clock sound
  }

  Future<void> _playTickTockSound(bool play) async {
    if (play) {
      if (_tictocPlayer.state == PlayerState.stopped) {
        await _tictocPlayer.setSourceAsset('sounds/tick_tock.wav');
        await _tictocPlayer.setReleaseMode(ReleaseMode.loop);
        await _tictocPlayer.play(AssetSource('sounds/tick_tock.wav'));
      }
    } else {
      if (_tictocPlayer.state == PlayerState.playing) {
        await _tictocPlayer.stop();
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _tictocPlayer.dispose();
    _timer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }
  void restart(){
    _tictocPlayer.stop();
    _timer?.cancel();
    _isTimerActive = false;
    _animationController?.reset();
    _secondsRemaining = timerDuration; // Reset the timer to user's input
    isStarted = false;
    showQuestions = false;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GoldColor,
        centerTitle: true,
        title: Text('Scattegories'),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline), // Add the instruction icon
            onPressed: () {
              languageController.isEnglish.value
                  ? _showEnglishInstructionsDialog()
                  : _showFarsiInstructionsDialog();
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showSettingsDialog(context,
                  (newTimerDuration, newNumberOfCategories) {
                restart();
                updateSettings(newTimerDuration, newNumberOfCategories);
              });
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: languageController.isEnglish.value
            ? TextDirection.ltr
            : TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    languageController.isEnglish.value ? 'Letter: ' : "حرف : ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: !showQuestions ? 0.0 : 1.0,
                        child: Text(
                          pickedLetter,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: GoldColor,
                          ),
                        ),
                      ),
                      if (showQuestions)
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Text(
                            pickedLetter,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: GoldColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              Center(
                child: AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, child) {
                    double lineWidth = (size.width - 80) /
                        2; // Adjust for clock icon width (80)
                    if (_isTimerActive && _secondsRemaining > 0) {
                      lineWidth *= (_secondsRemaining /
                          timerDuration); // Use timerDuration instead of 5
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
                    ? languageController.isEnglish.value
                        ? '$_secondsRemaining seconds'
                        : "  $_secondsRemaining ثانیه "
                    : languageController.isEnglish.value
                        ? 'Press Start!'
                        : " بر روی شروع بازی کلیک کنید",
                style: TextStyle(
                  fontSize: 24,
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
                      title: ImageFiltered(
                        imageFilter: showQuestions
                            ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                            : ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Card(
                          color: showQuestions
                              ? GoldColor.withOpacity(0.6)
                              : Colors.grey.withOpacity(0.3),
                          elevation: 4,
                          child: Container(
                            height: 65,
                            alignment: Alignment.center,
                            child: Wrap(
                              children: [
                                Text(
                                  randomCategories[index],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: size.width * 0.9,
                height: 45,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (!isStarted) {
                        isStarted = true;
                        _playTickTockSound(true);
                        showQuestions = true;
                        pickedLetter = generateRandomLetter();
                        randomCategories = languageController.isEnglish.value
                            ? EnglishCategories.getRandomCategories(
                                number: numberOfCategories)
                            : FarsiCategories.getRandomCategories(
                                number: numberOfCategories);

                        _isTimerActive = true;
                        startTimer();
                      } else {
                        _showAlertDialog();
                        restart();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: isStarted ? Colors.red : Colors.green,
                  ),
                  child: Text(
                    isStarted
                        ? languageController.isEnglish.value
                            ? 'Stop'
                            : " توقف "
                        : languageController.isEnglish.value
                            ? 'Start'
                            : " شروع بازی ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
