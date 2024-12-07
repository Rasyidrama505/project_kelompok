import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'menu.dart'; // Import your Menu class

class EditMenu extends StatefulWidget {
  final Menu menu;

  const EditMenu({required this.menu, Key? key}) : super(key: key);

  @override
  _EditMenuState createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  late String _title;
  late int _price;
  late String _image;

  @override
  void initState() {
    super.initState();
    _title = widget.menu.title;
    _price = widget.menu.price;
    _image = widget.menu.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: _title),
              decoration: const InputDecoration(labelText: 'Nama Menu'),
              onChanged: (value) => setState(() => _title = value),
            ),
            TextField(
              controller: TextEditingController(text: _price.toString()),
              decoration: const InputDecoration(labelText: 'Harga Menu'),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() => _price = int.parse(value)),
            ),
            GestureDetector(
              onTap: _selectImage,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _image.startsWith('/')
                    ? (File(_image).existsSync()
                        ? Image.file(
                            File(_image),
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/placeholder.jpg',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ))
                    : Image.asset(
                        'assets/images/$_image',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: _saveMenu,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        child: const Text('Simpan'),
      ),
    );
  }

  void _selectImage() {
    // Implement your image picker logic here
  }

  void _saveMenu() {
    final box = Hive.box<Menu>('menus');
    final updatedMenu = Menu(
      title: _title,
      price: _price,
      image: _image,
      category: widget.menu.category,
    );

    box.put(widget.menu.key, updatedMenu);
    Navigator.of(context).pop(); // Return to previous screen
  }
}
