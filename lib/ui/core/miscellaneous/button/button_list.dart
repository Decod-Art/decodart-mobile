import 'package:decodart/ui/core/miscellaneous/button/chevron_button.dart';
import 'package:flutter/cupertino.dart';

class ButtonListWidget extends StatelessWidget {

  final List<ChevronButtonWidget> buttons;

  const ButtonListWidget({
    super.key,
    required this.buttons
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> buttonListWithSeparators = [];
    for (int i = 0; i < buttons.length; i++) {
      buttonListWithSeparators.add(buttons[i]);
      if (i < buttons.length - 1) {
        buttonListWithSeparators.add(
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Container(
              width: double.infinity,
              height: 1,
              color: CupertinoColors.systemGrey4,
            ),
          ),
        );
      }
    }

    return Column(children: buttonListWithSeparators);
  }
}