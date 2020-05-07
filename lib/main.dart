import 'package:flutter/material.dart';
import './screens/my_home_page.dart';
import 'package:provider/provider.dart';
import './screens/surah_info_list_screens.dart';
import './providers/surah_info_list.dart';
import './providers/format_info_list.dart';
import './providers/ayah_info_list.dart';
import './screens/ayah_info_list_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String appName = 'Al-Quran';
  final String source = 'alquran.cloud';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: SurahInfoList()),
          ChangeNotifierProvider.value(
            value: FormatInfoList()),
          ChangeNotifierProvider.value(
            value: AyahInfoList()),
        ],
        child: MaterialApp(
          title: '$appName readers',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.blueGrey,
            textTheme: TextTheme(
              title: TextStyle(fontSize: 25, color: Colors.white),
              subhead: TextStyle(fontSize: 20),
              subtitle: TextStyle(fontSize: 15),
            ),
          ),
          //home: MyHomePage(title: appName),
          initialRoute: SurahInfoListScreen.routeName,
          routes: {
            //'/': (ctx) => MyHomePage(title: appName),
            '/' : (ctx) => SurahInfoListScreen(title: appName,),
            AyahInfoListScreen.routeName : (ctx) => AyahInfoListScreen(),
          },
        ),
        
    );
  }
}

