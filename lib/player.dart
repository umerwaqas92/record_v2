import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import './recorder.dart';
import 'package:audiocutter/audiocutter.dart';

enum PlayerState { stopped, playing, paused }

class MediaPlayerWidget extends StatefulWidget {
  final String url;
  final bool isLocal;
  final PlayerMode mode;
  SolidController _controller ;


  MediaPlayerWidget(
      {@required 
      this.url,
      this.isLocal = false,
      this.mode = PlayerMode.MEDIA_PLAYER,

      });

  @override
  State<StatefulWidget> createState() {
    return _MediaPlayerState(url, isLocal, mode,);
  }
}



class _MediaPlayerState extends State<MediaPlayerWidget> {
  String url;
  bool isLocal;
  PlayerMode mode;

  AudioPlayer _audioPlayer;
  Duration _duration;
  Duration _position;
  double _lowerValue = 0;
  double _upperValue = 180;
  double _lowerValue2 = 0;
  double _upperValue2= 0;

  
  Future<String> _url;
  String _cutFilePath;





  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;

  get _durationText => _duration?.toString()?.split('.')?.first ?? '';

  get _positionText => _position?.toString()?.split('.')?.first ?? '';

get lowerValueText => _lowerValue?.toString()?.split('.')?.first ?? '';

 


  _MediaPlayerState(this.url, this.isLocal, this.mode, );
bool pressed = false;
 bool trimmer = false;
 bool cutterNew = false;
  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    Timer(Duration(milliseconds: 100), (){
      _play();

    });

    print("playing file " +url);

    
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  /// Returns the slider value.
  /// 
 double _getDurationValue() {
    
return (_duration.inSeconds).toDouble();
  }

  double _getSliderValue() {
    if (_position == null || _position.inSeconds <= 0) {
      return 0.0;
    }

    return (_position >= _duration ? _duration.inSeconds : _position.inSeconds).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Card(


        color: Colors.white70,
        child: Column(mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row( mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[


          IconButton(icon: Icon(Icons.fast_rewind), iconSize: 50, splashColor: Colors.teal, onPressed: (){if (_position<Duration(seconds:05)) {
            _seek(_position= Duration(seconds:0));

          } else {_seek( _position= _position - Duration(seconds:05));
          }



          }),




          IconButton(
              icon: _isPlaying ? Icon(Icons.pause_circle_outline, color: Colors.red,) : Icon(Icons.play_circle_outline, color: Colors.teal,),
              iconSize: 90.0,

              onPressed: () => _isPlaying ? _pause() : _play()),

              IconButton(icon: Icon(Icons.fast_forward), iconSize: 50, splashColor: Colors.teal, onPressed: (){if (_duration -_position < Duration(seconds:05)) {
            _seek(_position= _duration);

          } else {_seek( _position= _position + Duration(seconds:05));
          }



          }),

          ]),
          Container(
              child: Text(
                  _position != null
                      ? '${_positionText ?? ''} / ${_durationText ?? ''}'
                      : _duration != null ? _durationText : '0:00:00/0:00:00',
                  textAlign: TextAlign.left)),

          Row(mainAxisSize: MainAxisSize.max, children: <Widget>[





            Expanded(
                child:



                pressed ?
                 FlutterSlider(
  values: [_getSliderValue(), _getDurationValue()],
  rangeSlider: true,
  max: _getDurationValue(),
  min: 0,


  onDragging: (handlerIndex, lowerValue, upperValue) {

        setState(() {

          _lowerValue = lowerValue;
          _upperValue = upperValue;
          _lowerValue2 = lowerValue;
          _upperValue2 = upperValue;
          print("saving audio start"+lowerValue.toString());
          print("saving audio end"+upperValue.toString());

        });
  },


tooltip: FlutterSliderTooltip(
  custom: (value)
          {
            return Text(Duration( seconds: value.toInt()).toString()?.split('.')?.first ?? '');
          },
          boxStyle: FlutterSliderTooltipBox(
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.7)

          )
          ,
          )
)):

Slider(
                    value: _getSliderValue(),
                    max: _duration != null ? _duration.inSeconds.toDouble() : 0.0,
                    onChanged: (double newValue) =>
                        _seek(Duration(seconds: newValue.ceil()))
                        )
                        ),
                        ]
          ),
        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[

               IconButton(icon: Icon(Icons.content_cut, size: 25,),color: Colors.black, onPressed: ()
{setState(() {
                    pressed = true;
                  });}
),
               Expanded(child: Container()),
               pressed? SizedBox(): IconButton(icon: Icon(Icons.share, size: 35,),color: Colors.black, onPressed:
                   () async {

                      var file=File(url);

                      var title=file.path.split('/').last;
                     final ByteData bytes = await ByteData.view(File(url).readAsBytesSync().buffer);

                     await Share.file('Share recoding', title, bytes.buffer.asUint8List(), 'audio/*', text: 'My optional text.');



                   }
               ),
                        pressed ?
                        IconButton(icon: Icon(Icons.done), onPressed: (){setState(() async {
                          var path = await _cutSong();
                              setState(() async {


                                _cutFilePath = path;
                                url=path;

                                var pathnew= await getExternalStorageDirectory();

                              await File(_cutFilePath).copy(pathnew.path+"/output.mp3");
                              File(path).delete();


                                print("file cut to "+_cutFilePath);
                               initState();


                              });
                    pressed = false;
                    cutterNew = true;



                    });})

                  :SizedBox(),

                        ],
                        )
                        ]
        ),
      ),
    );
  }
Future<String> _cutSong() async {
                var start = _lowerValue.toString();
                var end = _upperValue.toString();
                String path = url;


            
                // Close the keyboard.
                FocusScope.of(context).requestFocus(FocusNode());
            
                return await AudioCutter.cutAudio(
                    path, _lowerValue2, _upperValue2);
              }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription =
        _audioPlayer.onDurationChanged.listen((duration) => setState(() {
              _duration = duration;
            }));

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

  }




  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;


    // Close the keyboard.
    FocusScope.of(context).requestFocus(FocusNode());

    final result =
        await _audioPlayer.play(url, isLocal: isLocal, position: playPosition);
    if (result == 1) setState(() => _playerState = PlayerState.playing);
    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  Future<int> _seek(Duration position) async {
    return await _audioPlayer.seek(position);
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }
  
}





