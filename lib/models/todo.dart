
import 'package:hive/hive.dart';
part 'todo.g.dart';

//command that generate hive modal class ==> flutter pub run build_runner build

@HiveType(typeId: 1)
class Todo {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String priority;
  @HiveField(3)
  final String image;
  @HiveField(4)
  final DateTime createDate;
  @HiveField(5)
  final DateTime modifiedDate;
  @HiveField(6)
  final String status;

  Todo({this.title, this.description, this.priority, this.image, this.createDate, this.modifiedDate, this.status});
}