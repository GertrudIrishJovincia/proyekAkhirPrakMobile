// import 'package:final_project_sanbercode/config/app/app_font.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:proyekakhir/config/app/appColor.dart';

class OverlayImage extends StatelessWidget {
  const OverlayImage({
    super.key,
    this.height = 300,
    this.width = 300,
    required this.image,
    this.widget,
    this.boxFit,
    this.colorFilter,
    this.borderRadius,
  });
  final ImageProvider image;
  final Widget? widget;
  final double? height;
  final double? borderRadius;
  final double? width;
  final double? colorFilter;
  final BoxFit? boxFit;
  @override
  Widget build(BuildContext context) {
    return GFImageOverlay(
      height: height,
      width: width,
      child: widget ?? const SizedBox(),
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      image: image,
      boxFit: boxFit ?? BoxFit.fill,
      colorFilter: ColorFilter.mode(
        AppColor.dark.withOpacity(colorFilter ?? 0),
        BlendMode.darken,
      ),
    );
  }
}
