import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  // final int serialNumber;
  // MainDrawer({this.serialNumber});  

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

enum TransType { InLine , AsAWhole }

  

class _MainDrawerState extends State<MainDrawer> {
  final _formKey = GlobalKey<FormState>();
  bool _isTranstation = false;
  TransType _translationDecoration = TransType.InLine;
  bool _isRepeat = false;

  List<String> _listOfSurahs = ['Fatiha', 'Bakara', 'Al-Imran', 'An-Nissa', 'Al-Maaida', 'Al-Anaam'];
  String _selectedSurah = 'Fatiha';
  List<int> _listOfSurahsno = [1,2,3,4,5,255];
  int _selectedSurahno = 1;

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

  void _switchRepeat(bool value){
    setState(() {
      _isRepeat = value;
    });
  }

  void _switchTranslationDecoration(TransType value){
    setState(() {
      _translationDecoration = value;
    });
  }

  void _switchTranslation (var value){
    setState(() {
      _isTranstation = value;
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
                        Text('SURAH:', style: TextStyle(fontWeight: FontWeight.bold),),
                        Expanded(
                          child: DropdownButton<String>(
                          value: _selectedSurah,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
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
                        DropdownButton<int>( 
                          value: _selectedSurahno,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
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
                        
                      ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Text('Repeat:'),
                        Switch(
                          value: _isRepeat, 
                          onChanged: (value) => _switchRepeat(value)),
                      ],),
                      Row(
                        children: <Widget>[
                        Text('Translation:'),
                        Switch(
                          value: _isTranstation, 
                          onChanged: (value) => _switchTranslation(value)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Row(children: <Widget>[
                              Radio(value: TransType.InLine, groupValue: _translationDecoration, onChanged: _isTranstation ? (value) => _switchTranslationDecoration(value) : null),
                              Text('line by line'),
                            ],),
                            Row(children: <Widget>[
                              Radio(value: TransType.AsAWhole, groupValue: _translationDecoration, onChanged: _isTranstation ? (value) => _switchTranslationDecoration(value) : null),
                              Text('whole text'), 
                            ],),
                          ],
                        ),
                      
                        ],),
                      Row(children: <Widget>[
                        Text('Translator Name:'),
                        Expanded(
                          child: TextFormField(
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter name';
                            }
                            return null;
                          },
                      ),
                        ),
                      ],),
                     RaisedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_formKey.currentState.validate()) {
                          Scaffold
                              .of(context)
                              .showSnackBar(SnackBar(content: Text('Processing Data')));
                        }
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