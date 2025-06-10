import 'package:flutter/material.dart';
import 'package:proyekakhir/components/widgets/productCard.dart';
// import 'package:proyekakhir/components/widgets/standSearchBar.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/pages/product/detailProductPage.dart';
import 'package:proyekakhir/services/apiservice.dart'; // Pastikan kamu sudah punya API service

class Productpage extends StatefulWidget {
  const Productpage({super.key});

  @override
  State<Productpage> createState() => _ProductpageState();
}

class _ProductpageState extends State<Productpage>
    with TickerProviderStateMixin {
  List<String> categories = ['Cake', 'Cookies', 'Bread', 'Side Dish'];
  String selectedCategory = 'Cake';
  bool isLoading = true;

  // Produk yang dikelompokkan berdasarkan kategori
  final Map<String, List<Map<String, dynamic>>> productsByCategory = {
    'Cake': [],
    'Cookies': [],
    'Bread': [],
    'Side Dish': [],
  };

  // Variabel untuk menyimpan query pencarian
  String searchQuery = '';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedCategory = categories[_tabController.index];
        fetchProductsByCategory(
          selectedCategory,
        ); // Memperbarui produk berdasarkan kategori
      });
    });
    fetchProductsByCategory(
      selectedCategory,
    ); // Ambil produk saat halaman dimuat pertama kali
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchProductsByCategory(String category) async {
    setState(() {
      isLoading = true;
    });

    try {
      final products = await Apiservice.fetchProductsByCategory(
        category,
      ); // Mengambil produk berdasarkan kategori
      setState(() {
        productsByCategory[category] = products;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching products: $e');
    }
  }

  List<Map<String, dynamic>> get currentProducts =>
      productsByCategory[selectedCategory] ?? [];

  List<Map<String, dynamic>> get filteredProducts {
    // Memfilter produk berdasarkan pencarian
    return currentProducts
        .where(
          (product) => product['productName'].toLowerCase().contains(
            searchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColor.primary)),
      );
    }

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: AppColor.white,
          title: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.gray),
              borderRadius: BorderRadius.circular(28),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search cake, cookies, anything..',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Categories',
                    style: AppFont.nunitoSansBold.copyWith(
                      fontSize: 20,
                      color: AppColor.dark,
                    ),
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  labelStyle: AppFont.nunitoSansMedium.copyWith(fontSize: 14),
                  labelColor: AppColor.primary,
                  unselectedLabelColor: AppColor.dark,
                  indicatorColor: AppColor.primary,
                  isScrollable: true,
                  padding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.only(left: 25, right: 25),
                  tabs: categories.map((cat) => Tab(text: cat)).toList(),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ProductTabView(
                products: filteredProducts,
              ), // Gunakan filteredProducts
            ),
          ),
        ),
      ),
    );
  }
}

class ProductTabView extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const ProductTabView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text("No products found."));
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.7,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          url: product["productImage"],
          productPrice: product["productPrice"],
          productName: product["productName"],
          onPressed: () {
            // Panggil halaman DetailProductPage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailProductPage(id: product["id"]),
              ),
            );
          },
        );
      },
    );
  }
}
