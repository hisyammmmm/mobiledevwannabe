import 'package:flutter/material.dart';
import 'login_page.dart'; // Mengimpor halaman login

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodApp',
      theme: ThemeData(
        primarySwatch: Colors.orange, // Tema warna utama
      ),
      home: LoginPage(), // Halaman pertama saat aplikasi dibuka
    );
  }
}
