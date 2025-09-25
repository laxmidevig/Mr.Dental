import 'package:dental/common_color.dart';
import 'package:dental/landing_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final Color bgColor;
  final String logoAsset;

  const SplashScreen({
    Key? key,
    required this.bgColor,
    required this.logoAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
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
                logoAsset,
                width: 150, // adjust size
                height: 150,
              ),
            ),
            SizedBox(height: 20,),
            Text("Dental Pro",style:TextStyle(fontSize: size*0.055,fontWeight: FontWeight.bold,color: AppColors.white),),

          ],
        ),
      ),
    );
  }
}
class SplashScreenWrapper extends StatefulWidget {
  @override
  _SplashScreenWrapperState createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 10), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      bgColor: Color(0xFFF0F4FF),
      logoAsset: 'assets/images/tooth.png',
    );
  }
}
