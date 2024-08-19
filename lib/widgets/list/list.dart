import 'package:flutter/material.dart' show Colors;
import 'package:flutter/cupertino.dart';

import 'package:decodart/widgets/decod_bar.dart' show DecodNavigationBar;
import 'package:decodart/widgets/list/tile.dart' show TileWidget, ListNavigation;

import 'package:decodart/model/abstract_item.dart' show AbstractListItem;

// Étape 1: Définir le StatefulWidget
class ListWidget<T extends Widget> extends StatefulWidget {
  final String listName;
  final List<AbstractListItem> listContent;
  final T Function(AbstractListItem) onClick;
  final ListNavigation navigator;
  final bool navigationBar;
  

  const ListWidget({
    super.key,
    required this.listName,
    required this.listContent,
    required this.onClick,
    this.navigator=ListNavigation.tabNavigator,
    this.navigationBar=true});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

// Étape 2: Créer la classe State
class _ListWidgetState extends State<ListWidget> {

  Widget _list(BuildContext context){
    return ListView.builder(
      itemCount: widget.listContent.length,
      itemBuilder: (context, index) {
        return TileWidget(
          title: widget.listContent[index].title,
          subtitle: widget.listContent[index].subtitle,
          backgroundImageUrl: widget.listContent[index].image.path,
          view: () => widget.onClick(widget.listContent[index]),
          navigator: widget.navigator);
      },
    );
  }

  
  @override
  Widget build(BuildContext context) {
    if (widget.navigationBar) {
      return CupertinoPageScaffold(
        backgroundColor: Colors.black,
        navigationBar: DecodNavigationBar(
          title: widget.listName
        ),
        child: _list(context)
      );
    } else {
      return _list(context);
    }
    
  }
}
