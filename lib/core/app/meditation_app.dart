import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditation_new/features/features.dart';

import '../core.dart';

class MeditationApplication extends StatelessWidget {
  const MeditationApplication({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Meditation',
            theme: ThemeData(
              fontFamily: "HelveticaNeue",
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                  elevation: 0, backgroundColor: Colors.transparent),
              colorScheme: ColorScheme.fromSeed(seedColor: TColor.primary),
              useMaterial3: false,
            ),
            home: const SplashUi(),
          );
        });
  }
}
