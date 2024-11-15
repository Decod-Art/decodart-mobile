import 'package:decodart/controller/global/hive.dart' show HiveService;
import 'package:decodart/view/apropos/util/tile.dart' show DecodPreferenceTile;
import 'package:decodart/widgets/dialog/dialog.dart' show showDialog;
import 'package:decodart/widgets/scaffold/decod_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart' show Hive, Box;

class AproposView extends StatelessWidget {
  const AproposView({super.key});

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
              // Action à effectuer lors du tap
            },
          ),
          DecodPreferenceTile(
            title: const Text('Option 1'),
            trailing: CupertinoSwitch(
              value: true,
              onChanged: (bool value) {},
            ),
          ),
          DecodPreferenceTile(
            title: const Text('Option 2'),
            trailing: CupertinoSwitch(
              value: false,
              onChanged: (bool value) {},
            ),
          ),
          DecodPreferenceTile(
            title: const Text('Option 3'),
            trailing: const Icon(CupertinoIcons.forward),
            onTap: () {
              // Action à effectuer lors du tap
            },
          ),
          DecodPreferenceTile(
            title: const Text('Option 3'),
            trailing: const Icon(CupertinoIcons.forward),
            onTap: () {
              // Action à effectuer lors du tap
            },
          ),
          DecodPreferenceTile(
            title: const Text('Option 3'),
            trailing: const Icon(CupertinoIcons.forward),
            onTap: () {
              // Action à effectuer lors du tap
            },
          ),
          DecodPreferenceTile(
            title: const Text('Option 3'),
            trailing: const Icon(CupertinoIcons.forward),
            onTap: () {
              // Action à effectuer lors du tap
            },
          ),
          DecodPreferenceTile(
            title: const Text('Option 3'),
            trailing: const Icon(CupertinoIcons.forward),
            onTap: () {
              // Action à effectuer lors du tap
            },
          ),
          DecodPreferenceTile(
            title: const Text('Option 3'),
            trailing: const Icon(CupertinoIcons.forward),
            onTap: () {
              // Action à effectuer lors du tap
            },
          ),
          DecodPreferenceTile(
            title: const Text('Option 3'),
            trailing: const Icon(CupertinoIcons.forward),
            onTap: () {
              // Action à effectuer lors du tap
            },
          ),
          DecodPreferenceTile(
            title: const Text('Option 3'),
            trailing: const Icon(CupertinoIcons.forward),
            onTap: () {
              // Action à effectuer lors du tap
            },
          ),
          DecodPreferenceTile(
            title: const Text('Option 3'),
            trailing: const Icon(CupertinoIcons.forward),
            onTap: () {
              // Action à effectuer lors du tap
            },
          ),
          DecodPreferenceTile(
            title: const Text('Option 3'),
            trailing: const Icon(CupertinoIcons.forward),
            onTap: () {
              // Action à effectuer lors du tap
            },
          ),
          DecodPreferenceTile(
            title: const Text('Option 3'),
            trailing: const Icon(CupertinoIcons.forward),
            onTap: () {
              // Action à effectuer lors du tap
            },
          ),
          DecodPreferenceTile(
            title: const Text('Option 3'),
            trailing: const Icon(CupertinoIcons.forward),
            onTap: () {
              // Action à effectuer lors du tap
            },
          ),
          DecodPreferenceTile(
            title: const Text('Option 3'),
            trailing: const Icon(CupertinoIcons.forward),
            onTap: () {
              // Action à effectuer lors du tap
            },
          ),
          DecodPreferenceTile(
            title: const Text('Scans récents'),
            trailing: CupertinoButton(
              child: const Text('Réinitialiser'),
              onPressed: () async {
                showDialog(
                  context,
                  content: const Text('Voulez-vous vraiment supprimer tous les scans récents ?'),
                  onPressedOk: () async {
                    Box<List> recentScanBox = await HiveService().openBox<List>('recentScan');
                    await recentScanBox.clear(); // Vider la boîte
                    await HiveService().closeBox('recentScan');
                  });
              },
            ),
          )
        ],
      ),
    );
  }
}
