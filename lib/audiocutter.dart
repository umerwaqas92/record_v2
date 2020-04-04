import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

/// An audio cutting class that will clip audio files into specified chunks.
class AudioCutter {
  static const MethodChannel _channel = const MethodChannel('audiocutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Cuts the audio from [path].
  ///
  /// Returns a the path of the cut audio, specified by the [start] and [end] in
  /// seconds, cut from the original audio source.
  ///
  /// Throws an [ArgumentError] if the [end] time is after the [start] time.
  /// Throws an [ArgumentError] if the [start] or [end] are negative.
  static Future<String> cutAudio2(String path, double start, double end) async {
    if (start < 0.0 || end < 0.0) {
      throw ArgumentError('Cannot pass negative values.');
    }

    if (start > end) {
      throw ArgumentError('Cannot have start time after end.');
    }

    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

    final Directory dir = await getExternalStorageDirectory();
    var title="out.mp3";//path.split('/').last;

    final outPath2 = "${dir.path}/"+title;
    print("saving audio toc"+outPath2);
    print("saving audio start"+start.toString());
    print("saving audio end"+end.toString());


    var cmd =
        "-y -i \"$path\"  -af \"volume=enable='between(t,$start,$end)':volume=1\"  $outPath2";
    int rc = await _flutterFFmpeg.execute(cmd);


    if (rc != 0) {
     SnackBar(
            content: Text('No Recording yet!'));
            
    }

    return outPath2;
    
  }

}