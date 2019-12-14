import 'package:flutter/material.dart';

class ConfDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
          width: MediaQuery.of(context).size.width * .74,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Configurazione"),
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
              Text("TODO")
            ],
          ),
        ),
      ),
    );
  }
}
