
import 'package:flutter/material.dart';

class ListMenu extends StatelessWidget{

  @override
  State<ListMenu> createState() => _ListMenu();
}

class _ListMenu extends State<ListMenu> {
  final List<Map<String, dynamic>> menuItems = [
    {"name": "Nasi Goreng", "price": 15000, "image": "assets/images/piring.jfif"},
    {"name": "Mie Goreng", "price": 15000, "image": "assets/images/piring.jfif"},
    {"name": "Sate Goreng", "price": 15000, "image": "assets/images/piring.jfif"},
    {"name": "Ayam Goreng", "price": 15000, "image": "assets/images/piring.jfif"},
  ];

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  };