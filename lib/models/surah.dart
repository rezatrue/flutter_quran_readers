import 'package:flutter/foundation.dart';
import './ayah.dart';

class Surah {

int number;  
String name;
String englishName;
String englishNameTranslation;
String revelationType;
List<Ayah> ayahs;

Surah({
  @required this.number,
  @required this.name,
  @required this.englishName,
  @required this.englishNameTranslation,
  @required this.revelationType,
  @required this.ayahs,
});


}