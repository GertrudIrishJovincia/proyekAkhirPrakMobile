import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyekakhir/models/product.dart';
import 'package:proyekakhir/pages/product/detailProductPage.dart';
import 'package:proyekakhir/providers/favoriteProvider.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/components/widgets/productCard.dart';
import 'package:proyekakhir/services/apiservice.dart';
import 'package:proyekakhir/util/local_storage.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<Product>> _futureFavoriteproducts;

  @override
  void initState() {
    super.initState();
    _futureFavoriteproducts = _loadFavoriteproducts();
  }

  Future<List<Product>> _loadFavoriteproducts() async {
    List<String>? favoriteIds = await LocalStorage.getFavoriteIds();

    if (favoriteIds == null || favoriteIds.isEmpty) {
      return [];
    }

    List<Product> favoriteproducts = [];
    for (String id in favoriteIds) {
      try {
        final product = await Apiservice.fetchProductById(id); // fetch Product
        favoriteproducts.add(product); // Add Product to list
      } catch (e) {
        // If fetching product fails, ignore and continue
      }
    }

    return favoriteproducts;
  }

  Future<void> _refreshFavorites(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _futureFavoriteproducts = _loadFavoriteproducts(); // Reload favorites
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorit Saya',
          style: AppFont.nunitoSansBold.copyWith(color: AppColor.white),
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.white),
      ),
      backgroundColor: AppColor.white,
      body: FutureBuilder<List<Product>>(
        future: _futureFavoriteproducts, // Use the correct type for Product
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada produk favorit'));
          }

          final favorites =
              snapshot.data!; // Get the list of favorites (Products)

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () => _refreshFavorites(context),
              color: AppColor.primary,
              backgroundColor: AppColor.white,
              child: favorites.isEmpty
                  ? Center(
                      child: Text(
                        'Belum ada produk favorit',
                        style: AppFont.nunitoSansRegular.copyWith(fontSize: 16),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.7,
                            ),
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          final product = favorites[index];
                          return ProductCard(
                            url:
                                product.productImage, // Correct property access
                            productName:
                                product.productName, // Correct property access
                            productPrice:
                                product.productPrice, // Correct property access
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailProductPage(id: product.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
