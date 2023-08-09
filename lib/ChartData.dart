import 'package:hive/hive.dart';

part 'ChartData.g.dart';

@HiveType(typeId: 1)
class ChartData extends HiveObject{

  @HiveField(0)
  final int x;

  @HiveField(1)
  final double? y;

  ChartData(this.x, this.y);

}