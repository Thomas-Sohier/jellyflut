import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/book/bloc/book_bloc.dart';
import 'package:jellyflut/screens/book/components/setting_buton.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import 'components/book_placeholder.dart';
import 'components/page_counter_parent.dart';

class LargeBookView extends StatefulWidget {
  final Item item;
  final BookBloc bookBloc;
  final Function(int currentPage, int nbPage) listener;
  final Stream<Map<int, int>> streamPosition;
  final PageController pageController;
  const LargeBookView(
      {super.key,
      required this.item,
      required this.bookBloc,
      required this.pageController,
      required this.streamPosition,
      required this.listener});

  @override
  State<LargeBookView> createState() => _LargeBookViewState();
}

class _LargeBookViewState extends State<LargeBookView> {
  late final Item item;
  late final BookBloc bookBloc;
  late final Function(int, int) listener;
  late final PageController pageController;
  late final Stream<Map<int, int>> streamPosition;
  late final ScrollController scrollController;

  @override
  void initState() {
    item = widget.item;
    bookBloc = widget.bookBloc;
    listener = widget.listener;
    pageController = widget.pageController;
    streamPosition = widget.streamPosition;
    scrollController = ScrollController();
    streamPosition.first.then((value) => pageController.jumpToPage(value.keys.first));
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(item.name ?? '', style: Theme.of(context).textTheme.headlineSmall),
          actions: [SettingButton()],
        ),
        extendBodyBehindAppBar: false,
        extendBody: false,
        backgroundColor: Colors.black,
        body: SizedBox(
          height: double.maxFinite,
          child: Row(children: [
            Container(
              color: ColorUtil.lighten(Theme.of(context).colorScheme.background, 0.1),
              width: 200,
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    width: 300,
                    child: PageCounterParent(controller: pageController, streamPage: streamPosition, clickable: false),
                  ),
                  Expanded(child: pageButtonsBuilder())
                ],
              ),
            ),
            BlocBuilder<BookBloc, BookState>(
                bloc: bookBloc,
                builder: (context, bookState) {
                  if (bookState is BookLoadingState) {
                    return Flexible(child: BookPlaceholder(item: item));
                  } else if (bookState is BookLoadedState) {
                    return Flexible(child: bookState.bookView);
                  } else if (bookState is BookErrorState) {
                    return Center(child: Text(bookState.error));
                  }
                  return const SizedBox();
                }),
          ]),
        ));
  }

  Widget pageButtonsBuilder() {
    return StreamBuilder<Map<int, int>>(
        stream: streamPosition, builder: (context, snapshot) => pageButtons(snapshot.data));
  }

  Widget pageButtons(Map<int, int>? bookMap) {
    final nbPages = bookMap?.values.first ?? 0;
    final currentPage = bookMap?.keys.first ?? 0;
    final listValues = List.generate(nbPages, (index) => index + 1);
    return SizedBox(
      width: 300,
      child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          itemCount: nbPages,
          shrinkWrap: true,
          itemBuilder: (context, index) => pageButton(listValues.elementAt(index), currentPage, context)),
    );
  }

  Widget pageButton(int pageNumber, int currentPage, BuildContext context) {
    return TextButton(
        onPressed: () =>
            pageController.animateToPage(pageNumber, duration: Duration(milliseconds: 400), curve: Curves.easeInOut),
        child:
            Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
          if (pageNumber == currentPage)
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 2),
              child: Icon(Icons.check, size: 24),
            ),
          if (pageNumber != currentPage) SizedBox(width: 28),
          Text('page_number'.tr(args: [pageNumber.toString()]), style: Theme.of(context).textTheme.bodyMedium)
        ]));
  }
}
