import 'package:decodart/widgets/scaffold/navigation_bar/decod_bar.dart';
import 'package:decodart/widgets/scaffold/navigation_bar/sliver_decod_bar.dart';
import 'package:decodart/widgets/scaffold/scaffold/classic.dart' show DecodClassicScaffold;
import 'package:decodart/widgets/scaffold/scaffold/sliver.dart' show DecodSliverScaffold;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;

class DecodPageScaffold extends StatefulWidget {
  final List<Widget>? children;
  final NullableIndexedWidgetBuilder? builder;
  final Widget? child;
  final int? childCount;
  final String? title;
  final bool smallTitle;
  final void Function(String)? onSearch;
  final ScrollController? controller;
  final Widget? leadingBar;
  final bool showTrailing;
  final bool withScrolling;
  const DecodPageScaffold({
    super.key,
    this.children,
    this.builder,
    this.childCount,
    required this.title,
    this.onSearch,
    this.controller,
    this.smallTitle=false,
    this.leadingBar,
    this.child,
    this.showTrailing=true,
    this.withScrolling=false});
    
      @override
      State<DecodPageScaffold> createState() => _DecodPageScaffoldState();
}

class _DecodPageScaffoldState extends State<DecodPageScaffold> {
  late ScrollController _scrollController;
  bool _showBorder = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller??ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  int get offsetThreshold => widget.smallTitle ? 5 : 50;

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection != ScrollDirection.idle) {
      FocusScope.of(context).focusedChild?.unfocus();
    }
    if (_scrollController.hasClients) {
      final offset = _scrollController.offset;
      if (offset > offsetThreshold && !_showBorder) {
        setState(() {
          _showBorder = true;
        });
      } else if (offset <= offsetThreshold && _showBorder) {
        setState(() {
          _showBorder = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    if (widget.controller == null){
      _scrollController.dispose();
    }
    super.dispose();
  }

  bool get hasClassicNavigationBar => (widget.title==null&&widget.onSearch==null)||widget.smallTitle;

  bool get hasSliverNavigationBar => !hasClassicNavigationBar;

  bool get hasClassicView => widget.child != null;

  Widget classic(BuildContext context){
    return DecodClassicScaffold(
      classicNavigationBar: DecodNavigationBar(
        title: widget.title,
        showBorder: _showBorder,
        leadingBar: widget.leadingBar,
        showTrailing: widget.showTrailing,
      ),
      withScrolling: widget.withScrolling,
      controller: _scrollController,
      child: widget.child!,
    );
  }

  Widget sliver(BuildContext context) {
    return DecodSliverScaffold(
      classicNavigationBar: hasClassicNavigationBar
        ? DecodNavigationBar(
            title: widget.title,
            showBorder: _showBorder,
            leadingBar: widget.leadingBar,
            showTrailing: widget.showTrailing,
          )
        : null,
      controller: _scrollController,
      builder: widget.builder,
      childCount: widget.childCount,
      sliverNavigationBar:  hasSliverNavigationBar
        ? SliverDecodNavigationBar(
            title: widget.title,
            onSearch: widget.onSearch,
            showBorder: _showBorder,)
        : null,
      children: widget.children,
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