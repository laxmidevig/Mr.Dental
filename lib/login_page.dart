import 'dart:convert';
import 'dart:io';

import 'package:dental/common_color.dart';
import 'package:dental/common_widget.dart';
import 'package:dental/dashboard_page.dart';
import 'package:dental/register_page.dart';
import 'package:dental/text_styles.dart';
import 'package:dental/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? selectedUserType;
  final _formKeyLogin = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController clinicNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Future<UserModel?> loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> userList = prefs.getStringList("users") ?? [];

    for (var userStr in userList) {
      final Map<String, dynamic> userMap = jsonDecode(userStr);
      final user = UserModel.fromJson(userMap);

      if (user.email == email && user.password == password) {
        print(
            "Logged in as ${user.email} name: ${user.fullName} userType: ${user
                .userType} regId: ${user.regId}");
        return user;
      }
    }
    return null;
  }

  DateTime? currentBackPressTime;

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      CommonDialog.showExitDialog(context);
      return false;
    }
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.peacockBlue,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKeyLogin,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: size.width * 0.45,
                    decoration: BoxDecoration(
                      //color: bgColor,
                      // Or use gradient:
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF5A46F3), AppColors.peacockBlue],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/tooth.png",
                            width: size.width * 0.12, // adjust size
                            height: size.width * 0.12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    height: 800,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      // Or use gradient:
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Center(
                            child: Text(
                                "SignIn", textAlign: TextAlign.center,
                                style: AppTextStyles.labelText(
                                    context, color: AppColors.black)
                            ),
                          ),

                          SizedBox(height: size.height * 0.01),

                          // Subtitle
                          Center(
                            child: Text(
                                "Sign In and get the best Medical experience",
                                textAlign: TextAlign.center,
                                style: AppTextStyles.valueText(
                                    context, color: AppColors.grey)
                            ),
                          ),

                          const SizedBox(height: 40),

                          sectionTitle("Enter Your Email", context,
                              Colors.grey),
                          _buildTextField("Email", Icons.email, context,
                              controller: emailController),
                          const SizedBox(height: 20),

                          sectionTitle("Enter Your Password", context, Colors.grey),
                          _buildTextField(
                            "Password", // Hint text
                            Icons.lock, // Prefix icon
                            context, // BuildContext
                            isPassword: true,
                            // Enable password field with eye toggle
                            controller: passwordController, // Controller for the field
                          ),

                          const SizedBox(height: 55),

                          // Sign Up Button
                          SizedBox(
                            width: size.width * 1,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.peacockBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKeyLogin.currentState!.validate()) {
                                  String email = emailController.text.trim();
                                  String password = passwordController.text;

                                  if (email.isEmpty || password.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Please enter email and password")),
                                    );
                                    return;
                                  }
                                  UserModel? user = await loginUser(
                                      email, password);

                                  if (user != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text(
                                          "Login Successfully")),);
                                    emailController.clear();
                                    passwordController.clear();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DentalHomePage(
                                                regId: user.regId ?? "",
                                                userType: user.userType ?? "",
                                                fullName: user.fullName ?? "",
                                                place: user.address ?? ""
                                            ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text(
                                          "Invalid email or password")),
                                    );
                                  }
                                }
                              }, child: Text(
                              "Sign In",
                              style: AppTextStyles.labelText(
                                  context, color: AppColors.white),
                            ),
                            ),
                          ),


                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Are You New User ? Please Click Register ",
                                style: AppTextStyles.valueText(context),),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (
                                        context) => const RegisterPage()),
                                  );
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: AppColors.peacockBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildTextField(String hint,
      IconData icon,
      BuildContext context, {
        bool isPassword = false,
        TextEditingController? controller,
        String? Function(String?)? validator,
        int? maxLength,
      }) {
    bool _obscureText = isPassword;

    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          controller: controller,
          obscureText: isPassword ? _obscureText : false,
          style: AppTextStyles.valueText(context, color: Colors.black54),
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.valueText(context),
            prefixIcon: Icon(icon, color: AppColors.grey),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding:
            const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppColors.white),
            ),
          ),
          validator: validator ??
                  (value) {
                if (value == null || value.isEmpty) {
                  return "$hint cannot be empty";
                }
                if (hint == "Email" &&
                    !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                        .hasMatch(value)) {
                  return "Enter a valid email";
                }
                return null;
              },
        );
      },
    );
  }
}
