

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_bite_project/controllers/providers/sign_in_google_provider.dart';
import 'package:healthy_bite_project/views/screens/home_module/home_page.dart';
import 'package:provider/provider.dart';

class ContinueWithGoogle extends StatefulWidget {
  final String selectedGender;
  final String height;
  final String weight;
  final DateTime selectedBirthday;

  const ContinueWithGoogle({super.key,
    required this.selectedGender,
    required this.height,
    required this.weight,
    required this.selectedBirthday
  });

  @override
  State<ContinueWithGoogle> createState() => _ContinueWithGoogleState();
}

class _ContinueWithGoogleState extends State<ContinueWithGoogle> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SignInGoogleProvider>(
      builder: (context,provider,value){
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Let’s Get Started!',style: GoogleFonts.poppins(
                      fontSize: 25.sp,fontWeight: FontWeight.w700,
                      color: Color(0xff3A3734),height: 1.0
                  ),),
                  SizedBox(height: 10.h,),
                  Text('Start exploring your account',style: GoogleFonts.poppins(
                      fontSize: 14.sp,fontWeight: FontWeight.w400,
                      color: Color(0xff3A3734),height: 1.0
                  ),),
                  SizedBox(height: 100.h,),

                  // Sign in with google
                  GestureDetector(
                    onTap: ()async{
                      await provider.signIn(
                        widget.selectedGender,
                        widget.height,
                        widget.weight,
                        widget.selectedBirthday
                      );
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                      HomePage()));
                    },
                    child: Container(
                      width: 315.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                            color: Color(0xffF0EEEE),
                            width: 2.w
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Image.asset('assets/images/google.png',height: 25.sp,),
                            SizedBox(width: 40.w,),
                            Text('Continue with Google',style: GoogleFonts.poppins(
                                fontSize: 14.sp,fontWeight: FontWeight.w500,
                                color: Color(0xff000000),height: 1.0
                            ),)
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
      },

    );
  }
}
