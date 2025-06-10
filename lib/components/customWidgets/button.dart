import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class PillsButton extends StatelessWidget {
  const PillsButton({
    super.key,
    this.text,
    this.backgroundColor = AppColor.primary,
    this.textColor = AppColor.white,
    this.fontSize = 12,
    this.paddingSize = 32,
    this.fullWidthButton = false,
    this.onPressed,
  });
  final String? text;
  final bool fullWidthButton;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double paddingSize;
  final dynamic Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return GFButton(
      blockButton: fullWidthButton,
      onPressed: onPressed ?? () {},
      text: text,
      textColor: textColor,
      size: GFSize.LARGE,
      type: GFButtonType.solid,
      shape: GFButtonShape.pills,
      padding: EdgeInsets.only(
        left: paddingSize,
        right: paddingSize,
        top: 10,
        bottom: 10,
      ),
      color: backgroundColor,
      textStyle: AppFont.nunitoSansBold.copyWith(
        color: textColor,
        fontSize: fontSize,
      ),
      //boxShadow: const [],
    );
  }
}

class IconPillsButton extends StatelessWidget {
  const IconPillsButton({
    super.key,
    this.onPressed,
    this.color = AppColor.primary,
    required this.icon,
    this.buttonType,
    this.borderColor,
    this.borderWidth,
    this.size = 24,
  });
  final Widget icon;
  final double size;
  final GFIconButtonShape? buttonType;
  final Color color;
  final Color? borderColor;
  final double? borderWidth;
  final dynamic Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth ?? 0,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GFIconButton(
        onPressed: onPressed ?? () {},
        icon: icon,
        size: size,
        shape: buttonType ?? GFIconButtonShape.pills,
        color: color,
      ),
    );
  }
}
