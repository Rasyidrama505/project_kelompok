import 'package:hive/hive.dart';

part 'menu.g.dart';

@HiveType(typeId: 0)
class Menu extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  int price;

  @HiveField(2)
  String image;

  @HiveField(3)
  final String category;

  Menu({required this.title, required this.price, required this.image, required this.category});
}
