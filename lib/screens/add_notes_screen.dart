import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_notes/model/notes.dart';
import 'package:my_notes/providers/notes_provider.dart';
import 'package:provider/provider.dart';

class AddNewScreen extends StatefulWidget {
  final int index;
  AddNewScreen(this.index);

  @override
  _AddNewScreenState createState() => _AddNewScreenState();
}

class _AddNewScreenState extends State<AddNewScreen> {
  void addToDb(String _title, String _text) async {
    Note addNote = new Note(title: _title, note: _text);

    var box = await Hive.openBox<Note>('notes');
    box.add(addNote);
  }

  void updateToDb(String _title, String _text) async {
    Note updateNote = Note(title: _title, note: _text);
    var box = await Hive.openBox<Note>('notes');
    box.putAt(widget.index, updateNote);
  }

  final _titleController = TextEditingController();
  final _textController = TextEditingController();
  @override
  void initState() {
    if (widget.index != null) {
      final noteList = Provider.of<NotesProvider>(context, listen: false).items;
      _titleController.text = noteList[widget.index].title;
      _textController.text = noteList[widget.index].note;
    }
    super.initState();
  }

  void save() {
    final noteList = Provider.of<NotesProvider>(context, listen: false);
    if (_titleController.text == '' && _textController.text == '') {
      Navigator.of(context).pop();
    } else {
      if (widget.index == null) {
        noteList.addToItem(_titleController.text, _textController.text);
        addToDb(_titleController.text, _textController.text);
      } else {
        noteList.updateToItem(
            _titleController.text, _textController.text, widget.index);
        updateToDb(_titleController.text, _textController.text);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteList = Provider.of<NotesProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () {
        save();

        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: Theme.of(context).iconTheme,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                if (_titleController.text == '' && _textController.text == '') {
                  Navigator.of(context).pop();
                } else {
                  final box = Hive.box<Note>('notes');
                  box.deleteAt(widget.index);
                  noteList.removeNote(widget.index);
                  Navigator.of(context).pop();
                }
              },
              icon: Icon(Icons.delete_rounded),
            ),
            IconButton(
                onPressed: () {
                  if ((_textController.text == '') &&
                      (_titleController.text == '')) {
                    return showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                              title: Text('You cannot save this'),
                              content: Text('Enter something to save, Idiot!'));
                        }
                        //  title: Text(''),
                        ); //content: Text());
                  } else {
                    if (widget.index == null) {
                      noteList.addToItem(
                          _titleController.text, _textController.text);
                      addToDb(_titleController.text, _textController.text);
                    } else {
                      noteList.updateToItem(_titleController.text,
                          _textController.text, widget.index);
                      updateToDb(_titleController.text, _textController.text);
                    }
                    Navigator.of(context).pop();
                  }
                },
                icon: Icon(Icons.save_rounded))
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    style: TextStyle(fontSize: 22),
                    cursorColor: Colors.black,
                    cursorHeight: 22,
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    maxLength: 30,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        hintText: 'Title',
                        hintStyle: TextStyle(fontSize: 22)),
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 16),
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.multiline,
                    maxLines: 100,
                    maxLength: null,
                    controller: _textController,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: 'Note',
                      //    hintStyle: GoogleFonts.montserrat()
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
