import 'package:decodart/controller_and_mixins/global/hive.dart' show HiveService;
import 'package:decodart/view/apropos/util/tile.dart' show DecodPreferenceTile;
import 'package:decodart/widgets/dialog/dialog.dart' show showDialog;
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart' show Box;


class ResetScansWidget extends StatelessWidget {
  const ResetScansWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return DecodPreferenceTile(
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
    );
  }
}