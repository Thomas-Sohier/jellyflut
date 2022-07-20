part of '../details_widgets.dart';

class PeoplesDetailsWidget extends StatelessWidget {
  final EdgeInsets padding;
  const PeoplesDetailsWidget({super.key, this.padding = const EdgeInsets.only(left: 12)});

  @override
  Widget build(BuildContext context) {
    final state = context.read<DetailsBloc>().state;
    if (state.item.type != ItemType.Person && !state.item.hasPeople()) {
      return const SliverToBoxAdapter(child: SizedBox());
    }
    return MultiSliver(
      children: [
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        SliverPadding(
            padding: padding,
            sliver: SliverToBoxAdapter(
                child: Align(
              alignment: Alignment.centerLeft,
              child: Text('item_cast'.tr(args: [state.item.name ?? '']), style: Theme.of(context).textTheme.headline5),
            ))),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        SliverPadding(padding: padding, sliver: const SliverToBoxAdapter(child: PeoplesList()))
      ],
    );
  }
}
