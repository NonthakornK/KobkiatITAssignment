import 'package:flutter/material.dart';
import 'package:kobkiat_it_assignment/presentation/news_list_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: NewsListPage.routeName,
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) {
          switch (settings.name) {
            case NewsListPage.routeName:
              return const NewsListPage();
            default:
              return const NewsListPage();
          }
        },
      ),
    );
  }
}
