import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project/keranjang.dart';
import 'menu.dart'; 

class CustomerHomeScreen extends StatefulWidget {
  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedCategoryIndex = 0;
  String _searchQuery = ""; // Menyimpan query pencarian
  late Box<Menu> _menuBox; // Hive box for menu items
  List<Map<String, dynamic>> _cartItems = []; // To keep track of selected menu items

  @override
  void initState() {
    super.initState();
    _initializeHive(); // Initialize Hive database
  }

  Future<void> _initializeHive() async {
    _menuBox = await Hive.openBox<Menu>('menus');
    setState(() {}); // Refresh UI after loading data
  }

  // Method to retrieve and filter menu items from Hive
  List<Menu> _getFilteredMenu() {
    final List<Menu> items = _menuBox.values.where((menu) {
      return _selectedCategoryIndex == 0
          ? menu.category == 'Makanan'
          : menu.category == 'Minuman';
    }).toList();

    if (_searchQuery.isEmpty) {
      return items;
    }
    return items.where((item) {
      return item.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: const [
            Text(
              'Dapur Azkiya',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Pilih menu yang akan dipesan',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Search bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Cari menu',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Category tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text(
                    'Makanan',
                    style: TextStyle(color: Colors.black),
                  ),
                  selected: _selectedCategoryIndex == 0,
                  selectedColor: Colors.red,
                  onSelected: (value) {
                    setState(() {
                      _selectedCategoryIndex = 0;
                    });
                  },
                ),
                const SizedBox(width: 16),
                ChoiceChip(
                  label: const Text('Minuman'),
                  selected: _selectedCategoryIndex == 1,
                  selectedColor: Colors.red,
                  onSelected: (value) {
                    setState(() {
                      _selectedCategoryIndex = 1;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Display menu items from Hive
            _buildMenu(_getFilteredMenu()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          if (_cartItems.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(cartItems: _cartItems),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Keranjang Anda kosong')),
            );
          }
        },
        child: const Icon(Icons.shopping_cart, color: Colors.white),
      ),
    );
  }

  Widget _buildMenu(List<Menu> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return MenuItemCard(
          imageUrl: item.image,
          title: item.title,
          price: item.price,
          quantity: _cartItems.indexWhere((map) => map['title'] == item.title) == -1 ? 0 : _cartItems.firstWhere((map) => map['title'] == item.title)['quantity'],
          onAdd: () {
            setState(() {
              int itemIndex = _cartItems.indexWhere((map) => map['title'] == item.title);
              if (itemIndex == -1) {
                _cartItems.add({'title': item.title, 'price': item.price, 'quantity': 1});
              } else {
                _cartItems[itemIndex]['quantity'] += 1;
              }
            });
          },
          onRemove: () {
            setState(() {
              int itemIndex = _cartItems.indexWhere((map) => map['title'] == item.title);
              if (itemIndex != -1 && _cartItems[itemIndex]['quantity'] > 0) {
                _cartItems[itemIndex]['quantity'] -= 1;
                if (_cartItems[itemIndex]['quantity'] == 0) {
                  _cartItems.removeAt(itemIndex);
                }
              }
            });
          },
        );
      },
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int price;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const MenuItemCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
            child: Image.asset(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(currencyFormatter.format(price), style: TextStyle(color: Colors.red)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(Icons.remove, color: Colors.red),
                    ),
                    Text('$quantity', style: TextStyle(fontSize: 16)),
                    IconButton(
                      onPressed: onAdd,
                      icon: const Icon(Icons.add, color: Colors.green),
                    ),
                    
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
