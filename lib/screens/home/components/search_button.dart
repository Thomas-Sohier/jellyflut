import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/providers/search/search_provider.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/screens/home/components/search/search_field.dart';
import 'package:jellyflut/screens/home/components/search/search_icon.dart';
import 'package:jellyflut/screens/home/components/search/search_result.dart';
import 'package:jellyflut/shared/utils/color_util.dart';

class SearchButton extends StatefulWidget {
  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  late Color fieldColor;
  late SearchProvider searchProvider;
  late TextEditingController textEditingController;
  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  void initState() {
    searchProvider = SearchProvider();
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    fieldColor =
        ColorUtil.darken(Theme.of(context).colorScheme.background, 0.05);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
        transitionType: _transitionType,
        openColor: Theme.of(context).colorScheme.background,
        middleColor: Theme.of(context).colorScheme.background,
        closedColor: Theme.of(context).colorScheme.background,
        openBuilder: (BuildContext _, VoidCallback openContainer) =>
            fullscreenSearch(),
        tappable: true,
        closedShape: const RoundedRectangleBorder(),
        closedElevation: 0.0,
        closedBuilder: (BuildContext _, VoidCallback openContainer) =>
            fieldClosed(openContainer));
  }

  Widget fieldClosed(VoidCallback openContainer) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: OutlinedButtonSelector(
        onPressed: openContainer,
        child: ExcludeFocus(
            excluding: true,
            child: IgnorePointer(
                ignoring: true,
                child: SearchField(
                  fieldColor: fieldColor,
                  constraints: BoxConstraints(maxWidth: 300),
                  icon: const Icon(Icons.search),
                  padding: EdgeInsets.only(left: 24, top: 8),
                  textEditingController: textEditingController,
                ))),
      ),
    );
  }

  Widget fullscreenSearch() {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: fieldColor,
            leading: const SizedBox(),
            actions: [
              BackButton(color: Theme.of(context).colorScheme.onBackground),
              Flexible(
                  child: SearchField(
                      textEditingController: textEditingController)),
              SearchIcon(textEditingController: textEditingController)
            ]),
        body: SearchResult());
  }
}
