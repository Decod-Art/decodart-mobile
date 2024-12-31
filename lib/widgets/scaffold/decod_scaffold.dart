import 'package:decodart/widgets/scaffold/navigation_bar/classic_navigation_bar.dart' show ClassicNavigationBar;
import 'package:decodart/widgets/component/button/apropos_button.dart' show AproposButton;
import 'package:decodart/widgets/scaffold/scaffold/classic_scaffold.dart' show ClassicScaffold;
import 'package:decodart/widgets/scaffold/scaffold/searchable_or_large_title_scaffold.dart' show SearchableOrLargeTitleScaffold;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;

class DecodPageScaffold extends StatefulWidget {
  final List<Widget>? children;

  final int? childCount;
  final NullableIndexedWidgetBuilder? builder;

  final Widget? child;

  final String? title;
  final bool smallTitle;

  final void Function(String)? onSearch;

  final ScrollController? controller;

  // Should we add a specific icon as leading
  // in the navigation bar
  final Widget? leading;

  // should we show the a propos view ?
  final bool showTrailing;

  // In the classical scaffold, should we add a scroll ?
  final bool withScrolling;

  // When using the classical navigation bar
  // How much pixel of scrolling should be used as a buffer
  // before changing the style (more transparent) of the navigation bar
  final double? threshold;

  // Indicates whether the current view can pop from the navigation stack.
  final bool canPop;

  const DecodPageScaffold({
    super.key,
    this.children,
    this.builder,
    this.childCount,
    required this.title,
    this.onSearch,
    this.controller,
    this.smallTitle=false,
    this.leading,
    this.child,
    this.showTrailing=true,
    this.withScrolling=false,
    this.threshold,
    this.canPop=true});
    
      @override
      State<DecodPageScaffold> createState() => _DecodPageScaffoldState();
}

class _DecodPageScaffoldState extends State<DecodPageScaffold> {
  late ScrollController _scrollController;
  

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller??ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection != ScrollDirection.idle) {
      FocusScope.of(context).focusedChild?.unfocus();
    }
  }

  int get offsetThreshold => widget.smallTitle ? 5 : 50;

  @override
  void dispose() {
    if (widget.controller == null){
      _scrollController.dispose();
    }
    super.dispose();
  }

  bool get hasClassicNavigationBar => (widget.title==null&&widget.onSearch==null)||widget.smallTitle;

  bool get hasSliverNavigationBar => !hasClassicNavigationBar;

  bool get hasClassicView => widget.child != null;

  Widget classic(BuildContext context){
    return ClassicScaffold(
      classicNavigationBar: ClassicNavigationBar(
        title: widget.title??'',
        scrollController: _scrollController,
        leading: widget.leading,
        trailing: widget.showTrailing
          ? AproposButton()
          : null,
        canPop: widget.canPop,
      ),
      withScrolling: widget.withScrolling,
      controller: _scrollController,
      child: widget.child!,
    );
  }

  Widget sliver(BuildContext context) {
    return SearchableOrLargeTitleScaffold(
      title: widget.title??'',
      showLargeTitle: !widget.smallTitle,
      scrollController: _scrollController,
      onSearch: widget.onSearch,
      leading: widget.leading,
      trailing: widget.showTrailing
          ? AproposButton()
          : null,
      threshold: widget.threshold,
      builder: widget.builder,
      childCount: widget.childCount,
      canPop: widget.canPop,
      children: widget.children
    );
  }

  @override
  Widget build(BuildContext context) {
    if (hasClassicView) {
      return classic(context);
    }
    return sliver(context);
  }
}