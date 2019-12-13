import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:stapp_ri/widgets/audio_recorder.dart';

class OperationPage extends StatefulWidget {
  @override
  _OperationPageState createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> {
  bool _showModalAudio = false;
  File _image;
  File _video;

  List<Asset> images = List<Asset>();
  String _error;

  void _registerAudio() async {}

  Future _pickImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);

    setState(() {
      _image = image;
    });
  }

  Future<void> _pickImages() async {
    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }

  Future _pickVideo(ImageSource source) async {
    var video = await ImagePicker.pickVideo(source: source);

    setState(() {
      _video = video;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stapp-RI - Intervento"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(Icons.more_vert),
              )),
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Inserimento Dati Intervento",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 26,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        labelText: "titolo",
                        labelStyle: TextStyle(
                            color: Colors.black38,
                            fontSize: 14,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      minLines: 8,
                      maxLines: 12,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        labelText: "Descrizione",
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                            color: Colors.black38,
                            fontSize: 14,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        labelText: "Data",
                        labelStyle: TextStyle(
                            color: Colors.black38,
                            fontSize: 14,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 5,
                      left: 5,
                    ),
                    margin: EdgeInsets.only(top: 15),
                    child: Row(
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Icon(
                            Icons.pin_drop,
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                        Text("Inserisci Posizione"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              child: Icon(
                Icons.photo_library,
                color: Colors.black54,
              ),
              onPressed: () {
                _pickImages();
              },
            ),
            FlatButton(
              child: Icon(
                Icons.mic,
                color: Colors.black54,
              ),
              onPressed: () {
                 showDialog(
                  child: AudioRecorder(), context: context,
                );
              },
            ),
            FlatButton(
              child: Icon(
                Icons.videocam,
                color: Colors.black54,
              ),
              onPressed: () {
                _pickVideo(ImageSource.camera);
              },
            ),
            FlatButton(
              child: Icon(
                Icons.photo_camera,
                color: Colors.black54,
              ),
              onPressed: () {
                _pickImage(ImageSource.camera);
              },
            )
          ],
        ),
      ),
    );
  }
}
