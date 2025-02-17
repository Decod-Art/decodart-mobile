import 'package:flutter/cupertino.dart';

typedef WidgetBuilder = Widget Function(BuildContext);
typedef WidgetListBuilder = Widget Function(BuildContext, [ScrollController?]);


Future<T?> showListInModal<T>(BuildContext context, WidgetListBuilder builder) {
  return showCupertinoSheet(
    context: context,
    pageBuilder: (context) => ModalListView(
      builder: builder,
    ),
  );
}

Future<T?> showWidgetInModal<T>(BuildContext context, WidgetBuilder builder) {
  return showCupertinoSheet(
    context: context,
    pageBuilder: (context) => ModalWidgetView(
      builder: builder,
    ),
  );
}


abstract class ModalView extends StatefulWidget {
  Function get builder;
  const ModalView({
    super.key
  });

  @override
  State<ModalView> createState() => _ModalState();
}

class ModalListView extends ModalView {
  @override
  final WidgetListBuilder builder;
  const ModalListView({super.key, required this.builder});

}

class ModalWidgetView extends ModalView {
  @override
  final WidgetBuilder builder;
  const ModalWidgetView({super.key, required this.builder});
  
}


class _ModalState extends State<ModalView> {
  bool _showTopLine = false;
  final ScrollController _scrollController = ScrollController();

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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        color: CupertinoTheme.of(context).brightness == Brightness.light 
          ? CupertinoColors.white 
          : CupertinoColors.black,
        child: SafeArea(
          bottom: true,
          top: false,
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
                  if (_showTopLine)
                    Container(
                      height: 1,
                      color: CupertinoColors.lightBackgroundGray,
                    ),
                  Expanded(
                    child: widget.builder is WidgetListBuilder
                      ? widget.builder(
                          context,
                          _scrollController,
                        )
                      : SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            widget.builder(context),
                            const SizedBox(height: 25)
                          ]
                        )
                      )
                  ),
                  
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}
