import 'package:decodart/api/util.dart' show DataFetcher, SearchableDataFetcher;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/widgets/list/horizontal_list_with_header.dart' show AbstractListItemCallback, LazyHorizontalListWithHeader;
import 'package:decodart/widgets/list/lazy_list.dart' show LazyListWidget;
import 'package:decodart/widgets/new/navigation/modal.dart' show showListInModal;
import 'package:decodart/widgets/new/navigation/screen.dart' show navigateToList;
import 'package:flutter/cupertino.dart';

class ContentBlock<T extends AbstractListItem> extends StatelessWidget {
  final String title;
  final SearchableDataFetcher<T> fetch;
  final DataFetcher<T>? secondaryFetch;
  final AbstractListItemCallback onPressed;
  final bool isModal;
  final bool Function(T)? isMuseum;
  final List<T> initialValues;
  const ContentBlock({
    super.key,
    required this.title,
    required this.fetch,
    required this.onPressed,
    this.isModal=false,
    this.secondaryFetch,
    this.isMuseum,
    this.initialValues = const []});


  @override
  Widget build(BuildContext context){
    
    return LazyHorizontalListWithHeader<T>(
      name: title,
      fetch: secondaryFetch??fetch,
      onPressed: onPressed,
      isMuseum: isMuseum??(item)=>false,
      initialValues: initialValues,
      onTitlePressed: (){
        if (isModal) {
          showListInModal(
            context, 
            (context, [controller]) => LazyListWidget(
              fetch: (
                {int limit=10,int offset=0}
              ) => fetch(limit: limit, offset: offset),
              onPress: onPressed,
              controller: controller,
            )
          );
        } else {
          navigateToList(
            context, 
            title: title,
            onPress: onPressed,
            fetch: (
              {int limit=10,int offset=0,String? query}
            ) => fetch(limit: limit, offset: offset, query: query)
          );
        }
      },
    );
  }
}