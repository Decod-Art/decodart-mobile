import 'package:decodart/ui/apropos/widgets/config.dart' show ConfigScreen;
import 'package:decodart/ui/apropos/widgets/offline.dart' show OfflineOptionView;
import 'package:decodart/ui/apropos/widgets/thanks.dart' show ThanksScreen;
import 'package:decodart/ui/apropos/widgets/components/reset_scans.dart' show ResetScansWidget;
import 'package:decodart/ui/apropos/widgets/components/tile.dart' show DecodPreferenceTile;
import 'package:decodart/ui/core/scaffold/decod_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';

class AproposView extends StatefulWidget {
  const AproposView({super.key});
  
  @override
  State<AproposView> createState()=> _AproposPageState();


}

class _AproposPageState extends State<AproposView> {
  @override
  Widget build(BuildContext context) {
    return DecodPageScaffold(
      title: 'À propos',
      smallTitle: true,
      showTrailing: false,
      withScrolling: true,
      child: Column(
        children: <Widget>[
          DecodPreferenceTile(
            title: const Text('Remerciements'),
            trailing: const Icon(CupertinoIcons.forward),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ThanksScreen(),
                ),
              );
            },
          ),
          DecodPreferenceTile(
            title: const Text('Mode hors ligne'),
            trailing: const Icon(CupertinoIcons.forward),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => OfflineOptionView(),
                ),
              );
            },
          ),
          const ResetScansWidget(),
          DecodPreferenceTile(
            title: const Text('Configuration'),
            trailing: const Icon(CupertinoIcons.forward),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ConfigScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
