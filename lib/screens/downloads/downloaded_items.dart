import 'package:downloads_repository/downloads_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/list_items/bloc/collection_bloc.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/screens/downloads/bloc/downloads_bloc.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class DownloadedItemsPage extends StatelessWidget {
  const DownloadedItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DownloadsBloc>(
          create: (BuildContext context) => DownloadsBloc(
            downloadsRepository: context.read<DownloadsRepository>(),
          )..add(const DownloadsSubscriptionRequested()),
        ),
        BlocProvider<CollectionBloc>(
            create: (BuildContext context) => CollectionBloc()),
      ],
      child: const DownloadedItemsView(),
    );
  }
}

class DownloadedItemsView extends StatelessWidget {
  const DownloadedItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<DownloadsBloc, DownloadsState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == DownloadsStatus.failure) {
                SnackbarUtil.message('Error while loading downloads',
                    Icons.download, Colors.red);
              }
            },
          ),
          BlocListener<DownloadsBloc, DownloadsState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedDownload != current.lastDeletedDownload &&
                current.lastDeletedDownload != null,
            listener: (context, state) {
              final deletedDownload = state.lastDeletedDownload!;
              SnackbarUtil.message(
                  '${deletedDownload.item.name} has been deleted',
                  Icons.delete,
                  Colors.green);
            },
          ),
        ],
        child: BlocBuilder<DownloadsBloc, DownloadsState>(
            builder: (context, state) {
          final downloads = state.downloads.map((e) => e.item).toList();
          return ListItems.fromList(
              collectionBloc: context.read<CollectionBloc>(),
              category: Category(
                  items: downloads,
                  startIndex: 0,
                  totalRecordCount: downloads.length),
              verticalListPosterHeight: 250,
              listType: ListType.GRID);
        }));
  }
}
