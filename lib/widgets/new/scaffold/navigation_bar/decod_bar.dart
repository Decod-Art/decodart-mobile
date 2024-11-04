import 'package:decodart/view/apropos/apropos.dart' show AproposView;
import 'package:flutter/cupertino.dart';

const double _kNavBarPersistentHeight = kMinInteractiveDimensionCupertino;

class DecodNavigationBar extends StatefulWidget implements ObstructingPreferredSizeWidget{
  final String? title;
  final bool showBorder;
  final Widget? leadingBar;
  const DecodNavigationBar({
    super.key,
    required this.title,
    this.leadingBar,
    this.showBorder=false});

  @override
  State<DecodNavigationBar> createState() => _DecodNavigationBarState();
  
  @override
  Size get preferredSize => const Size.fromHeight(_kNavBarPersistentHeight);
  
  @override
  bool shouldFullyObstruct(BuildContext context) {
    final Color backgroundColor = CupertinoTheme.of(context).barBackgroundColor;
    return backgroundColor.alpha == 0xFF;
  }
}

class _DecodNavigationBarState extends State<DecodNavigationBar> {

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      leading: widget.leadingBar?? (
        Navigator.of(context).canPop()
          ? CupertinoNavigationBarBackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              previousPageTitle: 'Retour',
            )
          : null
      ),
      middle: widget.title != null ? Text(widget.title!) : null,
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
      border: widget.showBorder
        ? const Border(
            bottom: BorderSide(
              color: CupertinoColors.separator,
              width: 0.0,
            ),
          )
        : const Border(),
      backgroundColor: widget.showBorder
        ? CupertinoColors.systemBackground.withOpacity(0.85)
        : CupertinoColors.white,
    );
  }
}