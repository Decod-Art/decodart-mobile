import 'package:decodart/api/offline/offline.dart' show OfflineManager;
import 'package:decodart/view/apropos/util/tile.dart' show DecodPreferenceTile;
import 'package:decodart/widgets/dialog/dialog.dart';
import 'package:decodart/widgets/scaffold/decod_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';

class OfflineOptionView extends StatefulWidget {
  const OfflineOptionView({super.key});
  
  @override
  State<OfflineOptionView> createState()=> _OfflineOptionViewState();


}

class _OfflineOptionViewState extends State<OfflineOptionView> {
  @override
  Widget build(BuildContext context) {
    return DecodPageScaffold(
      title: 'Mode hors ligne',
      smallTitle: true,
      showTrailing: false,
      withScrolling: true,
      child: Column(
        children: <Widget>[
          DecodPreferenceTile(
            title: const Text('Activé'),
            trailing: CupertinoSwitch(
              value: OfflineManager.appIsOffline,
              onChanged: (bool value) => setState(() {OfflineManager.appIsOffline = value;}),
            ),
          ),
          DecodPreferenceTile(
            title: const Text('Cache'),
            trailing: CupertinoButton(
              onPressed: () {
                showDialog(
                  context,
                  content: const Text('Voulez-vous vraiment supprimer toutes les données hors ligne ?'),
                  onPressedOk: () async {
                    final offline = OfflineManager();
                    offline.clearAll();
                    setState(() {
                      OfflineManager.appIsOffline = false;
                    });
                  });
              },
              child: const Text('Vider'),
            ),
          )
        ],
      ),
    );
  }
}
