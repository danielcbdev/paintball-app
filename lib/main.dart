import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:picospaintballzone/blocs_load.dart';
import 'package:picospaintballzone/firebase_options.dart';
import 'package:picospaintballzone/screens/splash/main.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    BlocsLoad(
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Nunito',
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt'),
        ],
      ),
    ),
  );
}
