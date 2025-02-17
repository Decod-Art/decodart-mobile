import 'package:decodart/ui/apropos/widgets/apropos.dart' show AproposView;
import 'package:flutter/cupertino.dart';

class AproposButton extends StatelessWidget {
  const AproposButton({super.key});
  @override
  Widget build(BuildContext context){
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => const AproposView()),
        );
      },
      child: const Icon(
        CupertinoIcons.person_circle,
        color: CupertinoColors.activeBlue,
        size: 24
      ),
    );
  }
}