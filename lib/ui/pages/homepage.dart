import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:stapp_ri/domain/entities/emergency_operation.dart';
import 'package:stapp_ri/domain/entities/operation_status.dart';
import 'package:stapp_ri/domain/ports/command_operation_service.dart';
import 'package:stapp_ri/domain/ports/query_operation_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:stapp_ri/ui/widgets/conf_drawer.dart';
import 'package:stapp_ri/ui/widgets/confirm_action.dart';
import 'package:stapp_ri/ui/widgets/slidable_tile.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final injector = Injector.getInjector();

  EmergencyOperation operation = EmergencyOperation(
    title: '',
    description: '',
    date: new DateTime.now(),
    status: EmergencyOperationStatus.LOCAL.toString(),
  );

  void testRead(int id) async {
    injector.get<QueryOperationService>().read(id).then((op) {
      print(
          "OP: ${op.id} ${op.title} ${op.description} ${op.status} ${op.coordinates} ${op.date}");
    });
    injector.get<QueryOperationService>().readAll().then((ops) {
      ops.map((op) {
        print(
            "OP: ${op.id} ${op.title} ${op.description} ${op.status} ${op.coordinates} ${op.date}");
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: ConfDrawer(),
      body: Center(
        child: Container(
          child: _buildListFromDB(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/operation');
        },
        tooltip: 'Crea Nuovo Intervento',
        child: Icon(Icons.add),
      ),
    );
  }

  Future loadOperations() async {
    return await injector.get<QueryOperationService>().readAll();
  }

  Widget _buildListFromDB() => FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.done:
              {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data.length > 0) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      EmergencyOperation eOp = snapshot.data[index];
                      return Column(
                        children: <Widget>[
                          //_tile(eOp)
                          SlidealbeTile(
                            eOp,
                            deleteCallback: deleteEO,
                            uploadCalback: uploadEOp,
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return Text("Nessun intervento presente");
                }
              }
              break;
            case ConnectionState.active:
              break;
          }
        },
        future: loadOperations(),
      );

  void deleteEO(int id) async {
    await injector.get<CommandOperationService>().delete(id).then((result) {
      setState(() {
        print("Eliminazione id: $result effettata");
        loadOperations();
      });
    });
  }

  void uploadEOp(EmergencyOperation eOp) async {
    // Scanning Bar Code or QR Code return content
    showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width * .74,
            height: MediaQuery.of(context).size.width * .85,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top:10,),
                  child: Text(
                    'Inserisci codice OTP',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'Annulla',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(ConfirmAction.CANCEL);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'Ok',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(ConfirmAction.ACCEPT);
                      },
                    )
                  ],
                ),
                Container( margin: EdgeInsets.only(top: 30), child: Text('Oppure', style: TextStyle(fontSize: 18))),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 15),
                  child: Text('Scansiona QRCode',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                FlatButton(
                  child: Icon(Icons.public, size: 40, color: Colors.indigo,),
                  onPressed: () {
                    Navigator.of(context).pop(ConfirmAction.ACCEPT);
                    scan(eOp);
                  },
                ),
              ],
              ),
            ),
        );
      },
    );
  }

  void otp(eOp) {
    //TODO
    print("otp $eOp");
  }

  void scan(eOp) async {
    String qrCode = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false, ScanMode.QR);
    sendHTTP(eOp, qrCode);
  }

  void sendHTTP(eOp, qrCode) {
    print("Sending through HTTP $eOp");
  }
}
