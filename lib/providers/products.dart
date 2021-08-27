import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shop_app/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String? authToken;
  final String? userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return _items.where((item) => item.isFavorite == true).toList();
  }

  Product getItem(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://starting-with-flutter-f2649-default-rtdb.firebaseio.com/products.json?auth=$authToken');

    try {
      final response = await http.get(url);

      if (json.decode(response.body) == null) return;
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
          userId: prodData['userId'],
        ));
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://starting-with-flutter-f2649-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'userId': userId,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
        userId: userId,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeProduct(String id) async {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();

    final url = Uri.parse(
        'https://starting-with-flutter-f2649-default-rtdb.firebaseio.com/products/${id}.json?auth=$authToken');

    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    dynamic existingProduct = _items[existingProductIndex];

    // Optimistic Updating
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct as Product);
      notifyListeners();
      throw "Error Occured";
    }

    existingProduct = null;
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      final url = Uri.parse(
          'https://starting-with-flutter-f2649-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$authToken');

      try {
        await http.patch(url,
            body: json.encode({
              'title': product.title,
              'userId': userId,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'isFavorite': product.isFavorite,
            }));

        _items[index] = product;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }
}
