import 'package:hive/hive.dart';

part 'meat_item.g.dart';

@HiveType(typeId: 0)
class MeatItem extends HiveObject {
  @HiveField(0)
  String type; // Pork, Beef, or Ribs

  @HiveField(1)
  double totalCount;

  @HiveField(2)
  DateTime lastUpdated;

  MeatItem({
    required this.type,
    required this.totalCount,
    required this.lastUpdated,
  });
}

class MeatPortions {
  static const double onePound = 1.0;
  static const double halfPound = 0.5;
  static const double thirdPound = 0.37;
  static const double sandwichSize = 0.31;
  static const double tacoSize = 0.125;
  static const double fullRack = 1.0;
  static const double halfRack = 0.5;
  static const double threeBone = 0.33;
}

class StockThresholds {
  final double fourPM;
  final double fivePM;
  final double sixPM;
  final double sevenPM;

  const StockThresholds({
    this.fourPM = 10.0,
    this.fivePM = 8.0,
    this.sixPM = 6.0,
    this.sevenPM = 3.5,
  });
}
