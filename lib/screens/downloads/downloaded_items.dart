import 'package:downloads_repository/downloads_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/downloads/bloc/downloads_bloc.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';

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
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (_, state) {
              if (state.status == DownloadsStatus.failure) {
                SnackbarUtil.message(
                    messageTitle: 'Error while loading downloads',
                    icon: Icons.download,
                    color: Colors.red,
                    context: context);
              }
            },
          ),
          BlocListener<DownloadsBloc, DownloadsState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedDownload != current.lastDeletedDownload && current.lastDeletedDownload != null,
            listener: (_, state) {
              final deletedDownload = state.lastDeletedDownload!;
              SnackbarUtil.message(
                  messageTitle: '${deletedDownload.item.name} has been deleted',
                  icon: Icons.delete,
                  color: Colors.green,
                  context: context);
            },
          ),
        ],
        child: BlocBuilder<DownloadsBloc, DownloadsState>(builder: (context, state) {
          final downloads = state.downloads.map((e) => e.item).toList();
          return const SizedBox();
          // return ListItemsView.fromList(
          //     collectionBloc: context.read<CollectionBloc>(),
          //     category: Category(items: downloads, startIndex: 0, totalRecordCount: downloads.length),
          //     verticalListPosterHeight: 250,
          //     listType: ListType.grid);
        }));
  }
}
