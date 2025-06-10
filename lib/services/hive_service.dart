// services/hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/order_model.dart';

class HiveService {
  static const String orderBoxName = 'orders';
  static const String userBoxName = 'users';
  static const String cartBoxName = 'cart';

  // Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(OrderModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(OrderItemAdapter());
    }

    // Open boxes
    await Hive.openBox<OrderModel>(orderBoxName);
    await Hive.openBox(userBoxName);
    await Hive.openBox(cartBoxName);
  }

  // === ORDER OPERATIONS ===

  // Get orders box
  static Box<OrderModel> get orderBox => Hive.box<OrderModel>(orderBoxName);

  // Save order
  static Future<void> saveOrder(OrderModel order) async {
    await orderBox.put(order.orderId, order);
  }

  // Get all orders
  static List<OrderModel> getAllOrders() {
    return orderBox.values.toList();
  }

  // Get orders by status
  static List<OrderModel> getOrdersByStatus(String status) {
    return orderBox.values.where((order) => order.status == status).toList();
  }

  // Get order by ID
  static OrderModel? getOrderById(String orderId) {
    return orderBox.get(orderId);
  }

  // Update order status
  static Future<void> updateOrderStatus(
    String orderId,
    String newStatus,
  ) async {
    final order = orderBox.get(orderId);
    if (order != null) {
      order.status = newStatus;
      await order.save(); // Hive automatically saves changes
    }
  }

  // Delete order
  static Future<void> deleteOrder(String orderId) async {
    await orderBox.delete(orderId);
  }

  // Get recent orders (last 10)
  static List<OrderModel> getRecentOrders({int limit = 10}) {
    final orders = getAllOrders();
    orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    return orders.take(limit).toList();
  }

  // === CART OPERATIONS (Optional - jika ingin migrasi dari SharedPreferences) ===

  static Box get cartBox => Hive.box(cartBoxName);

  static Future<void> saveCartItems(List<Map<String, dynamic>> items) async {
    await cartBox.put('cart_items', items);
  }

  static List<Map<String, dynamic>> getCartItems() {
    final items = cartBox.get('cart_items');
    if (items != null) {
      return List<Map<String, dynamic>>.from(items);
    }
    return [];
  }

  static Future<void> clearCart() async {
    await cartBox.delete('cart_items');
  }

  // === USER OPERATIONS (Optional - untuk data user) ===

  static Box get userBox => Hive.box(userBoxName);

  static Future<void> saveUserData(String key, dynamic value) async {
    await userBox.put(key, value);
  }

  static T? getUserData<T>(String key) {
    return userBox.get(key);
  }

  // === UTILITY METHODS ===

  // Get total orders count
  static int getTotalOrdersCount() {
    return orderBox.length;
  }

  // Get total revenue from all orders
  static double getTotalRevenue() {
    return getAllOrders().fold(0.0, (sum, order) => sum + order.totalPrice);
  }

  // Close all boxes (call this in app disposal)
  static Future<void> closeBoxes() async {
    await Hive.close();
  }
}
