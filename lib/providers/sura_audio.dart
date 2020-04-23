import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Sura {
  int number;
  String name;
  String englishName;
  int numberOfAyahs;
  List<AudioAyah> ayahs; 

  Sura({this.number, this.name, this.englishName, this.numberOfAyahs, this.ayahs});

}

class AudioAyah{
  String text;
  String audio;
  AudioAyah({this.text, this.audio});
}

class SuraAudio with ChangeNotifier{
var _sura;  

Sura get sura{
  return _sura;
}

Future<void> getAudio() async{
    final url = "http://api.alquran.cloud/v1/surah/114/ar.alafasy";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == 200 && jsonResponse['status'] == 'OK'){

        int ayahNumber = jsonResponse['data']['ayahs'].length;
        List<AudioAyah> _ayahs = new List<AudioAyah>();
          for(int i = 0; i < ayahNumber; i++){
           _ayahs.add(AudioAyah(text : jsonResponse['data']['ayahs'][i]['text'], audio: jsonResponse['data']['ayahs'][i]['audio']));
          }
           // jsonResponse['data']['ayahs'].map((ayah) => _ayahs.add(AudioAyah(text : ayah['text'],audio: ayah['audio'])));

          _sura = Sura(number:jsonResponse['data']['number'],name: jsonResponse['data']['name'],englishName: jsonResponse['data']['englishName'],
                    numberOfAyahs: jsonResponse['data']['numberOfAyahs'], ayahs: _ayahs );
          notifyListeners();
         
      }else{
          print('-------------error------------------');
      }
    
    }

  }


}