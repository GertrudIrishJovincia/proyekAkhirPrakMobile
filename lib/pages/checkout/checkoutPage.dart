import 'package:flutter/material.dart';
import 'package:proyekakhir/components/customWidgets/button.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/helpers/moneyFormat.dart';
import 'package:proyekakhir/util/local_storage.dart';
import 'package:proyekakhir/models/order_model.dart';
import 'package:proyekakhir/services/hive_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _addressController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _paymentMethod = 'Cash';
  List<Map<String, dynamic>> cartItems = [];
  double totalPrice = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCartData();
    _loadUserData();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Load cart data dari LocalStorage
  Future<void> _loadCartData() async {
    try {
      final items = await LocalStorage.getCartItems();
      final total = await LocalStorage.getCartTotalPrice();

      setState(() {
        cartItems = items;
        totalPrice = total;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading cart: $e')));
    }
  }

  // Load user data untuk pre-fill form
  Future<void> _loadUserData() async {
    try {
      final username = await LocalStorage.getUsername();
      if (username != null) {
        _nameController.text = username;
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Simpan pesanan ke Hive
  Future<void> _saveOrderToHive() async {
    try {
      // Generate order ID berdasarkan timestamp
      String orderId = 'ORDER_${DateTime.now().millisecondsSinceEpoch}';

      // Convert cart items ke OrderItem
      List<OrderItem> orderItems = cartItems.map((item) {
        return OrderItem.fromMap(item);
      }).toList();

      // Buat OrderModel
      OrderModel order = OrderModel(
        orderId: orderId,
        items: orderItems,
        totalPrice: totalPrice,
        shippingAddress: _addressController.text.trim(),
        paymentMethod: _paymentMethod,
        orderDate: DateTime.now(),
        status: 'confirmed',
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
      );

      // Simpan ke Hive
      await HiveService.saveOrder(order);

      print('Order saved successfully to Hive with ID: $orderId');

      // Optional: Show order summary
      _showOrderSummary(order);
    } catch (e) {
      print('Error saving order to Hive: $e');
      throw e;
    }
  }

  // Show order summary dialog
  void _showOrderSummary(OrderModel order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Pesanan Berhasil!',
            style: AppFont.nunitoSansBold.copyWith(color: Colors.green),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order ID: ${order.orderId}',
                style: AppFont.nunitoSansRegular,
              ),
              const SizedBox(height: 8),
              Text(
                'Total: ${formatIDRCurrency(number: order.totalPrice.toInt())}',
                style: AppFont.nunitoSansSemiBold,
              ),
              const SizedBox(height: 8),
              Text(
                'Status: ${order.status.toUpperCase()}',
                style: AppFont.nunitoSansRegular,
              ),
              const SizedBox(height: 8),
              Text(
                'Tanggal: ${order.formattedDate}',
                style: AppFont.nunitoSansRegular,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: AppFont.nunitoSansSemiBold),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmOrder() async {
    final address = _addressController.text.trim();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    // Validasi input
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama lengkap wajib diisi')));
      return;
    }

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor telepon wajib diisi')),
      );
      return;
    }

    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alamat pengiriman wajib diisi')),
      );
      return;
    }

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Keranjang kosong')));
      return;
    }

    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Simpan pesanan ke Hive
      await _saveOrderToHive();

      // Kosongkan keranjang menggunakan LocalStorage
      await LocalStorage.clearCart();

      // Hide loading
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pesanan berhasil dikonfirmasi dan disimpan!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to dashboard and clear all previous routes
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/dashboard', (route) => false);
    } catch (e) {
      // Hide loading
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan pesanan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: AppFont.nunitoSansSemiBold),
        backgroundColor: AppColor.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.dark),
      ),
      backgroundColor: AppColor.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: AppColor.grayWafer,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Keranjang kosong',
                    style: AppFont.nunitoSansSemiBold.copyWith(
                      fontSize: 18,
                      color: AppColor.grayWafer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tidak ada item untuk checkout',
                    style: AppFont.nunitoSansRegular.copyWith(
                      color: AppColor.grayWafer,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer Information Section
                  Text(
                    'Informasi Pelanggan',
                    style: AppFont.nunitoSansBold.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Nomor Telepon',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.phone),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Order Summary Section
                  Text(
                    'Ringkasan Pesanan',
                    style: AppFont.nunitoSansBold.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: cartItems.length,
                      separatorBuilder: (_, __) => const Divider(height: 16),
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item['productImage'] ?? '',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    color: AppColor.grayWafer.withOpacity(0.3),
                                    child: const Icon(
                                      Icons.image_not_supported,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['productName'] ?? 'Unknown Product',
                                    style: AppFont.nunitoSansSemiBold,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatIDRCurrency(
                                      number: (item['productPrice'] ?? 0)
                                          .toInt(),
                                    ),
                                    style: AppFont.nunitoSansBold.copyWith(
                                      color: AppColor.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Shipping Address Section
                  Text(
                    'Alamat Pengiriman',
                    style: AppFont.nunitoSansBold.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _addressController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'Masukkan alamat lengkap pengiriman',
                      hintStyle: AppFont.nunitoSansRegular.copyWith(
                        color: AppColor.grayWafer,
                      ),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: Icon(Icons.location_on),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Payment Method Section
                  Text(
                    'Metode Pembayaran',
                    style: AppFont.nunitoSansBold.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  RadioListTile<String>(
                    title: Text(
                      'Cash on Delivery (COD)',
                      style: AppFont.nunitoSansRegular,
                    ),
                    subtitle: Text(
                      'Bayar saat barang diterima',
                      style: AppFont.nunitoSansRegular.copyWith(
                        fontSize: 12,
                        color: AppColor.grayWafer,
                      ),
                    ),
                    value: 'Cash',
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value!;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),

                  RadioListTile<String>(
                    title: Text(
                      'Credit Card',
                      style: AppFont.nunitoSansRegular,
                    ),
                    subtitle: Text(
                      'Pembayaran dengan kartu kredit',
                      style: AppFont.nunitoSansRegular.copyWith(
                        fontSize: 12,
                        color: AppColor.grayWafer,
                      ),
                    ),
                    value: 'Credit Card',
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value!;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),

                  RadioListTile<String>(
                    title: Text(
                      'Bank Transfer',
                      style: AppFont.nunitoSansRegular,
                    ),
                    subtitle: Text(
                      'Transfer ke rekening bank',
                      style: AppFont.nunitoSansRegular.copyWith(
                        fontSize: 12,
                        color: AppColor.grayWafer,
                      ),
                    ),
                    value: 'Bank Transfer',
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value!;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),

                  const SizedBox(height: 24),

                  // Total Price Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Pembayaran',
                              style: AppFont.nunitoSansRegular.copyWith(
                                color: AppColor.grayWafer,
                              ),
                            ),
                            Text(
                              '${cartItems.length} item${cartItems.length > 1 ? 's' : ''}',
                              style: AppFont.nunitoSansRegular.copyWith(
                                color: AppColor.grayWafer,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          formatIDRCurrency(number: totalPrice.toInt()),
                          style: AppFont.nunitoSansBold.copyWith(
                            fontSize: 20,
                            color: AppColor.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Confirm Order Button
                  SizedBox(
                    width: double.infinity,
                    child: PillsButton(
                      text: 'Konfirmasi Pesanan',
                      fullWidthButton: true,
                      fontSize: 16,
                      paddingSize: 16,
                      onPressed: _confirmOrder,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
