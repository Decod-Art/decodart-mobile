import 'package:decodart/widgets/buttons/chevron_button.dart';
import 'package:flutter/cupertino.dart';

class ButtonListWidget extends StatelessWidget {

  final List<ChevronButtonWidget> buttons;

  const ButtonListWidget({
    super.key,
    required this.buttons
  });

  List<Widget> _buildButtonListWithSeparators() {
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
    return buttonListWithSeparators;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: _buildButtonListWithSeparators());
  }
}