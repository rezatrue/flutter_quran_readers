import 'package:flutter/foundation.dart';

class AyahInfo {

int numberOfSurah;
int number;
int numberInSurah;
String text; // the ayah / translation / audio
int page;
bool sajda;
String identifier;
String language;
String englishName;
String format;  // text / audio 
String type;    // quran / translation / versebyverse
String direction;


AyahInfo({
  @required this.numberOfSurah,
  @required this.number,
  @required this.numberInSurah,
  @required this.text, 
  @required this.page,
  @required this.sajda,
  @required this.identifier,
  @required this.language,
  @required this.englishName,
  @required this.format,  
  @required this.type,    
  @required this.direction,
});


}