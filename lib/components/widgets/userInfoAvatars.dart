import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class UserInfoAvatars extends StatelessWidget {
  const UserInfoAvatars({super.key, required this.email});
  final String email;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: GFAvatar(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              width: 500,
              height: 500,
              'https://ui-avatars.com/api/?name=$email&background=random&size=200&bold=true',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
