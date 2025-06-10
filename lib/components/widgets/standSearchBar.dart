import 'package:flutter/material.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';

class StandSearchBar extends StatelessWidget {
  const StandSearchBar(this.text, {super.key});
  final String? text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: SearchBar(
        hintStyle: WidgetStatePropertyAll<TextStyle>(
          AppFont.nunitoSansRegular.copyWith(
            fontSize: 12,
            color: AppColor.gray,
          ),
        ),
        hintText: '$text',
        backgroundColor: const WidgetStatePropertyAll<Color>(AppColor.white),
        elevation: const WidgetStatePropertyAll<double>(0),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        ),
        leading: Icon(Icons.search, color: AppColor.dark.withOpacity(0.8)),
      ),
    );
  }
}
