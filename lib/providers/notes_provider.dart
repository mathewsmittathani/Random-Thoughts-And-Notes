import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_notes/model/notes.dart';

class NotesProvider with ChangeNotifier {
  List<Note> _items = [];

  List<Note> get items {
    return [..._items];
  }

  void addToItem(String title, String note) {
    _items.add(Note(title: title, note: note));
    notifyListeners();
  }

  void updateToItem(String title, String note, int index) {
    _items[index].title = title;
    _items[index].note = note;
    notifyListeners();
  }

  void getNotes() async {
    final box = await Hive.openBox<Note>('notes');

    _items = box.values.toList();
    notifyListeners();
  }

  void removeNote(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}
