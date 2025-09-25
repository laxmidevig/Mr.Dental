import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dental/common_color.dart';
import 'package:dental/common_widget.dart';
import 'package:dental/count_list.dart';
import 'package:dental/profile_page.dart';
import 'package:dental/register_page.dart';
import 'package:dental/text_styles.dart';
import 'package:dental/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DentalHomePage extends StatefulWidget {
  final String regId;
  final String userType;
  final String fullName;
  final String place;

   DentalHomePage({
    Key? key,
    required this.regId,
    required this.userType,
    required this.fullName,
     required this.place,

   }) : super(key: key);

  State<DentalHomePage> createState() => _DentalHomePageState();
}

class _DentalHomePageState extends State<DentalHomePage> {
  @override
  final List<Map<String, dynamic>> services = [
    {"name": "Scaling", "isSelected": true},
    {"name": "Braces", "isSelected": false},
    {"name": "Prosthetic", "isSelected": false},
    {"name": "Cleaning", "isSelected": false}, // extra items
  ];
  int _currentIndex = 0;
  List<UserModel> users = [];
  int _selectedIndex = 0;
  final List<Map<String, String>> sliderItems = [
    {
      "title": "Check your dental health today",
      "subtitle": "Schedule your dental check up now!",
    },
    {
      "title": "Book your appointment easily",
      "subtitle": "Get reminders for your dental visits.",
    },
    {
      "title": "Maintain your perfect smile",
      "subtitle": "Learn tips to keep your teeth healthy.",
    },
  ];
  final List<IconData> _icons = [
    Icons.home, Icons.list_outlined,
    Icons.person, Icons.logout
  ];

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DentalHomePage(
                    regId: widget.regId ?? "",
                    userType: widget.userType ?? "",
                    fullName: widget.fullName ?? "",
                    place: widget.place ?? ""
                ),
          ),
        );
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const UserCountPage()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const DoctorProfilePage()));
        break;
      case 3:
        showLogOutDialog(context);
        break;
    }
  }

  Future<void> checkPlanAndShowDialog(BuildContext context,
      String registerId) async {
    final prefs = await SharedPreferences.getInstance();
    final planStart = prefs.getInt("plan_start");

    if (planStart == null) {
      // No plan activated
      _showExpiredDialog(context);
      return;
    }

    final now = DateTime
        .now()
        .millisecondsSinceEpoch;
    final threeDaysInMillis = 3 * 24 * 60 * 60 * 1000;

    if ((now - planStart) > threeDaysInMillis) {
      // Plan expired
      _showExpiredDialog(context);
    } else {
      //  _showExpiredDialog(context);

      // Plan is active
      print("Plan is active");
    }
  }

  void _showExpiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AlertDialog(
            title: Text("Plan Expired",
              style: AppTextStyles.labelText(context, color: AppColors.black),),
            content: Text(
              "Your 3-day plan has expired. Please buy a new plan to continue.",
              style: AppTextStyles.valueText(context, color: Colors.black54),),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: AppTextStyles.valueText(
                    context, color: AppColors.peacockBlue),),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.pushNamed(context, '/buyPlan');
                },
                child: Text("Buy Now", style: AppTextStyles.valueText(
                    context, color: AppColors.peacockBlue),),
              ),
            ],
          ),
    );
  }

  Future<void> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> userList = prefs.getStringList("users") ?? [];

    final loadedUsers = userList.map((userStr) {
      final Map<String, dynamic> userMap = jsonDecode(userStr);
      return UserModel.fromJson(userMap);
    }).toList();
    final currentUserType = prefs.getString("currentUserType")?.toLowerCase();

    if (widget.userType == "SuperAdmin") {
      // Superadmin sees ALL active users
      users = loadedUsers.where((u) {
        final isAdmin = u.userType?.toLowerCase() == "admin";
        return isAdmin && u.isActive == true;
      }).toList();
      //users = loadedUsers.where((u) => u.isActive == true).toList();
    } else {
      // Admin sees only same place + active
      users = loadedUsers.where((u) {
        final isAdmin = u.userType?.toLowerCase() == "admin";
        final samePlace = u.address?.toLowerCase() ==
            widget.place.toLowerCase();
        return isAdmin && samePlace && u.isActive == true;
      }).toList();
    }

    setState(() {
      users;
    }); // Refresh UI
    print(users); // Debug
  }
  @override
  void initState() {
    loadUsers();
    if (widget.userType == "Admin") {
      checkPlanAndShowDialog(context, widget.regId);
    }
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

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.peacockBlue,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_icons.length, (index) {
                bool isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () => _onItemTapped(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.peacockBlue : Colors
                          .transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Icon(
                      _icons[index],
                      color: isSelected ? Colors.white : AppColors.grey,
                      size: 24,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Greeting
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage(
                              "assets/images/cliniq.png"),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Good Morning,",
                                style: AppTextStyles.labelText(context)),
                            Text(
                                "${widget.fullName}!!",
                                style: AppTextStyles.labelText(context)),
                          ],
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        const Icon(Icons.notifications_none, size: 28),
                        Positioned(
                          right: 1,
                          top: 1,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Text("1", style: TextStyle(
                                fontSize: 10, color: Colors.white)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 20),

                /// Purple Banner
    Column(
      children: [
        CarouselSlider(
        options: CarouselOptions(
        height: width * 0.45, // adjust height
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1,
        autoPlayInterval: const Duration(seconds: 3),
        ),
        items: sliderItems.map((item) {
        return Builder(
        builder: (BuildContext context) {
        return Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
        color: AppColors.peacockBlue,
        borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
        children: [
        Expanded(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(
        item["title"]!,textAlign: TextAlign.center,
        style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: width * 0.04,
        ),
        ),
        const SizedBox(height: 8),
        Text(
        item["subtitle"]!,
        style: TextStyle(
        color: Colors.white70,
        fontSize: width * 0.03,
        ),
        ),
        ],
        ),
        ),
        Icon(
        Icons.medical_services,
        color: Colors.white,
        size: width * 0.08,
        ),
        ],
        ),
        );
        },
        );
        }).toList(),),
        const SizedBox(height: 10),
        // Optional: Dots indicator

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: sliderItems.asMap().entries.map((entry) {
            return Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? AppColors.peacockBlue
                    : AppColors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    ),


const SizedBox(height: 20),

                /// Services
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Our Services", style: AppTextStyles.labelText(context),),
                    const Text("See all",
                        style: TextStyle(color: AppColors.peacockBlue)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 50, // adjust based on chip height
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: serviceChip(services[index]['name'],
                            services[index]['isSelected']),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Available Doctors",
                      style: AppTextStyles.labelText(context),),
                    Text("See all", style: AppTextStyles.valueText(
                        context, color: AppColors.peacockBlue),),
                  ],
                ),
                const SizedBox(height: 12),
                users.isEmpty
                    ? Center(child: Text("No users found",
                  style: AppTextStyles.valueText(
                      context, color: AppColors.black),))
                    : SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return
                        doctorCard(
                            name: user.fullName?.isNotEmpty == true
                                ? user.fullName!
                                : "No Name",
                            role: "General Dentist",
                            rating: 5.0,
                            clinic: "${user.clinicName}",
                            date: "Friday, 2 July 2023",
                            time: "10.00 AM",
                            regId: user.regId,
                            place: user.address);
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Service Chip Widget
  Widget serviceChip(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? AppColors.peacockBlue : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.medical_services, size: 18,
              color: selected ? Colors.white : Colors.black54),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deactivateUserByRegId(String regId) async {
    print('delete id${regId}');
    final prefs = await SharedPreferences.getInstance();
    final List<String> userList = prefs.getStringList("users") ?? [];

    final updatedList = userList.map((userStr) {
      final Map<String, dynamic> userMap = jsonDecode(userStr);

      if (userMap["regId"] == regId) {
        userMap["isActive"] = false;
      }

      return jsonEncode(userMap); // re-save updated/unchanged user
    }).toList();

    await prefs.setStringList("users", updatedList);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Deleted Successfully")),);

  }

  Widget doctorCard({
    required String name,
    required String role,
    required double rating,
    required String clinic,
    required String date,
    required String time,
    required String regId,
    required String place
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Doctor Info
          Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage(
                      "assets/images/hospital.jpg"), // replace with doctor image asset
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Dr.${name}", style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                          if (widget.userType == "SuperAdmin")
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: AppColors.grey,
                                  size: 18, // adjust size
                                ),
                                onPressed: () {
                                  // Call the dialog here
                                  showDeleteDialog(context, regId);
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            )

                        ],
                      ),

                      Row(
                        children: [
                          Text(role, style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13)),
                          const SizedBox(width: 6),
                          const Icon(
                              Icons.star, color: Colors.orange, size: 16),
                          Text(rating.toString(),
                              style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                      Text("${clinic}, ${place}", style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                ),
              ]
          ),
          const SizedBox(height: 12),

          /// Date + Time
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                        Icons.calendar_today, color: Colors.blue, size: 16),
                    const SizedBox(width: 6),
                    Text(date, style: const TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                        Icons.access_time, color: Colors.purple, size: 16),
                    const SizedBox(width: 6),
                    Text(time, style: const TextStyle(color: Colors.purple)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Future<void> showDeleteDialog(BuildContext context, String regId) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Delete',
            style: AppTextStyles.labelText(context, color: AppColors.black),
          ),
          content: Text(
            'Are You Sure To Delete this Admin?',
            style: AppTextStyles.valueText(context, color: AppColors.black),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await loadUsers();
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: AppTextStyles.valueText(
                  context,
                  color: AppColors.peacockBlue,
                ),
              ),
            ),
            TextButton(
              onPressed: ()async {
                await deactivateUserByRegId(regId);
                print(regId);
                await loadUsers();
                Navigator.of(context).pop();

              },
              child: Text(
                'Yes',
                style: AppTextStyles.valueText(
                  context,
                  color: AppColors.peacockBlue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


void showDeleteSuccessDialog(BuildContext context, String message) {
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
                    Navigator.of(context).pop();
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
