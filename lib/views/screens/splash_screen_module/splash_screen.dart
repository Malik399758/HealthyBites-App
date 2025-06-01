import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_bite_project/views/screens/auth_module/select_gender_screen.dart';
import 'package:healthy_bite_project/views/screens/home_module/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final currentUser = FirebaseAuth.instance.currentUser;

  void checkUserAccount()async{
    if(currentUser != null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
      HomePage()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
          SelectGenderScreen()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 4), () => checkUserAccount());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/healthy_bites _images.png',
            height: 60.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text('HealthyBites',style: GoogleFonts.poppins(
            fontSize: 18.sp,fontWeight: FontWeight.w600,
            height: 1.0,color: Color(0xff000000),
          ),),

          SizedBox(
            height: 20.h,
          ),
          SpinKitChasingDots(
            color: Color(0xff000000),
            size: 30.sp,
          )
        ],
      )),
    );
  }
}
