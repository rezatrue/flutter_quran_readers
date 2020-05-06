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


  List<SurahInfo> _surahInfoList = [];
  List<FormatInfo> _formatInfo = [];
  String _selectedSurah = 'Fatiha';
  int _selectedSurahno = 1;

  
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
      });
      print('data retrived' + surahInfoList.surahsInfo.length.toString());
    });

     var formatInfoList = Provider.of<FormatInfoList>(context, listen: false);
       formatInfoList.getFormatInfo().then((_){
       setState(() {
         _formatInfo = formatInfoList.formatInfo;
       });
     });
    
    super.initState();
  }

  void selectSurah({name, number}){
     print(name.toString());
      if(name != null){
        _surahInfoList.map((surahInfo){ 
          if (surahInfo.englishName == name){
            setState(() {
             _selectedSurah = name;
             print(_selectedSurah);
             _selectedSurahno = _surahInfoList.indexOf(surahInfo)+1;  
             print(_selectedSurahno.toString());
            });
          } 
          });
      }
      if(number != null){
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

    print('serialNumber build ${widget.serialNumber.toString()}}');
    print('serialNumber build ${_surahInfoList.length.toString()}}');
    print('serialNumber build ${_formatInfo.length.toString()}}');
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
                          Text('SURAH:', style: TextStyle(fontWeight: FontWeight.bold),),
                          Expanded(
                            child: DropdownButton<String>(
                            value: _surahInfoList[_selectedSurahno-1].englishName,
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
                            Text('NUMBER:', style: TextStyle(fontWeight: FontWeight.bold),),
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