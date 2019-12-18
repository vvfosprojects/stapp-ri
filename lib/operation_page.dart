import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_media_picker/multi_media_picker.dart' as multimediapicker;
import 'package:stapp_ri/models/media_type.dart';
import 'package:stapp_ri/widgets/audio_recorder.dart';

import 'models/media.dart';
import 'models/emergency_operation.dart';
import 'models/operation_status.dart';
import 'ports/command_operation_service.dart';

class OperationPage extends StatefulWidget {
  final EmergencyOperation _operation;

  OperationPage(this._operation);

  @override
  _OperationPageState createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> {
  final _formKey = GlobalKey<FormState>();

  final injector = Injector.getInjector();

  final format = DateFormat("dd/MM/yyyy HH:mm");

  EmergencyOperation currentOperation;

  int _picturesLen = 0;
  int _videoLen = 0;
  int _audioLen = 0;

  @override
  void initState() {
    if (widget._operation != null) {
      currentOperation = widget._operation;
      currentOperation.media = currentOperation.media ?? List<Media>();
      loadBadges();
    } else {
      currentOperation = EmergencyOperation(
          title: '',
          description: '',
          date: null,
          status: EmergencyOperationStatus.LOCAL.toString(),
          media: List<Media>());
    }
  }

  void loadBadges() {
    if (currentOperation.media != null && currentOperation.media.isNotEmpty) {
      _picturesLen = 0;
      _videoLen = 0;
      _audioLen = 0;
      for (var m in currentOperation.media) {
        if (m.type == MediaType.AUDIO.toString()) {
          _audioLen = _audioLen + 1;
        } else if (m.type == MediaType.PICTURE.toString()) {
          _picturesLen = _picturesLen + 1;
        } else {
          _videoLen = _videoLen + 1;
        }
      }
    }
  }

  Future _pickImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);

    setState(() {
      Media media = Media(
          name: image.uri.path,
          path: image.path.substring(image.path.lastIndexOf("/") + 1),
          type: MediaType.VIDEO.toString());

      insertMediaIfNotPresent(media);
    });
  }

  Future getImages() async {
    var images = await multimediapicker.MultiMediaPicker.pickImages(
        source: multimediapicker.ImageSource.gallery);

    setState(() {
      if (images != null) {
        for (var img in images) {
          Media media = Media(
              name: img.uri.path,
              path: img.path.substring(img.path.lastIndexOf("/") + 1),
              type: MediaType.PICTURE.toString());

          insertMediaIfNotPresent(media);
        }
      }
    });
  }

  Future _pickVideo(ImageSource source) async {
    var video = await ImagePicker.pickVideo(source: source);

    setState(() {
      Media media = Media(
          name: video.uri.path,
          path: video.path.substring(video.path.lastIndexOf("/") + 1),
          type: MediaType.VIDEO.toString());

      insertMediaIfNotPresent(media);
    });
  }

  void insertMediaIfNotPresent(Media media) {
    var contain = false;
    for (var m in this.currentOperation.media) {
      if (m.path == media.path && m.name == media.name) {
        contain = true;
      }
    }
    if (!contain) {
      print(media);
      this.currentOperation.media.add(media);
    }
    loadBadges();
  }

  void audioCallback(List<Media> media) {
    setState(() {
      print(media);
      this.currentOperation.media.addAll(media);
      loadBadges();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("StApp-RI - Intervento"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 6,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Inserimento Dati Intervento",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 6,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Inserire il titolo';
                              }
                              return null;
                            },
                            initialValue: currentOperation.title,
                            onChanged: (String value) {
                              this.currentOperation.title = value.trim();
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
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 6,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            minLines: 6,
                            maxLines: 8,
                            textAlign: TextAlign.left,
                            initialValue: currentOperation.description,
                            onChanged: (String value) {
                              this.currentOperation.description = value.trim();
                            },
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
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 5),
                          child: FlatButton(
                            child: Icon(Icons.calendar_today),
                            onPressed: () =>
                                datepick(context, this.currentOperation.date),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            currentOperation.date != null
                                ? DateFormat("dd/MM/yyyy HH:mm")
                                    .format(currentOperation.date)
                                : "Data non selezionata",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 5),
                          child: FlatButton(
                            child: Icon(Icons.pin_drop),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: currentOperation.coordinates != null
                                ? currentOperation.coordinates
                                : Text(
                                    "Posizione non selezionata",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black54),
                                  )),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _picturesLen > 0
                          ? Flexible(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.all(15),
                                child: Badge(
                                  badgeContent: Text(
                                    _picturesLen.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  child: Icon(
                                    Icons.photo_library,
                                    size: 40,
                                  ),
                                ),
                              ))
                          : Container(),
                      _videoLen > 0
                          ? Flexible(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.all(15),
                                child: Badge(
                                  badgeContent: Text(
                                    _videoLen.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  child: Icon(
                                    Icons.videocam,
                                    size: 40,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      _audioLen > 0
                          ? Flexible(
                              flex: 1,
                              child: Container(
                                  margin: EdgeInsets.all(15),
                                  child: Badge(
                                    badgeContent: Text(
                                      _audioLen.toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    child: Icon(
                                      Icons.audiotrack,
                                      size: 40,
                                    ),
                                  )))
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
          // Create an inner BuildContext so that the onPressed methods
          // can refer to the Scaffold with Scaffold.of().
          builder: (BuildContext context) {
        return FloatingActionButton(
            backgroundColor: Colors.lightGreen,
            onPressed: () {
              saveOperation(context);
            },
            tooltip: 'Salva',
            child: Icon(Icons.save_alt));
      }),
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
                getImages();
              },
            ),
            FlatButton(
              child: Icon(
                Icons.mic,
                color: Colors.black54,
              ),
              onPressed: () {
                showDialog(
                  child: AudioRecorder.withCallback(
                    callback: audioCallback,
                  ),
                  context: context,
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

  void saveOperation(context) async {
    if (_formKey.currentState.validate()) {
      print(currentOperation.media.toList());
      if (this.currentOperation.id != null) {
        injector
            .get<CommandOperationService>()
            .update(this.currentOperation)
            .then((id) {
          print("Salvataggio operation id: $id");
        });
      } else {
        injector
            .get<CommandOperationService>()
            .insert(this.currentOperation)
            .then((id) {
          print("Inserimento operation id: $id");
        });
      }
      final snackBar = SnackBar(content: Text('Salvataggio effettuato!'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void datepick(context, currentValue) async {
    final date = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: currentValue ?? DateTime.now(),
        lastDate: DateTime(2100));
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
      );
      var dateTime = DateTime(
          date.year, date.month, date.day, time?.hour ?? 0, time?.minute ?? 0);
      this.currentOperation.date = dateTime;
      setState(() {
        this.currentOperation.date = dateTime;
      });
    }
  }
}
