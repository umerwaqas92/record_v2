import 'dart:async';
import 'dart:io';
import 'package:audiocutter_example/pages/record_list.dart';
import 'package:audiocutter_example/pages/record_voice.dart';
import 'package:audiocutter_example/pages/settings.dart';
import 'package:audiocutter_example/pages/voice_to_text.dart';
import 'package:audiocutter_example/recorder.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'audiocutter.dart';
import 'player.dart';

typedef void OnError(Exception exception);

void main() => runApp(ExampleApp());

  
 
 
  

class ExampleApp extends StatefulWidget {
  @override
  _ExampleAppState createState() => _ExampleAppState();


}

class _ExampleAppState extends State<ExampleApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();




  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(


      debugShowCheckedModeBanner: false,
        theme:ThemeData(
          primarySwatch: Colors.teal,
        ),
      home:Homepage()
      );
        }
      }
      
      
      
      
      
      
      class Homepage extends StatefulWidget {
        @override
        _HomepageState createState() => _HomepageState();
      }
      
      class _HomepageState extends State<Homepage> {


          Future<String> _url;
  String _cutFilePath;
  bool record = false;
  bool avl=false;
  

  String statusText = "";
  bool isComplete = false;


  final audioFileStartController = 0;
  final audioFileEndController = 0;
  int _page = 0;


  List screens=[Record_Voice_Screen(),Voice_to_Text(),Record_List(),Settings()];





        @override
        Widget build(BuildContext context) {
          return
      
       Scaffold(
              bottomNavigationBar: CurvedNavigationBar(
                animationDuration: Duration(milliseconds:100),
                color: Colors.teal[300],
    backgroundColor: Colors.transparent,
    buttonBackgroundColor: Colors.teal[700],
    items: <Widget>[
      Icon(Icons.mic,color: Colors.white, size: 30),
      Icon(Icons.record_voice_over,color: Colors.white, size: 30),
      Icon(Icons.list,color: Colors.white, size: 30),
      Icon(Icons.settings,color: Colors.white, size: 30),
    ],
    onTap: (index) {
      setState(() {
            _page = index;
          });

      //Handle button tap
    },
  ),
               body:  screens[_page]);


                       }
            
              @override
              void initState() {
                super.initState();
            
                
              }
            
//              Widget audioPlayer(BuildContext context)
//              {
//                return Container(
//                  padding: EdgeInsets.all(32.0),
//                  child: Column(mainAxisSize: MainAxisSize.min, children: [
//
//
//
//                    _cutFilePath == null
//                        ? Container()
//                        : MediaPlayerWidget(url: _cutFilePath, isLocal: true),
//
//
//                        avl?  Padding(
//  padding: EdgeInsets.only(left: 100.0, right: 100.0),
//  child: RaisedButton(
//    textColor: Colors.white,
//    color: Colors.black,
//    child: Text("Share"),
//    onPressed: (){
//  })): Container(),
//
//
//                  ]),
//                );
//              }
            
              /// Your reason for viewing this example!!!
              ///
              /// Takes the asset audio and passes the start and end times entered in the
              /// app to be chopped up and saved to the app directory.
              ///
              /// Also loads the cut song so you can listen to your new creation!
              ///
              /// Happy cutting!
              Future<String> _cutSong() async {
                var start = audioFileStartController.toString();
                var end = audioFileEndController.toString();
                String path = GlobalVariable.recordFilePath;
            
                // Close the keyboard.
                FocusScope.of(context).requestFocus(FocusNode());
            
                return await AudioCutter.cutAudio2(
                    path, double.parse(start), double.parse(end));
              }
            
            
              
            
              /// Copies the asset audio to the local app dir to be used elsewhere.
              Future<String> _copyAssetAudioToLocalDir() async {
                final Directory dir = await getApplicationDocumentsDirectory();
                final path = '${dir.path}/bensound-sunny.mp3';
                final File song = new File(path);
            
                if (!(await song.exists())) {
                  final data = await rootBundle.load('assets/bensound-sunny.mp3');
                  final bytes = data.buffer.asUint8List();
                  await song.writeAsBytes(bytes, flush: true);
                }
            
                return path;
              }
            
              recorder(BuildContext context) {}





}


