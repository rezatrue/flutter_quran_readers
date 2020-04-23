import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;


class Sura {
  int number;
  String name;
  String englishName;
  int numberOfAyahs;
  List<String> translations; 

  Sura({this.number, this.name, this.englishName, this.numberOfAyahs, this.translations});

}


class SuraTranslation with ChangeNotifier{
  var _sura;  

  Sura get sura{
    return _sura;
  }

  Future<void> getTranslation() async{
    final url = "http://api.alquran.cloud/v1/surah/114/bn.bengali";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == 200 && jsonResponse['status'] == 'OK'){


        List<String> translations = new List<String>();
        // int ayahNumber = jsonResponse['data']['ayahs'].length;
        //   for(int i = 0; i < ayahNumber; i++){
        //    translations.add(jsonResponse['data']['ayahs'][i]['text']);
        //    print(jsonResponse['data']['ayahs'][i]['text']);
        //   }
            jsonResponse['data']['ayahs'].map((ayah) {//translations.add(ayah['text']);
                print('-------5------------');
            });
          
          _sura = Sura(number:jsonResponse['data']['number'],name: jsonResponse['data']['name'],englishName: jsonResponse['data']['englishName'],
                    numberOfAyahs: jsonResponse['data']['numberOfAyahs'], translations: translations );
          notifyListeners();
         
      }else{
          print('-------------error------------------');
      }
    
    }


}

}
