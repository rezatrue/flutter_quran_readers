import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';
import '../providers/sura_audio.dart';
import 'package:provider/provider.dart';

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
    var suraAudio = Provider.of<SuraAudio>(context, listen: false);

    Future<void> _update() {
      return suraAudio.getAudio().then((_){
        setState(() {         
        });
      });

      
    }
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
            RaisedButton(child: Text('GET DATA'), 
            onPressed: _update,
            ),
            suraAudio.sura == null ? Text('No test found')  : Container(
              padding: EdgeInsets.all(10),
              child:  
                Column(
                    children: 
                      suraAudio.sura.ayahs.map((audioAyah) => Text(audioAyah.text,style: TextStyle(fontSize: 25),)).toList(),
                ),  
            ),
          ],
        ),
      ),

    );
  }
}
