import 'package:flutter/material.dart';
import 'package:calicut_university/data/wishlist_data.dart';
import '../models/product.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: wishlist.isEmpty
          ? const Center(child: Text('Your wishlist is empty'))
          : ListView.builder(
              itemCount: wishlist.length,
              itemBuilder: (_, i) {
                final p = wishlist[i];
                return ListTile(
                  leading: Image.network(p.image, width: 50, height: 50),
                  title: Text(p.title),
                  subtitle: Text('₹${p.price.toStringAsFixed(2)}'),
                );
              },
            ),
    );
  }
}
