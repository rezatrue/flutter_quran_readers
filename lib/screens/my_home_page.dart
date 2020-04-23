import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';
import '../providers/sura_audio.dart';
import 'package:provider/provider.dart';
import '../providers/sura_translation.dart';
import '../providers/quran.dart';
import '../models/surah.dart';
import '../models/ayah.dart';


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
    var quran = Provider.of<Quran>(context, listen: false);
    // var suraAudio = Provider.of<SuraAudio>(context, listen: false);
    // var translation = Provider.of<SuraTranslation>(context, listen: false);

    Future<void> _update() {
      return quran.getQuran().then((_){
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
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Assalamualikum, my Dear Muslim brothers & sisters',
              textAlign: TextAlign.center,
            ),
            RaisedButton(child: Text('GET DATA'), 
            onPressed: _update,
            ),
            quran.surahs == null 
              ? Text('No List found', textAlign: TextAlign.center,)  
              : Column(  
                  children: 
                    quran.surahs.map((surah) {
                      print(surah.englishName);
                      return Text('('+ surah.number.toString() +') '+ surah.englishName + ' : '+ surah.name, style: TextStyle(fontSize: 25),);
                    } ).toList(),           
              ), 
          ],
        ),
      ),

    );
  }
}
