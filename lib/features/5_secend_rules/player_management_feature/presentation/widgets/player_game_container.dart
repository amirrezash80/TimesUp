import 'package:flutter/material.dart';

class PlayGameContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, "/5second_rules");
        },
        child: Text("Play Game"),
      ),
    );
  }
}
