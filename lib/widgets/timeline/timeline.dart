import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Artwork {
  final String url;
  final String name;
  final int year;

  Artwork({required this.url, required this.name, required this.year});
}

class ArtworkTimeline extends StatelessWidget {
  final List<Artwork> artworks;
  final int yearMin;
  final int yearMax;
  final double artworkWidth = 120;
  final double artworkHeight = 100;
  final int nbYearPerTicks = 50;
  

  const ArtworkTimeline({super.key,required this.artworks, required this.yearMin, required this.yearMax});

  @override
  Widget build(BuildContext context) {
    double containerWidth = artworkWidth * artworks.length/2;
    const shift = 50.0;
    var nbTicks =((yearMax - yearMin)/nbYearPerTicks).toDouble();
    double tickSize = containerWidth / nbTicks.floor();
    print(nbTicks);
    return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: artworkHeight*2 + 15,
              width: containerWidth + shift + 15,
              child: Column(
                children: [
                  Row(
                    children: [
                      for (int i = 0; i < nbTicks; i++)
                        SizedBox(
                          width: tickSize,
                          child: Text(
                            '${yearMin + i * nbYearPerTicks}',
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        )
                    ]
                  ),
                  Row(
                    children: [
                        for (int i = 0; i < artworks.length; i += 2)
                          SizedBox(
                            width: artworkWidth,
                            height: artworkHeight,
                            child: Center(
                              child: Image.network(
                                artworks[i].url,
                                fit: BoxFit.cover),
                            )
                          )
                              
                      ],
                  ),
                  Row(
                    children: [
                        const SizedBox(width: shift),
                        for (int i = 1; i < artworks.length; i += 2)
                          SizedBox(
                            width: artworkWidth,
                            height: artworkHeight,
                            child: Center(
                              child: Image.network(
                                artworks[i].url,
                                fit: BoxFit.cover),
                            )
                          )
                              
                      ],
                  )
                  
                ]
              )
            )
    );
  }
}
