import 'package:decodart/widgets/scaffold/navigation_bar/classic_navigation_bar.dart' show ClassicNavigationBar;
import 'package:decodart/widgets/scaffold/navigation_bar/searchable_or_large_title_navigation_bar.dart' show SearchableOrLargeTitleNavigationBar;
import 'package:flutter/cupertino.dart';

class SearchableOrLargeTitleScaffold extends StatefulWidget {
  final String title;
  final bool showLargeTitle;
  final String? previousPageTitle;
  final Widget? trailing;
  final Widget? leading;
  final bool? transitionBetweenRoutes;
  final TextEditingController? searchController;
  final ScrollController? scrollController;
  final List<Widget>? children;
  final NullableIndexedWidgetBuilder? builder;
  final int? childCount;
  final Function(String)? onSearch;
  final double? threshold;
  final bool canPop;

  const SearchableOrLargeTitleScaffold(
      {super.key,
      required this.title,
      this.showLargeTitle=false,
      this.searchController,
      this.scrollController,
      this.children,
      this.builder,
      this.childCount,
      this.onSearch,
      this.transitionBetweenRoutes,
      this.previousPageTitle,
      this.trailing,
      this.leading,
      this.threshold,
      this.canPop=true});

  @override
  State<SearchableOrLargeTitleScaffold> createState() => _NavState();
}

class _NavState extends State<SearchableOrLargeTitleScaffold>{
  late final ScrollController scrollController;
  double searchBarHeight = 40;
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = widget.searchController??TextEditingController();
    scrollController = widget.scrollController??ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.addListener(_scrollUpdateListener);
      if (hasSearch) scrollController.position.isScrollingNotifier.addListener(_scrollEndingListener);
    });
  }

  void _scrollUpdateListener() {
    setState(() {
        searchBarHeight = (40 - scrollController.position.pixels).clamp(0, 40);
    });
  }

  void _scrollEndingListener() {
    if(!scrollController.position.isScrollingNotifier.value) {
      // When the scrolling is ending, put the search field properly.
      Future.delayed(Duration.zero, () {
        if (searchBarHeight < 30 && searchBarHeight > 0) {
          setState(() {
            scrollController.animateTo(40, duration: const Duration(milliseconds: 200), curve: Curves.ease);
          });
        } else if (searchBarHeight >= 30 && searchBarHeight <= 40) {
          setState(() {
            scrollController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.ease);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.searchController == null){
      searchController.dispose();
    }
    if(widget.scrollController == null) {
      scrollController.dispose();
    }
    super.dispose();
  }

  bool get showSearchBarAndLargeTitle => widget.showLargeTitle&&widget.onSearch!=null;
  bool get hasClassicNavigationBar => !widget.showLargeTitle&&widget.onSearch == null;
  bool get hasSearch => widget.onSearch != null;
  List<Widget> get children => widget.children!;
  bool get hasChildren => widget.children != null;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: hasClassicNavigationBar
        ? ClassicNavigationBar(
            title: widget.title,
            scrollController: scrollController,
            leading: widget.leading,
            trailing: widget.trailing,
            threshold: widget.threshold,
            canPop: widget.canPop,
          )
        : null,
      child:  CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController, // Extremely important to control the large title dynamic
        anchor: widget.showLargeTitle ? 0.055 : 0, //showSearchBarAndLargeTitle?0.055:0
        slivers: <Widget>[
          if (!hasClassicNavigationBar)
            SearchableOrLargeTitleNavigationBar(
              scrollController: scrollController,
              searchBarHeight: searchBarHeight,
              title: widget.title,
              showLargeTitle: widget.showLargeTitle,
              onSearch: widget.onSearch,
              trailing: widget.trailing,
              previousPageTitle: widget.previousPageTitle,
              canPop: widget.canPop
            ),
          SliverSafeArea(
            top: hasClassicNavigationBar,
            sliver: SliverList(

              delegate: hasChildren
                ? SliverChildListDelegate(
                    children
                  )
                : SliverChildBuilderDelegate(
                    widget.builder!,
                    childCount: widget.childCount!//childCount!
                  )
            )
          ),
        ],
      ),
    );
  }
}