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
  Widget build(BuildContext context) {
    var surahInfoList = Provider.of<SurahInfoList>(context, listen: false);

    surahInfoList.getApiSurahInfo().then((_){
      setState(() {         
      });
    });
    
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
      drawer: MainDrawer(),
      body: Consumer<SurahInfoList>(
        builder: (ctx, surahInfoList, ch)
        => Container(
          padding: EdgeInsets.all(2),
          child: ListView(
            children: <Widget>[
              surahInfoList.surahsInfo == null 
                ? Center(child: CircularProgressIndicator(),)  
                : Column(  
                    children: 
                      surahInfoList.surahsInfo.map((surahInfo) {
                        //print(surahInfo.englishName);
                        return Container(
                          margin: EdgeInsets.all(2),
                          color: Colors.black54,
                          child: ListTile(
                            title: Text(surahInfo.number.toString() + ': ' + surahInfo.name),
                            subtitle: Text(surahInfo.englishName + '('+ surahInfo.englishNameTranslation + ') - ' + surahInfo.revelationType),
                            onTap: () => print(surahInfo.name),
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
