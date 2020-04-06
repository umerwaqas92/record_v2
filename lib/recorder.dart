import 'dart:io';

import 'package:audiocutter_example/player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:toast/toast.dart';
import 'package:flutter_timer/flutter_timer.dart';

class GlobalVariable {
  static String recordFilePath = 'No recording yet!!';
}

class Recorder extends StatefulWidget {
  final Function func;


  Recorder(this.func);

  @override
  _RecorderState createState() => _RecorderState(func);
}
class _RecorderState extends State<Recorder>  {
  bool isShare = false;
  bool record = false;
  bool pause= false;
  bool saved = false;
  bool soundavl= false;
  final Function func;


  _RecorderState(this.func);

  Database db ;
  Future<void> initat_db() async {
    String dbPath = 'audirecorders.db';
    DatabaseFactory dbFactory = databaseFactoryIo;

// We use the database factory to open the database
    db = await dbFactory.openDatabase(dbPath);
  }



  @override
  void initState() {
    super.initState();
    checkPermission();
    initat_db();

  }

  void dispose() {
    // Clean up the controller when the widget is disposed.

    super.dispose();
  }

  
bool running = false;
String statusText = "";
  bool isComplete = false;
  
  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[

          TikTikTimer(
            height: 30 ,
                width: 100,
                initialDate: DateTime.now(),
                 
                running: running,
                backgroundColor: Colors.transparent,
                timerTextStyle: TextStyle(color: Colors.teal, fontSize: 25),
              ),
              SizedBox(width: 50,),
           
record?   MaterialButton(
  onPressed: () {

    setState(() {
          stopRecord();
          saved= true;
          running = false;
          record=false;
          Toast.show("Recording Saved", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.BOTTOM);

          func();

    });
  },
  color: Colors.white38,
  textColor: Colors.white,
  elevation: 10,
  child: Icon(
    Icons.mic,
    color: Colors.red,
    size: 70,
  ),
  padding: EdgeInsets.all(16),
  shape: CircleBorder(),
)     
:


MaterialButton(
  onPressed: ()async {
    setState(() {
          startRecord();
          running = true;
          record=true;
          Toast.show("Recording Started", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.BOTTOM);
    });
  },
  color: Colors.white38,
  textColor: Colors.white,
  elevation: 10,
  child: Icon(
    Icons.mic,
    color: Colors.teal,
    size: 70,
  ),
  padding: EdgeInsets.all(16),
  shape: CircleBorder(),
)   ,

        ])




      
       

              
              
      
        ]),
      
    );
  }
Future<String> getFilePath() async {
    String customPath = '/record_';
    io.Directory appDocDirectory;
    if (io.Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }
    customPath = appDocDirectory.path +
        customPath +
        DateTime.now().millisecondsSinceEpoch.toString() +
        ".mp3";
    print(customPath);
    return customPath;

  }

  

 Future<bool> checkPermission() async {
    Map<PermissionGroup, PermissionStatus> map = await new PermissionHandler()
        .requestPermissions(
            [PermissionGroup.storage, PermissionGroup.microphone]);
    print(map[PermissionGroup.microphone]);
    return map[PermissionGroup.microphone] == PermissionStatus.granted;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      statusText = "Recording...";
      GlobalVariable.recordFilePath = await getFilePath();
      isComplete = false;
      RecordMp3.instance.start(GlobalVariable.recordFilePath, (type) {
        statusText = "Recording failed--->$type";
        setState(() {});
      });
    } else {
      statusText = "No recording rights";
    }
    setState(() {});
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();

    if (s) {
      statusText = "Recording is complete";
      isComplete = true;
      setState(() {});
    }
  }

void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        statusText = "正在录音中...";
        setState(() {});
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Recording paused...";
        setState(() {});
      }
    }

    

  }

void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      statusText = "Recording...";
      setState(() {});
    }
  }




void play() {
    if (GlobalVariable.recordFilePath  != null && File(GlobalVariable.recordFilePath ).existsSync()) {
      setState(() {  soundavl= true;
        
      });
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.play(GlobalVariable.recordFilePath , isLocal: true);
    }
  }
}
