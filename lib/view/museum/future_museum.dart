import 'package:decodart/api/museum.dart' show fetchMuseumById;
import 'package:decodart/model/museum.dart' show Museum, MuseumListItem;
import 'package:decodart/view/museum/museum.dart' show MuseumView;
import 'package:decodart/widgets/modal_or_fullscreen/page_scaffold.dart';
import 'package:decodart/widgets/new_decod_bar.dart' show NewDecodNavigationBar;
import 'package:flutter/cupertino.dart';

class FutureMuseumView extends StatefulWidget {
  final MuseumListItem museum;
  final bool useModal;
  final bool fullscreen;

  const FutureMuseumView({
    super.key,
    required this.museum,
    this.useModal=true,
    this.fullscreen=false
    });
    
    @override
    State<FutureMuseumView> createState() => _FutureMuseumViewState();

}

class _FutureMuseumViewState extends State<FutureMuseumView> {
  late Future<Museum> museum;

  @override
  void initState(){
    super.initState();
    museum = fetchMuseumById(widget.museum.uid!);
  }

  Widget _container({required Widget child}){
    if (!widget.fullscreen){
      return child;
    }
    return DecodPageScaffold(
      title: widget.museum.name,
      children: [
        child
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return _container(
      child: FutureBuilder<Museum>(
        future: museum,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CupertinoActivityIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur : ${snapshot.error}',
                style: const TextStyle(color: CupertinoColors.systemRed),
              ),
            );
          } else if (snapshot.hasData) {
            final museum = snapshot.data!;
            return MuseumView(museum: museum, useModal: widget.useModal,);
          } else {
            return const Center(
              child: Text('Aucune donnée disponible'),
            );
          }
        },
      )
    );
  }
}