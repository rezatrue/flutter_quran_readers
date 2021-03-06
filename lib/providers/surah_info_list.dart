import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../models/surah_info.dart';
import '../helpers/db_helper.dart';

class SurahInfoList with ChangeNotifier{
  List<SurahInfo> _surahsInfo = [];
  
  List<SurahInfo> get surahsInfo{
    return [..._surahsInfo];
  }

  
  Future<void> getSurahInfo() async{

    await getDBSurahInfo().then( (val){
        if(surahsInfo.length != 114){
          getApiSurahInfo().then((val){
            return;
          });
        }else {
          return;
        }
      }
    );    
  }

  Future<void> getDBSurahInfo() async{
    print('Starting : getDBSurahInfo()');
    try{
      final dbData = await DBHelper.getData(DBHelper.TABLE_SURAH_INFO);
      _surahsInfo = dbData.map((item) => SurahInfo(
        
        name: item['name'],
        number: item['number'],
        numberOfAyahs: item['numberOfAyahs'],
        englishName: item['englishName'],
        revelationType: item['revelationType'],
        englishNameTranslation: item['englishNameTranslation'],
        )
        ).toList();    
      print('-: getDBSurahInfo()' + _surahsInfo.length.toString());
    }catch (error){
      print('Error : getDBSurahInfo()' + error.toString());
      return;
    }
    notifyListeners();
    print('Done : getDBSurahInfo()');
    return;
  }


  Future<void> getApiSurahInfo() async{
    DBHelper.clearTable(DBHelper.TABLE_SURAH_INFO);
    print('Start : get API data');
    final url = "http://api.alquran.cloud/v1/surah";
    try{
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == 200 && jsonResponse['status'] == 'OK'){
// jsonResponse['data']['ayahs'].map((ayah) => _ayahs.add(AudioAyah(text : ayah['text'],audio: ayah['audio'])));
      _surahsInfo = List<SurahInfo>();
      int numberOfSurah = jsonResponse['data'].length;
      for(int i = 0; i < numberOfSurah; i++){
        DBHelper.insert(DBHelper.TABLE_SURAH_INFO, {
          'name': jsonResponse['data'][i]['name'],
          'number': jsonResponse['data'][i]['number'],
          'numberOfAyahs': jsonResponse['data'][i]['numberOfAyahs'],
          'englishName': jsonResponse['data'][i]['englishName'],
          'revelationType': jsonResponse['data'][i]['revelationType'],
          'englishNameTranslation': jsonResponse['data'][i]['englishNameTranslation'],}
        );
        _surahsInfo.add(SurahInfo(
            number: jsonResponse['data'][i]['number'],
            name: jsonResponse['data'][i]['name'],
            englishName: jsonResponse['data'][i]['englishName'],
            englishNameTranslation: jsonResponse['data'][i]['englishNameTranslation'],
            numberOfAyahs: jsonResponse['data'][i]['numberOfAyahs'],
            revelationType: jsonResponse['data'][i]['revelationType'],
          ));
      }
     
      
        }else{
            print('-------------error----------------');
        }
      }
      }catch (error){
        print('error : '+ error.toString()+' : ' + _surahsInfo.length.toString());
        return;
      }
      notifyListeners();
      print('End : get API data' + _surahsInfo.length.toString());
      return;
    }

  }