import 'package:flutter/material.dart';
import './widgets/main_drawer.dart';
import './widgets/test_drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String appName = 'Al-Quran';
  final String source = 'alquran.cloud';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$appName readers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blueGrey,
      ),
      home: MyHomePage(title: appName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.menu), 
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
            print("Hay!! Hello");
          },
        ),
      ),
      drawer: MainDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Assalamualikum, my Dear Muslim brothers & sisters',
            ),
          ],
        ),
      ),

    );
  }
}
