import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/surah_info_list.dart';

class SurahInfoListScreen extends StatelessWidget {
  SurahInfoListScreen({Key key, this.title}) : super(key: key);
  final String title;

  static const String routeName = '/surah-info-list-screen';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

 @override
  Widget build(BuildContext context) {
    var surahInfoList = Provider.of<SurahInfoList>(context, listen: false);
    surahInfoList.getSurahInfo().then((_){   
      print('data retrived' + surahInfoList.surahsInfo.length.toString());
    });

    int _selectedNumberOfSurah = 5;
    void openDrawerWithNumber(int surahNumber){
      print('openDrawer $surahNumber');
      _selectedNumberOfSurah = surahNumber;
      print('openDrawer $_selectedNumberOfSurah');
      _scaffoldKey.currentState.openDrawer();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.menu), 
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      drawer: MainDrawer(serialNumber: _selectedNumberOfSurah),
      body: Consumer<SurahInfoList>(
        builder: (ctx, surahInfoList, ch)
        => Container(
          padding: EdgeInsets.all(2),
          child: ListView(
            children: <Widget>[
              surahInfoList.surahsInfo.length < 114 
                ? Center(child: CircularProgressIndicator(),)  
                : Column(  
                    children: 
                      surahInfoList.surahsInfo.map((surahInfo) {
                        return Container(
                          margin: EdgeInsets.all(2),
                          color: Colors.black54,
                          child: ListTile(
                            title: Text('${surahInfo.number.toString()} : ${surahInfo.name}', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
                            subtitle: Text('${surahInfo.englishName} ( ${surahInfo.englishNameTranslation} ) - ${surahInfo.revelationType}',  style: TextStyle(fontSize: 15, color: Colors.white),),
                            onTap: () {
                              print('${surahInfo.name} ${surahInfo.number}'); 
                              openDrawerWithNumber(surahInfo.number);
                              },
                          ),
                        ); } 
                      ).toList(),     
                ), 
            ],
          ),
        ),
      ),

    );
  }
}
