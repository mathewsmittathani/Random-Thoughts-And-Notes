import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
part 'notes.g.dart';

@HiveType(typeId: 0)
class Note with ChangeNotifier {
  @HiveField(0)
  String title;

  @HiveField(1)
  String note;

  Note({this.title, this.note});
}
