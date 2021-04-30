import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:my_notes/providers/notes_provider.dart';
import 'package:my_notes/screens/add_notes_screen.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    final notes = Provider.of<NotesProvider>(context, listen: false);
    notes.getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Random Thoughts and Notes",
                    style: GoogleFonts.ptSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white70)),
              ),
              Divider(
                color: Colors.white54,
                thickness: 2,
                indent: 60,
                endIndent: 60,
              ),
              SizedBox(height: 15),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child:
                      Consumer<NotesProvider>(builder: (context, notes, child) {
                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          crossAxisCount: 2,
                        ),
                        itemCount: notes.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: Card(
                                elevation: 7,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.white60,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                              '${notes.items[index].title.toUpperCase()}',
                                              // overflow: TextOverflow.clip,
                                              // softWrap: true,
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22)
                                              // TextStyle(
                                              //     fontWeight: FontWeight.bold,
                                              //     fontSize: 20),
                                              ),
                                        ),
                                        // Align(
                                        //   alignment: Alignment.topRight,
                                        //   child: IconButton(
                                        //       onPressed: () {},
                                        //       icon: Icon(Icons.close)),
                                        // ),
                                        Divider(
                                            indent: 10,
                                            endIndent: 10,
                                            thickness: 2),
                                        SizedBox(height: 4),
                                        Flexible(
                                          child: Text(
                                            '${notes.items[index].note}',
                                            style: GoogleFonts.poppins(),
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                        )
                                      ]),
                                )),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddNewScreen(index)),
                              ); //.then((value) =>);
                            },
                          );
                        });
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: Icon(
          Icons.add,
          size: 35,
          color: Colors.white70,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewScreen(null)),
          );
        },
      ),
    );
  }
}
