import 'package:decodart/view/apropos/apropos.dart' show AproposView;
import 'package:flutter/cupertino.dart';

class SliverDecodNavigationBar extends StatefulWidget {
  final String? title;
  final void Function(String)? onSearch;
  final bool showBorder;
  final bool showTrailing;
  const SliverDecodNavigationBar({
    super.key,
    this.onSearch,
    required this.title,
    this.showBorder=false,
    this.showTrailing=true});

  @override
  State<SliverDecodNavigationBar> createState() => _SliverDecodNavigationBarState();
}

class _SliverDecodNavigationBarState extends State<SliverDecodNavigationBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
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
      trailing: widget.showTrailing 
        ? CupertinoButton(
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
          )
        : null,
      middle: widget.onSearch!=null 
        ? Text(widget.title??"")
        : const Text(''),
      border: widget.showBorder
        ? const Border(
            bottom: BorderSide(
              color: CupertinoColors.separator,
              width: 0.0,
            ),
          )
        : const Border(),
      backgroundColor: widget.showBorder
        ? CupertinoColors.systemBackground.withOpacity(0.85)
        : CupertinoColors.white,
    );
  }
}