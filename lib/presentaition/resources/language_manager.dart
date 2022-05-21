import 'package:flutter/material.dart';

enum LanguageManager { english, arabic }

const String ar = "ar";
const String en = "en";

const String ASSET_PATH_LOCALISATIONS = "assets/translations";

const Locale ARABIC_LOCAL = Locale("ar", "SA");
const Locale ENGLISH_LOCAL = Locale("en", "US");

extension LanguageTypeExtension on LanguageManager {
  String getValue() {
    switch (this) {
      case LanguageManager.english:
        return en;

      case LanguageManager.arabic:
        return ar;
    }
  }
}
