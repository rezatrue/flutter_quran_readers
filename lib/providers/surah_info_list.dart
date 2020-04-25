import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../models/surah_info.dart';

class SurahInfoList with ChangeNotifier{
  List<SurahInfo> _surahsInfo;
  
  List<SurahInfo> get surahsInfo{
    return _surahsInfo;
  }

  /*
  Future<void> getSurahInfo() async{
    get from db 
    if null
    get from api = getApiSurahInfo
    wirite in db
  }
  */

  Future<void> getApiSurahInfo() async{
    final url = "http://api.alquran.cloud/v1/surah";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == 200 && jsonResponse['status'] == 'OK'){
// jsonResponse['data']['ayahs'].map((ayah) => _ayahs.add(AudioAyah(text : ayah['text'],audio: ayah['audio'])));
      _surahsInfo = List<SurahInfo>();
      int numberOfSurah = jsonResponse['data'].length;
      for(int i = 0; i < numberOfSurah; i++){
        _surahsInfo.add(SurahInfo(
            number: jsonResponse['data'][i]['number'],
            name: jsonResponse['data'][i]['name'],
            englishName: jsonResponse['data'][i]['englishName'],
            englishNameTranslation: jsonResponse['data'][i]['englishNameTranslation'],
            numberOfAyahs: jsonResponse['data'][i]['numberOfAyahs'],
            revelationType: jsonResponse['data'][i]['revelationType'],
          ));
      }
      /*
      jsonResponse['data'].map((number){
        jsonResponse['data'][number].map((surahInfo) {
          print('--- ' + surahInfo['number']);
          _surahsInfo.add( SurahInfo(
            number: surahInfo['number'],
            name: surahInfo['name'],
            englishName: surahInfo['englishName'],
            englishNameTranslation: surahInfo['englishNameTranslation'],
            numberOfAyahs: surahInfo['numberOfAyahs'],
            revelationType: surahInfo['revelationType'],
          ));
        });
      });
      */
      notifyListeners();
        }else{
            print('-------------error------------------');
        }
      }
    }

  }