import 'dart:io';
import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klemi/Configuration/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  Timer? _connectivityTimer;
  bool _lienOuvert = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _navigateToNextPage();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivityTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Quand l'application revient au premier plan
    //if (state == AppLifecycleState.resumed && !_lienOuvert) {
    if (state == AppLifecycleState.resumed && !_lienOuvert) {
      _ouvrirLienConnexion();
    }
  }

  Future<void> _navigateToNextPage() async {
    // Attends 5 secondes
    await Future.delayed(const Duration(seconds: 3));

    _ouvrirLienConnexion();
  }

  Future<void> _ouvrirLienConnexion() async {
    try {
      // Vérifier d'abord la connexion Internet
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Il y a une connexion, ouvrir le lien
        final url = Uri.parse('https://learn.klemi.ci/sign-in');
        if (!await launchUrl(url)) {
          throw 'Could not launch $url';
        }
        _lienOuvert = true;
        _connectivityTimer?.cancel();
      }
    } on SocketException {
      EasyLoading.dismiss();
      EasyLoading.showError(
        "Pas de connexion Internet. Vérifiez votre réseau.",
      );
      _surveillerConnexion();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Erreur inattendue. Veuillez réessayer.");
    }
  }

  void _surveillerConnexion() {
    if (_lienOuvert) return;

    _connectivityTimer = Timer.periodic(const Duration(seconds: 5), (
      timer,
    ) async {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty &&
            result[0].rawAddress.isNotEmpty &&
            !_lienOuvert) {
          EasyLoading.dismiss();
          EasyLoading.showSuccess("Connexion rétablie !");
          await Future.delayed(const Duration(seconds: 1));
          final url = Uri.parse('https://learn.klemi.ci/sign-in');
          if (await launchUrl(url)) {
            _lienOuvert = true;
            timer.cancel();
          }
        }
      } on SocketException {
        // Toujours pas de connexion, on continue à surveiller
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: AppTheme.couleurDefaut,
      child: Center(
        child: Image.asset(
          'assets/logos/logo_klemi_white.png',
          width: 280,
          height: 280,
        ).animate().fadeIn(duration: 750.ms).slideY(begin: 0.2),
      ),
    );
  }
}
