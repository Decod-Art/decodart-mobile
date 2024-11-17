import 'package:decodart/controller_and_mixins/widgets/list/controller.dart' show AbstractListController;
import 'package:flutter/cupertino.dart' show VoidCallback, WidgetsBinding;

mixin ListMixin {
  AbstractListController get controller;
  void setState(VoidCallback fn);
  bool get mounted;

  void initMixin () {
    controller.addListener(checkIfNeedsLoading);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 250));
      checkIfNeedsLoading();
    });
  }

  bool get showContent => (controller.isNotEmpty || controller.hasMore) && !(controller.failed&&controller.firstTimeLoading);

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
        checkIfNeedsLoading();
      }
    }
  }
}