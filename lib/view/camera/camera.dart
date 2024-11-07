import 'package:decodart/view/camera/util/camera/camera.dart' show Camera;
import 'package:decodart/widgets/navigation/modal.dart' show showWidgetInModal;
import 'package:decodart/widgets/scaffold/decod_scaffold.dart' show DecodPageScaffold;
import 'package:decodart/view/camera/util/help.dart' show HelpView;
import 'package:decodart/view/camera/util/recent.dart' show RecentScan;
import 'package:flutter/cupertino.dart';


class CameraView extends StatelessWidget {
  const CameraView({super.key});
  @override
  Widget build(BuildContext context) {    
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 4 / 7;

    return DecodPageScaffold(
      title: "Scanner",
      smallTitle: true,
      leadingBar: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          showWidgetInModal(
            context,
            (context) => const HelpView()
          );
        },
        child: const Icon(CupertinoIcons.info_circle, size: 24),
      ),
      children: [
        Camera(
          height: containerHeight
        ),
        const RecentScan()
      ],
    );
  }
}