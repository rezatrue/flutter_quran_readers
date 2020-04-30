import 'package:flutter/material.dart';
import '../models/ayah_info.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../helpers/db_helper.dart';

class AyahInfoList with ChangeNotifier{
  List<AyahInfo> _ayahInfo = [];
  
  List<AyahInfo> get ayahInfo{
    return [..._ayahInfo];
  }

  List<String> missingIdentifiyers = [];
  
  Future<void> getAyahInfo(int surahNumber, List<String> identifiyers) async{
    missingIdentifiyers = identifiyers;
    return await getDBAyahInfo(surahNumber).then( (val){
          return getApiAyahInfo(surahNumber).then((val){
            return;
          });
        
      }
    );    
  }

  Future<void> getDBAyahInfo(int surahNumber) async{
    print('Starting : getDBAyahInfo()');
    List<String> tempIdentifiyers = [];
    if(missingIdentifiyers.length > 0) tempIdentifiyers = missingIdentifiyers;
    else return;
    
    for(int i = 0; i < tempIdentifiyers.length; i++){
    final dbData = await DBHelper.getAyah(DBHelper.TABLE_AYAH_INFO, surahNumber, tempIdentifiyers[i]);
      if(dbData.length > 0 ){
          try{
              _ayahInfo = dbData.map((item) => AyahInfo( 
                number: item['number'],
                numberOfSurah: item['numberOfSurah'],
                numberInSurah: item['numberInSurah'],
                text: item['text'],
                page: item['page'],
                sajda: item['sajda'],
                identifier: item['identifier'],
                language: item['language'],
                englishName: item['englishName'],
                format: item['format'],
                type: item['type'],
                direction: item['direction'],
                )
              ).toList();  
              missingIdentifiyers.removeWhere((value) => (value == tempIdentifiyers[i]));
            }catch (error){ // need to set surah number & ideftifiyer combination unique
              print('Error : getDBAyahInfo()' + error.toString());
            }
        }
      notifyListeners();
      print('-: getDBAyahInfo()' + _ayahInfo.length.toString());
    }
    print('Done : getDBAyahInfo()');
    return;
  }

  Future<void> getApiAyahInfo(int surahNumber) async{
    DBHelper.clearTable(DBHelper.TABLE_AYAH_INFO);
    print('Start : get API data');

    List<String> tempIdentifiyers = [];
    if(missingIdentifiyers.length > 0) tempIdentifiyers = missingIdentifiyers;
    else return;
    
    if(surahNumber > 0 || surahNumber < 115 ) return;
    
    String url = 'http://api.alquran.cloud/v1/surah/${surahNumber.toString()}/editions/';

    for(int i = 0; i < tempIdentifiyers.length; i++){
      if(i == 0) url = url + '${tempIdentifiyers[i]}';
      else url = url + ',${tempIdentifiyers[i]}';
    }

    //String url = "http://api.alquran.cloud/v1/surah/114/editions/quran-uthmani,en.asad,ar.alafasy";

      try{
        var response = await http.get(url);
        if (response.statusCode == 200) {
          var jsonResponse = convert.jsonDecode(response.body);
          if(jsonResponse['code'] == 200 && jsonResponse['status'] == 'OK'){

              _ayahInfo = List<AyahInfo>();
              int numberOfFormat = jsonResponse['data'].length;
              for(int i = 0; i < numberOfFormat; i++){
                  int numberOfAyah = jsonResponse['data'][i]['ayahs'].length;
                  for(int j=0; j < numberOfAyah; j++){

                    DBHelper.insert(DBHelper.TABLE_AYAH_INFO, {
                      'numberOfSurah': jsonResponse['data'][i]['ayahs'][j]['numberOfSurah'],
                      'number': jsonResponse['data'][i]['ayahs'][j]['number'],
                      'numberInSurah': jsonResponse['data'][i]['ayahs'][j]['numberInSurah'],
                      'text': jsonResponse['data'][i]['ayahs'][j]['text'],
                      'page': jsonResponse['data'][i]['ayahs'][j]['page'],
                      'sajda': jsonResponse['data'][i]['ayahs'][j]['sajda'],
                      'identifier': jsonResponse['data'][i]['edition']['identifier'],
                      'language': jsonResponse['data'][i]['edition']['language'],
                      'englishName': jsonResponse['data'][i]['edition']['englishName'],
                      'format': jsonResponse['data'][i]['edition']['format'],
                      'type': jsonResponse['data'][i]['edition']['type'],
                      'direction': jsonResponse['data'][i]['edition']['direction'],}
                    );

                    _ayahInfo.add(AyahInfo(
                        numberOfSurah: jsonResponse['data'][i]['ayahs'][j]['numberOfSurah'],
                        number: jsonResponse['data'][i]['ayahs'][j]['number'],
                        numberInSurah: jsonResponse['data'][i]['ayahs'][j]['numberInSurah'],
                        text: jsonResponse['data'][i]['ayahs'][j]['text'],
                        page: jsonResponse['data'][i]['ayahs'][j]['page'],
                        sajda: jsonResponse['data'][i]['ayahs'][j]['sajda'],
                        identifier: jsonResponse['data'][i]['edition']['identifier'],
                        language: jsonResponse['data'][i]['edition']['language'],
                        englishName: jsonResponse['data'][i]['edition']['englishName'],
                        format: jsonResponse['data'][i]['edition']['format'],
                        type: jsonResponse['data'][i]['edition']['type'],
                        direction: jsonResponse['data'][i]['edition']['direction'],
                      ));
                    missingIdentifiyers.removeWhere((value) => (value == jsonResponse['data'][i]['edition']['identifier']));
                    notifyListeners();
                  }
              }
          
            }else{
                print('-------------error----------------');
            }
          }
        }catch (error){
          print('error : '+ error.toString()+' : ' + _ayahInfo.length.toString());
          return;
        }
      print('End : get API data' + _ayahInfo.length.toString());
      return;
    }


}