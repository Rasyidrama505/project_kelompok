import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'pemesanan.dart'; // Import OrderPage if it's in a separate file

// CartScreen
class CartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems; // Now expects a list of maps

  const CartScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    // Create a NumberFormat instance for the "Rp" currency format
    final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          // Menampilkan daftar item keranjang
          Expanded(
            child: cartItems.isEmpty
                ? const Center(
                    child: Text(
                      'Keranjang kosong',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        title: Text(item['title']),
                        subtitle: Text('Harga: ${currencyFormatter.format(item['price'])}'), // Format the price
                        trailing: Text('Jumlah: ${item['quantity']}'),
                      );
                    },
                  ),
          ),
          // Tombol Lanjut ke Pemesanan
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (cartItems.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPage(cartItems: cartItems),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Keranjang Anda kosong')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                "Lanjut Ke Pemesanan",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
