import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

class WaitFutureWidget<T> extends StatefulWidget {
  final Future<T> Function() fetch;
  final Widget Function(T) builder;
  const WaitFutureWidget({
    super.key,
    required this.fetch,
    required this.builder
  });
  
  @override
  State<WaitFutureWidget<T>> createState() => _WaitFutureWidget<T>();
  
}

class _WaitFutureWidget<T> extends State<WaitFutureWidget<T>> {
  T? item;

  @override
  void initState(){
    super.initState();
    
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final futureItem = widget.fetch();
      await Future.delayed(const Duration(milliseconds: 250));
      item = await futureItem;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return item==null
      ? Center(
          child: Container(
            width: screenSize.width,
            height: screenSize.height,
            color: CupertinoColors.white, // Fond blanc
            child: const CupertinoActivityIndicator(),
            ),
          )
        : widget.builder(item as T);
  }
  
}