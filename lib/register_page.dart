import 'dart:convert';
import 'package:dental/common_color.dart';
import 'package:dental/login_page.dart';
import 'package:dental/text_styles.dart';
import 'package:dental/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

  class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
  }

  class _RegisterPageState extends State<RegisterPage> {
    String? selectedUserType;
    String? selectedPlace;

    final PageController _pageController = PageController();
    final _formKey=GlobalKey<FormState>();
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController clinicNameController = TextEditingController();
    final TextEditingController mobileController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
    String generateRegId(String userType, int count) {
      String prefix;
      switch (userType) {
        case "Admin":
          prefix = "ADM";
          break;
        case "SuperAdmin":
          prefix = "SUP";
          break;
        default:
          prefix = "USR";
      }
      return "$prefix-${count + 1}";
    }
    void _showAlert(BuildContext context, String message) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Alert"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
    Future<void> _saveUserData() async {
      if (_formKey.currentState!.validate()) {
        if (selectedUserType == null || selectedUserType!.isEmpty) {
          _showAlert(context, "Please select a User Type");
          return;
        }
        if (selectedPlace == null || selectedPlace!.isEmpty) {
          _showAlert(context, "Please select a Place");
          return;
        }

        final prefs = await SharedPreferences.getInstance();
        List<String> userList = prefs.getStringList("users") ?? [];

        // Check if email already exists
        bool emailExists = userList.any((userStr) {
          final Map<String, dynamic> userMap = jsonDecode(userStr);
          return userMap['email']?.toString().toLowerCase() == emailController.text.toLowerCase();
        });

        if (emailExists) {
          _showAlert(context, "Email already exists. Please use a different email.");
          return;
        }

        String regId = generateRegId(selectedUserType ?? "", userList.length);

        final newUser = UserModel(
          regId: regId,
          fullName: fullNameController.text,
          email: emailController.text,
          userType: selectedUserType ?? "",
          clinicName: clinicNameController.text,
          mobile: mobileController.text,
          address: selectedPlace ?? "",
          password: passwordController.text,
          isActive: true,
        );

        userList.add(jsonEncode(newUser.toJson()));
        await prefs.setStringList("users", userList);

        String _planStartKey = "plan_start";
        String _planUserKey = "plan_user";

        Future<void> activatePlan(String registerId) async {
          final prefs = await SharedPreferences.getInstance();
          final now = DateTime.now().millisecondsSinceEpoch;

          await prefs.setString(_planUserKey, registerId);
          await prefs.setInt(_planStartKey, now);
          print('plan success');
        }

        if (selectedUserType == 'Admin') {
          await activatePlan(regId);
          showSuccessDialog(context, "Free Plan Successfully activated for 3 days..Enjoy the Plan");
        } else {
          showSuccessDialog(context, "User registered successfully! Your Register Id is $regId");
        }

        // Clear form
        fullNameController.clear();
        emailController.clear();
        selectedPlace = null;
        selectedUserType = null;
        mobileController.clear();
        addressController.clear();
        passwordController.clear();
        confirmPasswordController.clear();

        print("User added. Total users: ${userList.length}");
      }
    }

    @override

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:AppColors.peacockBlue ,
      body: SingleChildScrollView(
        //physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
            //  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: size.width*0.45,
                  decoration: const BoxDecoration(
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
                          width: size.width*0.12, // adjust size
                          height: size.width*0.12,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),

                Container(
                  width: double.infinity,
                 // height:900,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    // Or use gradient:
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),),
                  child: Padding(
                    padding:  const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                         Center(
                           child: Text(
                            "Create Account",
                            style: AppTextStyles.labelText(context,color: AppColors.black),textAlign: TextAlign.center,
                        ),
                         ),

                        SizedBox(height: size.height * 0.01),

                        // Subtitle
                        Center(
                          child: Text(
                            "Sign up to enjoy the best Medical experience",textAlign: TextAlign.center,
                              style: AppTextStyles.valueText(context,color: AppColors.black)
                          ),
                        ),

                        const SizedBox(height: 10),

                        sectionTitle("Name", context, Colors.grey),

                        _buildTextField("Name", Icons.person,context,controller: fullNameController),
                        sectionTitle("Email", context, Colors.grey),

                        const SizedBox(height: 5),
                        _buildTextField("Email", Icons.email,context,controller: emailController),
                        const SizedBox(height: 5),
                        sectionTitle("userType", context, Colors.grey),
                        _buildDropdownField(
                          hint: "Select UserType",
                          icon: Icons.person_outline,
                          context: context,
                          items: ["User", "Admin", "SuperAdmin"],
                          selectedValue: (selectedUserType == null || selectedUserType!.isEmpty)
                              ? null
                              : selectedUserType,
                          onChanged: (value) {
                            setState(() {
                              selectedUserType = value;
                              print('us: $selectedUserType');
                            });
                          },
                        ),
                        if(selectedUserType=='Admin')
                          const SizedBox(height: 5),
                        if(selectedUserType=='Admin')
                          sectionTitle("Clinic Name", context, Colors.grey),
                        if(selectedUserType=='Admin')

                        _buildTextField("Clinic Name", Icons.local_hospital,context,controller: clinicNameController),
                        const SizedBox(height: 5),
                        sectionTitle("Mobile Number", context, Colors.grey),

                        _buildTextField(
                          "Mobile Number",
                          Icons.phone,
                          context,
                          controller: mobileController,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Mobile Number cannot be empty";
                            }
                            if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                              return "Enter a valid 10-digit mobile number starting with 6-9";
                            }
                            return null;
                          },
                        ),

                        sectionTitle("Address", context, Colors.grey),

                        //_buildTextField("Place", Icons.place,context,controller: addressController),
                        _buildDropdownField(
                          hint: "Select Place",
                          icon: Icons.place,
                          context: context,
                          items: ["Chennai", "Bangalore", "Mumbai"],
                          selectedValue: (selectedPlace == null || selectedPlace!.isEmpty)
                              ? null
                              : selectedPlace,
                          onChanged: (value) {
                            setState(() {
                              selectedPlace = value;
                              print('us: $selectedPlace');
                            });
                          },
                        ),
                        const SizedBox(height: 5),

                        sectionTitle("Password", context, Colors.grey),
                        _buildTextField("Password", Icons.lock, isPassword: true,context,controller:passwordController),

                        const SizedBox(height: 5),

                        sectionTitle("Confirm Password", context, Colors.grey),
                        _buildTextField("Confirm Password", Icons.lock, isPassword: true,context,controller: confirmPasswordController),

                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async{
                              await _saveUserData();

                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero, // Needed for gradient to fill the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.transparent, // Make button transparent for gradient
                              shadowColor: Colors.transparent,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: AppColors.peacockBlue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Sign Up",
                                  style: AppTextStyles.labelText(context, color: AppColors.white),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Or divider
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Or sign up with"),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Social Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton("assets/images/download.png",context),
                            const SizedBox(width: 20),
                            _buildSocialButton("assets/images/facebook.png",context),
                          ],
                        ),

                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text("Already have an account? ",style: AppTextStyles.valueText(context),),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                );


                              },
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                  color: AppColors.peacockBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

    Widget _buildTextField(
        String hint,
        IconData icon,
        BuildContext context, {
          bool isPassword = false,
          TextEditingController? controller,
          String? Function(String?)? validator,
          int? maxLength,
          TextInputType keyboardType = TextInputType.text, // Default to text
        }) {
      bool _obscureText = isPassword;

      return StatefulBuilder(
        builder: (context, setState) {
          return TextFormField(
            controller: controller,
            obscureText: isPassword ? _obscureText : false,
            keyboardType: keyboardType,
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
                  if (keyboardType == TextInputType.emailAddress &&
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

    Widget _buildSocialButton(String assetPath,dynamic context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
      },
      child: ClipRRect(
        child: CircleAvatar(
          radius: size.width*0.062,
          child: CircleAvatar(
            radius: size.width*0.061,
            backgroundColor: Colors.grey[200],
            backgroundImage: AssetImage(assetPath),
          ),
        ),
      ),
    );
  }
}
Widget _buildDropdownField({
  required String hint,
  required IconData icon,
  required dynamic context,
  required List<String> items,
  required String? selectedValue,
  required Function(String?) onChanged,
}) {
  final size = MediaQuery.of(context).size;

  return SizedBox(
    height: size.width * 0.14,
    child: InputDecorator(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.valueText(context),
        prefixIcon: Icon(icon, color: AppColors.grey),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.white),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: AppTextStyles.valueText(context)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    ),
  );
}
void showSuccessDialog(BuildContext context, String message) {
  final size = MediaQuery.of(context).size;
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              CircleAvatar(
                backgroundColor: Colors.green[100],
                radius: 30,
                child: const Icon(Icons.check_circle, color: Colors.green, size: 50),
              ),

              const SizedBox(height: 20),

              // Title
               Text(
                "Success",
                style:AppTextStyles.labelText(context)
              ),

              const SizedBox(height: 10),

              // Message
              Text(
                message,
                style: AppTextStyles.valueText(context),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // OK Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.peacockBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child:  Text("OK", style:AppTextStyles.valueText(context,color: AppColors.white)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
