part of '../details_widgets.dart';

class ProvidersDetailsWidget extends StatelessWidget {
  final Item item;
  const ProvidersDetailsWidget({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item.providerIds == null || item.providerIds!.isEmpty) {
      return SizedBox();
    }
    final widgets = <Widget>[];
    item.providerIds!.forEach((key, value) {
      widgets.add(ProviderButton(value: key));
    });
    return Wrap(spacing: 8, runSpacing: 10, children: widgets);
  }
}
