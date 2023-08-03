import 'package:flutter/material.dart';
import 'package:scattegories/core/widgets/main_drawer.dart';

import '../core/utils/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: GoldColor,
        centerTitle: true,
        actions: [
          Container(
            width: size.width,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Time's Up"),
              ],
            ),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: Container(
        color: GoldColor.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: LightGoldColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white70.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                alignment: Alignment.center,
                height: size.height * 0.1,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, "/Players"),
                  child: Text(
                    "5 Seconds Rule",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 70),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: LightGoldColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                alignment: Alignment.center,
                height: size.height * 0.1,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, "/LetterPicker"),
                  child: Text(
                    "Scattegories",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
