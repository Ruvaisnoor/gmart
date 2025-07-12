import 'package:calicut_university/data/cart_data.dart';
import 'package:calicut_university/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screen/splash_screen.dart';
import 'screen/login_screen.dart';
import 'screen/signup_screen.dart';
import 'screen/forgot_password_screen.dart';
import 'screen/home_screen.dart';
import 'screen/wishlist_screen.dart';
import 'screen/product_details_page.dart';
import 'models/product.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gmart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/',
     routes: {
  '/': (_) => SplashScreen(),
  '/login': (_) => LoginScreen(),
  '/signup': (_) => SignUpScreen(),
  '/forgot': (_) => ForgotPasswordScreen(),
  '/home': (_) => HomeScreen(),
  '/wishlist': (_) => WishlistScreen(),
  '/cart': (_) => CartScreen(), 
  '/profile': (_) => const ProfileScreen(),
  '/details': (ctx) {
    final product = ModalRoute.of(ctx)!.settings.arguments as Product;
    return ProductDetailsPage(product: product);
  },
},

    );
  }
}
