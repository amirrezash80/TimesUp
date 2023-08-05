import 'package:flutter/material.dart';

class LetterPicker extends StatelessWidget {
  final void Function(String) onLetterPicked;
  final bool english;
  const LetterPicker({required this.onLetterPicked, required this.english});

  @override
  Widget build(BuildContext context) {
    final englishLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final farsiLetters = 'الفبپتثجچحخدذرزژسشصضطظعغفقکگلمنوهی';

    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Generate a random letter based on language settings
          final alphabet = english ? englishLetters : farsiLetters;
          final randomIndex = DateTime.now().millisecondsSinceEpoch % alphabet.length;
          final randomLetter = alphabet[randomIndex];
          onLetterPicked(randomLetter);
        },
        child: Text(
          'Pick a Letter',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
