import 'package:flutter/material.dart';
import 'package:proyekakhir/components/customWidgets/button.dart';
import 'package:proyekakhir/components/customWidgets/input.dart';
import 'package:proyekakhir/components/customWidgets/toast.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/pages/auth/loginPage.dart';
import 'package:proyekakhir/util/local_storage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  bool _isError = false;

  // Future<void> _submit(BuildContext context) async {
  //   if (_formKey.currentState!.validate()) {
  //     debugPrint("Email: ${emailController.text}");
  //     debugPrint("Password: ${passwordController.text}");

  //     await successToast(
  //       context,
  //       text: 'Berhasil mendaftar, silahkan tunggu beberapa saat',
  //     );

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const LoginPage()),
  //     );
  //   } else {
  //     debugPrint("Form tidak valid");
  //   }
  // }

  void _submit() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() => _isError = true);
      return;
    }

    // Simpan username & password di SharedPreferences
    await LocalStorage.saveUser(
      emailController.text.trim(),
      passwordController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Registrasi berhasil! Silakan login.")),
    );

    Navigator.pop(context); // Kembali ke login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColor.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColor.dark,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: AppColor.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Image.asset(
                  'assets/images/brand_logo.png',
                  width: 250,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 5),
                Text(
                  'Silahkan daftar melalui akun',
                  style: AppFont.nunitoSansBold.copyWith(
                    fontSize: 20,
                    color: AppColor.dark,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Input(
                        keyboardType: TextInputType.emailAddress,
                        labelText: 'Email',
                        hintText: 'Masukkan email',
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email wajib diisi';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Input(
                        labelText: 'Password',
                        hintText: 'Masukkan password',
                        controller: passwordController,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password wajib diisi';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Input(
                        labelText: 'Konfirmasi Password',
                        hintText: 'Masukkan Konfirmasi password',
                        controller: passwordConfirmationController,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password wajib diisi';
                          }
                          if (passwordConfirmationController.text !=
                              passwordController.text) {
                            return 'Konfirmasi password tidak sesuai';
                          }
                          if (value.length < 6) {
                            return 'Konfirmasi password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      PillsButton(
                        text: 'Mendaftar',
                        fontSize: 16,
                        paddingSize: 80,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Sudah punya akun? Silahkan',
                                style: AppFont.nunitoSansRegular.copyWith(
                                  color: AppColor.dark,
                                ),
                              ),
                              TextSpan(
                                text: ' Masuk ',
                                style: AppFont.nunitoSansRegular.copyWith(
                                  color: AppColor.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
