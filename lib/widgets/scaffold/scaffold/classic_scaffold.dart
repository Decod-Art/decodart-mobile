import 'package:decodart/widgets/scaffold/navigation_bar/classic_navigation_bar.dart' show ClassicNavigationBar;
import 'package:flutter/cupertino.dart';

class ClassicScaffold extends StatelessWidget {
  final ClassicNavigationBar? classicNavigationBar;
  final Widget child;
  final bool withScrolling;
  final ScrollController? controller;

  const ClassicScaffold({
    super.key,
    this.classicNavigationBar,
    this.controller,
    required this.child,
    this.withScrolling=false});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: classicNavigationBar,
      child: SafeArea(
        child: withScrolling 
          ? SingleChildScrollView(
              controller: controller,
              child: child
            )
          : child
      )
    );
  }
}