import 'package:decodart/widgets/component/error/error.dart';
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
  bool _error = false;
  T? item;

  @override
  void initState(){
    super.initState();
    
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _fetch(pause: 250);
    });
  }

  Future<void> _fetch ({int? pause}) async {
    try {
      setState(() {_error = false;});
      final futureItem = widget.fetch();
      if (pause != null) {
        await Future.delayed(Duration(milliseconds: pause));
      }
      item = await futureItem;
    } catch(_, __) {
      _error = true;
    }
    setState((){});
  }

  bool get isLoading => !_error&&item==null;

  bool get hasFailed => _error;

  bool get hasContent => item != null;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return isLoading
      ? Center(
          child: Container(
            width: screenSize.width,
            height: screenSize.height-300,
            color: CupertinoColors.white, // Fond blanc
            child: const CupertinoActivityIndicator(),
            ),
          )
        : hasFailed
            ? ErrorView(onPress: _fetch)
            : widget.builder(item as T);
  }
  
}