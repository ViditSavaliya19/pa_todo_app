import 'package:flutter/material.dart';
import 'package:pa_todo_app/helper/db_helper.dart';
import 'package:pa_todo_app/model/note_model.dart';
import 'package:speech_to_text/speech_to_text.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List notesList = [];
  SpeechToText? speech;
  String textString = "Press The Button";
  bool isListen = false;
  double confidence = 1.0;

  @override
  void initState() {
    super.initState();
    speech = SpeechToText();
    readNotes();
  }

  Future<void> readNotes() async {
    notesList = await DbHelper.helper.readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: notesList.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.primaries[index % Colors.primaries.length].shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "${notesList[index]['title']}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        shape: BoxShape.circle,
                        color: Colors.primaries[index % Colors.primaries.length]
                            .shade200,
                      ),
                      child: Text(
                        "$index",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                    // Image.network(
                    //   "https://cdn-icons-png.flaticon.com/512/889/889647.png",
                    //   height: 30,
                    //   width: 30,
                    // ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Hii, How are you what are you doing hear, How are you what are you doing hear, How are you what are you doing hear, How are you what are you doing hear, ",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "10:20",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "10/08/2023",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              listen();
            },
            child: Icon(Icons.mic),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, 'note');
            },
            child: Icon(Icons.mic_off),
          ),
        ],
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
              confidence = value.confidence;
            }
            if (textString.toLowerCase() == "new note" &&
                value.confidence > 0) {
              Navigator.pushNamed(context, 'note');
            }

            if (textString.toLowerCase().contains("delete note") &&
                value.confidence > 0) {
              print("${int.parse(textString.substring(10).trim())}");
              DbHelper.helper.deleteData(NotesModel(
                  id: notesList[int.parse(textString.substring(10).trim())]
                      ['id']));
              setState(() {
                readNotes();
              });
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
