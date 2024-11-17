import 'package:decodart/controller_and_mixins/widgets/list/_util.dart' show OnPressList, SearchableFetch;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/widgets/list/sliver_lazy_list.dart' show SliverLazyListView;
import 'package:decodart/widgets/scaffold/decod_scaffold.dart';

import 'package:flutter/cupertino.dart';

void _waitForKeyboardToClose() {
  final focusNode = FocusManager.instance.primaryFocus;
  if (focusNode != null) {
    focusNode.unfocus();
  }
}

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
        builder: (context) => DecodPageScaffold(
          title: title,
          smallTitle: smallTitle,
          onSearch: onSearch,
          children: [
            builder(context)
          ],
        )
      )
    );
}
