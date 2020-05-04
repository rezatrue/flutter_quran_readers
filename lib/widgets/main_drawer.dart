import 'package:flutter/material.dart';
import '../providers/format_info_list.dart';
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

  List<String> _listOfSurahs = ['Fatiha', 'Bakara', 'Al-Imran', 'An-Nissa', 'Al-Maaida', 'Al-Nas'];
  String _selectedSurah = 'Fatiha';
  List<int> _listOfSurahsno = [1,2,3,4,5,6];
  int _selectedSurahno = 1;

  
  var formatInfoList;
  List<String> _listVerseByVerse = [];
  String _selectedAudioVerse = 'Click to Seelct';


  @override
  void initState() {
    print('serialNumber  create ${widget.serialNumber.toString()}');
    /*
     formatInfoList = Provider.of<FormatInfoList>(context, listen: false).getFormatInfo().then((_){
       setState(() {
         _listVerseByVerse = formatInfoList.formatInfo.map((val){
           return val.name;
         }).toList();
       });
     });
    */
    super.initState();
  }

  void selectSurah({name, number}){
    setState(() {
      if(name != null){
        _selectedSurah = name;
      _selectedSurahno = _listOfSurahs.indexOf(name)+1;
      }
      if(number != null){
        _selectedSurahno = number;
        _selectedSurah = _listOfSurahs[_listOfSurahsno.indexOf(number)];
      }
    });
  }

    bool _audioEnable = false;

    void _audioOptionEnable(bool val){
      setState(() {
      _audioEnable = val;
      });
    }
    

  @override
  Widget build(BuildContext context) {
    print('serialNumber build ${widget.serialNumber.toString()}');
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
                            value: _selectedSurah,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 16,
                            elevation: 12,
                            items: _listOfSurahs.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),  
                            onChanged: (name) {
                                selectSurah(name: name);
                            },
                          ),
                          ),
                          Text('NUMBER:', style: TextStyle(fontWeight: FontWeight.bold),),
                          Expanded(child: 
                          DropdownButton<int>( 
                            value: _selectedSurahno,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 16,
                            elevation: 16,
                            items: _listOfSurahsno.map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),  
                            onChanged: (number) {
                              selectSurah(number: number);
                            },
                          ),
                          )
                        ],),
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