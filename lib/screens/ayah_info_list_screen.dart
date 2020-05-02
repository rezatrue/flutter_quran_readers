import 'package:flutter/material.dart';
import '../providers/ayah_info_list.dart';
import 'package:provider/provider.dart';

class AyahInfoListScreen extends StatelessWidget {

static const String routeName = '/ayah-info-list-screen';

  @override
  Widget build(BuildContext context) {
    var ayahInfoList = Provider.of<AyahInfoList>(context, listen: false);

    ayahInfoList.getAyahInfo(114,['quran-uthmani' ,'en.asad' ,'ar.alafasy']).then((_){  

      print('ayah - data retrived - ${ayahInfoList.ayahInfo.length}');
      if(ayahInfoList.ayahInfo.length < 1) return;
      for(int i= 0; i <ayahInfoList.ayahInfo.length; i++){
        print('ayah - ${i.toString()}');
        print(ayahInfoList.ayahInfo[i].text);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Ayah'),
      ),
      body: Consumer<AyahInfoList>(
        builder: (ctx, ayahInfoList, ch)
        => ayahInfoList.ayahInfo.length == 0 
          ? Center(child : CircularProgressIndicator())
          : ListView(
            children:   
              ayahInfoList.ayahInfo.map(
                (data) => Container(
                  margin: EdgeInsets.all(2),
                  color: Colors.black54,
                  child: Text('${data.text} (${data.numberInSurah})', style: TextStyle(fontSize: 20, color: Colors.white),))
                ).toList(),
        )
      ),
    ); 
  }
}