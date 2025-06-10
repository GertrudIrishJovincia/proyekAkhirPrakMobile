import 'package:flutter/material.dart';
import 'package:proyekakhir/components/customWidgets/button.dart';
import 'package:proyekakhir/components/customWidgets/image.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/helpers/moneyFormat.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:proyekakhir/models/product.dart';
import 'package:proyekakhir/pages/cart/cartPage.dart';
import 'package:proyekakhir/services/apiservice.dart';
import 'package:proyekakhir/util/local_storage.dart';

class DetailProductPage extends StatefulWidget {
  final String id;

  const DetailProductPage({super.key, required this.id});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  late Future<Product> _futureProduct;
  bool isFavorite = false;
  bool isAddingToCart = false;
  String selectedSize = '16 cm'; // Default size

  @override
  void initState() {
    super.initState();
    _futureProduct = Apiservice.fetchProductById(widget.id);
    checkFavoriteStatus();
  }

  void checkFavoriteStatus() async {
    List<String>? favoriteIds = await LocalStorage.getFavoriteIds();
    setState(() {
      isFavorite = favoriteIds?.contains(widget.id) ?? false;
    });
  }

  void toggleFavorite() async {
    List<String> favoriteIds = await LocalStorage.getFavoriteIds() ?? [];
    if (isFavorite) {
      favoriteIds.remove(widget.id);
      await LocalStorage.setFavoriteIds(favoriteIds);
      setState(() {
        isFavorite = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Dihapus dari favorit')));
    } else {
      favoriteIds.add(widget.id);
      await LocalStorage.setFavoriteIds(favoriteIds);
      setState(() {
        isFavorite = true;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ditambahkan ke favorit')));
    }
  }

  Future<void> addToCart(Product product) async {
    setState(() {
      isAddingToCart = true;
    });

    try {
      // Create cart item with selected size
      final cartItem = {
        'id': '${product.id}_$selectedSize', // Make ID unique with size
        'productId': product.id, // Keep original product ID
        'productName': '${product.productName} ($selectedSize)',
        'productPrice': product.productPrice,
        'productImage': product.productImage,
        'category': product.category,
        'size': selectedSize,
        'addedAt': DateTime.now().millisecondsSinceEpoch,
      };

      // Check if item already exists in cart
      List<Map<String, dynamic>> existingItems =
          await LocalStorage.getCartItems();
      bool itemExists = existingItems.any(
        (item) => item['id'] == cartItem['id'],
      );

      if (itemExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${product.productName} ($selectedSize) sudah ada di keranjang',
            ),
            backgroundColor: AppColor.yellow,
          ),
        );
      } else {
        await LocalStorage.addCartItem(cartItem);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${product.productName} berhasil ditambahkan ke keranjang',
            ),
            backgroundColor: AppColor.primary,
          ),
        );

        // Navigate to cart page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error menambahkan ke keranjang: $e'),
          backgroundColor: AppColor.red,
        ),
      );
    } finally {
      setState(() {
        isAddingToCart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColor.white,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: FutureBuilder<Product>(
        future: _futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada detail produk'));
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 48,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OverlayImage(
                    borderRadius: 22,
                    height: 343,
                    boxFit: BoxFit.cover,
                    width: double.infinity,
                    image: NetworkImage("${product.productImage}"),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.productName,
                    style: AppFont.nunitoSansBold.copyWith(
                      color: AppColor.dark,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColor.yellow, size: 16),
                      Text(
                        "${product.rating ?? '0'}",
                        style: AppFont.nunitoSansSemiBold.copyWith(
                          color: AppColor.dark,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '(${product.ratingTotals ?? '0'})',
                        style: AppFont.nunitoSansSemiBold.copyWith(
                          color: AppColor.grayWafer,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    product.productDescription ??
                        "This is a delicious cake made with the finest ingredients. Perfect for any celebration or simply to satisfy your sweet tooth. Made fresh daily to ensure the best taste and quality.",
                    style: AppFont.nunitoSansRegular.copyWith(
                      color: AppColor.dark,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),

                  // Size Selection Label
                  Text(
                    'Pilih Ukuran:',
                    style: AppFont.nunitoSansSemiBold.copyWith(
                      color: AppColor.dark,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Size Selection Radio Buttons
                  CustomRadioButton(
                    elevation: 0,
                    enableShape: true,
                    buttonTextStyle: ButtonTextStyle(
                      textStyle: AppFont.nunitoSansSemiBold.copyWith(
                        color: AppColor.dark,
                        fontSize: 12,
                      ),
                    ),
                    unSelectedColor: AppColor.white,
                    unSelectedBorderColor: AppColor.dark.withOpacity(0.3),
                    selectedBorderColor: AppColor.primary,
                    buttonLables: const ['16 cm', '20 cm', '22 cm', '24 cm'],
                    buttonValues: const ['16 cm', '20 cm', '22 cm', '24 cm'],
                    width: 80,
                    padding: 8,
                    spacing: 1,
                    defaultSelected: selectedSize,
                    radioButtonValue: (value) {
                      setState(() {
                        selectedSize = value;
                      });
                      debugPrint('Selected size: $value');
                    },
                    selectedColor: AppColor.primary,
                    enableButtonWrap: false,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.border_color,
                        size: 16,
                        color: AppColor.grayWafer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ' Add wording on your cake (optional)',
                        style: AppFont.nunitoSansRegular.copyWith(
                          color: AppColor.grayWafer,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<Product>(
        future: _futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink(); // No bottom bar while loading
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const SizedBox.shrink(); // Hide bottom bar if there's an error or no data
          }

          final product = snapshot.data!;

          return Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total price ($selectedSize)',
                          style: AppFont.nunitoSansRegular.copyWith(
                            fontSize: 12,
                            color: AppColor.grayWafer,
                          ),
                        ),
                        Text(
                          formatIDRCurrency(
                            number: (product.productPrice ?? 0).toInt(),
                          ),
                          style: AppFont.nunitoSansBold.copyWith(
                            fontSize: 18,
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
                      onPressed: isAddingToCart
                          ? null
                          : () => addToCart(product),
                      fullWidthButton: false,
                      text: isAddingToCart ? 'Adding...' : 'Add to cart',
                      fontSize: 16,
                      paddingSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
