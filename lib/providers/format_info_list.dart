import 'package:flutter/material.dart';
import '../models/format_info.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../helpers/db_helper.dart';

class FormatInfoList with ChangeNotifier{
  //List<FormatInfo> _formatInfo = [];
  List<FormatInfo> _formatTextTypeInfo = [];
  List<FormatInfo> _formatTranslationInfo = [];
  List<FormatInfo> _formatAudioAyahInfo = [];
  List<FormatInfo> _formatAudioTranslationInfo = [];

  //foramt "text" / "audio"
  // type "quran", "translation", "tafsir" / "translation" , "versebyverse"

  List<FormatInfo> get formatTextTypeInfo{
    return [..._formatTextTypeInfo];
  }
  List<FormatInfo> get formatTranslationInfo{
    return [..._formatTranslationInfo];
  }
  List<FormatInfo> get formatAudioAyahInfo{
    return [..._formatAudioAyahInfo];
  }

  List<FormatInfo> get formatAudioTranslationInfo{
    return [..._formatAudioTranslationInfo];
  }

  Future<void> getFormatInfo() async{

    await getDBFormatInfo().then( (_){
        print(' length - ${formatTextTypeInfo.length}');
        if(formatTextTypeInfo.length < 1){
          getApiFormatInfo().then((_){
            return;
          });
        }else{
          return;
        }
      }
    );    
  }

  Future<void> getDBFormatInfo() async{
    print('Starting : getDBFormatInfo()');
    try{
      final dbData = await DBHelper.getData(DBHelper.TABLE_FORMAT_INFO);
      print('DB - ${dbData.length}');
      for(int i = 0 ; i < dbData.length; i++){
               
        String identifier = dbData[i]['identifier'] ;
        String language = dbData[i]['language'] ;
        String name = dbData[i]['name'] ;
        String englishName = dbData[i]['englishName'] ;
        String format = dbData[i]['format'] ;
        String type = dbData[i]['type'] ;
        String direction = dbData[i]['direction'] ;  
        //foramt "text" / "audio"
        // type "quran", "translation", "tafsir" / "translation" , "versebyverse"
        if(format == "text"){
            type == "quran" 
            ? _formatTextTypeInfo.add(FormatInfo(
                identifier: identifier,
                language: language,
                name: name,
                englishName: englishName,
                format: format,
                type: type,
                direction: direction,
                ))
            : _formatTranslationInfo.add(FormatInfo(
                identifier: identifier,
                language: language,
                name: name,
                englishName: englishName,
                format: format,
                type: type,
                direction: direction,
                ));
          }else if (format == "audio"){
            type == "versebyverse" 
            ? _formatAudioAyahInfo.add(FormatInfo(
                identifier: identifier,
                language: language,
                name: name,
                englishName: englishName,
                format: format,
                type: type,
                direction: direction,
                ))
            : _formatAudioTranslationInfo.add(FormatInfo(
                identifier: identifier,
                language: language,
                name: name,
                englishName: englishName,
                format: format,
                type: type,
                direction: direction,
                ));
          }
      }
    
    }catch (error){
      print('Error : getDBFormatInfo()' + error.toString());
      return;
    }
    notifyListeners();
    print('Done : getDBFormatInfo() ${_formatTextTypeInfo.length}-${_formatTranslationInfo.length}-${_formatAudioAyahInfo.length}-${_formatAudioTranslationInfo.length} ');
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
        
        int numberOfInfo = jsonResponse['data'].length;
        for(int i = 0; i < numberOfInfo; i++){

          String identifier = jsonResponse['data'][i]['identifier'] ;
          String language = jsonResponse['data'][i]['language'] ;
          String name = jsonResponse['data'][i]['name'] ;
          String englishName = jsonResponse['data'][i]['englishName'] ;
          String format = jsonResponse['data'][i]['format'] ;
          String type = jsonResponse['data'][i]['type'] ;
          String direction = jsonResponse['data'][i]['direction'] ;          
          
          DBHelper.insert(DBHelper.TABLE_FORMAT_INFO, {
            'identifier': identifier,
            'language': language,
            'name': name,
            'englishName': englishName,
            'format': format,
            'type': type,
            'direction': direction,}
          );

          //foramt "text" / "audio"
          // type "quran", "translation", "tafsir" / "translation" , "versebyverse"
          if(format == "text"){
            type == "quran" 
            ? _formatTextTypeInfo.add(FormatInfo(
                identifier: identifier,
                language: language,
                name: name,
                englishName: englishName,
                format: format,
                type: type,
                direction: direction,
                ))
            : _formatTranslationInfo.add(FormatInfo(
                identifier: identifier,
                language: language,
                name: name,
                englishName: englishName,
                format: format,
                type: type,
                direction: direction,
                ));
          }else if (format == "audio"){
            type == "versebyverse" 
            ? _formatAudioAyahInfo.add(FormatInfo(
                identifier: identifier,
                language: language,
                name: name,
                englishName: englishName,
                format: format,
                type: type,
                direction: direction,
                ))
            : _formatAudioTranslationInfo.add(FormatInfo(
                identifier: identifier,
                language: language,
                name: name,
                englishName: englishName,
                format: format,
                type: type,
                direction: direction,
                ));
          }
          
        }
        
          }else{
              print('-------------error----------------');
          }
        }
        }catch (error){
          print('error : '+ error.toString()+' : ' + formatTextTypeInfo.length.toString());
          return;
        }

    }
      notifyListeners();      
      print('End : get API data' + formatTextTypeInfo.length.toString());
      return;

    }






}