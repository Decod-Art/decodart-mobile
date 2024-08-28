import 'package:flutter/cupertino.dart';

class AproposView extends StatelessWidget {
  const AproposView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('À propos'),
      ),
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            CupertinoListTile(
              title: const Text('Remerciements'),
              trailing: const Icon(CupertinoIcons.forward),
              onTap: () {
                // Action à effectuer lors du tap
              },
            ),
            CupertinoListTile(
              title: const Text('Option 1'),
              trailing: CupertinoSwitch(
                value: true,
                onChanged: (bool value) {},
              ),
            ),
            CupertinoListTile(
              title: const Text('Option 2'),
              trailing: CupertinoSwitch(
                value: false,
                onChanged: (bool value) {},
              ),
            ),
            CupertinoListTile(
              title: const Text('Option 3'),
              trailing: const Icon(CupertinoIcons.forward),
              onTap: () {
                // Action à effectuer lors du tap
              },
            ),
            // Ajoutez plus d'options ici
          ],
        ),
      ),
    );
  }
}

class CupertinoListTile extends StatelessWidget {
  final Widget title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const CupertinoListTile({super.key, required this.title, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CupertinoColors.separator,
              width: 0.0, // Utilisez 0.0 pour une ligne fine
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            title,
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}