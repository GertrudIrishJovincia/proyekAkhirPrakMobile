import 'package:flutter/material.dart';
import 'package:proyekakhir/components/customWidgets/carding.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/helpers/moneyFormat.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    this.onPressed,
    required this.url,
    required this.productPrice,
    required this.productName,
  });
  final dynamic Function()? onPressed;
  final String url;
  final int productPrice;
  final String productName;

  @override
  Widget build(BuildContext context) {
    return Carding(
      color: AppColor.white,
      borderRadius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              url,
              width: double.infinity,
              height: 124,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 124,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.error, color: Colors.grey),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 124,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 8,
                top: 8,
                bottom: 8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          productName.isNotEmpty ? productName : 'No Name',
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppFont.nunitoSansSemiBold.copyWith(
                            color: AppColor.dark,
                            fontSize: 14,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatIDRCurrency(number: productPrice),
                          style: AppFont.nunitoSansBold.copyWith(
                            color: AppColor.primary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onPressed ?? () {},
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.visibility_rounded,
                        color: AppColor.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
