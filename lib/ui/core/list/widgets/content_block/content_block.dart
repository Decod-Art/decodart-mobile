import 'package:decodart/ui/core/list/util/_util.dart' show DataFetcher, OnPressList, SearchableDataFetcher;
import 'package:decodart/data/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/ui/core/list/widgets/content_block/horizontal_list_with_header.dart' show LazyHorizontalListWithHeader;
import 'package:decodart/ui/core/list/widgets/lazy_list.dart' show LazyListWidget;
import 'package:decodart/ui/core/list/widgets/components/item_type.dart' show defaultItemTypeFct, ItemType;
import 'package:decodart/ui/core/navigation/modal.dart' show showListInModal;
import 'package:decodart/ui/core/navigation/screen.dart' show navigateToList;
import 'package:flutter/cupertino.dart';


class ContentBlock<T extends AbstractListItem> extends StatelessWidget {
  final String title;
  final SearchableDataFetcher<T> fetch;
  // Fetch is used in the sub-lists when opening up the modal or the widget
  // secondary fetch is used in the current block.. if not set, fetch is used instead.
  // The interest of secondaryFetch is to permet explore widget to search simultaneously in all blocks
  final DataFetcher<T>? secondaryFetch;
  final OnPressList onPressed;
  final bool isModal;
  // itemType returns an element from the enumeration to show
  // the correct icon on the image
  final ItemType Function(T) itemType;
  // initialValues prefill the list with the correct values
  final List<T> initialValues;
  // Error when fetching new data for the list
  final void Function(Object, StackTrace)? onError;

  // Wait some time (ms) before starting the loading
  final bool loadingDelay;
  const ContentBlock({
    super.key,
    required this.title,
    required this.fetch,
    required this.onPressed,
    this.isModal=false,
    this.secondaryFetch,
    this.itemType=defaultItemTypeFct,
    this.initialValues = const [],
    this.onError,
    this.loadingDelay=false});

  @override
  Widget build(BuildContext context){
    return LazyHorizontalListWithHeader<T>(
      name: title,
      fetch: secondaryFetch??fetch,
      onPressed: onPressed,
      itemType: itemType,
      initialValues: initialValues,
      onError: onError,
      loadingDelay: loadingDelay,
      onTitlePressed: (){
        if (isModal) {
          showListInModal(
            context, (context, [controller]) => LazyListWidget(fetch: fetch, onPress: onPressed, controller: controller))
          ;
        } else {
          navigateToList(context, title: title, onPress: onPressed, fetch: fetch);
        }
      },
    );
  }
}