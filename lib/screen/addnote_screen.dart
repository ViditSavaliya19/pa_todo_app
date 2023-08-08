import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:pa_todo_app/helper/db_helper.dart';
import 'package:pa_todo_app/model/note_model.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AddNotesScreen extends StatefulWidget {
  const AddNotesScreen({super.key});

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  SpeechToText? speech;
  String textString = "Press The Button";
  bool isListen = false;

  TextEditingController txtTitle = TextEditingController();
  TextEditingController txtNotes = TextEditingController();

  @override
  void initState() {
    super.initState();
    speech = SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Notes"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Title",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: txtTitle,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.black26),
                      hintText: "Speak Title...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Notes",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: txtNotes,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.black26),
                      hintText: "Speak Notes...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: isListen,
          glowColor: Colors.red,
          endRadius: 65.0,
          duration: Duration(milliseconds: 2000),
          repeatPauseDuration: Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            child: Icon(isListen ? Icons.mic : Icons.mic_none),
            onPressed: () {
              listen();
            },
          ),
        ),
      ),
    );
  }


  void listen() async {
    if (!isListen) {
      bool avail = await speech!.initialize();
      if (avail) {
        setState(() {
          isListen = true;
        });
        speech!.listen(onResult: (value) {
          setState(() {
            textString = value.recognizedWords;
            if (value.hasConfidenceRating && value.confidence > 0) {
              // confidence = value.confidence;
            }
            if (textString.toLowerCase().contains("add title") && value.confidence > 0) {

              txtTitle = TextEditingController(text: textString.substring(9));
            }else if (textString.toLowerCase().contains("add notes") && value.confidence > 0) {

              txtNotes = TextEditingController(text: textString.substring(8));
            }else if (textString.toLowerCase().contains("save notes") && value.confidence > 0) {

              DbHelper.helper.insertData(NotesModel(title: txtTitle.text,notes: txtNotes.text,date: "${DateTime.now()}",time: "${TimeOfDay.now()}"));
            }
            // var a = textString.toLowerCase().similarityTo("hii i note");
            // print("============= $a");
          });
        });
      }
    } else {
      setState(() {
        isListen = false;
      });
      speech!.stop();
    }
  }
}
