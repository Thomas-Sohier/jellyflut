part of '../details_widgets.dart';

class PeoplesDetailsWidget extends StatelessWidget {
  const PeoplesDetailsWidget({super.key});

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
            padding: state.contentPadding,
            sliver: SliverToBoxAdapter(
                child: Align(
              alignment: Alignment.centerLeft,
              child:
                  Text('item_cast'.tr(args: [state.item.name ?? '']), style: Theme.of(context).textTheme.headlineSmall),
            ))),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        SliverPadding(
            padding: EdgeInsets.only(left: state.contentPadding.left),
            sliver: const SliverToBoxAdapter(child: PeoplesList()))
      ],
    );
  }
}
