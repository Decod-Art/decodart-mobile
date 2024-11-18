import 'package:decodart/controller_and_mixins/widgets/list/_util.dart' show DataFetcher, OnPressList;
import 'package:decodart/controller_and_mixins/widgets/list/controller.dart' show ListController;
import 'package:decodart/controller_and_mixins/widgets/list/mixin.dart' show ListMixin;
import 'package:decodart/model/abstract_item.dart' show AbstractListItem;
import 'package:decodart/widgets/component/button/chevron_button.dart' show ChevronButtonWidget;
import 'package:decodart/widgets/component/image/thumbnail.dart' show ThumbnailWidget;
import 'package:decodart/widgets/list/util/_item_type.dart';
import 'package:flutter/cupertino.dart';

class LazyHorizontalListWithHeader<T extends AbstractListItem> extends StatefulWidget {
  final String name;
  final DataFetcher<T> fetch;
  final OnPressList onPressed;
  final VoidCallback onTitlePressed;
  final void Function(Object, StackTrace)? onError;
  final ItemType Function(T) itemType;
  final List<T> initialValues;
  const LazyHorizontalListWithHeader({
    super.key,
    required this.name,
    required this.fetch,
    required this.onPressed,
    required this.itemType,
    required this.onTitlePressed,
    this.initialValues = const [],
    this.onError
    });
    
      @override
      State<LazyHorizontalListWithHeader<T>> createState() => LazyHorizontalListWithHeaderState<T>();
}

class LazyHorizontalListWithHeaderState<T extends AbstractListItem> extends State<LazyHorizontalListWithHeader<T>> with ListMixin {
  @override
  late ListController<T> controller = ListController<T>(
    widget.fetch,
    initial: widget.initialValues,
    onError: widget.onError
  );

  @override
  void initState() {
    super.initState();
    initMixin();
  }

  @override
  void didUpdateWidget(covariant LazyHorizontalListWithHeader<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fetch != widget.fetch) {
      setState(() {
        controller = ListController<T>(
          widget.fetch,
          initial: widget.initialValues,
          onError: widget.onError
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          checkIfNeedsLoading();
        });
      });
    }
  }

  @override
  void dispose() {
    controller.removeListener(checkIfNeedsLoading);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showContent) ... [
          ChevronButtonWidget(
            text: widget.name,
            fontWeight: FontWeight.w500,
            fontSize: 22,
            chevronColor: CupertinoColors.activeBlue,
            marginRight: 20,
            onPressed: widget.onTitlePressed,
          ),
          SizedBox(
            height: 250, // Ajustez la hauteur selon vos besoins
            child: ListView.builder(
              controller: controller.scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: controller.length + (controller.isLoading?1:0),
              itemBuilder: (context, index) {
                if (index != controller.length){
                  final item = controller[index];
                  return ThumbnailWidget(
                      title: item.title,
                      image: item.image,
                      itemType: widget.itemType(item),
                      onPressed: (){widget.onPressed(item);}
                    );
                } else {
                  return const Center(child: CupertinoActivityIndicator());
                }
              },
            ),
          ),
        ]
    ],
  );
  }
}