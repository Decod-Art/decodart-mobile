import 'package:decodart/view/apropos/apropos.dart' show AproposView;
import 'package:flutter/cupertino.dart';

typedef StringCallback = void Function(String);
const double _kNavBarPersistentHeight = kMinInteractiveDimensionCupertino;

class NewDecodNavigationBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  final String? title;
  final Widget? leading;

  const NewDecodNavigationBar({
    super.key,
    this.title,
    this.leading});

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      leading: leading,
      middle: title!=null?Text(title!):null,
      trailing: CupertinoButton(
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
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(_kNavBarPersistentHeight);
  
  @override
  bool shouldFullyObstruct(BuildContext context) {
    final Color backgroundColor = CupertinoTheme.of(context).barBackgroundColor;
    return backgroundColor.alpha == 0xFF;
  }
}


