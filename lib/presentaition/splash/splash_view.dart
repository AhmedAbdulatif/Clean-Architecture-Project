import 'dart:async';

import 'package:clean_arc_app/app/app_prefs.dart';
import 'package:clean_arc_app/app/di.dart';
import 'package:clean_arc_app/presentaition/resources/assets_manager.dart';
import 'package:clean_arc_app/presentaition/resources/color_manager.dart';
import 'package:clean_arc_app/presentaition/resources/constants_manager.dart';
import 'package:clean_arc_app/presentaition/resources/routes_manager.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  final appPrefs = getIt<AppPrefrences>();

  _startDelay() {
    _timer = Timer(const Duration(seconds: AppConstants.splashDelay), _goNext);
  }

  _goNext() {
    appPrefs.isUserLoggedIn().then((userLoggedIn) {
      if (userLoggedIn) {
        Navigator.pushReplacementNamed(context, Routes.mainRoute);
      } else {
        appPrefs.isOnBoardingSeen().then((boardingSeen) {
          if (boardingSeen) {
            Navigator.pushReplacementNamed(context, Routes.loginRoute);
          } else {
            Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body:
          const Center(child: Image(image: AssetImage(ImageAssets.splashLogo))),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
