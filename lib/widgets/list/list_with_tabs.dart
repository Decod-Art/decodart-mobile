import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/widgets/list/tile.dart' show TileWidget, ListNavigation;
import 'package:decodart/widgets/decod_bar.dart' show DecodNavigationBar;


typedef ConditionalNavigator = ListNavigation Function(AbstractListItem);
typedef ConditionalWidget = Widget Function() Function(AbstractListItem);

class TabListWidget extends StatefulWidget {
  final Future<List<List<AbstractListItem>>> content;
  final Map<String, String> tabs;
  final ConditionalWidget onClickWidget;
  final ConditionalNavigator onClickNavigator;

  const TabListWidget({
    super.key,
    required this.content,
    required this.tabs,
    required this.onClickWidget,
    required this.onClickNavigator
    });
  @override
  State<TabListWidget> createState() => _TabListWidgetState();
}

class _TabListWidgetState extends State<TabListWidget> {
  late String _selectedFilter;
  late List<String> _tabNames;
  late Future<List<List<AbstractListItem>>> content;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.tabs.keys.first;
    _tabNames = widget.tabs.keys.toList();
    content = widget.content;

  }

  @override
  Widget build(BuildContext context) {
    int idx = _tabNames.indexOf(_selectedFilter);
    return CupertinoPageScaffold(
      navigationBar: DecodNavigationBar(
        onTabValueChanged: (String value) {
          setState(() {
            _selectedFilter = value;
          });
        },
        selectedFilter: _selectedFilter,
        tabs: widget.tabs,
      ),
      child: FutureBuilder<List<List<AbstractListItem>>>(
        future: content, // Le Future que FutureBuilder surveille
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Les données ne sont pas encore disponibles, afficher un loader
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Une erreur s'est produite lors de la récupération des données
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            // Les données sont disponibles, construire le ListView
            return ListView.builder(
              itemCount: snapshot.data![idx].length,
              itemBuilder: (context, index) {
                return TileWidget(
                  title: snapshot.data![idx][index].title,
                  subtitle: snapshot.data![idx][index].subtitle,
                  backgroundImageUrl: snapshot.data![idx][index].image.path,
                  view: widget.onClickWidget(snapshot.data![idx][index]),
                  navigator: widget.onClickNavigator(snapshot.data![idx][index])
                );
              },
            );
          }
        }
      )
    ); 
  }
}