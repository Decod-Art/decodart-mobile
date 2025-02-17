import 'package:decodart/data/model/hive/artist.dart' show ArtistForeignKeyAdapter;
import 'package:decodart/data/model/hive/artwork.dart' show ArtworkListItemAdapter;
import 'package:decodart/data/model/hive/decod.dart' show GameDataAdapter;
import 'package:decodart/data/model/hive/image.dart' show ImageAdapter;
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:decodart/ui/home/widgets/home.dart' show HomePage;

void main() async {
  // debugPaintSizeEnabled=true;
  // configure DB
  await Hive.initFlutter();
  Hive.registerAdapter(GameDataAdapter());
  Hive.registerAdapter(ImageAdapter());
  Hive.registerAdapter(ArtistForeignKeyAdapter());
  Hive.registerAdapter(ArtworkListItemAdapter());

  runApp(
    const CupertinoApp(
      theme: CupertinoThemeData(
        brightness: Brightness.light, // Forcer le mode clair
      ),
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