import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../models/surah.dart';
import '../models/ayah.dart';

class Quran with ChangeNotifier{
  List<Surah> _surahs;
  
  List<Surah> get surahs{
    return _surahs;
  }

  Future<void> getQuran() async{
    final url = "http://api.alquran.cloud/v1/quran/quran-uthmani";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == 200 && jsonResponse['status'] == 'OK'){
        
        int numberOfSurah = jsonResponse['data']['surahs'].length;
        _surahs = new List<Surah>();
        
          for(int i = 0; i < numberOfSurah; i++){
            
            List<Ayah> _ayahs = new List<Ayah>();
            int numberOfAyah = jsonResponse['data']['surahs'][i]['ayahs'].length;
            for(int j = 0; j < numberOfAyah; j++){
              _ayahs.add(Ayah(
                number: jsonResponse['data']['surahs'][i]['ayahs'][j]['number'],
                text: jsonResponse['data']['surahs'][i]['ayahs'][j]['text'],
                numberInSurah: jsonResponse['data']['surahs'][i]['ayahs'][j]['numberInSurah'],
                juz: jsonResponse['data']['surahs'][i]['ayahs'][j]['juz'],
                manzil: jsonResponse['data']['surahs'][i]['ayahs'][j]['manzil'],
                page: jsonResponse['data']['surahs'][i]['ayahs'][j]['page'],
                ruku: jsonResponse['data']['surahs'][i]['ayahs'][j]['ruku'],
                hizbQuarter: jsonResponse['data']['surahs'][i]['ayahs'][j]['hizbQuarter'],
                sajda: jsonResponse['data']['surahs'][i]['ayahs'][j]['sajda'],
                )
              );
            }

            _surahs.add(Surah(
              number : jsonResponse['data']['surahs'][i]['number'],
              name : jsonResponse['data']['surahs'][i]['name'],
              englishName : jsonResponse['data']['surahs'][i]['englishName'],
              englishNameTranslation : jsonResponse['data']['surahs'][i]['englishNameTranslation'],
              revelationType : jsonResponse['data']['surahs'][i]['revelationType'],
              ayahs: _ayahs),
            );
            
          }
        //    // jsonResponse['data']['ayahs'].map((ayah) => _ayahs.add(AudioAyah(text : ayah['text'],audio: ayah['audio'])));

        //   _sura = Sura(number:jsonResponse['data']['number'],name: jsonResponse['data']['name'],englishName: jsonResponse['data']['englishName'],
        //             numberOfAyahs: jsonResponse['data']['numberOfAyahs'], ayahs: _ayahs );
          notifyListeners();
         
        }else{
            print('-------------error------------------');
        }
      }
    }

  }