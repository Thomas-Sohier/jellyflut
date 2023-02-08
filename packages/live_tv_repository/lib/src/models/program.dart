import 'package:jellyflut_models/jellyflut_models.dart';

class Program {
  final String id;
  final String name;
  final String? description;
  final DateTime startAt;
  final DateTime endAt;

  const Program({
    required this.id,
    required this.name,
    required this.description,
    required this.startAt,
    required this.endAt,
  });

  static Program fromItem(Item item) {
    assert(item.name != null, 'Item name is null but is required');
    assert(item.startDate != null, 'Item startDate is null but is required');
    assert(item.endDate != null, 'Item endDate is null but is required');
    return Program(
      id: item.id,
      name: item.name!,
      description: item.overview,
      startAt: item.startDate!,
      endAt: item.endDate!,
    );
  }
}
