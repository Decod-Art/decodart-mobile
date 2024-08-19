import 'package:flutter/cupertino.dart';

typedef StringCallback = void Function(String);
const double _kNavBarPersistentHeight = kMinInteractiveDimensionCupertino;

class DecodNavigationBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  // TODO update decodNavigationBar to accept filters, etc.
  final String? title;
  final StringCallback? onTabValueChanged;
  final String? selectedFilter;
  final Map<String, String>? tabs;
  final Color backgroundColor = const Color.fromARGB(200, 0, 0, 0);

  const DecodNavigationBar({super.key, this.selectedFilter, this.tabs, this.onTabValueChanged, this.title});

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      middle: tabs!=null?segmentedControl():(title!=null)?Text(title!, style: const TextStyle(color: CupertinoColors.white)):null, // test if segmented control
      backgroundColor: backgroundColor,
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
    final Color backgroundColor = CupertinoDynamicColor.maybeResolve(this.backgroundColor, context)
                            ?? CupertinoTheme.of(context).barBackgroundColor;
    return backgroundColor.alpha == 0xFF;
  }
}


