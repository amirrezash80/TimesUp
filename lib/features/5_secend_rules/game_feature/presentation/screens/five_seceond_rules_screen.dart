import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scattegories/core/utils/constants.dart';

import '../../../../../core/getx/language_getx.dart';
import '../../../../../core/utils/categories/english_questions.dart';
import '../../../../../core/utils/categories/farsi_quetions.dart';
import '../../../player_management_feature/presentation/getx/player_getx.dart';

class FiveSecondRules extends StatefulWidget {
  const FiveSecondRules({Key? key}) : super(key: key);

  @override
  _FiveSecondRulesState createState() => _FiveSecondRulesState();
}

class _FiveSecondRulesState extends State<FiveSecondRules>
    with SingleTickerProviderStateMixin {
  final languageController = Get.find<LanguageController>();

  Timer? _timer;
  int _secondsRemaining = 5;
  bool _isTimerActive = false;
  AnimationController? _animationController;
  int _elapsedSeconds = 0; // Variable to track elapsed seconds
  List<String> randomCategories = [];
  bool _isCardRevealed = false;
  Animation<double>? _spinAnimation;
  late AudioPlayer _audioPlayer;
  late AudioPlayer _tictocPlayer;
  double _textsize = 30;
  @override
  void initState() {
    super.initState();
    Get.put(PlayersController());
    _audioPlayer = AudioPlayer();
    _tictocPlayer = AudioPlayer();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController?.addListener(() {
      setState(() {}); // Redraw the widget when the animation updates
    });

    // Generate the first set of random categories on initialization
    randomCategories = languageController.isEnglish.value
        ? EnglishCategories.getRandomCategories(number: 1)
        : FarsiCategories.getRandomCategories(number: 1);

    _spinAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    )?.animate(_animationController!);
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {

        if(_secondsRemaining % 2 == 0)
          _textsize+=2;
        if(_secondsRemaining % 2 == 1)
          _textsize-=2;

        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          _playTickTockSound(
              true); // Play tick-tock sound while timer is active
        } else {
          // Timer is done, show alert dialog
          _playTickTockSound(false); // Stop tick-tock sound
          _tictocPlayer.stop(); // Dispose of the tick-tock audio player
          _isTimerActive = false;
          _elapsedSeconds = 0;
          _animationController?.reset();
          _isCardRevealed = false;

          // Generate a new set of random categories
          randomCategories = languageController.isEnglish.value
              ? EnglishCategories.getRandomCategories(number: 1)
              : FarsiCategories.getRandomCategories(number: 1);

          _showAlertDialog();

          // Reset the timer
          _secondsRemaining = 5;
        }
      });
    });
  }

  void _showEnglishInstructionsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Instructions'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1. Press the "Start" button to begin the game.'),
              Text('2. A random question will appear at the center.'),
              Text('3. Quickly tap the card to reveal the question.'),
              Text('4. You have 5 seconds to answer.'),
              Text('5. After 5 seconds, tap "Yes" if the answer is correct.'),
              Text(
                  '6. If the answer is incorrect or the time is up, tap "No".'),
              Text(
                  '7. The timer and question card can be stopped or resumed by tapping the "Start" button.'),
              Text('8. Players take turns, and their points are tracked.'),
              Text('9. To see the points, tap "Points".'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(languageController.isEnglish.value ? 'OK' : "قبول"),
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
        return AlertDialog(
          title: const Text('دستورالعمل‌ها'),
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1. برای شروع بازی، دکمه "شروع" را فشار دهید.'),
                Text('2. یک سوال تصادفی در وسط نمایش ظاهر می‌شود.'),
                Text('3. به سرعت کارت را لمس کنید تا سوال نمایش داده شود.'),
                Text('4. شما ۵ ثانیه برای پاسخ فرصت دارید.'),
                Text('5. پس از ۵ ثانیه، اگر پاسخ درست باشد "بله" را بزنید.'),
                Text(
                    '6. اگر پاسخ نادرست باشد یا زمان تمام شده باشد، "خیر" را بزنید.'),
                Text(
                    '7. تایمر و کارت سوال با فشار دادن دکمه "شروع" می‌تواند متوقف یا ادامه یابد.'),
                Text(
                    '8. بازیکنان به تناوب نوبت می‌گیرند و امتیازات آن‌ها پیگیری می‌شود.'),
                Text('9. برای مشاهده امتیازات، دکمه "امتیازات" را بزنید.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(languageController.isEnglish.value ? 'OK' : "قبول"),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog() {
    final currentPlayerName = Get.find<PlayersController>()
        .getCurrentPlayerName(); // Use Get.find to access the PlayersController

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        _timer?.cancel();
        _playClockSound();
        return AlertDialog(
          title: Image.asset(
              Theme.of(context).brightness == Brightness.light?
              'assets/images/WhiteGoldLogo.png' :
              'assets/images/DarkAlert.png'

          ),
          content: Directionality(
            textDirection: languageController.isEnglish.value
                ? TextDirection.ltr
                : TextDirection.rtl,
            child: Text(languageController.isEnglish.value
                ? 'Did $currentPlayerName get the answer right within 5 seconds?'
                : '$currentPlayerName تونست در عرض ۵ ثانیه جواب بده؟ '),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.find<PlayersController>().addPlayerPoint(); // Use Get.find
                _audioPlayer.stop();
                Navigator.pop(context);
                _isTimerActive = false;
                _elapsedSeconds = 0;
                _animationController?.reset();
                Get.find<PlayersController>()
                    .moveToNextPlayer(); // Use Get.find
              },
              child:  Text(languageController.isEnglish.value?
              'Yes' : "آره"),
            ),
            TextButton(
              onPressed: () {
                _audioPlayer.stop();
                Navigator.pop(context);
                _isTimerActive = false;
                _elapsedSeconds = 0;
                _animationController?.reset();
                Get.find<PlayersController>()
                    .moveToNextPlayer(); // Use Get.find
              },
              child:  Text(languageController.isEnglish.value?
        'No' : "نه"),
        ),

          ],
        );
      },
    ).then((value) {
      _playTickTockSound(false);
    });
  }

  void _playClockSound() async {
    _audioPlayer.dispose(); // Dispose of the previous audio player
    _audioPlayer = AudioPlayer(); // Create a new audio player instance
    await _audioPlayer
        .play(AssetSource('sounds/Counter_effect.wav')); // Play the clock sound
  }

  void _playTickTockSound(bool play) async {
    if (play) {
      if (_tictocPlayer.state == PlayerState.stopped) {
        await _tictocPlayer.seek(Duration.zero); // Reset the audio position
        await _tictocPlayer.play(AssetSource(
            'sounds/tick_tock.wav')); // Play the preloaded tick-tock sound
      }
    } else {
      if (_tictocPlayer.state == PlayerState.playing) {
        await _tictocPlayer.stop(); // Stop the tick-tock sound
        await _tictocPlayer.release(); // Release the tick-tock sound
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _tictocPlayer
        .dispose(); // Dispose the audio player when the widget is disposed
    _timer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor, // Use the theme's background color
        body: Column(
          children: [
            GetBuilder<PlayersController>(
              builder: (controller) {
                if (controller.playersList.isEmpty) {
                  return const Center(
                    child: Text('No players available'),
                  );
                }
                final currentPlayerName = controller.getCurrentPlayerName();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            languageController.isEnglish.value
                                ? "Question for "
                                : "سوال برای ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            "$currentPlayerName",
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal),
                          ),
                        ],
                      ),
                      Container(
                        height: 70,
                        child: Image.asset(
                          Theme.of(context).brightness == Brightness.light?
                          'assets/images/GoldLogo.png' :
                           'assets/images/DarkLogo.png',

                          fit: BoxFit.fill,
                        ),
                      )
                    ],
                  ),
                );
              },
            ), // Image.asset(

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
                                ? languageController.isEnglish.value
                                    ? '$_secondsRemaining seconds'
                                    : '  ثانیه $_secondsRemaining'
                                : languageController.isEnglish.value
                                    ? 'Press the Start!'
                                    : 'بر روی شروع بازی کلیک کنید',
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
                                            color:
                                                Colors.black.withOpacity(0.3),
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
                                        child: Directionality(
                                          textDirection:languageController
                                              .isEnglish.value? TextDirection.ltr:TextDirection.rtl,
                                          child: Wrap(
                                            children: [
                                              Center(
                                                child: Text(languageController
                                                        .isEnglish.value
                                                    ? "Name 3"
                                                    : " نام ببر ۳ تا از" , style: TextStyle(
                                                  color: Colors.black54
                                                ),),
                                              ),
                                              const Divider(),
                                              Align(
                                                alignment: Alignment.center,

                                                child:AnimatedDefaultTextStyle(
                                                  duration: Duration(milliseconds: 1000),
                                                  style: TextStyle(fontSize: _textsize , fontWeight: FontWeight.bold ,color: Colors.black),
                                                  child: Text(randomCategories.first),
                                                ),



                                // child: AnimatedTextKit(
                                //   pause: Duration(milliseconds: 1000),
                                //                 repeatForever: true,
                                //                 isRepeatingAnimation: true,
                                //                 animatedTexts: [
                                //                   ColorizeAnimatedText(
                                //                     randomCategories.first,
                                //                     textStyle:
                                //                         colorizeTextStyle,
                                //                     colors: colorizeColors,
                                //                   ),
                                //                 ],
                                //               ),
                                              ),
                                            ],
                                          ),
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
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.help_outline,
                                              size: 45,
                                              color: LightGoldColor,
                                            ),
                                            onPressed: () {
                                              languageController.isEnglish.value
                                                  ? _showEnglishInstructionsDialog()
                                                  : _showFarsiInstructionsDialog();
                                            },
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              languageController.isEnglish.value
                                                  ? "Tap To Reveal The Card"
                                                  : "برای مشاهده سوال کلیک کنید",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: LightGoldColor),
                                            ),
                                          ),
                                          Container(
                                              child: ElevatedButton(
                                            onPressed: () =>
                                                Get.toNamed("/Points"),
                                            style: ElevatedButton.styleFrom(
                                              primary: GoldColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: Text(
                                                languageController
                                                        .isEnglish.value
                                                    ? "Points"
                                                    : "امتیازات",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )),
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
                                languageController.isEnglish.value
                                    ? EnglishCategories.getRandomCategories(
                                        number: 1)
                                    : FarsiCategories.getRandomCategories(
                                        number: 1);

                            _tictocPlayer.stop();
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
                            _playTickTockSound(true);
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
                          backgroundColor:
                              _isTimerActive ? Colors.red : Colors.teal,
                        ),
                        child: Text(
                          _isTimerActive
                              ? languageController.isEnglish.value
                                  ? 'Stop'
                                  : "توقف"
                              : languageController.isEnglish.value
                                  ? 'Start'
                                  : 'شروع بازی',
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
