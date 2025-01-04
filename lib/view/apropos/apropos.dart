import 'package:decodart/api/offline.dart';
import 'package:decodart/view/apropos/util/reset_scans.dart' show ResetScansWidget;
import 'package:decodart/view/apropos/util/tile.dart' show DecodPreferenceTile;
import 'package:decodart/widgets/scaffold/decod_scaffold.dart' show DecodPageScaffold;
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
              // Action à effectuer lors du tap
            },
          ),
          DecodPreferenceTile(
            title: const Text('Mode hors ligne'),
            trailing: CupertinoSwitch(
              value: OfflineManager.useOffline,
              onChanged: (bool value) => setState(() {OfflineManager.useOffline = value;}),
            ),
          ),
          DecodPreferenceTile(
            title: const Text('Mode hors ligne'),
            trailing: CupertinoButton(
              child: const Text('Réinitialiser'),
              onPressed: () {
                final offline = OfflineManager();
                offline.clearAll();
                setState(() {
                  OfflineManager.useOffline = false;
                });
              },
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
          const ResetScansWidget()
        ],
      ),
    );
  }
}
