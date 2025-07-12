import '../models/product.dart';

/// A globally accessible wishlist used across the app.
/// This list holds all products the user has added to their wishlist.
final List<Product> wishlist = [];

/// Adds a product to the wishlist if it's not already present.
void addToWishlist(Product product) {
  if (!wishlist.any((item) => item.id == product.id)) {
    wishlist.add(product);
  }
}

/// Removes a product from the wishlist by ID.
void removeFromWishlist(Product product) {
  wishlist.removeWhere((item) => item.id == product.id);
}

/// Checks if a product is already in the wishlist.
bool isInWishlist(Product product) {
  return wishlist.any((item) => item.id == product.id);
}
