import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_notes/model/notes.dart';
import 'package:my_notes/providers/notes_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      // navigation bar color
      statusBarColor: Colors.red[400], // status bar color
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(NoteAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NotesProvider()),
        ],
        child: MaterialApp(
          title: "Random Notes and Thoughts",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(),
        ));
  }
}
