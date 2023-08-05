import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scattegories/core/getx/language_getx.dart';
import 'package:scattegories/core/utils/constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/Theme/app_theme.dart';
import '../../config/Theme/theme_notifier.dart';
import 'package:day_night_switch/day_night_switch.dart';

Text DrawerTextStyle(String text ,context) {
  return Text(text,
      style: TextStyle(
          color:Theme.of(context).brightness == Brightness.dark?
          GoldColor: GoldColor, fontSize: 20, fontWeight: FontWeight.bold)
  );
}

Container myDivider() {
  return Container(
    color: GoldColor.withOpacity(0.3),
    height: 1,
  );
}

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key});

  @override
  _MainDrawerState createState() => _MainDrawerState();
}


class _MainDrawerState extends State<MainDrawer> {
  bool _isDarkModeEnabled = false;
  bool _isEnglishSelected = true; // Assume English is selected by default
  final _languageController = Get.find<
      LanguageController>(); // Use Get.find to get the controller instance
  var _darkTheme = true;


  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Obx(
      () => Directionality(
        textDirection: _languageController.isEnglish.value? TextDirection.ltr:TextDirection.rtl,
        child: Drawer(
          backgroundColor:Theme.of(context).brightness == Brightness.dark?
              // Color(0xFFababab) : Colors.white
           Color(0xFF385070) : Colors.white
          ,
          elevation: 25.0,
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.white60,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 400,
                  child: DrawerHeader(
                    child: Container(
                      child: Image.asset(
                        Theme.of(context).brightness == Brightness.light?
                        'assets/images/WhiteGoldLogo.png' :'assets/images/BlueGreyLogo.png'  ,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: DrawerTextStyle(_languageController.isEnglish()
                            ? "Theme"
                            : "پس زمینه" , context),
                        trailing: Transform.scale(
                          scale: 0.4,
                          child: DayNightSwitch(
                            value: _darkTheme,
                            onChanged: (val) {
                              setState(() {
                                _darkTheme = val;
                              });
                              onThemeChanged(val, themeNotifier);
                            },
                          ),
                        ),
                      ),
                      myDivider(),
                      ExpansionTile(
                        title: DrawerTextStyle(_languageController.isEnglish()
                            ? "Language"
                            : "زبان" , context),
                        children: [
                          ListTile(
                            title: DrawerTextStyle("English", context),
                            leading: Image.asset(
                              'icons/flags/png/us.png',
                              package: 'country_icons',
                              height: 30,
                            ),
                            trailing: Obx(() => Radio<bool>(
                                  value: true,
                                  groupValue: _languageController.isEnglish.value,
                                  onChanged: (value) {
                                    _languageController.setLanguage(true);
                                  },
                                )),
                          ),
                          ListTile(
                            title: DrawerTextStyle("فارسی", context),
                            leading: Image.asset(
                              'icons/flags/png/ir.png',
                              package: 'country_icons',
                              height: 35,
                            ),
                            trailing: Obx(() => Radio<bool>(
                                  value: false,
                                  groupValue: _languageController.isEnglish.value,
                                  onChanged: (value) {
                                    _languageController.setLanguage(false);
                                  },
                                )),
                          ),
                        ],
                      ),
                      myDivider(),
                      ExpansionTile(
                        title: DrawerTextStyle(
                          _languageController.isEnglish.value ? "About Me" : "درباره من",
                          context,
                        ),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _languageController.isEnglish.value
                                      ? "Hello and welcome! I'm Amir Reza, \na mobile developer."
                                      : "سلام خیلی خوش اومدید! من امیررضام،\n یک عدد توسعه‌دهنده موبایل (:",
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  _languageController.isEnglish.value
                                      ? "I hope you enjoy using this app."
                                      : "امیدوارم از این برنامه لذت ببرید.",
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  _languageController.isEnglish.value
                                      ? "If you have any suggestions, feedback, or criticisms,"
                                      : "اگر پیشنهاد، نظر یا انتقادی دارید،",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  _languageController.isEnglish.value
                                      ? "feel free to reach out to me through the contact methods."
                                      : "از طریق راه‌های ارتباطی با من در میون بذارید.",
                                  style: TextStyle(fontSize: 16),
                                ),
                                // Add more about me information here
                              ],
                            ),
                          ),
                        ],
                      ),
                      myDivider(),
                      ExpansionTile(
                        title: DrawerTextStyle(
                          _languageController.isEnglish.value ? "Contact Me" : "راه ارتباطی",
                          context,
                        ),
                        children: [
                          ListTile(
                            leading: Icon(Icons.email ,color: Colors.teal,),
                            title: Text(
                              _languageController.isEnglish.value
                                  ? "Email:\nsharifzadeamir80@gmail.com"
                                  : "ایمیل:\n sharifzadeamir80@gmail.com",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.telegram ,color: Colors.teal,),
                            title: Text(
                              _languageController.isEnglish.value
                                  ? "Telegram: \n@AmirSharif80"
                                  : "تلگرام:\n @AmirSharif80",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.computer ,color: Colors.teal,),
                            title: Text(
                              _languageController.isEnglish.value
                                  ? "Linkedin: www.linkedin.com/in/amirreza-sharifzade"
                                  : "لینکدین: www.linkedin.com/in/amirreza -sharifzade",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          // Add more contact information here
                        ],
                      ),
                      myDivider(),
                      ExpansionTile(
                        title: DrawerTextStyle(
                          _languageController.isEnglish.value ? "Support Me" : "حمایت",
                          context,
                        ),
                        children: [
                          ListTile(
                            leading: Icon(Icons.favorite ,color: Colors.teal,),
                            title: Text(
                              _languageController.isEnglish.value
                                  ? "Support my work by following me on social media!"
                                  : "از طریق رسانه‌های اجتماعی من را دنبال کنید!",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          // Add more ways to support here
                        ],
                      ),
                      myDivider(),
                      ExpansionTile(
                        title: DrawerTextStyle(_languageController.isEnglish.value
                            ? "Share the App"
                            : "اشتراک ‌گذاری اپلیکیشن", context),
                        children: [
                          ListTile(
                            title:Text(
                              _languageController.isEnglish.value
                                  ? "Share this App with Friends and Family"
                                  : "این برنامه را با دوستان و آشنایانتون به اشتراک بگذارید",
                              style: TextStyle(fontSize: 16),
                            ),
                            leading: Icon(
                              Icons.share,
                              color:Colors.teal
                            ),
                            onTap: () {
                              Share.share(
                                _languageController.isEnglish.value
                                    ? "Hey! Check out this amazing app that I found. It's called Time's Up! and I'm loving it. You can download it from the App Store or Google Play Store."
                                    : "سلام! اپلیکیشن فوق‌العاده‌ای رو پیدا کردم به نام Time's Up! که واقعاً دوستش دارم. می‌توانید از فروشگاه اپل یا گوگل پلی اپ استور دانلودش کنید.",
                              );
                            },
                          ),
                          // سایر موارد حمایت را اینجا اضافه کنید
                        ],
                      ),


                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
  (value)
      ? themeNotifier.setTheme(darkTheme)
      : themeNotifier.setTheme(lightTheme);
  var prefs = await SharedPreferences.getInstance();
  prefs.setBool('lightMode', value);
}
