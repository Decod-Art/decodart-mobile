import 'package:decodart/view/apropos/apropos.dart' show AproposView;
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
    this.child});
    
      @override
      State<DecodPageScaffold> createState() => _DecodPageScaffoldState();

}

class _DecodPageScaffoldState extends State<DecodPageScaffold> {
  late ScrollController _scrollController;
  bool _showBorder = false;
  //late final FocusNode _searchFocusNode;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_searchFocusNode = FocusNode();
    _scrollController = widget.controller??ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection != ScrollDirection.idle) {
      FocusScope.of(context).focusedChild?.unfocus();
    }
    if (_scrollController.hasClients) {
      final offset = _scrollController.offset;
      if (offset > 50 && !_showBorder) {
        setState(() {
          _showBorder = true;
        });
      } else if (offset <= 50 && _showBorder) {
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: (widget.title==null&&widget.onSearch==null)||widget.smallTitle
        ? CupertinoNavigationBar(
            leading: widget.leadingBar?? (Navigator.of(context).canPop()
                  ? CupertinoNavigationBarBackButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      previousPageTitle: 'Retour',
                    )
                  : null),
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
            border: _showBorder
              ? const Border(
                  bottom: BorderSide(
                    color: CupertinoColors.separator,
                    width: 0.0,
                  ),
                )
              : const Border(),
              backgroundColor: _showBorder
                ? CupertinoColors.systemBackground.withOpacity(0.85)
                : CupertinoColors.white,
        )
        : null,
      child: SafeArea(
        child: widget.child ?? CustomScrollView( // We use the widget in child if it exists. Otherwise CustomScrollView
          controller: _scrollController,
          slivers: [
            if ((widget.title != null || widget.onSearch != null)&&!widget.smallTitle)
              CupertinoSliverNavigationBar(
                transitionBetweenRoutes: false,
                leading: Navigator.of(context).canPop()
                  ? CupertinoNavigationBarBackButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      previousPageTitle: 'Retour',
                    )
                  : null,
                largeTitle: widget.onSearch!=null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 25, left: 5),
                      child: SizedBox(
                        height: 36,
                        child: CupertinoSearchTextField(
                          //focusNode: _searchFocusNode,
                          placeholder: 'Rechercher',
                          onSubmitted: widget.onSearch,
                          onSuffixTap: (){
                            setState((){_searchController.text = '';});
                            widget.onSearch!('');
                          },
                          controller: _searchController,
                        ),
                      ),
                    )
                  : Text(widget.title??""),
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
                middle: widget.onSearch!=null 
                  ? Text(widget.title??"")
                  : const Text(''),
                border: _showBorder
                ? const Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator,
                      width: 0.0,
                    ),
                  )
                : const Border(),
                backgroundColor: _showBorder
                  ? CupertinoColors.systemBackground.withOpacity(0.85)
                  : CupertinoColors.white,
              ),
            SliverSafeArea(
              top: false,
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
      )
    );
  }
}