import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

const _kCacheKey = 'cached_products';

class ProductService {
  /// Attempts network fetch; on success caches the result.
  /// On any error or timeout, falls back to returning cached list (if any).
  static Future<List<Product>> fetchProducts() async {
    try {
      final products = await _fetchFromNetwork();
      await _saveToCache(products);
      return products;
    } catch (_) {
      final cached = await _loadFromCache();
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  static Future<List<Product>> _fetchFromNetwork() async {
    final url = Uri.parse('https://fakestoreapi.com/products');
    final resp = await http.get(url).timeout(const Duration(seconds: 10));
    if (resp.statusCode != 200) {
      throw Exception(
          'Network error: statusCode=${resp.statusCode}');
    }
    final List<dynamic> data = json.decode(resp.body) as List<dynamic>;
    return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> _saveToCache(List<Product> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((p) => p.toJsonString()).toList();
    await prefs.setStringList(_kCacheKey, jsonList);
  }

  static Future<List<Product>> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_kCacheKey);
    if (jsonList == null) return [];
    return jsonList
        .map((str) => Product.fromJson(json.decode(str) as Map<String, dynamic>))
        .toList();
  }
}
