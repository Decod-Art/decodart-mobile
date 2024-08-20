import 'package:flutter/cupertino.dart';

typedef StringCallback = void Function(String);
const double _kNavBarPersistentHeight = kMinInteractiveDimensionCupertino;

class NewDecodNavigationBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  // TODO update decodNavigationBar to accept filters, etc.
  final String? title;
  final StringCallback? onTabValueChanged;
  final String? selectedFilter;
  final Map<String, String>? tabs;

  const NewDecodNavigationBar({super.key, this.selectedFilter, this.tabs, this.onTabValueChanged, this.title});

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      middle: title!=null?Text(title!):null,
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          // Ajoutez ici l'action que vous souhaitez effectuer lorsque l'icône est pressée.
        },
        child: const Icon(
          CupertinoIcons.person_circle,
          color: CupertinoColors.activeBlue,
        ),
      ),
    );
  }

  Widget segmentedControl() {
    return CupertinoSegmentedControl<String>(
        children: tabs!.map((key, value) {
          // Créez un nouveau widget pour chaque paire clé/valeur.
          // Ici, `value` est transformé en fonction de vos besoins spécifiques.
          return MapEntry(
            key,
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 5),
              child: Text(value, style: const TextStyle(fontSize: 12)),
          ));
        }),
        onValueChanged: (String value) {
          onTabValueChanged!(value);
        },
        groupValue: selectedFilter,
        selectedColor: CupertinoColors.white, // Couleur active définie sur blanc
        unselectedColor: CupertinoColors.black, // Couleur non sélectionnée définie sur noir
        borderColor: CupertinoColors.white, 
      );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(_kNavBarPersistentHeight);
  
  @override
  bool shouldFullyObstruct(BuildContext context) {
    final Color backgroundColor = CupertinoTheme.of(context).barBackgroundColor;
    return backgroundColor.alpha == 0xFF;
  }
}


