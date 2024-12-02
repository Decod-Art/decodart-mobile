import 'dart:async' show Timer;
import 'dart:ui' show lerpDouble;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

const int secondsToWaitAfterInactivityBeforeSearch = 1;

class SearchableOrLargeTitleNavigationBar extends StatefulWidget {
  final ScrollController scrollController;
  final TextEditingController? searchController;
  final bool showLargeTitle;
  final String title;

  final Function(String)?onSearch;

  final double searchBarHeight;

  final String? previousPageTitle;
  final Widget? middle;
  final Widget? trailing;
  final bool? transitionBetweenRoutes;

  const SearchableOrLargeTitleNavigationBar(
      {super.key,
      required this.scrollController,
      required this.searchBarHeight,
      this.searchController,
      this.transitionBetweenRoutes,
      this.showLargeTitle=false,
      this.onSearch,
      required this.title,
      this.previousPageTitle,
      this.middle,
      this.trailing});

  @override
  State<SearchableOrLargeTitleNavigationBar> createState() => _NavState();
}

class _NavState extends State<SearchableOrLargeTitleNavigationBar> {
  late final TextEditingController searchController;
  String lastSubmittedSearch = '';
  bool _isCollapsed = false;
  Timer? _debounce;
  ScrollController get scrollController => widget.scrollController;

  double get threshold => showLargeTitle&&showSearchInput?97:55;

  @override
  void initState() {
    super.initState();
    searchController = widget.searchController??TextEditingController();
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
  void dispose() {
    if (widget.searchController == null)searchController.dispose();
    super.dispose();
  }


  bool get showLargeTitle => widget.showLargeTitle;
  bool get showSearchInput => widget.onSearch != null;
  double get searchBarHeight => widget.searchBarHeight;

  @override
  Widget build(BuildContext context) {
    // t in [0, 1] gives the ratio of visibility of the search bar
    final t = ((searchBarHeight - 30) / 10).clamp(0.0, 1.0);
    return CupertinoSliverNavigationBar(
      transitionBetweenRoutes: false,
      largeTitle: Column(
        children: [
          if (showLargeTitle)
            Align(alignment: Alignment.centerLeft, child: Text(widget.title)),
          if (showSearchInput)
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: searchBarHeight,
              child: Padding(
                padding: const EdgeInsets.only(right: 15, top: 3),
                child: CupertinoSearchTextField(
                  style: TextStyle(
                    fontSize: lerpDouble(13, 17, t),
                    color: Colors.black.withAlpha(lerpDouble(0, 255, t)!.round())
                  ),
                  placeholderStyle: TextStyle(
                      fontSize: lerpDouble(13, 17, t),
                      color: CupertinoDynamicColor.withBrightness(
                          color: const Color.fromARGB(153, 60, 60, 67)
                              .withAlpha((t * 153).round()),
                          darkColor: const Color.fromARGB(153, 235, 235, 245)
                              .withAlpha((t * 153).round()))),
                  prefixIcon: AnimatedOpacity(
                    duration: const Duration(milliseconds: 1),
                    opacity: ((searchBarHeight - 30) / 10).clamp(0.0, 1.0),
                    child: Transform.scale(
                        scale: lerpDouble(0.7, 1.0, t),
                        child: const Icon(CupertinoIcons.search)),
                  ),
                  controller: searchController,
                  onSubmitted: (query){
                    lastSubmittedSearch = query;
                    widget.onSearch?.call(query);
                  },
                  onChanged: (String value) {
                    if (_debounce?.isActive ?? false) _debounce?.cancel();
                    _debounce = Timer(const Duration(seconds: secondsToWaitAfterInactivityBeforeSearch), () {
                      if (value != lastSubmittedSearch) {
                        lastSubmittedSearch = value;
                        widget.onSearch?.call(value);
                      }
                    });
                  },
                  suffixIcon: Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: CupertinoColors.systemGrey.withAlpha(lerpDouble(0, 255, t)!.round()),
                    size:  lerpDouble(15, 20.0, t), // Taille de l'icône de suffixe
                  ),
                  onSuffixTap: (){
                    setState((){searchController.text = '';});
                    lastSubmittedSearch = '';
                    widget.onSearch!('');
                  },
                ),
              ),
            ),
        ],
      ),
      leading: Navigator.of(context).canPop()
        ? CupertinoNavigationBarBackButton(
            onPressed: () {
              Navigator.pop(context);
            },
            previousPageTitle: 'Retour',
          )
        : null,
      trailing: widget.trailing,
      alwaysShowMiddle: !showLargeTitle,
      previousPageTitle: widget.previousPageTitle,
      middle: Text(widget.title),
      stretch: true,
      backgroundColor: _isCollapsed
          ? const Color.fromRGBO(250, 250, 250, 0.85)
          : CupertinoColors.white,
      border: _isCollapsed
        ? const Border(
            bottom: BorderSide(
              color: CupertinoColors.separator,
              width: 0.0,
            ),
          )
        : const Border()
    );
  }
}
