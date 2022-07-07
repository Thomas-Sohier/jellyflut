part of '../details_widgets.dart';

class ProvidersDetailsWidget extends StatelessWidget {
  final Item item;
  const ProvidersDetailsWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.externalUrls.isEmpty) {
      return const SizedBox();
    }
    final widgets = <Widget>[];
    for (var externalUrl in item.externalUrls) {
      widgets.add(ProviderButton(providerName: externalUrl.name ?? '', providerUrl: externalUrl.url ?? ''));
    }
    return Wrap(spacing: 8, runSpacing: 10, children: widgets);
  }
}
