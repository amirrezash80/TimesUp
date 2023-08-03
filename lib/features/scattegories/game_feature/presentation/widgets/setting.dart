
import 'package:flutter/material.dart';

class SettingsDialog extends StatefulWidget {
  final Function(int timerDuration, int numberOfCategories) onSave;

  SettingsDialog({required this.onSave});

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late TextEditingController _timerDurationController;
  late TextEditingController _numberOfCategoriesController;

  @override
  void initState() {
    super.initState();
    _timerDurationController = TextEditingController();
    _numberOfCategoriesController = TextEditingController();
  }

  @override
  void dispose() {
    _timerDurationController.dispose();
    _numberOfCategoriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _timerDurationController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Timer Duration (seconds)',
            ),
          ),
          TextField(
            controller: _numberOfCategoriesController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Number of Categories',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final newTimerDuration =
                int.tryParse(_timerDurationController.text) ?? 5;
            final newNumberOfCategories =
                int.tryParse(_numberOfCategoriesController.text) ?? 10;

            widget.onSave(newTimerDuration, newNumberOfCategories);

            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

void showSettingsDialog(BuildContext context, Function(int, int) onSave) {
  showDialog(
    context: context,
    builder: (context) {
      return SettingsDialog(onSave: onSave);
    },
  );
}
