import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/widgets/buttons/chevron_button.dart' show ChevronButtonWidget;
import 'package:decodart/widgets/image/thumbnail.dart' show ThumbnailWidget;
import 'package:flutter/cupertino.dart';

class SetBlock extends StatelessWidget {
  final String name;
  final List<AbstractListItem> items;
  final AbstractListItemCallback onPressed;
  final VoidCallback onTitlePressed;
  final bool Function(AbstractListItem) isMuseum;
  const SetBlock({
    super.key,
    required this.name,
    required this.items,
    required this.onPressed,
    required this.isMuseum,
    required this.onTitlePressed
    });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChevronButtonWidget(
          text: name,
          fontWeight: FontWeight.w500,
          fontSize: 22,
          chevronColor: CupertinoColors.activeBlue,
          marginRight: 20,
          onPressed: onTitlePressed,),
          if (items.isEmpty)
            const Center(
              child: CupertinoActivityIndicator(),
            )
          else
            SizedBox(
              height: 250, // Ajustez la hauteur selon vos besoins
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ThumbnailWidget(
                    title: item.title,
                    image: item.image,
                    isMuseum: isMuseum(item),
                    onPressed: (){onPressed(item);}
                  );
                },
              ),
            )]
    );
  }
}

typedef AbstractListItemCallback = void Function(AbstractListItem);