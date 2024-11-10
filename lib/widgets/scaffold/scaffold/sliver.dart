import 'package:decodart/widgets/scaffold/navigation_bar/decod_bar.dart' show DecodNavigationBar;
import 'package:decodart/widgets/scaffold/navigation_bar/sliver_decod_bar.dart' show SliverDecodNavigationBar;
import 'package:flutter/cupertino.dart';

class DecodSliverScaffold extends StatelessWidget {
  final DecodNavigationBar? classicNavigationBar;
  final SliverDecodNavigationBar? sliverNavigationBar;
  final List<Widget>? children;
  final NullableIndexedWidgetBuilder? builder;
  final int? childCount;
  final ScrollController controller;
  const DecodSliverScaffold({
    super.key,
    this.classicNavigationBar,
    this.sliverNavigationBar,
    this.children,
    this.builder,
    this.childCount,
    required this.controller});

  bool get hasSliverNavigationBar => sliverNavigationBar != null;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: classicNavigationBar,
      child: CustomScrollView( // We use the widget in child if it exists. Otherwise CustomScrollView
        controller: controller,
        slivers: [
          if (hasSliverNavigationBar) sliverNavigationBar!,
          SliverSafeArea(
            top: !hasSliverNavigationBar,
            sliver: SliverList(
              delegate: children!=null
                ? SliverChildListDelegate(
                    children!
                  )
                : SliverChildBuilderDelegate(
                    builder!,
                    childCount: childCount!
                  )
            ),
          )
        ],
      ),
    );
  }
}