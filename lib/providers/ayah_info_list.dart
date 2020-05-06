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
  
  Future<void> getAyahInfo(int surahNumber,int totalAyah, List<String> identifiyers) async{
    missingIdentifiyers = identifiyers;
    print('missingIdentifiyers - ${missingIdentifiyers.length.toString()}');
    return await getDBAyahInfo(surahNumber).then( (_){
          if( totalAyah * identifiyers.length != _ayahInfo.length){
            return getApiAyahInfo(surahNumber).then((_){
                return;
              });
          } 
      }
    );    
  }
  Future<void> clearDB() async{
      DBHelper.clearTable(DBHelper.TABLE_AYAH_INFO);
  }

  Future<void> getDBAyahInfo(int surahNumber) async{
    print('Starting : getDBAyahInfo()');
    List<String> tempIdentifiyers = [];
    if(missingIdentifiyers.length > 0) tempIdentifiyers = missingIdentifiyers;
    else return;
    
    for(int i = 0; i < tempIdentifiyers.length; i++){
    final List<Map<String, dynamic>> dbData = await DBHelper.getAyah(DBHelper.TABLE_AYAH_INFO, surahNumber, tempIdentifiyers[i]);

    print(dbData.length);
      if(dbData.length > 0 ){
          print('I am in here');
          try{
              _ayahInfo = dbData.map((item) => AyahInfo( 
                number: item['number'],
                numberOfSurah: item['numberOfSurah'],
                numberInSurah: item['numberInSurah'],
                text: item['text'],
                page: item['page'],
                sajda: item['sajda'] == 'false' ? false : true,
                identifier: item['identifier'],
                language: item['language'],
                englishName: item['englishName'],
                format: item['format'],
                type: item['type'],
                direction: item['direction'],
                )
              ).toList();  
              print('removing $tempIdentifiyers[i])');
              missingIdentifiyers.removeWhere((value) => (value == tempIdentifiyers[i]));
              print('number after removal ${missingIdentifiyers.length.toString()}');
            }catch (error){ 
              print('Error : getDBAyahInfo()' + error.toString());
            }
        }
      print('missingIdentifiyers - ${missingIdentifiyers.length.toString()}');  
      notifyListeners();
      print('-: getDBAyahInfo()' + _ayahInfo.length.toString());
    }
    print('Done : getDBAyahInfo()');
    return;
  }

  Future<void> getApiAyahInfo(int surahNumber) async{
    
    print('Start : get ayah API data');

    List<String> tempIdentifiyers = [];
    if(missingIdentifiyers.length > 0) tempIdentifiyers = missingIdentifiyers;
    else return;
    
    if(surahNumber < 0 || surahNumber > 114 ) return;
    
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

              //_ayahInfo = List<AyahInfo>();
              int numberOfFormat = jsonResponse['data'].length;
              for(int i = 0; i < numberOfFormat; i++){
                  int numberOfAyah = jsonResponse['data'][i]['ayahs'].length;
                  for(int j=0; j < numberOfAyah; j++){

                    int numberOfSurah = jsonResponse['data'][i]['ayahs'][j]['numberOfSurah'];
                    int number = jsonResponse['data'][i]['ayahs'][j]['number'];
                    int numberInSurah = jsonResponse['data'][i]['ayahs'][j]['numberInSurah'];
                    //String text= jsonResponse['data'][i]['ayahs'][j]['text'];
                    int page = jsonResponse['data'][i]['ayahs'][j]['page'];
                    bool sajda = jsonResponse['data'][i]['ayahs'][j]['sajda'];
                    String identifier = jsonResponse['data'][i]['edition']['identifier'];
                    String language = jsonResponse['data'][i]['edition']['language'];
                    String englishName = jsonResponse['data'][i]['edition']['englishName'];
                    String format = jsonResponse['data'][i]['edition']['format'];
                    String text = format == 'text' 
                                    ? jsonResponse['data'][i]['ayahs'][j]['text']
                                    : jsonResponse['data'][i]['ayahs'][j]['audio'];
                    String type = jsonResponse['data'][i]['edition']['type'];
                    String direction = jsonResponse['data'][i]['edition']['direction'];


                    print(' >>>>>> $text <<<<<<<');

                    DBHelper.insert(DBHelper.TABLE_AYAH_INFO, {
                      'numberOfSurah': numberOfSurah, 'number': number,
                      'numberInSurah': numberInSurah, 'text': text, 'page': page, 'sajda': sajda,
                      'identifier': identifier, 'language': language, 'englishName': englishName,
                      'format': format, 'type': type, 'direction': direction,}
                    );

                    _ayahInfo.add(AyahInfo(
                        numberOfSurah: numberOfSurah, number: number,
                        numberInSurah: numberInSurah, text: text, page: page, sajda: sajda,
                        identifier: identifier, language: language, englishName: englishName,
                        format: format, type: type, direction: direction,
                      ));
                    print('api removing $tempIdentifiyers[i]) - identifier');  
                    missingIdentifiyers.removeWhere((value) => (value == tempIdentifiyers[i]));
                    print('number after removal ${missingIdentifiyers.length.toString()}');
                    notifyListeners();
                  }
              }
          
            }else{
                print('-------------error----------------');
            }
          }
        }catch (error){
          print('error : '+ error.toString()+' : ' + _ayahInfo.length.toString());
          missingIdentifiyers = []; 
          return;
        }
      missingIdentifiyers = [];  
      print('End : get API data' + _ayahInfo.length.toString());
      return;
    }


}