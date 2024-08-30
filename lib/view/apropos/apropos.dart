import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
            CupertinoListTile(
              title: const Text('Scans récents'),
              trailing: CupertinoButton(
                child: const Text('Réinitialiser'),
                onPressed: () async {
                  showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: const Text('Confirmation'),
                        content: const Text('Voulez-vous vraiment supprimer tous les scans récents ?'),
                        actions: <CupertinoDialogAction>[
                          CupertinoDialogAction(
                            child: const Text('Annuler', style: TextStyle(color: CupertinoColors.systemRed),),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          CupertinoDialogAction(
                            child: const Text('Ok'),
                            onPressed: () async {
                              Box<List>? recentScanBox = await Hive.openBox<List>('recentScan');
                              await recentScanBox.clear(); // Vider la boîte
                              await recentScanBox.close(); // Fermer la boîte
                              if(context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            )
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