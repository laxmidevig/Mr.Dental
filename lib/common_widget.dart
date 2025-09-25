import 'package:dental/common_color.dart';
import 'package:dental/login_page.dart';
import 'package:dental/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          "Confirm Logout",
          style: AppTextStyles.labelText(context, color: AppColors.black),
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: AppTextStyles.valueText(context, color: AppColors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // close dialog
            child: Text(
              "Cancel",
              style: AppTextStyles.labelText(context, color: AppColors.peacockBlue),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pushReplacementNamed(context, '/loginScreen');
            },
            child: Text(
              "LogOut",
              style: AppTextStyles.labelText(context, color: AppColors.peacockBlue),
            ),
          ),
        ],
      );
    },
  );
}
class CommonDialog {
  static Future<void> showExitDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Exit Confirmation',
            style: AppTextStyles.labelText(context, color: AppColors.black),),
          content: Text('Press back again to exit',
            style: AppTextStyles.valueText(context, color: AppColors.black),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: AppTextStyles.valueText(
                    context, color: AppColors.peacockBlue),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
              child: Text(
                'Yes',
                style: AppTextStyles.valueText(
                    context, color: AppColors.peacockBlue),

              ),
            ),
          ],
        );
      },
    );
  }
}

 Future<void> showLogOutDialog(BuildContext context) async {
return showDialog(
context: context,
barrierDismissible: false,
builder: (context) {
return AlertDialog(
title: Text('LogOut',textAlign: TextAlign.center,
style: AppTextStyles.labelText(context, color: AppColors.black),),
content: Text('Are You Want To LogOut Confirm?',
style: AppTextStyles.valueText(context, color: AppColors.black),),
actions: [
TextButton(
onPressed: () {
Navigator.of(context).pop();
},
child: Text(
'No',
style: AppTextStyles.valueText(
context, color: AppColors.peacockBlue),
),
),
TextButton(
onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
},
child: Text(
'Yes',
style: AppTextStyles.valueText(
context, color: AppColors.peacockBlue),

),
),
],
);
},
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
