import 'package:flutter/material.dart';

class LetterPicker extends StatelessWidget {
  final void Function(String) onLetterPicked;

  const LetterPicker({required this.onLetterPicked});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Generate a random letter and pass it back to the parent
          final alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
          final randomIndex = DateTime.now().millisecondsSinceEpoch % 26;
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
