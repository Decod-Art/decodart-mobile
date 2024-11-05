import 'package:smooth_page_indicator/smooth_page_indicator.dart' show SmoothPageIndicator, WormEffect;
import 'package:flutter/cupertino.dart';

class PageIndicator extends StatelessWidget {
  final int length;
  final PageController controller;
  const PageIndicator({super.key, required this.length, required this.controller});
  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        if (length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SmoothPageIndicator(
              controller: controller,
              count: length,
              effect: const WormEffect(
                dotHeight: 8.0,
                dotWidth: 8.0,
                activeDotColor: CupertinoColors.systemBlue,
                dotColor: CupertinoColors.systemGrey4,
              ),
            ),
          ),
      ],
    );
  }
}