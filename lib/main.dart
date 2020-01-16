import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:stapp_ri/configuration/module_container.dart';
import 'package:stapp_ri/ui/pages/credits.dart';
import 'package:stapp_ri/ui/pages/homepage.dart';
import 'package:stapp_ri/ui/pages/operation_page.dart';

void main() {
  // Initialization Dependency Injection
  final injector = ModuleContainer().initialise(Injector.getInjector());
  runApp(StatRiApp());
}

class StatRiApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('it'),
      ],
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        '/homepage': (context) => Homepage(),
        '/operation': (context) => OperationPage(null),
        '/credits': (context) => Credits()
      },
      title: 'StApp-RI APP',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Splash(title: 'StApp-RI - Interventi'),
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
          'images/600px-Logo_del_Corpo_Nazionale_dei_Vigili_del_Fuoco.png'),
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
