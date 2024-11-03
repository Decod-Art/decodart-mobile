import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/view/list/lazy_list.dart';
import 'package:decodart/widgets/modal_or_fullscreen/page_scaffold.dart' show DecodPageScaffold;
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' show showCupertinoModalBottomSheet;

typedef WidgetBuilder = Widget Function(BuildContext);
typedef WidgetListBuilder = Widget Function(BuildContext, [ScrollController?]);

void _waitForKeyboardToClose() {
  final focusNode = FocusManager.instance.primaryFocus;
  if (focusNode != null) {
    focusNode.unfocus();
    //await Future.delayed(const Duration(milliseconds: 100)); // Attendre 300ms pour que le clavier se ferme
  }
}

// TODO add navigate to customList
Future<T?> navigateToList<T, C extends AbstractListItem>(
  BuildContext context,
  {
    required String title,
    required OnPressList<C> onPress,
    hideSearch=false,
    required SearchableFetch<C> fetch
  }) async {
    _waitForKeyboardToClose();
    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => SliverLazyListView<C>(
          title: title,
          fetch: fetch,
          smallTitle: hideSearch,
          onPress: onPress,),
      ),
    );
}

Future<T?> navigateToWidget<T>(
  BuildContext context,
  WidgetBuilder builder,
  {
    String? title,
    void Function(String)? onSearch,
    bool smallTitle=false
  }) async {
  _waitForKeyboardToClose();
  return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ModalOrFullScreen(
          inModal: false,
          title: title,
          smallTitle: smallTitle,
          onSearch: onSearch,
          builder: builder
        )
      )
    );
}

Future<T?> showListInModal<T>(BuildContext context, WidgetListBuilder builder) {
  return showCupertinoModalBottomSheet(
    context: context,
    builder: (context) => ModalWithList(
      inModal: true,
      builder: builder,
    ),
    expand: true,
    useRootNavigator: true,
    enableDrag: true
  );
}

Future<T?> showModal<T>(BuildContext context, WidgetBuilder builder) {
  return showCupertinoModalBottomSheet(
    context: context,
    builder: (context) => ModalOrFullScreen(
      inModal: true,
      builder: builder,
    ),
    expand: true,
    useRootNavigator: true,
    enableDrag: true
  );
}

abstract class _ModalOrFullscreen extends StatefulWidget {
  final bool inModal;
  final String? title;
  final void Function(String)? onSearch;
  Function get builder;
  

  const _ModalOrFullscreen({
    super.key,
    required this.inModal,
    this.title,
    this.onSearch
  });

  

  @override
  State<_ModalOrFullscreen> createState() => _ModalOrFullscreenState();

}

class ModalWithList extends _ModalOrFullscreen {
  @override
  final WidgetListBuilder builder;
  const ModalWithList({
    super.key,
    required super.inModal,
    required this.builder
  });
}

class ModalOrFullScreen extends _ModalOrFullscreen {
  @override
  final WidgetBuilder builder;
  final bool smallTitle;

  const ModalOrFullScreen({
    super.key,
    required super.inModal,
    super.title,
    super.onSearch,
    required this.builder,
    this.smallTitle=false
  });
}




class _ModalOrFullscreenState extends State<_ModalOrFullscreen> {
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

  Widget _fullScreenView(BuildContext context) {
    return DecodPageScaffold(
      title: widget.title,
      smallTitle: (widget as ModalOrFullScreen).smallTitle,
      onSearch: widget.onSearch,
      children: [
        widget.builder(context)
      ]
    );
  }

  Widget _modalView(BuildContext context){
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
                  child: widget.builder(context)
                )
            )
            
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
        color: CupertinoTheme.of(context).brightness == Brightness.light ? CupertinoColors.white : CupertinoColors.black,
        child: SafeArea(
          child: widget.inModal
            ? _modalView(context)
            : _fullScreenView(context),
        ),
      ),
    );
  }
}
