part of '../details_widgets.dart';

class ProvidersDetailsWidget extends StatelessWidget {
  const ProvidersDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    if (state.item.externalUrls.isEmpty) {
      return const SizedBox();
    }
    final widgets = <Widget>[];
    for (var externalUrl in state.item.externalUrls) {
      widgets.add(ProviderButton(
        providerName: externalUrl.name ?? '',
        providerUrl: externalUrl.url ?? '',
      ));
    }
    return Wrap(spacing: 8, runSpacing: 10, children: widgets);
  }
}
