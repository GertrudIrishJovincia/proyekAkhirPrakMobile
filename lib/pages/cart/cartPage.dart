import 'package:flutter/material.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/helpers/moneyFormat.dart';
import 'package:proyekakhir/components/customWidgets/button.dart';
import 'package:proyekakhir/pages/checkout/checkoutPage.dart';
import 'package:proyekakhir/util/local_storage.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];
  double totalPrice = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    setState(() {
      isLoading = true;
    });

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

  Future<void> removeItem(int index) async {
    try {
      await LocalStorage.removeCartItem(index);
      await loadCartItems(); // Reload cart items after removal

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item berhasil dihapus dari keranjang')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error removing item: $e')));
    }
  }

  Future<void> clearCart() async {
    try {
      await LocalStorage.clearCart();
      await loadCartItems(); // Reload cart items after clearing

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang berhasil dikosongkan')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error clearing cart: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang', style: AppFont.nunitoSansSemiBold),
        backgroundColor: AppColor.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.dark),
        actions: cartItems.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Kosongkan Keranjang',
                            style: AppFont.nunitoSansSemiBold,
                          ),
                          content: Text(
                            'Apakah Anda yakin ingin menghapus semua item dari keranjang?',
                            style: AppFont.nunitoSansRegular,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Batal',
                                style: AppFont.nunitoSansRegular,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                clearCart();
                              },
                              child: Text(
                                'Hapus Semua',
                                style: AppFont.nunitoSansSemiBold.copyWith(
                                  color: AppColor.red,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ]
            : null,
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
                    'Tambahkan produk ke keranjang untuk melanjutkan',
                    style: AppFont.nunitoSansRegular.copyWith(
                      color: AppColor.grayWafer,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: loadCartItems,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item['productImage'] ?? '',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              color: AppColor.grayWafer.withOpacity(0.3),
                              child: const Icon(Icons.image_not_supported),
                            );
                          },
                        ),
                      ),
                      title: Text(
                        item['productName'] ?? 'Unknown Product',
                        style: AppFont.nunitoSansSemiBold,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            formatIDRCurrency(
                              number: (item['productPrice'] ?? 0).toInt(),
                            ),
                            style: AppFont.nunitoSansBold.copyWith(
                              color: AppColor.primary,
                              fontSize: 16,
                            ),
                          ),
                          if (item['category'] != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              item['category'],
                              style: AppFont.nunitoSansRegular.copyWith(
                                color: AppColor.grayWafer,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: AppColor.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Hapus Item',
                                  style: AppFont.nunitoSansSemiBold,
                                ),
                                content: Text(
                                  'Apakah Anda yakin ingin menghapus "${item['productName']}" dari keranjang?',
                                  style: AppFont.nunitoSansRegular,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                      'Batal',
                                      style: AppFont.nunitoSansRegular,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      removeItem(index);
                                    },
                                    child: Text(
                                      'Hapus',
                                      style: AppFont.nunitoSansSemiBold
                                          .copyWith(color: AppColor.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total (${cartItems.length} item${cartItems.length > 1 ? 's' : ''})',
                            style: AppFont.nunitoSansRegular.copyWith(
                              color: AppColor.grayWafer,
                            ),
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
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 140,
                      child: PillsButton(
                        text: 'Checkout',
                        fullWidthButton: true,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CheckoutPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
