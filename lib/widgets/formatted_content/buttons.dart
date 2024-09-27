import 'package:decodart/widgets/formatted_content/content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

class ArtworkButton extends StatelessWidget {
  final ArtworkButtonContent content;
  final VoidCallback onTap;

  const ArtworkButton({
    super.key,
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 250,
        child: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: NetworkImage(content.image.path),
                  fit: BoxFit.cover,
                  alignment: FractionalOffset.center,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Stack(
                  children: [
                    // Dégradé sombre en bas
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    content.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    content.subtitle,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
                          CupertinoIcons.info_circle_fill,
                          color: Colors.white,
                          size: 18
                        ),
                      ),)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}