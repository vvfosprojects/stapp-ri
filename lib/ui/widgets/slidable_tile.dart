import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stapp_ri/data/helpers/string_utils.dart';
import 'package:stapp_ri/domain/entities/emergency_operation.dart';
import 'package:stapp_ri/domain/entities/operation_status.dart';
import 'package:stapp_ri/ui/pages/operation_page.dart';

class SlidealbeTile extends StatelessWidget {
  final EmergencyOperation eOp;
  final Function deleteCallback;
  final Function uploadCalback;

  SlidealbeTile(this.eOp, {this.deleteCallback, this.uploadCalback});

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
          onTap: () => uploadCalback(eOp),
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
          onTap: () => deleteCallback(eOp.id),
        ),
      ],
    );
  }

  ListTile _tile(EmergencyOperation operation, context) => ListTile(
        title: Text(truncateString(operation.title, 40),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(truncateString(operation.description, 100)),
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
