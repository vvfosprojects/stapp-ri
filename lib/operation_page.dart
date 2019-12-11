import 'package:flutter/material.dart';

class OperationPage extends StatefulWidget {
  @override
  _OperationPageState createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> {
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
                    padding: EdgeInsets.only(top: 5, left: 5,),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_library,
              color: Colors.black54,
            ),
            title: Text('Gallery'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mic,
              color: Colors.black54,
            ),
            title: Text('Audio'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.videocam,
              color: Colors.black54,
            ),
            title: Text('Video'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
              color: Colors.black54,
            ),
            title: Text('Foto'),
          ),
        ],
        currentIndex: 1,
        type: BottomNavigationBarType.shifting,
        fixedColor: Colors.black54,
        unselectedLabelStyle: TextStyle(color: Colors.black54),
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black54,
        onTap: (_) {},
      ),
    );
  }
}
