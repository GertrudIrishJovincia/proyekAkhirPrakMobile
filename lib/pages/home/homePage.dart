import 'package:flutter/material.dart';
import 'package:proyekakhir/components/widgets/bannerImage.dart';
import 'package:proyekakhir/components/widgets/outletImage.dart';
import 'package:proyekakhir/components/widgets/productCard.dart';
import 'package:proyekakhir/components/widgets/standSearchBar.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/models/product.dart';
import 'package:proyekakhir/pages/cart/cartPage.dart';
import 'package:proyekakhir/pages/outlet/detailOutletPage.dart';
import 'package:proyekakhir/pages/product/detailProductPage.dart';
import 'package:proyekakhir/pages/product/favoritePage.dart';
import 'package:proyekakhir/pages/product/orderHistoryPage.dart';
import 'package:proyekakhir/pages/product/productPage.dart';
import 'package:proyekakhir/services/apiservice.dart';
import 'package:proyekakhir/util/local_storage.dart';
import 'package:proyekakhir/models/outlet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];
  List<Outlet> outlets = [];
  bool isLoadingProducts = false;
  bool isLoadingOutlets = false;
  String _username = "User"; // Default username

  // Fungsi untuk memanggil API dan mengambil data outlet
  Future<void> fetchOutletsFromApi() async {
    setState(() {
      isLoadingOutlets = true;
    });

    try {
      final fetchedOutlets =
          await Apiservice.fetchOutlets(); // Mengambil data outlet
      setState(() {
        outlets = fetchedOutlets;
        isLoadingOutlets = false;
      });
    } catch (e) {
      setState(() {
        isLoadingOutlets = false;
      });
      print('Error fetching outlets: $e');
    }
  }

  // Fungsi untuk mengambil produk dari API
  Future<void> fetchProductsFromApi() async {
    setState(() {
      isLoadingProducts = true;
    });

    try {
      final fetchedProducts = await Apiservice.fetchProducts();
      setState(() {
        products = fetchedProducts;
        isLoadingProducts = false;
      });
    } catch (e) {
      setState(() {
        isLoadingProducts = false;
      });
      print('Error fetching products: $e');
    }
  }

  // Load username dari localStorage
  Future<void> loadUsername() async {
    try {
      String? username = await LocalStorage.getUsername();
      setState(() {
        _username = username ?? "User";
      });
    } catch (e) {
      print('Error loading username: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadUsername();
    fetchProductsFromApi(); // Memanggil fungsi fetchProducts saat widget dimuat
    fetchOutletsFromApi(); // Menambahkan pengambilan data outlet
  }

  // Extract first name from email atau username
  String getDisplayName(String fullName) {
    if (fullName.contains('@')) {
      // Jika berupa email, ambil bagian sebelum @
      return fullName.split('@')[0];
    } else {
      // Jika berupa nama, ambil nama pertama
      return fullName.split(' ')[0];
    }
  }

  // Fungsi untuk pull-to-refresh
  Future<void> _refresh() async {
    await Future.delayed(
      const Duration(seconds: 1),
    ); // Memberikan delay sebelum memperbarui data
    await fetchProductsFromApi(); // Memanggil fungsi untuk mengambil produk dari API
    await fetchOutletsFromApi(); // Memanggil fungsi untuk mengambil outlet dari API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        title: Text(
          'Hi ${getDisplayName(_username)}!',
          style: AppFont.nunitoSansBold.copyWith(
            fontSize: 20,
            color: AppColor.dark,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            color: AppColor.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            color: AppColor.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            color: AppColor.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderHistoryPage(),
                ),
              );
            },
          ),
        ],
        iconTheme: const IconThemeData(color: AppColor.dark),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh:
              _refresh, // Memanggil fungsi _refresh saat menarik untuk memuat ulang
          color: AppColor.primary,
          backgroundColor: AppColor.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.gray),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const StandSearchBar(
                      'Search cake, cookies, anything..',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Banner images
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: false,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 32 : 0,
                            right: 16,
                            top: 5,
                          ),
                          child: BannerImage(
                            "assets/images/banner_${index + 1}.png",
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Product section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Our Product',
                            style: AppFont.nunitoSansBold.copyWith(
                              color: AppColor.dark,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Productpage(),
                                ),
                              );
                            },
                            child: Text(
                              'All Product',
                              style: AppFont.nunitoSansBold.copyWith(
                                color: AppColor.primary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (isLoadingProducts)
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primary,
                          ),
                        )
                      else
                        SizedBox(
                          height: 260,
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];

                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: 16,
                                  top: 16,
                                  bottom: 20,
                                ),
                                child: ProductCard(
                                  url: '${product.productImage}',
                                  productName: "${product.productName}",
                                  productPrice: product.productPrice,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailProductPage(id: product.id),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Explore Shop (Outlets section)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore Shop',
                        style: AppFont.nunitoSansBold.copyWith(
                          color: AppColor.dark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (isLoadingOutlets)
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primary,
                          ),
                        )
                      else
                        // Ganti bagian GridView.builder untuk outlet dengan kode ini:
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12.0,
                                crossAxisSpacing: 12.0,
                                childAspectRatio:
                                    0.8, // Menambahkan aspect ratio untuk konsistensi
                              ),
                          itemCount: outlets.length,
                          itemBuilder: (context, index) {
                            final outlet = outlets[index];
                            return GestureDetector(
                              onTap: () {
                                print(
                                  'Outlet tapped: ${outlet.name}',
                                ); // Debug print
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailOutletPage(outlet: outlet),
                                  ),
                                );
                              },
                              child: OutletImage(
                                url: outlet.image,
                                text: outlet.address,
                                onPressed: () {
                                  print(
                                    'OutletImage onPressed called',
                                  ); // Debug print
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailOutletPage(outlet: outlet),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                    ],
                  ),

                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
