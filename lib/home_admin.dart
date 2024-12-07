import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'add_menu.dart'; // Pastikan path import benar
import 'menu.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Dapur Azkiya',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.red, width: 3),
            insets: EdgeInsets.symmetric(horizontal: 16),
          ),
          tabs: const [
            Tab(text: 'Manajemen Menu'),
            Tab(text: 'Manajemen Pesanan'),
            Tab(text: 'Laporan Harian'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: _buildMenuGrid(),
            ),
          ),
          const Center(child: Text('Manajemen Pesanan')),
          const Center(child: Text('Laporan Harian')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddMenu screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMenu()),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMenuGrid() {
    return ValueListenableBuilder<Box<Menu>>(
      valueListenable: Hive.box<Menu>('menus').listenable(),
      builder: (context, box, _) {
        final menus = box.values.toList().cast<Menu>();

        if (menus.isEmpty) {
          return const Center(child: Text('Belum ada menu.'));
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 3 / 4,
          ),
          itemCount: menus.length,
          itemBuilder: (context, index) {
            final menu = menus[index];
            return _buildMenuCard(menu);
          },
        );
      },
    );
  }

  Widget _buildMenuCard(Menu menu) {
    final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: menu.image.startsWith('/') // Check if this is a file path
                ? (File(menu.image).existsSync()
                    ? Image.file(
                        File(menu.image),
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/placeholder.jpg',
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ))
                : Image.asset(
                    'assets/images/${menu.image}',
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  menu.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  currencyFormatter.format(menu.price),
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  menu.category, // Display category here
                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _showDeleteDialog(context, menu);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Menu menu) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus menu ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Hive.box<Menu>('menus').delete(menu.key); // Menghapus menu dari Hive
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: const Text('Hapus'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog tanpa menghapus
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }
}
