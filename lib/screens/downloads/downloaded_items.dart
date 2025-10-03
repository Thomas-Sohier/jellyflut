import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/list_items/bloc/collection_bloc.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/screens/downloads/downloads_bloc/downloads_bloc.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';

class DownloadedItemsPage extends StatelessWidget {
  const DownloadedItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DownloadedItemsView();
  }
}

class DownloadedItemsView extends StatelessWidget {
  const DownloadedItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    final downloadsState = context.read<DownloadsBloc>().state;
    final downloads = downloadsState.downloads.map((e) => e.item).toList();
    final bloc = CollectionBloc(
      fetchMethod: (startIndex, limit) async {
        final endIndex = (startIndex + limit) > downloads.length ? downloads.length : (startIndex + limit);
        return downloads.sublist(startIndex, endIndex);
      },
      verticalListPosterHeight: 200,
      gridPosterHeight: 250,
      listType: ListType.grid,
    )..add(CollectionFetchStarted());
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
                context: context,
              );
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
              context: context,
            );
          },
        ),
        BlocListener<DownloadsBloc, DownloadsState>(
          listenWhen: (previous, current) => previous.downloads != current.downloads,
          listener: (_, state) {
            final downloads = state.downloads.map((e) => e.item).toList();
            bloc.add(CollectionItemsReplaced(downloads));
          },
        ),
      ],
      child: ListItems(collectionBloc: bloc, items: const []),
    );
  }
}
