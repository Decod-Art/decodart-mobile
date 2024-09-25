import 'package:decodart/view/apropos/apropos.dart' show AproposView;
import 'package:flutter/cupertino.dart';

class DecodPageScaffold extends StatelessWidget {
  final List<Widget>? children;
  final NullableIndexedWidgetBuilder? builder;
  final int? childCount;
  final String? title;
  final bool smallTitle;
  final void Function(String)? onSearch;
  final ScrollController? controller;
  final Widget? leadingBar;
  const DecodPageScaffold({
    super.key,
    this.children,
    this.builder,
    this.childCount,
    required this.title,
    this.onSearch,
    this.controller,
    this.smallTitle=false,
    this.leadingBar});
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: (title==null&&onSearch==null)||smallTitle
        ? CupertinoNavigationBar(
            leading: leadingBar?? (Navigator.of(context).canPop()
                  ? CupertinoNavigationBarBackButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      previousPageTitle: 'Retour',
                    )
                  : null),
            middle: title != null ? Text(title!) : null,
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const AproposView()),
                );
              },

              child: const Icon(
                CupertinoIcons.person_circle,
                color: CupertinoColors.activeBlue,
                size: 24
              ),
            ),
        )
        : null,
      child: SafeArea(
        child: CustomScrollView(
          controller: controller,
          slivers: [
            if ((title != null || onSearch != null)&&!smallTitle)
              CupertinoSliverNavigationBar(
                leading: Navigator.of(context).canPop()
                  ? CupertinoNavigationBarBackButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      previousPageTitle: 'Retour',
                    )
                  : null,
                largeTitle: onSearch!=null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 25, left: 5),
                      child: CupertinoSearchTextField(
                        placeholder: 'Rechercher',
                        onChanged: onSearch,
                      ),
                    )
                  : Text(title??""),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const AproposView()),
                    );
                  },
                  child: const Icon(
                    CupertinoIcons.person_circle,
                    color: CupertinoColors.activeBlue,
                    size: 24
                  ),
                ),
                middle: onSearch!=null 
                  ? Text(title??"")
                  : const Text('')
              ),
            SliverSafeArea(
              top: false,
              sliver: SliverList(
                delegate: children!=null
                  ? SliverChildListDelegate(
                      children!
                    )
                  : SliverChildBuilderDelegate(
                      builder!,
                      childCount: childCount!
                    )
              ),
            )
          ],
        ),
      )
    );
  }
}