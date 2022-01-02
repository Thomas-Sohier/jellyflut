import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/screens/iptv/components/iptv_channel.dart';
import 'package:jellyflut/services/livetv/livetv_service.dart';

class IptvPrograms extends StatefulWidget {
  IptvPrograms({Key? key}) : super(key: key);

  @override
  _IptvProgramsState createState() => _IptvProgramsState();
}

class _IptvProgramsState extends State<IptvPrograms> {
  late final Future<Category> programs;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    programs = IptvService.getPrograms();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
        future: programs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.data!.items;
            return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: ListView.builder(
                    shrinkWrap: true,
                    controller: scrollController,
                    itemCount: items.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: IptvChannel(item: items[index]),
                        )));
          }
          return const SizedBox();
        });
  }
}
