import 'package:flutter/material.dart';
import 'sidemenu.dart'; // modul: package:router_flutter/sidemenu.dart
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_typing_uninitialized_variables
  var namauser;
  void _loadUsername() async {
    // Inisalisasi share preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Ambil Username yang sudah tersimpan
    namauser = prefs.getString('username');
    // Set username on UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _loadUsername();
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')), // AppBar
      body: Center(child: Text('Ini adalah halaman User $namauser')), // Center
      drawer: const Sidemenu(),
    ); // Scaffold
  }
}
