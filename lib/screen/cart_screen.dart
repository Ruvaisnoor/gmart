import 'package:flutter/material.dart';
import 'package:calicut_university/data/cart_data.dart';
import '../models/product.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final total = cart.fold<double>(0, (sum, item) => sum + item.price);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4CAF50), Color.fromARGB(221, 190, 234, 175)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Cart'),
        ),
        body: cart.isEmpty
            ? const Center(
                child: Text(
                  'Your cart is empty',
                  style: TextStyle(color: Colors.white70),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (_, i) {
                        final p = cart[i];
                        return ListTile(
                          leading: Image.network(p.image, width: 50),
                          title: Text(p.title, style: const TextStyle(color: Colors.white)),
                          subtitle: Text('₹${p.price.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.white70)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () {
                              cart.removeAt(i);
                              (context as Element).reassemble();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Total: ₹${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
