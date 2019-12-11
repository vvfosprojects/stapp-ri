import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'credits.dart';
import 'homepage.dart';
import 'operation_page.dart';

void main() => runApp(StatRiApp());

class StatRiApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        '/homepage': (context) => Homepage(),
        '/operation': (context) => OperationPage(),
        '/credits' : (context) => Credits()
      },
      title: 'Stapp-RI APP',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Splash(title: 'Stapp-RI - Interventi'),
    );
  }
}

class Splash extends StatefulWidget {
  Splash({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 1,
      navigateAfterSeconds: new Homepage(
        title: widget.title,
      ),
      title: new Text(
        'STAPP-RI',
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 40.0,
          color: Colors.red,
        ),
      ),
      image: new Image.asset(
          'images/600px-Logo_del_Corpo_Nazionale_dei_Vigili_del_Fuoco.svg.png'),
      gradientBackground: new LinearGradient(
          colors: [Colors.white, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      onClick: () {},
      loaderColor: Colors.red,
    );
  }
}
