import 'package:flutter/material.dart';
import 'package:proyekakhir/components/customWidgets/button.dart';
import 'package:proyekakhir/components/customWidgets/input.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/util/local_storage.dart';

class EditProfilePage extends StatefulWidget {
  final String currentUsername;
  final String currentEmail;

  const EditProfilePage({
    super.key,
    required this.currentUsername,
    required this.currentEmail,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.currentEmail);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String newEmail = emailController.text.trim();
      String? newPassword;

      // Check if password is provided
      if (passwordController.text.isNotEmpty) {
        newPassword = passwordController.text;
      }

      // Update profile in local storage
      await LocalStorage.updateUserProfile(
        widget.currentEmail, // old username/email
        newEmail, // new username/email
        newPassword, // new password (can be null)
      );

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile successfully updated!'),
            backgroundColor: Colors.green,
          ),
        );

        // Go back to profile page with success indicator
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColor.dark,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Edit Profile',
          style: AppFont.nunitoSansSemiBold.copyWith(
            fontSize: 18,
            color: AppColor.dark,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Header
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.account_circle,
                          size: 80,
                          color: AppColor.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Update Your Profile',
                          style: AppFont.nunitoSansBold.copyWith(
                            fontSize: 20,
                            color: AppColor.dark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Fill out the information below to update your profile',
                          style: AppFont.nunitoSansRegular.copyWith(
                            fontSize: 14,
                            color: AppColor.dark.withOpacity(0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Email Field
                  Input(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // New Password Field
                  Input(
                    labelText: 'New Password (Optional)',
                    hintText: 'Enter a new password if you want to change it',
                    controller: passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Confirm Password Field
                  Input(
                    labelText: 'Confirm New Password',
                    hintText: 'Confirm your new password',
                    controller: confirmPasswordController,
                    isPassword: true,
                    validator: (value) {
                      if (passwordController.text.isNotEmpty) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 40),

                  // Update Button
                  SizedBox(
                    width: double.infinity,
                    child: PillsButton(
                      text: _isLoading ? 'Updating...' : 'Update Profile',
                      backgroundColor: AppColor.primary,
                      fontSize: 16,
                      paddingSize: 0,
                      fullWidthButton: true,
                      onPressed: _isLoading ? null : _updateProfile,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info Text
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColor.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColor.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Leave the password fields empty if you do not want to change your password.',
                            style: AppFont.nunitoSansRegular.copyWith(
                              fontSize: 12,
                              color: AppColor.dark.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
