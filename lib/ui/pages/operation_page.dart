import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_media_picker/multi_media_picker.dart' as multimediapicker;
import 'package:stapp_ri/domain/entities/emergency_operation.dart';
import 'package:stapp_ri/domain/entities/media.dart';
import 'package:stapp_ri/domain/entities/media_type.dart';
import 'package:stapp_ri/domain/entities/operation_status.dart';
import 'package:stapp_ri/domain/ports/save_em_op_usecase_port.dart';
import 'package:stapp_ri/ui/widgets/audio_recorder.dart';
import 'package:stapp_ri/ui/widgets/confirm_action.dart';

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

  var _isModified = false;

  FocusNode _focusNode;

  EmergencyOperation currentOperation;

  int _picturesLen = 0;
  int _videoLen = 0;
  int _audioLen = 0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    if (widget._operation != null) {
      currentOperation = widget._operation;
      currentOperation.media = currentOperation.media ?? List<Media>();
      loadBadges();
    } else {
      currentOperation = EmergencyOperation(
          title: '',
          description: '',
          date: DateTime.now(),
          status: EmergencyOperationStatus.LOCAL.toString(),
          media: List<Media>());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
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
          type: MediaType.PICTURE.toString());

      insertMediaIfNotPresent(media);
    });
  }

  Future getImages() async {
    var images = await multimediapicker.MultiMediaPicker.pickImages(
        source: multimediapicker.ImageSource.gallery);

    setState(() {
      if (images != null) {
        _isModified = true;
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
      _isModified = true;
      loadBadges();
    });
  }

  Future<List<Media>> fetchMedia() async {
    return await Future(() => currentOperation.media);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("StApp-RI - Intervento"),
        leading: GestureDetector(
          onTap: () {
            _isModified
                ? showDialog<ConfirmAction>(
                    context: context,
                    barrierDismissible:
                        false, // user must tap button for close dialog!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Attenzione'),
                        content: const Text(
                            'Modifiche non salvate. Salvare prima di uscire?'),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text(
                              'No',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(ConfirmAction.CANCEL);
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: const Text(
                              'Si',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(ConfirmAction.ACCEPT);
                              saveOperation(context);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    },
                  )
                : Navigator.pop(context);
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
                              _isModified = true;
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
                            focusNode: _focusNode,
                            //minLines: 6,
                            maxLines: null,
                            autofocus: false,
                            textInputAction: TextInputAction.done,
                            textAlign: TextAlign.left,
                            initialValue: currentOperation.description,
                            onChanged: (String value) {
                              _isModified = true;
                              this.currentOperation.description = value.trim();
                            },
                            onEditingComplete: () {
                              _isModified = true;
                              _focusNode.unfocus();
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
            new FutureBuilder<List<Media>>(
              future: fetchMedia(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? new GridView.count(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 4,
                        childAspectRatio: 0.99,
                        children: List.generate(snapshot.data.length, (index) {
                          return Container(
                            margin: EdgeInsets.all(8),
                            child: FlatButton(
                              onPressed: () {},
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    (snapshot.data[index].type
                                        .replaceAll("MediaType.", "")),
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Icon(Icons.flag),
                                ],
                              ),
                            ),
                            color: Colors.white,
                          );
                        }),
                      )
                    : new Center(child: new CircularProgressIndicator());
              },
            ),
            Container(
              height: 50,
            )
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
              saveOperation(context, showSnackBar: true);
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
                  child: AudioRecorder(
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

  void saveOperation(context, {showSnackBar}) async {
    if (_formKey.currentState.validate()) {
      try {
        await injector.get<SaveEmOpUsecasePort>()
            .save(this.currentOperation)
            .then((savedOp) {
          setState(() {
            this.currentOperation = savedOp;
          });
          _isModified = false;
          if (showSnackBar ?? false) {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Salvataggio effettuato!')));
          }
        });
      } catch (error) {
        print(error);
      }
    }
  }

  void datepick(context, currentValue) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      initialDate: currentValue ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
      );
      var dateTime = DateTime(
          date.year, date.month, date.day, time?.hour ?? 0, time?.minute ?? 0);
      setState(() {
        _isModified = true;
        this.currentOperation.date = dateTime;
      });
    }
  }
}
