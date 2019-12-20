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
          // actions: <Widget>[
          //   Padding(
          //       padding: EdgeInsets.only(right: 20.0),
          //       child: GestureDetector(
          //         onTap: () {},
          //         child: Icon(Icons.exit_to_app),
          //       )),
          // ],
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              // Row(
              //   children: <Widget>[
              //     Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: <Widget>[
              //         Row(
              //           children: <Widget>[
              //             Container(
              //               padding: EdgeInsets.only(left: 15, top: 15),
              //               child: Text(
              //                 "Utente",
              //                 style: TextStyle(
              //                     fontStyle: FontStyle.italic, fontSize: 14),
              //               ),
              //             ),
              //           ],
              //         ),
              //         Row(
              //           children: <Widget>[
              //             Container(
              //               padding: EdgeInsets.only(left: 15, top: 10),
              //               child: Icon(Icons.face),
              //             ),
              //             Container(
              //               padding: EdgeInsets.only(left: 15, top: 10),
              //               child: Text(
              //                 "Cognome Nome",
              //                 style: TextStyle(
              //                     fontSize: 16, fontWeight: FontWeight.bold),
              //               ),
              //             ),
              //           ],
              //         )
              //       ],
              //     )
              //   ],
              // ),
              // Divider(),
              Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 15, top: 10),
                            child: Icon(Icons.message),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, top: 10),
                            child: Text(
                              "Feedback",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 15, top: 10),
                            child: Icon(Icons.help_outline),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, top: 10),
                            child: Text(
                              "Guida",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
