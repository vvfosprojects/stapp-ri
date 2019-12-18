import 'package:stapp_ri/operation_page.dart';
import 'package:stapp_ri/widgets/slidable_tile.dart';

import './models/emergency_operation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import './models/operation_status.dart';
import './ports/query_operation_service.dart';
import './widgets/conf_drawer.dart';

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

  List<EmergencyOperation> _loadOperations;

  Future loadOperations() async {
    return await injector.get<QueryOperationService>().readAll();
  }

  List<EmergencyOperation> _mockList() {
    List<EmergencyOperation> result = new List<EmergencyOperation>();
    result.add(new EmergencyOperation(
        title: 'Incendio auto',
        date: new DateTime.now(),
        status: EmergencyOperationStatus.LOCAL.toString(),
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ut odio cursus, volutpat augue et, dapibus erat....'));
    result.add(new EmergencyOperation(
        title: 'Apertura Porta',
        date: new DateTime.now().add(Duration(days: 1)),
        status: EmergencyOperationStatus.PARTIAL_UPLOAD.toString(),
        description:
            'Fusce faucibus nulla vitae arcu hendrerit, sed aliquam odio ornare.'));
    result.add(new EmergencyOperation(
        title: 'Fuga Gas',
        date: new DateTime.now().add(Duration(days: 2)),
        status: EmergencyOperationStatus.COMPLETED_UPLOAD.toString(),
        description:
            'Donec fermentum lobortis felis et tincidunt. Vivamus cursus scelerisque dignissim...'));
    result.add(new EmergencyOperation(
        title: 'Incendio Sterpaglia',
        date: new DateTime.now().add(Duration(days: 3)),
        status: EmergencyOperationStatus.COMPLETED_UPLOAD.toString(),
        description: 'Praesent egestas sagittis sodales.'));
    return result;
  }

  Widget _buildList() => ListView(
        children: _mockList().map((element) => _tile(element)).toList(),
      );

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
                } else if(snapshot.data.length >0) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      EmergencyOperation eOp = snapshot.data[index];
                      return Column(
                        children: <Widget>[
                          //_tile(eOp)
                          SlidealbeTile(eOp),
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

  ListTile _tile(EmergencyOperation operation) => ListTile(
        title: Text(operation.title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(operation.description),
        isThreeLine: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OperationPage(operation),
            ),
          );
        },
        leading: Icon(
          Icons.cloud_upload,
          color: (operation.status ==
                  EmergencyOperationStatus.COMPLETED_UPLOAD.toString())
              ? Colors.green[500]
              : operation.status == EmergencyOperationStatus.PARTIAL_UPLOAD.toString()
                  ? Colors.orange[500]
                  : Colors.red[500],
          size: 30,
        ),
      );
}
