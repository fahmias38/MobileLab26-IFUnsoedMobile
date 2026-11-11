import 'package:flutter/material.dart';
import 'sidemenu.dart'; // modul: package:router_flutter/sidemenu.dart

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Page')), // AppBar
      body: const Center(child: Text('Ini adalah halaman About')), // Center
      drawer: const Sidemenu(),
    ); // Scaffold
  }
}
