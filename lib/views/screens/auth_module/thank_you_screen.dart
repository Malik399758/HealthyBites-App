
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_bite_project/views/components/custom_button.dart';
import 'package:healthy_bite_project/views/screens/auth_module/continue_with_google.dart';
import 'package:lottie/lottie.dart';

class ThankYouScreen extends StatefulWidget {
  final String selectedGender;
  final String height;
  final String weight;
  final DateTime selectedBirthday;

  const ThankYouScreen({super.key,
    required this.selectedGender,
    required this.height,
    required this.weight,
    required this.selectedBirthday
  });

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100.h,),
            Lottie.asset('assets/images/lottie/Animation - 1748580173954 (1).json',height: 250),
           /* Text(
              "${widget.selectedBirthday.day}/${widget.selectedBirthday.month}/${widget.selectedBirthday.year}",
              style: TextStyle(fontSize: 16),
            ),*/
            Text('Thank You\n '
              'we appreciate you\n'
              'for trusting us',style: GoogleFonts.poppins(
              fontSize: 25.sp,fontWeight: FontWeight.w700,
              color: Color(0xff3A3734),height: 1.0
            ),textAlign: TextAlign.center,),
            SizedBox(height: 40.h,),
            Text('We are committed to ensuring that\n'
              'your personal information remains safe\n'
              'and confidential.',style: GoogleFonts.poppins(
                fontSize: 14.sp,fontWeight: FontWeight.w400,
                color: Color(0xff000000),height: 1.0
            ),textAlign: TextAlign.center,),
            Spacer(),

            Container(
              width: double.infinity,
              height: 100.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.sp),
                  topRight: Radius.circular(18.sp)
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 0.5,
                    spreadRadius: 0.2
                  )
                ]
              ),
              child: GestureDetector(
                onTap: (){
                  if(widget.selectedGender.isNotEmpty && widget.height.isNotEmpty
                      && widget.weight.isNotEmpty){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        ContinueWithGoogle(
                            selectedGender: widget.selectedGender,
                            height: widget.height,
                            weight: widget.weight,
                            selectedBirthday: widget.selectedBirthday)));
                  }
                },
                child: Container(
                    padding: EdgeInsets.all(20),
                    height: 100,
                    width: double.infinity,
                    child: CustomButton(text: 'Next')
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
