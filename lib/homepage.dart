import './models/operation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import './ports/command_operation_service.dart';
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

  Operation operation = Operation(
    title: "t",
    description: "d",
    date: new DateTime.now(),
    status: OperationStatus.LOCAL.toString(),
  );

  void testInsert() async {
    injector.get<CommandOperationService>().save(operation).then((id) {
      print("Inserimento op id: $id");
      testRead(id);
    });
  }

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
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  testInsert();
                },
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(Icons.more_vert),
              )),
        ],
      ),
      drawer: ConfDrawer(),
      body: Center(
        child: Container(
          child: _buildList(),
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

  List<Operation> _mockList() {
    List<Operation> result = new List<Operation>();
    result.add(new Operation(
        title: 'Incendio auto',
        date: new DateTime.now(),
        status: OperationStatus.LOCAL.toString(),
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ut odio cursus, volutpat augue et, dapibus erat....'));
    result.add(new Operation(
        title: 'Apertura Porta',
        date: new DateTime.now().add(Duration(days: 1)),
        status: OperationStatus.PARTIAL_UPLOAD.toString(),
        description:
            'Fusce faucibus nulla vitae arcu hendrerit, sed aliquam odio ornare.'));
    result.add(new Operation(
        title: 'Fuga Gas',
        date: new DateTime.now().add(Duration(days: 2)),
        status: OperationStatus.COMPLETED_UPLOAD.toString(),
        description:
            'Donec fermentum lobortis felis et tincidunt. Vivamus cursus scelerisque dignissim...'));
    result.add(new Operation(
        title: 'Incendio Sterpaglia',
        date: new DateTime.now().add(Duration(days: 3)),
        status: OperationStatus.COMPLETED_UPLOAD.toString(),
        description: 'Praesent egestas sagittis sodales.'));
    return result;
  }

  Widget _buildList() => ListView(
        children: _mockList().map((element) => _tile(element)).toList(),
      );

  ListTile _tile(Operation operation) => ListTile(
        title: Text(operation.title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(operation.description),
        isThreeLine: true,
        onTap: () {},
        leading: Icon(
          Icons.cloud_upload,
          color: (operation.status ==
                  OperationStatus.COMPLETED_UPLOAD.toString())
              ? Colors.green[500]
              : operation.status == OperationStatus.PARTIAL_UPLOAD.toString()
                  ? Colors.orange[500]
                  : Colors.red[500],
          size: 30,
        ),
      );
}
