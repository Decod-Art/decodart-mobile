import 'package:decodart/controller_and_mixins/widgets/list/controller.dart' show AbstractListController;
import 'package:flutter/cupertino.dart' show VoidCallback, WidgetsBinding;

// The mixin is required to handle lazy lists
// because it accesses "setState" as well as "mounted"
// to refresh the widget when required

// The list mixin handles the work with the controller.

// the user must handle all the creation update work with the controller
mixin ListMixin {
  // The list controller actually manages the condition, etc. over the scroll controller
  // to query the API
  AbstractListController get controller;
  void setState(VoidCallback fn);
  bool get mounted;

  void initOrUpdateListMixin () {
    controller.addListener(checkIfNeedsLoading);
    updateView(250);
  }

  void updateView([int? duration]) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (duration != null){
        await Future.delayed(Duration(milliseconds: duration));
      }
      checkIfNeedsLoading();
    });
  }

  bool get showContent => (controller.isNotEmpty || controller.hasMore) && (!controller.failed||controller.firstTimeLoading);

  Future<void> checkIfNeedsLoading() async {
    if (controller.shouldReload) {
      loadMoreItems();
    }
  }

  Future<void> loadMoreItems() async {
    setState(() {
      controller.resetLoading();
    });   
    await controller.fetchMore();
    if (mounted){
      setState(() {});
      if (!controller.failed) {
        updateView();
      }
    }
  }
}