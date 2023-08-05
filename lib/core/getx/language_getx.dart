import 'package:get/get.dart';

class LanguageController extends GetxController {
  RxBool _isEnglish = true.obs;

  RxBool get isEnglish => _isEnglish; // Rename the getter function
  void setLanguage(bool language) {
    _isEnglish.value = language; // Update the value using .value
  }
}
