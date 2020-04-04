
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../audiocutter.dart';
import '../player.dart';
import '../recorder.dart';

class Record_Voice_Screen extends StatefulWidget {
  @override
  _Record_Voice_ScreenState createState() => _Record_Voice_ScreenState();
}

class _Record_Voice_ScreenState extends State<Record_Voice_Screen> {


  Future<String> _url;
  String _cutFilePath;
  bool record = false;
  bool avl=false;


  String statusText = "";
  bool isComplete = false;


  final audioFileStartController = 0;
  final audioFileEndController = 0;

  @override
  Widget build(BuildContext context) {

    return  Center ( child: Container(



      child: ListView(

          children: <Widget>[
            SizedBox(height: 40,),
            Center(child:
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Recorder()])
            )
            ,SizedBox(height: 50)
            ,



            Padding(
              padding: EdgeInsets.only(left: 150.0, right: 150.0),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.black,
                child: Text("Render"),
                onPressed: () async {
                  if (           File(GlobalVariable.recordFilePath ).existsSync()
                  ) {

                    var path = await _cutSong();
                    setState(() {
                      avl=true;


                      _cutFilePath = path;
                    });




                  } else {
                    avl=false;   }



                },
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
              ),
            )

            ,             audioPlayer(context)

            ,avl? Container(): Padding(
                padding: EdgeInsets.only(left: 110.0, right: 100.0),
                child:Text('No Recording Yet!' , textScaleFactor: 1.8,))

          ]),),);
  }


  Widget audioPlayer(BuildContext context)
  {
    return Container(
      padding: EdgeInsets.all(32.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [



        _cutFilePath == null
            ? Container()
            : MediaPlayerWidget(url: _cutFilePath, isLocal: true),


        avl?  Padding(
            padding: EdgeInsets.only(left: 100.0, right: 100.0),
            child: RaisedButton(
                textColor: Colors.white,
                color: Colors.black,
                child: Text("Share"),
                onPressed: (){

                })): Container(),


      ]),
    );
  }

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
