import 'package:decodart/api/museum.dart' show fetchMuseumById;
import 'package:decodart/model/museum.dart' show MuseumForeignKey;
import 'package:decodart/view/museum/museum.dart' show MuseumView;
import 'package:decodart/widgets/util/wait_future.dart' show WaitFutureWidget;
import 'package:flutter/cupertino.dart';

class FutureMuseumView extends StatelessWidget {
  final MuseumForeignKey museum;
  final bool useModal;
  const FutureMuseumView({
    super.key,
    required this.museum,
    required this.useModal
  });
  @override
  Widget build(BuildContext context) {
    return WaitFutureWidget(
      fetch: () => fetchMuseumById(museum.uid!),
      builder: (museum) => MuseumView(
        museum: museum,
        useModal: useModal
      )
    );
  }
}
