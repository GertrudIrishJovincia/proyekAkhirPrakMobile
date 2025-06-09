import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  static const String _keyLogin = 'is_logged_in';
  static const String _keyUsername = 'username';
  static const String _keyFavoriteIds = 'favorite_ids';
  static const String _keyUserEmail = 'user_email';
  static const String _keyCartItems = 'cart_items'; // Key baru untuk cart

  // Simpan status login dan username
  static Future<void> login(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLogin, true);
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyUserEmail, username);
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLogin) ?? false;
  }

  static Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLogin);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyUserEmail);
  }

  // **Fungsi baru untuk simpan user (username & password)**
  static Future<void> saveUser(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('password_$username', password);
  }

  // Fungsi untuk cek password user saat login
  static Future<bool> checkUserPassword(
    String username,
    String password,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPassword = prefs.getString('password_$username');
    return savedPassword == password;
  }

  // Update user profile
  static Future<void> updateUserProfile(
    String oldUsername,
    String newUsername,
    String? newPassword,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Jika password baru diberikan, update password
    if (newPassword != null && newPassword.isNotEmpty) {
      // Hapus password lama
      await prefs.remove('password_$oldUsername');
      // Simpan password baru
      await prefs.setString('password_$newUsername', newPassword);
    } else {
      // Jika username berubah tapi password tidak, pindahkan password ke key baru
      if (oldUsername != newUsername) {
        String? existingPassword = prefs.getString('password_$oldUsername');
        if (existingPassword != null) {
          await prefs.setString('password_$newUsername', existingPassword);
          await prefs.remove('password_$oldUsername');
        }
      }
    }

    // Update username dan email di storage
    await prefs.setString(_keyUsername, newUsername);
    await prefs.setString(_keyUserEmail, newUsername);
  }

  // Ambil daftar favorite IDs (list string)
  static Future<List<String>?> getFavoriteIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFavoriteIds);
  }

  // Simpan daftar favorite IDs (list string)
  static Future<void> setFavoriteIds(List<String> ids) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyFavoriteIds, ids);
  }

  // Tambah satu id ke favorite list
  static Future<void> addFavoriteId(String id) async {
    final ids = await getFavoriteIds() ?? [];
    if (!ids.contains(id)) {
      ids.add(id);
      await setFavoriteIds(ids);
    }
  }

  // Hapus satu id dari favorite list
  static Future<void> removeFavoriteId(String id) async {
    final ids = await getFavoriteIds() ?? [];
    if (ids.contains(id)) {
      ids.remove(id);
      await setFavoriteIds(ids);
    }
  }

  // === FUNGSI CART BARU ===

  // Ambil semua item cart dari SharedPreferences
  static Future<List<Map<String, dynamic>>> getCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString(_keyCartItems);

    if (cartData != null) {
      List<dynamic> decoded = json.decode(cartData);
      return decoded.cast<Map<String, dynamic>>();
    }

    return [];
  }

  // Simpan semua item cart ke SharedPreferences
  static Future<void> setCartItems(List<Map<String, dynamic>> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encoded = json.encode(items);
    await prefs.setString(_keyCartItems, encoded);
  }

  // Tambah item ke cart
  static Future<void> addCartItem(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> items = await getCartItems();

    // Cek apakah item sudah ada di cart berdasarkan ID
    bool itemExists = items.any(
      (existingItem) => existingItem['id'] == item['id'],
    );

    if (!itemExists) {
      items.add(item);
      await setCartItems(items);
    }
  }

  // Hapus item dari cart berdasarkan index
  static Future<void> removeCartItem(int index) async {
    List<Map<String, dynamic>> items = await getCartItems();

    if (index >= 0 && index < items.length) {
      items.removeAt(index);
      await setCartItems(items);
    }
  }

  // Hapus item dari cart berdasarkan ID
  static Future<void> removeCartItemById(String id) async {
    List<Map<String, dynamic>> items = await getCartItems();
    items.removeWhere((item) => item['id'] == id);
    await setCartItems(items);
  }

  // Kosongkan seluruh cart
  static Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCartItems);
  }

  // Hitung total harga cart
  static Future<double> getCartTotalPrice() async {
    List<Map<String, dynamic>> items = await getCartItems();
    double total = 0.0;

    for (var item in items) {
      total += (item['productPrice'] ?? 0).toDouble();
    }

    return total;
  }

  // Hitung jumlah item di cart
  static Future<int> getCartItemCount() async {
    List<Map<String, dynamic>> items = await getCartItems();
    return items.length;
  }
}
