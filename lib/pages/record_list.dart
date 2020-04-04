
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audiocutter_example/audioplaybar.dart';
import 'package:audiocutter_example/player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';

import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';


class Record_List extends StatefulWidget {
  @override
  _Record_ListState createState() => _Record_ListState();
}



class _Record_ListState extends State<Record_List> {


  List<io.File> files=List();

  void _listofFiles() async {
    var directory = (await getExternalStorageDirectory()).path;
      List<io.FileSystemEntity> loadedfiles = io.Directory("$directory").listSync();  //use your folder name insted of resume.
  loadedfiles.forEach((file){
    files.add(File(file.absolute.path));
  });

   print(files.length.toString()+" files");
   setState(() {

   });

  }

  SolidController _controller = SolidController();

  String _selectfFile="";
  int selection =-1;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listofFiles();

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
    bottomSheet: SolidBottomSheet(

      body:  MediaPlayerWidget(url: _selectfFile, isLocal: true,),
      controller: _controller,
      draggableBody: true,
      maxHeight: 250,

    ),
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,


      body: Padding(
        padding: const EdgeInsets.fromLTRB(10,100,10,0),
        child: ListView.builder(
          itemCount: files.length,



          itemBuilder: (context, index) {
            var title=files[index].path.split('/').last;



            return Card(
              color:index==selection?Colors.teal:Colors.white70,
              child: ListTile(

                onTap: () async {


                   _selectfFile=  files[index].path;
                   selection=index;




                   Timer(Duration(milliseconds: 100), () {
                     print("selected" +_selectfFile);
                     _controller.show();

                   });
                   setState(() {

                   });


                },
                title: Text(title,style: TextStyle(color: Colors.black)),
                leading: Icon(
                  Icons.audiotrack,
                  color: Colors.black87,
                ),
                subtitle: Text("size "+(files[index].lengthSync()/1024).toString()+" kb",style: TextStyle(color: Colors.black87),),
                trailing: IconButton(
                  onPressed: () async {
                   await files[index].delete();
                   files.removeAt(index);


//                final ByteData bytes = await ByteData.view(files[index].readAsBytesSync().buffer);
//
//                await Share.file('esys image', title, bytes.buffer.asUint8List(), 'audio/*', text: 'My optional text.');

                   setState(() {

                   });

                  },

                  icon: Icon(
                      Icons.delete,
                    color: Colors.black87,
                  ),
                ),
              ),
            );
          },
        ),
      )

    );
  }
}
