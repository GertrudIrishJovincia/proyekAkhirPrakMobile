import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyekakhir/components/customWidgets/button.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/routes/authRoutes.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/get_started.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Positioned(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColor.white,
                      AppColor.white,
                      AppColor.white.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 60),
              child: Column(
                children: [
                  const Spacer(),
                  Center(
                    child: Text(
                      'Hassle-Free Orderingst',
                      style: AppFont.nunitoSansBlack.copyWith(
                        fontSize: 20,
                        color: AppColor.darkLighter,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Enjoy a seamless and convenient ordering experience with our online platform that lets you get your cake delivered to your doorstep.',
                      style: AppFont.nunitoSansRegular.copyWith(
                        fontSize: 14,
                        color: AppColor.darkWafer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  PillsButton(
                    onPressed: () {
                      Get.toNamed(AuthRoutes.login);
                    },
                    text: 'Start Shopping',
                    fontSize: 16,
                    paddingSize: 32,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
