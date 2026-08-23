import 'package:flutter/material.dart';
import 'tale/tale_screen.dart'; // import ไฟล์ที่เพิ่งสร้าง

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tale App',
      home: TaleScreen(),
    );
  }
}