// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calicut_university/data/cart_data.dart';
import 'package:calicut_university/data/wishlist_data.dart';
import 'package:calicut_university/services/product_service.dart';
import '../models/product.dart';
import '../widgets/gradient_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;

  final categories = const [
    Icons.checkroom,
    Icons.phone_iphone,
    Icons.chair,
    Icons.brush,
    Icons.shopping_basket,
  ];
  final labels = const [
    'Fashion',
    'Electronics',
    'Home',
    'Beauty',
    'Grocery',
  ];

  void _onTabTapped(int index) {
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/wishlist');
        break;
      case 2:
        Navigator.pushNamed(context, '/cart');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
      default:
        setState(() => _selectedIndex = index);
    }
  }

  Widget _buildBadgeIcon(IconData icon, int count, Color badgeColor) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (count > 0)
          Positioned(
            right: -6,
            top: -6,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: badgeColor,
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  height: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      colors: const [
        Color(0xFF4CAF50),
        Color.fromARGB(221, 190, 234, 175),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leadingWidth: 100,
          leading: const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Image(
              image: AssetImage('asset/images/logo.png'),
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          actions: [
            if (user?.photoURL != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(user!.photoURL!),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Product>>(
          future: ProductService.fetchProducts(),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(child: Text('Error: ${snap.error}'));
            }

            final products = snap.data!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Promo Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.lightGreen, Color.fromARGB(255, 56, 142, 60)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Exclusive Deals!",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Hurry! Limited-time offers.",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child: const Text(
                          "Shop Now",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Categories
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Categories",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text("See All", style: TextStyle(color: Colors.white70)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (_, i) => Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: Icon(categories[i],
                              color: Colors.greenAccent),
                        ),
                        const SizedBox(height: 6),
                        Text(labels[i],
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Popular Products Grid
                const Text("Popular Products",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (ctx, i) {
                    final p = products[i];
                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/details',
                        arguments: p,
                      ),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.lightGreen, Color.fromARGB(255, 57, 145, 61)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      p.image,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.broken_image),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  p.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "₹${p.price.toStringAsFixed(2)}",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.star,
                                        size: 14, color: Colors.yellow),
                                    const SizedBox(width: 4),
                                    Text(p.rating.toString(),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),

        // Bottom Navigation with Badges
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.greenAccent,
          unselectedItemColor: Colors.grey,
          onTap: _onTabTapped,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: _buildBadgeIcon(Icons.favorite_border, wishlist.length, Colors.red),
              label: "Wishlist",
            ),
            BottomNavigationBarItem(
              icon: _buildBadgeIcon(Icons.shopping_cart_outlined, cart.length, Colors.greenAccent),
              label: "Cart",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
