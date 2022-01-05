part of '../details_widgets.dart';

class ProvidersDetailsWidget extends StatelessWidget {
  final Item item;
  const ProvidersDetailsWidget({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item.externalUrls.isEmpty) {
      return const SizedBox();
    }
    final widgets = <Widget>[];
    item.externalUrls.forEach((ExternalUrl externalUrl) {
      widgets.add(ProviderButton(
          providerName: externalUrl.name, providerUrl: externalUrl.url));
    });
    return Wrap(spacing: 8, runSpacing: 10, children: widgets);
  }
}
