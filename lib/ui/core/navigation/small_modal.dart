import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' show showCupertinoModalBottomSheet;

Future<T?> showSmallModal<T>(BuildContext context, WidgetBuilder builder) {
  return showCupertinoModalBottomSheet(
    context: context,
    builder: (context) => _ModalContentWidget(
      content: builder(context),
    ),
    expand: false,
    useRootNavigator: false,
    enableDrag: true
  );
}

class _ModalContentWidget extends StatelessWidget {
  final Widget content;
  
  const _ModalContentWidget({
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                )
              ),
              const SizedBox(height: 35),
              content,
            ]
          ),
          Positioned(
            top: 15,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: CupertinoColors.lightBackgroundGray, // Fond plus clair
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.clear_thick,
                  size: 17,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}