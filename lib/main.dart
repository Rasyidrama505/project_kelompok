import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:project/home_admin.dart';
import 'package:project/login_admin.dart';
import 'package:project/home_pelanggan.dart';
import 'package:project/menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();

  // Registrasikan Adapter untuk model Menu
  Hive.registerAdapter(MenuAdapter());

  // Buka box Hive
  await Hive.openBox<Menu>('menus');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.redAccent, Colors.red],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar tanpa CircleAvatar
              Image.asset(
                'assets/images/icon.png', 
                width: 300, 
                height: 200, 
                fit: BoxFit.cover, 
              ),
              const SizedBox(height: 40),
              const Text(
                "Masuk Sebagai",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Tombol Pelanggan
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CustomerHomeScreen()),
        );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Pelanggan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
              // Tombol Admin
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AdminHome()),
        );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 62,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Admin",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


