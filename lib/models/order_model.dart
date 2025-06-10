  // models/order_model.dart
  import 'package:hive/hive.dart';

  part 'order_model.g.dart'; // Generated file

  @HiveType(typeId: 0)
  class OrderModel extends HiveObject {
    @HiveField(0)
    String orderId;

    @HiveField(1)
    List<OrderItem> items;

    @HiveField(2)
    double totalPrice;

    @HiveField(3)
    String shippingAddress;

    @HiveField(4)
    String paymentMethod;

    @HiveField(5)
    DateTime orderDate;

    @HiveField(6)
    String status;

    @HiveField(7)
    String? customerName;

    @HiveField(8)
    String? customerPhone;

    OrderModel({
      required this.orderId,
      required this.items,
      required this.totalPrice,
      required this.shippingAddress,
      required this.paymentMethod,
      required this.orderDate,
      this.status = 'confirmed',
      this.customerName,
      this.customerPhone,
    });

    // Getter untuk format tanggal yang mudah dibaca
    String get formattedDate {
      return '${orderDate.day}/${orderDate.month}/${orderDate.year} ${orderDate.hour}:${orderDate.minute.toString().padLeft(2, '0')}';
    }

    // Getter untuk total items
    int get totalItems => items.length;
  }

  @HiveType(typeId: 1)
  class OrderItem extends HiveObject {
    @HiveField(0)
    String id;

    @HiveField(1)
    String productName;

    @HiveField(2)
    double productPrice;

    @HiveField(3)
    String productImage;

    @HiveField(4)
    String? category;

    @HiveField(5)
    int quantity;

    OrderItem({
      required this.id,
      required this.productName,
      required this.productPrice,
      required this.productImage,
      this.category,
      this.quantity = 1,
    });

    // Convert dari Map ke OrderItem
    factory OrderItem.fromMap(Map<String, dynamic> map) {
      return OrderItem(
        id: map['id'] ?? '',
        productName: map['productName'] ?? '',
        productPrice: (map['productPrice'] ?? 0).toDouble(),
        productImage: map['productImage'] ?? '',
        category: map['category'],
        quantity: map['quantity'] ?? 1,
      );
    }

    // Convert OrderItem ke Map
    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'productName': productName,
        'productPrice': productPrice,
        'productImage': productImage,
        'category': category,
        'quantity': quantity,
      };
    }
  }

