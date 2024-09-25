import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' show showCupertinoModalBottomSheet;

mixin ShowModal {
    Future<T?> showDecodModalBottomSheet<T>(
    BuildContext context,
    WidgetBuilder builder,
    {
      useRootNavigator=false,
      expand=false,
      scroll=true
    }) {
    return showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => ModalContentWidget(
        content: builder(context),
        safeArea: !useRootNavigator,
        withScroll: expand&&scroll,
      ),
      expand: expand,
      useRootNavigator: useRootNavigator,
      enableDrag: true
    );
  }
}


class ModalContentWidget extends StatefulWidget {
  final Widget content;
  final bool safeArea;
  final bool withScroll;
  
  const ModalContentWidget({
    super.key,
    required this.content,
    this.safeArea=false,
    this.withScroll=false
  });

  @override
  State<ModalContentWidget> createState() => _ModalContentWidgetState();

}

class _ModalContentWidgetState extends State<ModalContentWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _showTopLine = false;
  bool _canScroll = true;
  final events = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels > 0) {
      if (!_showTopLine) {
        setState(() {
          _showTopLine = true;
        });
      }
    } else {
      if (_showTopLine) {
        setState(() {
          _showTopLine = false;
        });
      }
    }
  }

  Widget _scrollableContent(BuildContext context) {
    return PrimaryScrollController(
      controller: ScrollController(),
        child: Expanded(
          child: Column(
            children: [
              if (_showTopLine)
                Container(
                  height: 1,
                  color: CupertinoColors.lightBackgroundGray,
                ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: _canScroll
                    ? const ScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                  child: Listener(
                    onPointerDown: (event) {
                      events.add(event.pointer);
                    },
                    onPointerUp: (event) {
                      events.clear();
                      setState(() {
                        _canScroll = true;
                      });
                    },
                    onPointerMove: (event) {
                      if (events.length >= 2) {                        
                        setState(() {
                          _canScroll = false;
                        });
                      }
                    },
                    child: widget.content
                  )
                )
              )
            ]
          )
        )
    );
  }

  Widget _modalContent(BuildContext context) {
    return Stack(
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
            if (widget.withScroll)
              _scrollableContent(context)
            else
              widget.content,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.safeArea) {
      return SafeArea(child: _modalContent(context));
    }
    return _modalContent(context);
  }
}