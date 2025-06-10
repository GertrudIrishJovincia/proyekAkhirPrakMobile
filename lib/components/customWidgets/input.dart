import 'package:flutter/material.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';

class Input extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const Input({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
  });
  final String labelText;
  final TextInputType? keyboardType;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType ?? TextInputType.text,
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      validator: widget.validator,
      cursorColor: AppColor.darkLighter,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        filled: true,
        fillColor: Colors.white,
        labelStyle: AppFont.nunitoSansLight.copyWith(
          color: AppColor.darkLighter,
        ),
        hintStyle: AppFont.nunitoSansLight.copyWith(
          color: AppColor.darkLighter,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.gray, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.gray, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.dark, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
