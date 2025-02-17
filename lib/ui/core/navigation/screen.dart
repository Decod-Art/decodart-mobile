import 'package:decodart/ui/core/list/util/_util.dart' show OnPressList, SearchableDataFetcher;
import 'package:decodart/data/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/ui/core/list/widgets/sliver_lazy_list.dart' show SliverLazyListView;
import 'package:decodart/ui/core/scaffold/decod_scaffold.dart';

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
    required SearchableDataFetcher<C> fetch
  }) async {
    _waitForKeyboardToClose();
    return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => SliverLazyListView<C>(
          title: title,
          fetch: fetch,
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
    bool smallTitle=true,
    double? threshold
  }) async {
  _waitForKeyboardToClose();
  return Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => DecodPageScaffold(
          title: title,
          smallTitle: smallTitle,
          onSearch: onSearch,
          threshold: threshold,
          children: [
            builder(context)
          ],
        )
      )
    );
}
