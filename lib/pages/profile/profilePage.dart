import 'package:flutter/material.dart';
import 'package:proyekakhir/components/widgets/infoDivider.dart';
import 'package:proyekakhir/components/widgets/userInfoAvatars.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/components/customWidgets/button.dart';
import 'package:proyekakhir/pages/auth/loginPage.dart';
import 'package:proyekakhir/pages/dashboard/dashboard.dart';
import 'package:proyekakhir/pages/auth/editProfilePage.dart';
import 'package:proyekakhir/util/local_storage.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = "Loading...";
  String _email = "Loading...";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void logout(BuildContext context) async {
    await LocalStorage.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void loadUserData() async {
    try {
      String? username = await LocalStorage.getUsername();
      String? email = await LocalStorage.getUserEmail();

      setState(() {
        _username = username ?? "Guest";
        _email = email ?? "No email";
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _username = "Error loading name";
        _email = "Error loading email";
      });
    }
  }

  void navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditProfilePage(currentUsername: _username, currentEmail: _email),
      ),
    );

    // Jika ada perubahan, reload data
    if (result == true) {
      loadUserData();
    }
  }

  // Extract display name from email
  String getDisplayName(String fullName) {
    if (fullName.contains('@')) {
      return fullName.split('@')[0];
    } else {
      return fullName.split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            );
          },
        ),
        title: Text(
          'Profiles',
          style: AppFont.nunitoSansSemiBold.copyWith(
            fontSize: 18,
            color: AppColor.dark,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.white,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColor.primary.withOpacity(0.2), AppColor.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(child: UserInfoAvatars(email: _email)),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            getDisplayName(_username),
                            style: AppFont.nunitoSansBold.copyWith(
                              fontSize: 24,
                              color: AppColor.dark,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        InfoDivider(
                          title: 'Name',
                          value: getDisplayName(_username),
                        ),
                        const SizedBox(height: 16),
                        InfoDivider(title: 'Email', value: _email),
                        const SizedBox(height: 32),

                        // Edit Profile Button
                        SizedBox(
                          width: double.infinity,
                          child: PillsButton(
                            text: 'Edit Profile',
                            backgroundColor: AppColor.gray.withOpacity(0.2),
                            textColor: AppColor.dark,
                            fontSize: 16,
                            paddingSize: 0,
                            fullWidthButton: true,
                            onPressed: navigateToEditProfile,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Logout Button
                        SizedBox(
                          width: double.infinity,
                          child: PillsButton(
                            text: 'Logout',
                            backgroundColor: AppColor.primary,
                            fontSize: 16,
                            paddingSize: 0,
                            fullWidthButton: true,
                            onPressed: () => logout(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
