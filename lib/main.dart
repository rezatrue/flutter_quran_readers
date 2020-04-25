import 'package:flutter/material.dart';
import './screens/my_home_page.dart';
import 'package:provider/provider.dart';
import './screens/surah_info_list_screens.dart';
import './providers/surah_info_list.dart';
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
        ],
        child: MaterialApp(
          title: '$appName readers',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.blueGrey,
          ),
          //home: MyHomePage(title: appName),
          initialRoute: SurahInfoListScreen.routeName,
          routes: {
            '/': (ctx) => MyHomePage(title: appName),
            SurahInfoListScreen.routeName : (ctx) => SurahInfoListScreen(title: appName,),
          },
        ),
        
    );
  }
}

