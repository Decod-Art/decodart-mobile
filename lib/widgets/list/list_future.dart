import 'package:decodart/widgets/list/list.dart' show ListWidget;
import 'package:decodart/widgets/list/tile.dart' show ListNavigation;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/widgets/decod_bar.dart' show DecodNavigationBar;

// Étape 1: Définir le StatefulWidget
class ListFutureWidget<T extends Widget> extends StatefulWidget {
  final String listName;
  final Future<List<AbstractListItem>> listContent;
  final T Function(AbstractListItem) onClick;
  final ListNavigation navigator;
  

  const ListFutureWidget({
    super.key,
    required this.listName,
    required this.listContent,
    required this.onClick,
    this.navigator=ListNavigation.tabNavigator});

  @override
  State<ListFutureWidget> createState() => _ListFutureWidgetState();
}

// Étape 2: Créer la classe State
class _ListFutureWidgetState extends State<ListFutureWidget> {
  @override
  Widget build(BuildContext context) {
    // Étape 4: Construire l'interface utilisateur
    return CupertinoPageScaffold(
      navigationBar: DecodNavigationBar(
        title: widget.listName
      ),
      child: FutureBuilder<List<AbstractListItem>>(
        future: widget.listContent, // Le Future que FutureBuilder surveille
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Les données ne sont pas encore disponibles, afficher un loader
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Une erreur s'est produite lors de la récupération des données
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            return ListWidget(
              listName: widget.listName,
              listContent: snapshot.data!,
              onClick: widget.onClick,
              navigator: widget.navigator,
              navigationBar: false,
            );
          }
        }
      )
    ); 
  }
}
