import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/book/bloc/book_bloc.dart';
import 'package:jellyflut/screens/book/components/setting_buton.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'components/book_placeholder.dart';
import 'components/page_counter_parent.dart';

class CompactBookView extends StatefulWidget {
  final Item item;
  final BookBloc bookBloc;
  final Function(int currentPage, int nbPage) listener;
  final Stream<Map<int, int>> streamPosition;
  final PageController pageController;
  const CompactBookView(
      {super.key,
      required this.item,
      required this.bookBloc,
      required this.pageController,
      required this.streamPosition,
      required this.listener});

  @override
  State<CompactBookView> createState() => _CompactBookViewState();
}

class _CompactBookViewState extends State<CompactBookView> {
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
    streamPosition.first.then((value) => pageController.jumpToPage(value.keys.first));
    scrollController = ScrollController();
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
          title: Text(item.name ?? ''),
          actions: [
            SettingButton(),
            PageCounterParent(streamPage: streamPosition, controller: pageController),
          ],
        ),
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: false,
        extendBody: false,
        body: SizedBox(
          height: double.maxFinite,
          child: Center(
            child: BlocBuilder<BookBloc, BookState>(
                bloc: bookBloc,
                builder: (context, bookState) {
                  if (bookState is BookLoadingState) {
                    return BookPlaceholder(item: item);
                  } else if (bookState is BookLoadedState) {
                    return bookState.bookView;
                  } else if (bookState is BookErrorState) {
                    return Center(child: Text(bookState.error));
                  }
                  return const SizedBox();
                }),
          ),
        ));
  }
}
