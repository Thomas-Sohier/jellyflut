import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jellyflut/components/async_image.dart';
import 'package:jellyflut/components/progress_bar_minimalist.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class IptvChannel extends StatelessWidget {
  final Item item;

  const IptvChannel({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        logo(),
        ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: 150, minHeight: 150, minWidth: 150, maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title(context),
                channelnumber(context),
                Divider(),
                currentProgram(context),
                timeProgress(context)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget logo() {
    return OutlinedButton(
        onPressed: () => item.playItem(),
        style: OutlinedButton.styleFrom()
            .copyWith(side: buttonBorderSide())
            .copyWith(backgroundColor: buttonBackgroundColor()),
        child: Container(
            constraints: BoxConstraints(
                minHeight: 150, maxHeight: 150, minWidth: 50, maxWidth: 150),
            padding: EdgeInsets.all(4),
            child: AspectRatio(
              aspectRatio: item.primaryImageAspectRatio ?? 1,
              child: AsyncImage(
                  item: item,
                  boxFit: BoxFit.contain,
                  tag: ImageType.PRIMARY,
                  placeholder: const SizedBox(),
                  errorWidget: noLogo()),
            )));
  }

  Widget noLogo() {
    return Container(
      color: Colors.transparent,
      child: Icon(Icons.tv),
    );
  }

  Widget timeProgress(BuildContext context) {
    if (item.currentProgram != null &&
        item.currentProgram!.startDate != null &&
        item.currentProgram!.endDate != null) {
      final dateTimeFormatter = DateFormat('HH:mm');
      return Row(
        children: [
          Text(dateTimeFormatter.format(item.currentProgram!.startDate!),
              style: Theme.of(context).textTheme.overline,
              maxLines: 1,
              overflow: TextOverflow.clip),
          Container(
            width: 80,
            padding: EdgeInsets.only(left: 4, right: 4),
            child: ProgressBarMinimalist(
                startDate: item.currentProgram!.startDate!,
                endDate: item.currentProgram!.endDate!),
          ),
          Text(dateTimeFormatter.format(item.currentProgram!.endDate!),
              style: Theme.of(context).textTheme.overline,
              maxLines: 1,
              overflow: TextOverflow.clip),
        ],
      );
    }
    return const SizedBox();
  }

  Widget title(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(item.name,
              style: Theme.of(context).textTheme.subtitle1,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget channelnumber(BuildContext context) {
    if (item.channelNumber != null) {
      return Row(children: [
        Flexible(
            child: Text('Channel : ${item.channelNumber.toString()}',
                style: Theme.of(context).textTheme.bodyText2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis))
      ]);
    }
    return const SizedBox();
  }

  Widget currentProgram(BuildContext context) {
    if (item.currentProgram != null) {
      return Row(
        children: [
          Flexible(
            child: Text(item.currentProgram!.name,
                style: Theme.of(context).textTheme.bodyText2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  MaterialStateProperty<BorderSide> buttonBorderSide() {
    return MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return BorderSide(
            width: 2,
            color: Colors.white,
          );
        }
        return BorderSide(width: 2, color: Colors.grey.shade800);
      },
    );
  }

  MaterialStateProperty<Color> buttonBackgroundColor() {
    return MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return Colors.grey.shade800;
        }
        return Colors.grey.shade700;
      },
    );
  }
}
