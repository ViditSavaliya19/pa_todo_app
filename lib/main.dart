import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_todo_app/screen/addnote_screen.dart';
import 'package:pa_todo_app/screen/home_screen.dart';
import 'package:pa_todo_app/screen/notes_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: true),
       debugShowCheckedModeBanner: false,
      routes: {
        // '/':(context) => HomeScreen(),
        '/':(context) => NotesScreen(),
        'note':(context) => AddNotesScreen(),
      }
    ),
  );
}
