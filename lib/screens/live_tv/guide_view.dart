import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/routes/router.gr.dart' as r;
import 'package:jellyflut/screens/live_tv/bloc/live_tv_guide_cubit.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:live_tv_repository/live_tv_repository.dart';

class GuideView extends StatelessWidget {
  const GuideView({super.key});
  @override
  Widget build(BuildContext context) {
    final guide = context.select<LiveTvGuideCubit, List<Channel>>((cubit) => cubit.state.guide);
    return ListView.builder(
        itemCount: guide.length,
        padding: EdgeInsets.zero,
        itemBuilder: ((context, index) {
          final guideElement = guide.elementAt(index);
          return GuideChannelRow(channel: guideElement.channel, programs: guideElement.programs);
        }));
  }
}

class GuideChannelRow extends StatelessWidget {
  const GuideChannelRow({super.key, required this.channel, required this.programs});

  final Item channel;
  final List<Program> programs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              OutlinedButtonSelector(
                onPressed: () => context.router.root.push(r.DetailsPage(item: channel, heroTag: channel.id)),
                child: SizedBox(
                  width: 80,
                  child: Stack(alignment: Alignment.center, clipBehavior: Clip.none, children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4, right: 4),
                      child: Poster(
                          imageType: ImageType.Primary,
                          heroTag: channel.id,
                          clickable: false,
                          boxFit: BoxFit.contain,
                          item: channel),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: Card(
                            elevation: 2,
                            margin: EdgeInsets.zero,
                            color: Theme.of(context).colorScheme.primary,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                              child: Text(
                                channel.channelNumber ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary)
                                    .copyWith(fontSize: 12),
                              ),
                            ))),
                  ]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: ProgramList(programs: programs)),
            ],
          )),
    );
  }
}

class ProgramList extends StatelessWidget {
  const ProgramList({super.key, required this.programs});

  final List<Program> programs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: programs.length,
        controller: ScrollController(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) => ProgramListElement(program: programs.elementAt(index)));
  }
}

class ProgramListElement extends StatelessWidget {
  const ProgramListElement({super.key, required this.program});

  final Program program;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('HH:mm');
    final width = (program.endAt.difference(program.startAt).inMinutes * 10).toDouble();
    return OutlinedButtonSelector(
      onPressed: () => {}, //context.router.root.push(r.DetailsPage(item: program, heroTag: program.id)),
      child: Card(
          elevation: 0,
          margin: EdgeInsets.symmetric(horizontal: 4),
          color: ColorUtil.darken(Theme.of(context).cardTheme.color!),
          child: SizedBox(
              width: width,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        program.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      '${formatter.format(program.startAt)} - ${formatter.format(program.endAt)}',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ],
                ),
              ))),
    );
  }
}
