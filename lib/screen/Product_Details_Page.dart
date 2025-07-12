import 'package:flutter/material.dart';
import 'package:calicut_university/data/cart_data.dart';
import 'package:calicut_university/data/wishlist_data.dart';
import '../models/product.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool get _isWished =>
      wishlist.any((item) => item.id == widget.product.id);

  bool get _isInCart =>
      cart.any((item) => item.id == widget.product.id);

  void _toggleWishlist() {
    setState(() {
      if (_isWished) {
        wishlist.removeWhere((item) => item.id == widget.product.id);
      } else {
        wishlist.add(widget.product);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isWished ? 'Removed from Wishlist' : 'Added to Wishlist',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _addToCart() {
    if (_isInCart) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Already in cart')),
      );
      return;
    }

    cart.add(widget.product);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
        title: const Text(
          'Details',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isWished ? Icons.favorite : Icons.favorite_border,
              color: _isWished ? Colors.red : Colors.grey,
            ),
            onPressed: _toggleWishlist,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _addToCart,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            _isInCart ? "Already in Cart" : "Add to Cart",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Hero(
            tag: p.id,
            child: Image.network(p.image, height: 300, fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          Text(
            p.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            '₹${p.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            p.title, // Replace with actual description if available
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }
}
