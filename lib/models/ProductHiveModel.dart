import 'package:cook_book/network/model/product_entity.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class ProductHiveModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool fav_status;

  @HiveField(3)
  int category_id;

  @HiveField(4)
  int subcategory_id;

  @HiveField(5)
  int status;

  @HiveField(6)
  String color;

  @HiveField(7)
  String image;

  @HiveField(8)
  String description;

  @HiveField(9)
  List<IngredientEntity> ingredients;

  @HiveField(10)
  List<StepsEntity> steps;

  @HiveField(11)
  String tags;

  @HiveField(12)
  int total_calories;
}
