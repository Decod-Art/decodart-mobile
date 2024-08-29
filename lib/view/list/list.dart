import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/view/apropos/apropos.dart' show AproposView;
import 'package:decodart/widgets/list/list_with_thumbnail.dart' show ListWithThumbnail;
import 'package:flutter/cupertino.dart';

class SliverListViewPage<T extends AbstractListItem> extends StatelessWidget {
  final String title;
  final List<T> items;
  final void Function(T) onPress;
  const SliverListViewPage({
    super.key,
    required this.title,
    required this.items,
    required this.onPress
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Padding(
              padding: const EdgeInsets.only(right: 25, left: 5),
              child: CupertinoSearchTextField(
                placeholder: 'Rechercher',
                onChanged: (String value) {
                  // Action à effectuer lors de la saisie dans le champ de recherche
                },
              ),
            ),
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
            middle: const Text('Explorer')
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [ 
                  ListWithThumbnail(
                    items: items,
                    onPress: onPress,)
                ]
              )
            )
          )
        ]
      ),
    );
  }
}
