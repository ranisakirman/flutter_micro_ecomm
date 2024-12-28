import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product_model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  Map<String, dynamic>? _productDetail;
  List<dynamic> _reviews = [];
  bool _isDetailLoading = false;
  bool _isPollingActive = true;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get productDetail => _productDetail;
  List<dynamic> get reviews => _reviews;
  bool get isDetailLoading => _isDetailLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('http://192.168.100.176:3000/products'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        _products = data.map((product) => Product.fromJson(product)).toList();
      } else {
        print("Error: Unexpected status code ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching products: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProductDetail(int productId) async {
    _isDetailLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(
          'http://192.168.100.176:3005/product/$productId?format=json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        _productDetail = data['product']['data'];
        _reviews = data['reviews'];
      }
    } catch (e) {
      print("Error fetching product detail: $e");
    }

    _isDetailLoading = false;
    notifyListeners();
  }

  void startPolling() {
    Future.doWhile(() async {
      if (!_isPollingActive) return false;

      await fetchProducts();
      await Future.delayed(const Duration(seconds: 5));
      return true;
    });
  }

  void stopPolling() {
    _isPollingActive = false;
  }
}
