import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/surah_info_list.dart';

class SurahInfoListScreen extends StatefulWidget {
  SurahInfoListScreen({Key key, this.title}) : super(key: key);
  final String title;
  static const String routeName = '/surah-info-list-screen';

  @override
  _SurahInfoListScreenState createState() => _SurahInfoListScreenState();
}

class _SurahInfoListScreenState extends State<SurahInfoListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();


  @override
  void initState() {
    var surahInfoList = Provider.of<SurahInfoList>(context, listen: false);
    surahInfoList.getSurahInfo().then((_){   
      print('data retrived' + surahInfoList.surahsInfo.length.toString());
    });
    super.initState();
  }

  int _selectedNumberOfSurah = 1;


  void openDrawerWithNumber(int surahNumber){
    setState(() {
      _selectedNumberOfSurah = surahNumber;
      print('openDrawer $_selectedNumberOfSurah');
      _scaffoldKey.currentState.openDrawer();
    });
  }


  @override
  void didChangeDependencies() {
    var surahInfoList = Provider.of<SurahInfoList>(context, listen: false);
    surahInfoList.getSurahInfo().then((_){   
      print('data retrived' + surahInfoList.surahsInfo.length.toString());
    });
    super.didChangeDependencies();
  }

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
          },
        ),
      ),
      drawer: MainDrawer(key: ValueKey(_selectedNumberOfSurah), serialNumber: _selectedNumberOfSurah),
      body: Consumer<SurahInfoList>(
        builder: (ctx, surahInfoList, ch)
        => Container(
          padding: EdgeInsets.all(2),
          child: surahInfoList.surahsInfo.length < 114 
                ? Center(child: CircularProgressIndicator(),)  
                : ListView(  
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
        ),
      ),

    );
  }
}
