import 'package:clean_arc_app/presentaition/resources/language_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String langKey = "LangKey";
const String onBoardingKey = "onBoardingKey";
const String loginKey = "loginKey";

class AppPrefrences {
  final SharedPreferences _sharedPreferences;
  AppPrefrences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(langKey);
    //print("GET LANGUAGE///////////////////////" + language!);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageManager.english.getValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String currentLang = await getAppLanguage();
    print("CCCCUUUUURRRRREEEEENNNTTTTTT" + currentLang);

    if (currentLang == LanguageManager.arabic.getValue()) {
      // set english
      _sharedPreferences.setString(langKey, LanguageManager.english.getValue());
    } else {
      // set arabic
      _sharedPreferences.setString(langKey, LanguageManager.arabic.getValue());
    }
    print("Change Language*****************" +
        _sharedPreferences.getString(langKey)!);
  }

  Future<Locale> getLocal() async {
    String currentLang = await getAppLanguage();

    if (currentLang == LanguageManager.arabic.getValue()) {
      return ARABIC_LOCAL;
    } else {
      return ENGLISH_LOCAL;
    }
  }

  Future<void> setOnBoardingScreenSeen() async {
    _sharedPreferences.setBool(onBoardingKey, true);
  }

  Future<void> setUserLoggedInSuccessfully() async {
    _sharedPreferences.setBool(loginKey, true);
  }

  Future<bool> isOnBoardingSeen() async =>
      _sharedPreferences.getBool(onBoardingKey) ?? false;
  Future<bool> isUserLoggedIn() async =>
      _sharedPreferences.getBool(loginKey) ?? false;

  Future<void> logout() async {
    _sharedPreferences.remove(loginKey);
  }
}
