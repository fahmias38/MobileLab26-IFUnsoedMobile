import 'package:flutter/material.dart';
import 'home_page.dart'; // modul: package:router_flutter/home_page.dart
import 'about_page.dart'; // tambahan: modul tidak menampilkan import ini

class Sidemenu extends StatelessWidget {
  const Sidemenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text('Sidemenu')), // DrawerHeader
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Navigasi ke halaman Home
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ), // MaterialPageRoute
              );
            },
          ), // ListTile
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              // Navigasi ke halaman Settings
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutPage(),
                ), // MaterialPageRoute
              );
            },
          ), // ListTile
        ],
      ), // ListView
    ); // Drawer
  }
}
