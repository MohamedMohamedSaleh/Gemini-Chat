import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';
@HiveType(typeId: 1)
class UserModel extends HiveObject{
  // extends to Hive object to i can to delete the model
  //create fields
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  // create constractor
  UserModel({
    required this.uid,
    required this.name,
    required this.image,
  });
}
