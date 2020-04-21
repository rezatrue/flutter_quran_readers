import 'package:flutter/material.dart';
import './providers/sura_audio.dart';
import './screens/my_home_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String appName = 'Al-Quran';
  final String source = 'alquran.cloud';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
          value: SuraAudio(),
        ),
        ],
        child: MaterialApp(
          title: '$appName readers',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.blueGrey,
          ),
          home: MyHomePage(title: appName),
        ),
    );
  }
}

