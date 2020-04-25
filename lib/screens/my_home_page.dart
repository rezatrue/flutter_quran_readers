import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';


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
        child: ListView(
          children: <Widget>[
            Text(
              'Assalamualikum, my Dear Muslim brothers & sisters',
              textAlign: TextAlign.center,
            ),
            RaisedButton(child: Text('GET DATA'), 
            onPressed: null,
            ),
            
          ],
        ),
      ),

    );
  }
}
