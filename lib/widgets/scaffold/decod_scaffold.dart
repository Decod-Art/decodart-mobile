import 'package:decodart/widgets/scaffold/navigation_bar/decod_bar.dart';
import 'package:decodart/widgets/scaffold/navigation_bar/sliver_decod_bar.dart';
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
  late Widget? child;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller??ScrollController();
    _scrollController.addListener(_scrollListener);
    _configureChild();
  }

  @override
  void didUpdateWidget(covariant DecodPageScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (child != widget.child) {
      _configureChild();
    }

  }

  void _configureChild() {
    if (widget.child == null) {
      child = null;
    }
    else {
      child = widget.withScrolling
        ? SingleChildScrollView(
            controller: _scrollController,
            child: widget.child,
          )
        : widget.child;
    }
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

  bool get isSmallNavigationBar => (widget.title==null&&widget.onSearch==null)||widget.smallTitle;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: isSmallNavigationBar
        ? DecodNavigationBar(
            title: widget.title,
            showBorder: _showBorder,
            leadingBar: widget.leadingBar,
            showTrailing: widget.showTrailing,
          )
        : null,
      child: child != null 
        ? SafeArea(
            child: child!
          )
        : CustomScrollView( // We use the widget in child if it exists. Otherwise CustomScrollView
            controller: _scrollController,
            slivers: [
              if (!isSmallNavigationBar)
                SliverDecodNavigationBar(
                  title: widget.title,
                  onSearch: widget.onSearch,
                  showBorder: _showBorder,),
              SliverSafeArea(
                top: isSmallNavigationBar,
                sliver: SliverList(
                  delegate: widget.children!=null
                    ? SliverChildListDelegate(
                        widget.children!
                      )
                    : SliverChildBuilderDelegate(
                        widget.builder!,
                        childCount: widget.childCount!
                      )
                ),
              )
            ],
          ),
    );
  }
}