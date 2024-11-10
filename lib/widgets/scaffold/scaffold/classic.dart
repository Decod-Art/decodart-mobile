import 'package:decodart/widgets/scaffold/navigation_bar/decod_bar.dart' show DecodNavigationBar;
import 'package:flutter/cupertino.dart';

class DecodClassicScaffold extends StatelessWidget {
  final DecodNavigationBar? classicNavigationBar;
  final Widget child;
  final bool withScrolling;
  final ScrollController? controller;

  const DecodClassicScaffold({
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