import 'package:flutter/material.dart';
import 'package:proyekakhir/models/outlet.dart'; // Pastikan model Outlet sudah ada
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';

class DetailOutletPage extends StatelessWidget {
  final Outlet outlet;

  const DetailOutletPage({super.key, required this.outlet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Text(outlet.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Gambar outlet
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                outlet.image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Nama outlet
            Text(
              outlet.name,
              style: AppFont.nunitoSansBold.copyWith(
                fontSize: 24,
                color: AppColor.dark,
              ),
            ),
            const SizedBox(height: 8),

            // Alamat outlet
            Text(
              outlet.address,
              style: AppFont.nunitoSansRegular.copyWith(
                fontSize: 16,
                color: AppColor.dark,
              ),
            ),
            const SizedBox(height: 16),

            // Menampilkan jumlah produk yang dijual
            Text(
              'Produk yang Dijual: ${outlet.outletSells}',
              style: AppFont.nunitoSansRegular.copyWith(
                fontSize: 16,
                color: AppColor.dark,
              ),
            ),
            const SizedBox(height: 16),

            // Menampilkan tanggal outlet dibuat
            Text(
              'Dibuat pada: ${outlet.createdAt.substring(0, 10)}',
              style: AppFont.nunitoSansRegular.copyWith(
                fontSize: 16,
                color: AppColor.dark,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
