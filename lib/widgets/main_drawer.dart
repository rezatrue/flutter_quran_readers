import 'package:flutter/material.dart';
import '../providers/format_info_list.dart';
import '../providers/surah_info_list.dart';
import '../models/surah_info.dart';
import '../models/format_info.dart';
import 'package:provider/provider.dart';
import '../screens/ayah_info_list_screen.dart';

class MainDrawer extends StatefulWidget {

  MainDrawer({Key key, this.serialNumber}) : super(key: key);  

  final int serialNumber;

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

enum TransType { InLine , AsAWhole }
  

class _MainDrawerState extends State<MainDrawer> {
  final _formKey = GlobalKey<FormState>();

  // Surah
  List<SurahInfo> _surahInfoList = [];
  String _selectedSurah = 'Fatiha';
  int _selectedSurahno = 1;
  // Qurean test
  List<FormatInfo> _textTypeInfo = [];
  String _selectedTextIdentifier = 'quran-kids';
  String _selectedTextType = 'Kids';
  void selectText(String type){
      String qidentifier;
      for(int i = 0; i < _textTypeInfo.length; i++){
          if(_textTypeInfo[i].name  == type) qidentifier = _textTypeInfo[i].identifier;
      }
      setState(() {
        _selectedTextIdentifier = qidentifier;
        _selectedTextType = type;
        print(_selectedTextIdentifier);
      });
  }
  // translation
  List<FormatInfo> _translationInfo = [];
  String _selectedtranslationIdentifier = 'en.asad';
  String _selectedTranslator = 'Asad';
  void selectTranslator(String translator){
      String tidentifier;
      for(int i = 0; i < _translationInfo.length; i++){
          if(_translationInfo[i].name  == translator) tidentifier = _translationInfo[i].identifier;
      }
      setState(() {
        _selectedtranslationIdentifier = tidentifier;
        _selectedTranslator = translator;
        print(_selectedtranslationIdentifier);
      });
  }


  List<String> _listVerseByVerse = [];
  String _selectedAudioVerse = 'Click to Seelct';

  @override
  void initState() {
    print('serialNumber  create ${widget.serialNumber.toString()}');
    _selectedSurahno = widget.serialNumber != null ? widget.serialNumber : 1;

    var surahInfoList = Provider.of<SurahInfoList>(context, listen: false);
    surahInfoList.getSurahInfo().then((_){
      setState(() {
      _surahInfoList = surahInfoList.surahsInfo;
      _selectedSurah = widget.serialNumber != null ? _surahInfoList[_selectedSurahno-1].englishName : 'Fatiha';
      });
      print('data retrived' + surahInfoList.surahsInfo.length.toString());
    });

     var formatInfoList = Provider.of<FormatInfoList>(context, listen: false);
       formatInfoList.getFormatInfo().then((_){
       setState(() {
          _textTypeInfo = formatInfoList.formatTextTypeInfo;
          _translationInfo = formatInfoList.formatTranslationInfo;
          // _textTypeInfo = formatInfoList.formatAudioAyahInfo;
          // _textTypeInfo = formatInfoList.formatAudioTranslationInfo;
         print('${formatInfoList.formatTextTypeInfo.length}-${formatInfoList.formatTranslationInfo.length}-${formatInfoList.formatAudioAyahInfo.length}-${formatInfoList.formatAudioTranslationInfo.length}');
       });
     });
    
    super.initState();
  }

  void selectSurah({name, number}){
    if(name != null && number != null) return;
      if(name != null){
       int len = _surahInfoList.length;
        for(int i = 0; i < len ; i++){
          print(_surahInfoList[i].name);
          if (_surahInfoList[i].englishName == name){
            setState(() {
            _selectedSurah = name;
            _selectedSurahno = _surahInfoList.indexOf(_surahInfoList[i])+1;  
            });
          }
        }     
      }else if(number != null){
        setState(() {
          _selectedSurahno = number;
          _selectedSurah = _surahInfoList[number].englishName;
        });
      }
  }

    bool _audioEnable = false;

    void _audioOptionEnable(bool val){
      setState(() {
      _audioEnable = val;
      });
    }
    

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                  //width: MediaQuery.of(context).size.width * 0.85,
                  width: double.infinity,
                  child: DrawerHeader(
                  child: Text('The Holy Al-Quran', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/quran_image_400x400.jpg'), fit: BoxFit.cover),
                  ),
                ),
              ),
            ), 
            Expanded(
              flex: 2,
              child: Form(
                key: _formKey,
                child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      children: <Widget>[
                        Row(children: <Widget>[
                          Text('SURAH : ', style: TextStyle(fontWeight: FontWeight.bold),),
                          Expanded(
                            child: DropdownButton<String>(
                            value: _selectedSurah,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 16,
                            elevation: 12,
                            items: _surahInfoList.map<DropdownMenuItem<String>>((SurahInfo value) {
                              return DropdownMenuItem<String>(
                                value: value.englishName,
                                child: Text(value.englishName),
                              );
                            }).toList(),  
                            onChanged: (name) {
                                selectSurah(name: name);
                            },
                          ),
                          ),
                        ],),
                        // Number
                        Row(
                          children: <Widget>[
                            Text('NUMBER : ', style: TextStyle(fontWeight: FontWeight.bold),),
                          Expanded(child: 
                          DropdownButton<int>( 
                            value: _selectedSurahno,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 16,
                            elevation: 16,
                            items: _surahInfoList.map<DropdownMenuItem<int>>((SurahInfo value) {
                              return DropdownMenuItem<int>(
                                value: value.number,
                                child: Text(value.number.toString()),
                              );
                            }).toList(),  
                            onChanged: (number) {
                              selectSurah(number: number);
                            },
                          ),
                          )
                          ],
                        ),
                        // TEXT TYPE
                        Row(children: <Widget>[
                          Text('TEXT TYPE : ', style: TextStyle(fontWeight: FontWeight.bold),),
                          Expanded(
                            child: DropdownButton<String>(
                            value: _selectedTextType,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 16,
                            elevation: 12,
                            items: _textTypeInfo.map<DropdownMenuItem<String>>((FormatInfo value) {
                              return DropdownMenuItem<String>(
                                value: value.name,
                                child: Text(value.name),
                              );
                            }).toList(),  
                            onChanged: (name) {
                              selectText(name);
                            },
                          ),
                          ),
                        ],),
                        // TRANSLATION
                       
                        // AUDIO 
                       Row(children: <Widget>[
                        Text('Audio : '), 
                        Checkbox(
                          value: _audioEnable, 
                          onChanged: (val) {
                            _audioOptionEnable(val);
                          }),
                       ],), 
                       Row(
                         children: <Widget>[
                           Text('versebyverse : '),
                            DropdownButton<String>(
                              value: _selectedAudioVerse,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 16,
                              elevation: 16,
                              items: _listVerseByVerse.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.toString()),
                                );
                                }).toList(),  
                                onChanged: (val) {
                                  _selectedAudioVerse = val;
                                },
                            ),
                         ],
                       ),

                       RaisedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState.validate()) {
                            Scaffold
                                .of(context)
                                .showSnackBar(SnackBar(content: Text('Processing Data')));
                          }
                          Navigator.of(context).pushNamed(AyahInfoListScreen.routeName);
                        },
                        child: Text('Submit'),
                      ),
                      ],
                    ),
              ),
            ),
          ],
        ),
      );
  }
}