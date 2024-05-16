import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/core.dart';
import '../features.dart';

class SplashUi extends StatefulWidget {
  const SplashUi({super.key});

  @override
  State<SplashUi> createState() => _SplashUiState();
}

class _SplashUiState extends State<SplashUi> {
  @override
  void initState() {
    super.initState();
    initialAppRoute();
  }

  void initialAppRoute() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getInt("user_id");
    final auth = userId != null ? true : false;

    Future.delayed(
        const Duration(seconds: 4),
        () => {
              if (auth)
                {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomeUI()),
                      (route) => false)
                }
              else
                {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const RegisterUI()),
                      (route) => false)
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(AppAssets.splashScreenImage),
      ),
    );
  }
}
