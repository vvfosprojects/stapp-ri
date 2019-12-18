import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stapp_ri/models/emergency_operation.dart';
import 'package:stapp_ri/models/operation_status.dart';

import '../operation_page.dart';

class SlidealbeTile extends StatelessWidget {
  
  final EmergencyOperation eOp;
  Function deleteCalback;
  Function uploadCalback;

  SlidealbeTile(this.eOp, {this.deleteCalback, this.uploadCalback});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: _tile(eOp, context),
      ),
      actions: <Widget>[
        // IconSlideAction(
        //   caption: 'Archive',
        //   color: Colors.blue,
        //   icon: Icons.archive,
        //   onTap: () => {},
        // ),
        IconSlideAction(
          caption: 'Carica',
          color: Colors.indigo,
          icon: Icons.cloud_upload,
          onTap: () => {},
        ),
      ],
      secondaryActions: <Widget>[
        // IconSlideAction(
        //   caption: 'More',
        //   color: Colors.black45,
        //   icon: Icons.more_horiz,
        //   onTap: () => {},
        // ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => {},
        ),
      ],
    );
  }

  ListTile _tile(EmergencyOperation operation, context) => ListTile(
        title: Text(operation.title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(operation.description),
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
              : operation.status ==
                      EmergencyOperationStatus.PARTIAL_UPLOAD.toString()
                  ? Colors.orange[500]
                  : Colors.red[500],
          size: 30,
        ),
      );
}
