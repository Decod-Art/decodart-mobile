import 'package:decodart/ui/camera/widgets/components/camera/camera.dart' show Camera;
import 'package:decodart/ui/core/navigation/modal.dart' show showWidgetInModal;
import 'package:decodart/ui/core/scaffold/decod_scaffold.dart' show DecodPageScaffold;
import 'package:decodart/ui/camera/widgets/components/help.dart' show HelpView;
import 'package:decodart/ui/camera/widgets/components/recent.dart' show RecentScan;
import 'package:flutter/cupertino.dart';


/// A widget that displays a camera view for scanning and recent scans.
/// 
/// The `CameraView` is a stateless widget that provides a camera interface for scanning and displays recent scans.
/// It also includes a help button that shows a modal with help information.
/// 
/// Attributes:
/// 
/// - `key` (optional): A [Key] to uniquely identify the widget.
class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {    
    final double screenHeight = MediaQuery.of(context).size.height;
    final double containerHeight = screenHeight * 4 / 7;
    return DecodPageScaffold(
      title: "Scanner",
      smallTitle: true,
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => showWidgetInModal(context, (context) => const HelpView()),
        child: const Icon(CupertinoIcons.info_circle, size: 24),
      ),
      children: [
        Camera(height: containerHeight),
        const RecentScan()
      ],
    );
  }
}