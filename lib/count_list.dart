import 'dart:convert';
import 'package:dental/common_color.dart';
import 'package:dental/text_styles.dart';
import 'package:dental/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCountPage extends StatefulWidget {
  const UserCountPage({Key? key}) : super(key: key);

  @override
  State<UserCountPage> createState() => _UserCountPageState();
}

class _UserCountPageState extends State<UserCountPage> {
  List<UserModel> users = [];

  // Count variables
  int adminActive = 0, adminInactive = 0;
  int superAdminActive = 0, superAdminInactive = 0;
  int userActive = 0, userInactive = 0;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> userList = prefs.getStringList("users") ?? [];

    users = userList.map((uStr) {
      final Map<String, dynamic> uMap = jsonDecode(uStr);
      return UserModel.fromJson(uMap);
    }).toList();

    // Calculate counts
    adminActive = users
        .where((u) => u.userType?.toLowerCase() == "admin" && u.isActive)
        .length;
    adminInactive = users
        .where((u) => u.userType?.toLowerCase() == "admin" && !u.isActive)
        .length;

    superAdminActive = users
        .where((u) => u.userType?.toLowerCase() == "superadmin" && u.isActive)
        .length;
    superAdminInactive = users
        .where((u) => u.userType?.toLowerCase() == "superadmin" && !u.isActive)
        .length;

    userActive = users
        .where((u) => u.userType?.toLowerCase() == "user" && u.isActive)
        .length;
    userInactive = users
        .where((u) => u.userType?.toLowerCase() == "user" && !u.isActive)
        .length;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double cardWidth = width < 600 ? width * 0.9 : width * 0.28;

    return Scaffold(
      appBar: AppBar(
        title:  Text("User Overview",style: AppTextStyles.labelText(context,color: AppColors.peacockBlue),),
        backgroundColor: AppColors.white,centerTitle: true,elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.peacockBlue, // Set your desired back arrow color
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildUserCard("Admin", adminActive, adminInactive, cardWidth),
            _buildUserCard("SuperAdmin", superAdminActive, superAdminInactive, cardWidth),
            _buildUserCard("User", userActive, userInactive, cardWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(
      String title, int activeCount, int inactiveCount, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.peacockBlue, AppColors.peacockBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCountBox("Active", activeCount, Colors.white),
              _buildCountBox("Inactive", inactiveCount, Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountBox(String label, int count, Color color) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        children: [
          Text(count.toString(),
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500, color: color)),
        ],
      ),
    );
  }
}
