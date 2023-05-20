import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_news/global_variables.dart';
import 'package:sport_news/pages/internet_error/internet_error_page.dart';
import 'package:sport_news/pages/placeholder/placeholder_page.dart';
import 'package:sport_news/pages/web_view/web_view_page.dart';
import 'package:sport_news/utils/emulator_utils/emulator_checkup.dart';
import 'package:sport_news/utils/firebase_remote_config_service/firebase_remote_config_service.dart';
import 'package:sport_news/utils/material_wrap/material_wrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  late final Widget app;

  final connection = await Connectivity().checkConnectivity();
  final hasConnection = connection != ConnectivityResult.none;
  final isEmu = await checkIsEmu();
  final prefs = await SharedPreferences.getInstance();
  final link = prefs.getString(GlobalVariables.localLinkName);
  app = await _getApp(
      hasInternet: hasConnection, isPlaceholder: isEmu, link: link);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      child: MaterialWrap(app),
    ),
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemStatusBarContrastEnforced: true,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
}

Future<Widget> _getApp({
  required bool hasInternet,
  required bool isPlaceholder,
  String? link,
}) async {
  if (!hasInternet) {
    return const InternetErrorPage(errorCode: 'errors.noInternet');
  }

  if (isPlaceholder) {
    return const PlaceHolderPage();
  }

  if (link != null && link.isNotEmpty) {
    var uri = Uri.tryParse(link);
    if (uri != null && uri.hasScheme) {
      SharedPreferences.getInstance().then(
          (prefs) => prefs.setString(GlobalVariables.localLinkName, link));
      return WebViewPage(uri: uri);
    }
  }

  final remoteConfig = FirebaseRemoteConfigService(
    firebaseRemoteConfig: FirebaseRemoteConfig.instance,
  );
  await remoteConfig.initialize();
  final uri = Uri.tryParse(remoteConfig.link);

  if (uri?.hasScheme != true) {
    return const InternetErrorPage(errorCode: 'errors.invalidUrl');
  }

  return WebViewPage(uri: uri!);
}
