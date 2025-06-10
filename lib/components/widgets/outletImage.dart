import 'package:flutter/material.dart';
import 'package:proyekakhir/components/customWidgets/image.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';

class OutletImage extends StatelessWidget {
  const OutletImage({
    super.key,
    required this.url,
    this.text = '',
    this.colorFilter = 0.5,
    required Null Function() onPressed,
  });
  final String url;
  final String text;
  final double? colorFilter;
  @override
  Widget build(BuildContext context) {
    return OverlayImage(
      height: 300,
      width: 300,
      borderRadius: 12,
      widget: Center(
        child: Text(
          text,
          style: AppFont.nunitoSansBold.copyWith(
            color: AppColor.white,
            fontSize: 16,
          ),
        ),
      ),
      image: NetworkImage(url, scale: 1.0),
      colorFilter: colorFilter ?? 0.5,
    );
  }
}
