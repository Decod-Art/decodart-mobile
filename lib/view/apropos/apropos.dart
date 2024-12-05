import 'package:decodart/view/apropos/util/reset_scans.dart' show ResetScansWidget;
import 'package:decodart/view/apropos/util/tile.dart' show DecodPreferenceTile;
import 'package:decodart/widgets/scaffold/decod_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';

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
          const ResetScansWidget()
        ],
      ),
    );
  }
}
