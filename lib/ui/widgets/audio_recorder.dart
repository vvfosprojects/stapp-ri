import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:stapp_ri/domain/entity/media.dart';
import 'package:stapp_ri/domain/entity/media_type.dart';

class AudioRecorder extends StatefulWidget {
  Function _callback;

  AudioRecorder();

  AudioRecorder.withCallback({callback}){
    this._callback = callback;
  }

  @override
  _AudioRecorderState createState() => new _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  bool _isRecording = false;
  bool _isPlaying = false;
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound;

  String _recorderTxt = '00:00:00';
  String _playerTxt = '00:00:00';
  double _dbLevel;

  double slider_current_position = 0.0;
  double max_duration = 1.0;

  String _fileName;
  String _filePath;
  Media _media;

  List<Media> _opAudioFiles;

  @override
  void initState() {
    super.initState();
    flutterSound = new FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);
    _opAudioFiles = List<Media>();
  }

  void startRecorder() async {
    try {
      stopPlayer();
      String fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + '.aac';

      setState(() {
        _media = Media(name: fileName, type: MediaType.AUDIO.toString());
      });

      String path =
          await flutterSound.startRecorder(_media.name).catchError((error) {
        print(error);
      });

      _media.path = path;
      _opAudioFiles.add(_media);
      widget._callback(_opAudioFiles);
      print('startRecorder: ${_media.path}');

      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            e.currentPosition.toInt(),
            isUtc: true);
        String txt = DateFormat('mm:ss:SS').format(date);

        this.setState(() {
          this._recorderTxt = txt.substring(0, 8);
        });
      });
      _dbPeakSubscription =
          flutterSound.onRecorderDbPeakChanged.listen((value) {
        print("got update -> $value");
        setState(() {
          this._dbLevel = value;
        });
      });

      this.setState(() {
        this._isRecording = true;
      });
    } catch (err) {
      print('startRecorder error: $err');
    }
  }

  void stopRecorder() async {
    try {
      String result = await flutterSound.stopRecorder();
      print('stopRecorder: $result');

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }
      if (_dbPeakSubscription != null) {
        _dbPeakSubscription.cancel();
        _dbPeakSubscription = null;
      }

      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  void startPlayer() async {
    print(_media.path);
    String path = await flutterSound.startPlayer(_media.path);
    await flutterSound.setVolume(1.0);
    print('startPlayer: $path');

    try {
      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
        if (e != null) {
          slider_current_position = e.currentPosition;
          max_duration = e.duration;

          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
              e.currentPosition.toInt(),
              isUtc: true);
          String txt = DateFormat('mm:ss:SS').format(date);
          this.setState(() {
            this._isPlaying = true;
            this._playerTxt = txt.substring(0, 8);
          });
        }
      });
    } catch (err) {
      print('error: $err');
    }
  }

  void stopPlayer() async {
    try {
      String result = await flutterSound.stopPlayer();
      print('stopPlayer: $result');
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }

      this.setState(() {
        this._isPlaying = false;
      });
    } catch (err) {
      print('error: $err');
    }
  }

  void pausePlayer() async {
    String result = await flutterSound.pausePlayer().catchError((onError) {
      print(onError);
    });
    print('pausePlayer: $result');
  }

  void resumePlayer() async {
    String result = await flutterSound.resumePlayer();
    print('resumePlayer: $result');
  }

  void seekToPlayer(int milliSecs) async {
    String result = await flutterSound.seekToPlayer(milliSecs);
    print('seekToPlayer: $result');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Registratore Audio'),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 24.0, bottom: 16.0),
                child: Text(
                  this._recorderTxt,
                  style: TextStyle(
                    fontSize: 48.0,
                    color: Colors.black,
                  ),
                ),
              ),
              _isRecording
                  ? LinearProgressIndicator(
                      value: 100.0 / 160.0 * (this._dbLevel ?? 1) / 100,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      backgroundColor: Colors.red,
                    )
                  : Container()
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: 64.0,
                height: 64.0,
                margin: EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  onPressed: () {
                    if (!this._isRecording) {
                      return this.startRecorder();
                    }
                    this.stopRecorder();
                  },
                  child: this._isRecording ? Icon(Icons.stop) : Icon(Icons.mic),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30.0, bottom: 16.0),
                child: Text(
                  this._playerTxt,
                  style: TextStyle(
                    fontSize: 48.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: 56.0,
                height: 56.0,
                margin: EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    startPlayer();
                  },
                  child: Icon(Icons.play_arrow),
                ),
              ),
              Container(
                width: 56.0,
                height: 56.0,
                margin: EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    pausePlayer();
                  },
                  child: Icon(Icons.pause),
                ),
              ),
              Container(
                width: 56.0,
                height: 56.0,
                margin: EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    stopPlayer();
                  },
                  child: Icon(Icons.stop),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 56.0,
                width: MediaQuery.of(context).size.width,
                child: Slider(
                  value: slider_current_position,
                  min: 0.0,
                  max: max_duration,
                  onChanged: (double value) async {
                    seekToPlayer(value.toInt());
                  },
                  divisions: max_duration.toInt(),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                child: ListView(
                  children:
                      _opAudioFiles.map((element) => _tile(element)).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tile(Media media) => ListTile(
        title: Text(media.name),
        subtitle: Platform.isAndroid ? Text(media.path): Text(''),
        leading: Icon(Icons.audiotrack),
        onTap: () => _selectFileToPlay(media),
        selected: media.path==_media.path,
      );

  void _selectFileToPlay(Media media) {
    _media = media;
  }
}
