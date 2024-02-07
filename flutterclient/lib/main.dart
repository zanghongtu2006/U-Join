import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutterclient/page/home_screen.dart';
import 'package:flutterclient/page/login/common_login.dart';
import 'package:flutterclient/page/login/login_page.dart';
import 'package:flutterclient/util/ws_manager.dart';
import 'package:flutterclient/util/ws_service.dart';
import 'package:oktoast/oktoast.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp( OKToast(child: MaterialApp(home: MyApp())));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        // Locale('en', 'US'), // English
        Locale('zh', 'CN'), // Chinese
        // ... other locales the app supports
      ],
      localizationsDelegates: const [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // For Cupertino widgets
      ],
      navigatorKey: navigatorKey,
      routes: {
        '/login': (context) => const LoginPage(),
      },
      home: HomeScreen(), // 启动屏，用于处理初始化逻辑
    );
  }
}