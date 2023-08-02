import 'package:flutter/material.dart';

import '../utils/constants.dart';

Text Drawer_text_style(String text) {
  return Text(text, style: TextStyle(color: GoldColor));
}

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Color(0xFFb39300),
      backgroundColor: Colors.white,
      elevation: 20.0,
      child: Container(
        decoration: BoxDecoration(color: Colors.white
            // gradient: LinearGradient(
            //   colors: [
            //     Colors.white,
            //     Colors.white,
            //     Colors.white,
            //     Colors.white.withOpacity(0.3),
            //     Colors.white.withOpacity(0.5),
            //     Colors.white.withOpacity(0.8),
            //     Colors.yellowAccent.withOpacity(0.2),
            //     Colors.yellowAccent.withOpacity(0.3),
            //     Colors.yellowAccent.withOpacity(0.4),
            //     Colors.yellow.withOpacity(0.5),
            //     Colors.yellow.withOpacity(0.5),
            //     Color(0xFFb39300).withOpacity(0.5),
            //     Color(0xFFb39300).withOpacity(0.5),
            //     Color(0xFFb39300).withOpacity(0.7),
            //   ],
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            // ),
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 400,
              child: DrawerHeader(
                  child: Container(
                      child: Image.asset(
                'assets/images/WhiteGoldLogo.png',
                fit: BoxFit.fill,
              ))),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ExpansionTile(
                    title: Drawer_text_style("Language"),
                    children: [
                      ElevatedButton(
                        child: Drawer_text_style("English"),
                        onPressed: () {},
                      ),
                      ElevatedButton(
                          onPressed: () {}, child: Drawer_text_style("Farsi"))
                    ],
                  ),
                  ExpansionTile(
                    title: Text("Theme"),
                    children: [
                      ElevatedButton(
                        child: Text("Dark Mode"),
                        onPressed: () {},
                      ),
                      ElevatedButton(
                          onPressed: () {}, child: Text("Light Mode"))
                    ],
                  ),
                  ListTile(
                    title: Text("My Other Apps"),
                  ),
                  ListTile(
                    title: Text("About Me"),
                  ),
                  ListTile(
                    title: Text("Contact Me"),
                  ),
                  ListTile(
                    title: Text("Support Me"),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
