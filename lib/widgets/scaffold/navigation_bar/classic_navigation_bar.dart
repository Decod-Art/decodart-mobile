import 'package:flutter/cupertino.dart';

const double _kNavBarPersistentHeight = kMinInteractiveDimensionCupertino;

class ClassicNavigationBar extends StatefulWidget implements ObstructingPreferredSizeWidget{
  final ScrollController scrollController;
  final String title;
  final Widget? trailing;
  final Widget? leading;
  final double? threshold;
  const ClassicNavigationBar({
    super.key,
    required this.scrollController,
    required this.title,
    this.trailing,
    this.leading,
    this.threshold});

  @override
  State<ClassicNavigationBar> createState() => _ClassicNavigationBarState();
  
  @override
  Size get preferredSize => const Size.fromHeight(_kNavBarPersistentHeight);
  
  @override
  bool shouldFullyObstruct(BuildContext context) {
    final Color backgroundColor = CupertinoTheme.of(context).barBackgroundColor;
    return backgroundColor.alpha == 0xFF;
  }
}

class _ClassicNavigationBarState extends State<ClassicNavigationBar> {
  bool _isCollapsed = false;

  ScrollController get scrollController => widget.scrollController;
  double get threshold => widget.threshold??25;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset >= threshold && !_isCollapsed) {
        setState(() {
          _isCollapsed = true;
        });
      } else if (scrollController.offset < threshold && _isCollapsed) {
        setState(() {
          _isCollapsed = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      leading: widget.leading?? (
        Navigator.of(context).canPop()
          ? CupertinoNavigationBarBackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              previousPageTitle: 'Retour',
            )
          : null
      ),
      middle: Text(widget.title),
      trailing: widget.trailing,
      border: _isCollapsed
        ? const Border(
            bottom: BorderSide(
              color: CupertinoColors.separator,
              width: 0.0,
            ),
          )
        : const Border(),
      backgroundColor: _isCollapsed
          ? const Color.fromRGBO(250, 250, 250, 0.85)
          : CupertinoColors.white,
    );
  }
}