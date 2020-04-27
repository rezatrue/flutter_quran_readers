import 'package:flutter/material.dart';
import '../models/format_info.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../helpers/db_helper.dart';

class FormatInfoList with ChangeNotifier{
  List<FormatInfo> _formatInfo = [];
  
  List<FormatInfo> get formatInfo{
    return [..._formatInfo];
  }

  Future<void> getFormatInfo() async{

    await getDBFormatInfo().then( (val){
        if(_formatInfo.length < 1 || _formatInfo.length > 124){
          getApiFormatInfo().then((val){
            //addSurahInfo();
          });
        }
      }
    );    
  }

  Future<void> getDBFormatInfo() async{
    print('Starting : getDBSurahInfo()');
    try{
      final dbData = await DBHelper.getData(DBHelper.TABLE_FORMAT_INFO);

      _formatInfo = dbData.map((item) => FormatInfo( 
          identifier: item['identifier'],
          language: item['language'],
          name: item['name'],
          englishName: item['englishName'],
          format: item['format'],
          type: item['type'],
          direction: item['direction'],
          )
        ).toList();    
      notifyListeners();
      print('-: getDBSurahInfo()' + _formatInfo.length.toString());
    }catch (error){
      print('Error : getDBSurahInfo()' + error.toString());
      return;
    }
    print('Done : getDBSurahInfo()');
    return;
  }

  Future<void> getApiFormatInfo() async{
    DBHelper.clearTable(DBHelper.TABLE_FORMAT_INFO);
    print('Start : get API data');
    String urlAudio = "http://api.alquran.cloud/v1/edition/format/audio";
    String urlText = "http://api.alquran.cloud/v1/edition/format/text";

    List<String> urlList = [];
    urlList.add(urlAudio);
    urlList.add(urlText);
    for(int j=0; j < urlList.length; j++){

      try{
      var response = await http.get(urlList[j]);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        if(jsonResponse['code'] == 200 && jsonResponse['status'] == 'OK'){
  // jsonResponse['data']['ayahs'].map((ayah) => _ayahs.add(AudioAyah(text : ayah['text'],audio: ayah['audio'])));
        _formatInfo = List<FormatInfo>();
        int numberOfInfo = jsonResponse['data'].length;
        for(int i = 0; i < numberOfInfo; i++){
          DBHelper.insert(DBHelper.TABLE_FORMAT_INFO, {
            'identifier': jsonResponse['data'][i]['identifier'],
            'language': jsonResponse['data'][i]['language'],
            'name': jsonResponse['data'][i]['name'],
            'englishName': jsonResponse['data'][i]['englishName'],
            'format': jsonResponse['data'][i]['format'],
            'type': jsonResponse['data'][i]['type'],
            'direction': jsonResponse['data'][i]['direction'],}
          );
          _formatInfo.add(FormatInfo(
              identifier: jsonResponse['data'][i]['identifier'],
              language: jsonResponse['data'][i]['language'],
              name: jsonResponse['data'][i]['name'],
              englishName: jsonResponse['data'][i]['englishName'],
              format: jsonResponse['data'][i]['format'],
              type: jsonResponse['data'][i]['type'],
              direction: jsonResponse['data'][i]['direction'],
            ));
        }
        
          }else{
              print('-------------error----------------');
          }
        }
        }catch (error){
          print('error : '+ error.toString()+' : ' + _formatInfo.length.toString());
          return;
        }


    }
      notifyListeners();
      
      print('End : get API data' + _formatInfo.length.toString());
      return;

    }






}