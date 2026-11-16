import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klemi/splash_screen.dart';
import 'package:sizer/sizer.dart';

import 'Configuration/app_theme.dart';
import 'Widgets/custom_animation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Fix l'orientation de l'application en portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) => runApp(const MyApp()));
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 2)
    ..indicatorType = EasyLoadingIndicatorType.doubleBounce
    ..maskType = EasyLoadingMaskType.custom
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.blue
    ..backgroundColor = AppTheme.couleurDefaut
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.black45
    ..userInteractions = false
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    Map<int, Color> swatch = {
      50: const Color.fromRGBO(10, 4, 52, .1),
      100: const Color.fromRGBO(10, 4, 52, .2),
      200: const Color.fromRGBO(10, 4, 52, .3),
      300: const Color.fromRGBO(10, 4, 52, .4),
      400: const Color.fromRGBO(10, 4, 52, .5),
      500: const Color.fromRGBO(10, 4, 52, .6),
      600: const Color.fromRGBO(10, 4, 52, .7),
      700: const Color.fromRGBO(10, 4, 52, .8),
      800: const Color.fromRGBO(10, 4, 52, .9),
      900: const Color.fromRGBO(10, 4, 52, 1),
    };

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'App Klemi',
          theme: ThemeData(
            primarySwatch: MaterialColor(0xFF002270, swatch),
            primaryColor: AppTheme.couleurDefaut,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Lato',
          ),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          builder: EasyLoading.init(),

          // langues supportées dans l'application
          // supportedLocales: const [
          //   Locale('fr')
          // ]
        );
      },
    );
  }
}
