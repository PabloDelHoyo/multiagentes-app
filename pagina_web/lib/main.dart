import 'package:flutter/material.dart';
import 'package:pagina_web/pages/home_page.dart';

late Size mq;
void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return MaterialApp(
      home: HomePage(),
    );
  }
}
