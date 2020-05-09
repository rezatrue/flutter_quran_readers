import 'package:flutter/foundation.dart';

class SearchArguments{

int serialNoOfSurah;
int totalNoAyahs;
List<String> identifiyers;

SearchArguments({
  @required this.serialNoOfSurah, 
  @required this.totalNoAyahs, 
  @required this.identifiyers});

}