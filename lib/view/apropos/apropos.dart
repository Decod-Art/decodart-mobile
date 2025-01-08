import 'package:decodart/view/apropos/offline.dart' show OfflineOptionView;
import 'package:decodart/view/apropos/thanks.dart';
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
