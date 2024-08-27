import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:decodart/view/home/home.dart' show HomePage;

void main() async {
  debugPaintSizeEnabled=false;
  await Hive.initFlutter();
  runApp(
    const CupertinoApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // Assurez-vous d'inclure les localisations Cupertino
      ],
      supportedLocales: [
        Locale('en', 'US'), // Anglais
        Locale('fr', 'FR'), // Français
        // autres langues supportées
      ],
      home: HomePage()
    )
  );
}