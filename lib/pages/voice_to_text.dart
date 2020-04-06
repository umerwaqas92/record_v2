
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Voice_to_Text extends StatefulWidget {
  @override
  _Voice_to_TextState createState() => _Voice_to_TextState();
}




class _Voice_to_TextState extends State<Voice_to_Text> {


  String word_loaded="";
  bool _status=false;
  stt.SpeechToText speech ;


  Future<void> start_listing  () async {


     speech = stt.SpeechToText();
    bool available = await speech.initialize( onStatus: (status){
      if(status == "listening"){
        _status=true;
      }
      if(status == "notListening"){
        _status=false;
      }
      print("status "+status);
      setState(() {

      });

    });


    if ( available ) {
      speech.listen( onResult: (result){

//        if(result.confidence>0.5){
          word_loaded=result.recognizedWords;
//        }

        print(result.alternates.toString());
        setState(() {

        });

      } );
    }
    else {
      print("The user has denied the use of speech recognition.");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    start_listing();

  }

  Widget get(){
     if(_status){
    return  Container(
        width: 150,
        height: 150,
        child: SpinKitRipple(
          color: Colors.red,
          size: 200,
          borderWidth: 50,


        ),
      );
    }else{
       return  Container(
         width: 150,
         height: 150,

       );
  }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 200, 20, 0),
        child: Column(
          children: <Widget>[
            Center(child: Text("Speech to text",style: TextStyle(color: Colors.teal,fontSize: 25,),)),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.fromLTRB(100,0,100,10),

            ),
            Container(

              height: 200,
              width: 400,

              child: TextField(
                maxLines: 20,




                controller: TextEditingController(text: word_loaded),
               style: TextStyle(fontSize: 20,letterSpacing: 1),


                decoration:InputDecoration(
                  fillColor: Colors.white70,
                  filled: true,

                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.teal)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.teal)
                  ),







                ) ,
              ),
            ),
            SizedBox(height: 100),
            Stack(
              children: <Widget>[
                get(),

                Container(
                  width: 150,
                  height: 150,
                  padding: EdgeInsets.all(30),
                  child: MaterialButton(


                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                    color: Colors.white70,
                    onPressed: (){
                      if(!_status){
                        start_listing();
                      }else{
                        speech.stop();

                      }



                    },
                      splashColor: Colors.teal,
                    child:Icon(
                      _status?Icons.mic_off:Icons.mic ,
                      color: _status?Colors.red:Colors.teal,
                      size: 50,
                    )

                  ),
                ),
              ],
            ),

          ],
        ),

      ),
    );
  }
}
