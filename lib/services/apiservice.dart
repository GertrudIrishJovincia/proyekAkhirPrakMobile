import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart'; // Pastikan model Product sudah ada
import '../models/outlet.dart'; // Pastikan model Outlet sudah ada

class Apiservice {
  static const String productUrl =
      'https://68426aade1347494c31cbb75.mockapi.io/menu';
  static const String outletUrl =
      'https://68426aade1347494c31cbb75.mockapi.io/outlets';

  // Fungsi untuk mengambil produk
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(productUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fungsi untuk mengambil produk berdasarkan kategori
  static Future<List<Map<String, dynamic>>> fetchProductsByCategory(
    String category,
  ) async {
    final response = await http.get(
      Uri.parse('$productUrl?category=$category'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Data products for category $category: $jsonResponse');
      return jsonResponse
          .map(
            (data) => {
              "id": data['id'],
              "productName": data['product_name'],
              "productPrice": data['product_price'],
              "productImage": data['product_image'],
              "category": data['category'],
            },
          )
          .toList();
    } else {
      throw Exception('Failed to load products for category: $category');
    }
  }

  // Fungsi untuk mengambil produk berdasarkan ID
  static Future<Product> fetchProductById(String id) async {
    final response = await http.get(Uri.parse('$productUrl/$id'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return Product.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load product with ID: $id');
    }
  }

  // Fungsi untuk mengambil daftar outlet
  static Future<List<Outlet>> fetchOutlets() async {
    final response = await http.get(Uri.parse(outletUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Outlet.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load outlets');
    }
  }
}
