import 'package:decodart/api/tour.dart' show fetchTourByMuseum;
import 'package:decodart/model/museum.dart' show Museum;
import 'package:decodart/model/tour.dart' show TourListItem;
import 'package:decodart/widgets/buttons/chevron_button.dart' show ChevronButtonWidget;
import 'package:decodart/widgets/image/thumbnail.dart' show ThumbnailWidget;
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;

class MuseumView extends StatefulWidget {
  final Museum museum;

  const MuseumView({
    super.key,
    required this.museum,
  });

  @override
  State<MuseumView> createState() => _MuseumViewState();
}

class _MuseumViewState extends State<MuseumView> {
  List<TourListItem> tours = [];
  List<TourListItem> exhibition = [];

    @override
  void initState() {
    super.initState();
    fetchToursByMuseum();
  }

  Future<void> fetchToursByMuseum() async {
    exhibition.addAll(await fetchTourByMuseum(widget.museum.uid!));
    for (int i = 0 ;i< 5; i +=1) {
      exhibition.add(exhibition[0]);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                widget.museum.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
              child: Text(
                widget.museum.descriptionText,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              )
            ),
            Center(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  // Action pour le bouton "Voir plus"
                },
                child: const Text(
                  'Voir plus',
                  style: TextStyle(
                    color: CupertinoColors.activeBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CachedNetworkImage(
              imageUrl: widget.museum.image.path,
              width: double.infinity,
              fit: BoxFit.cover),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: 
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      color: CupertinoColors.systemGrey4,
                      onPressed: () {
                        // Action pour le bouton
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'images/icons/square_split_bottomrightquarter.png',
                            width: 24,
                            height: 24,
                            color: CupertinoColors.activeBlue, // Optionnel : pour colorer l'icône
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Plan du musée",
                            style: TextStyle(
                              color: CupertinoColors.activeBlue,
                            ),
                          ),
                        ],
                      ),
                    )
                  )
                ]
              )
            ),
            const SizedBox(height: 15),
            if (widget.museum.hasExhibitions||true) ...[
              const ChevronButtonWidget(
                text: 'Expositions',
                showIcon: false,
                fontWeight: FontWeight.w500,
                fontSize: 22,
                chevronColor: CupertinoColors.activeBlue,
                marginRight: 20,),
                if (exhibition.isEmpty)
                  const Center(
                    child: CupertinoActivityIndicator(),
                  )
                else
                  SizedBox(
                    height: 250, // Ajustez la hauteur selon vos besoins
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: exhibition.length,
                      itemBuilder: (context, index) {
                        final item = exhibition[index];
                        return ThumbnailWidget(
                          title: item.name,
                          image: item.image);
                      },
                    ),
                  ),
            ],
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                widget.museum.descriptionText,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              )
            )
            // Ajoutez d'autres widgets pour afficher les autres propriétés de l'artwork
          ],
        ),
      ) 
    );
  }
}