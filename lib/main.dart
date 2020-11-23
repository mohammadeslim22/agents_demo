import 'package:agent_second/providers/auth.dart';
import 'package:agent_second/providers/counter.dart';
import 'package:agent_second/providers/language.dart';
import 'package:agent_second/providers/global_variables.dart';
import 'package:agent_second/services/navigationService.dart';
import 'package:agent_second/splash.dart';
import 'package:agent_second/ui/auth/login_screen.dart';
import 'package:agent_second/util/data.dart';
import 'package:agent_second/util/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'constants/config.dart';
import 'constants/route.dart';
import 'constants/themes.dart';
import 'localization/localization_delegate.dart';

import 'util/service_locator.dart';
import 'package:agent_second/providers/order_provider.dart';

// import 'package:flutter/scheduler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  dioDefaults();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);
  final String baseUrl = await data.getData("baseUrl");
  print("base url $baseUrl");
  if (baseUrl == "null" ||
      baseUrl == null ||
      baseUrl.isEmpty ||
      baseUrl == "") {
    config.baseUrl = "http://demo.agentsmanage.com/api/";
    config.imageUrl = "http://demo.agentsmanage.com/image/";
    config.qrCodeScan = true;
  } else {
    config.baseUrl = "${baseUrl}api/";
    config.imageUrl = "${baseUrl}image/";
    config.qrCodeScan = false;
  }
  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider<Language>(
          create: (_) => Language(),
        ),
        ChangeNotifierProvider<MyCounter>(
          create: (_) => MyCounter(),
        ),
        ChangeNotifierProvider<GlobalVars>.value(
          value: getIt<GlobalVars>(),
        ),
        ChangeNotifierProvider<OrderListProvider>.value(
          value: getIt<OrderListProvider>(),
        ),
      ],
      child: MyApp(),
    ),
  );

  await data.getData('authorization').then<dynamic>((dynamic auth) {
    if (auth == null) {}
    dio.options.headers['authorization'] = '$auth';
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Language lang = Provider.of<Language>(context);

    return MaterialApp(
        navigatorKey: getIt<NavigationService>().navigatorKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: <LocalizationsDelegate<dynamic>>[
          DemoLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('ar'),
          Locale('en'),
        ],
        locale: lang.currentLanguage,
        localeResolutionCallback:
            (Locale locale, Iterable<Locale> supportedLocales) {
          if (locale == null) {
            return supportedLocales.first;
          }

          for (final Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        theme: mainThemeData(),
        onGenerateRoute: onGenerateRoute,
        home: config.qrCodeScan ? const Splash() :  const LoginScreen());
  }
}
