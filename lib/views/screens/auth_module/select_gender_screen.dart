
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_bite_project/views/components/custom_button.dart';
import 'package:healthy_bite_project/views/screens/auth_module/birthday_date_screen.dart';
import 'package:healthy_bite_project/views/screens/auth_module/height_weight_screen.dart';

class SelectGenderScreen extends StatefulWidget {
  const SelectGenderScreen({super.key});

  @override
  State<SelectGenderScreen> createState() => _SelectGenderScreenState();
}
enum Gender { male, female, other }

class _SelectGenderScreenState extends State<SelectGenderScreen> {
  Gender? selectedGender;
  // Gender labels
  String male = 'Male';
  String female = 'Female';
  String other = 'Other';

  void activeGender(Gender gender){
    setState(() {
      selectedGender = gender;
    });
  }

  // gender text
  String get selectedGenderText {
    if (selectedGender == Gender.male) return male;
    if (selectedGender == Gender.female) return female;
    if (selectedGender == Gender.other) return other;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h,),
            Center(
              child: Container(
                width: 260.w,
                height: 87.h,
                decoration: BoxDecoration(
                ),
                child: Column(
                  children: [
                    Text('Select Your Gender',style: GoogleFonts.poppins(
                      fontSize: 25.sp,fontWeight: FontWeight.w700,height: 1.0,
                      color: Color(0xff3A3734)
                    ),),
                    SizedBox(height: 10.h,),
                    Text('This step ensures that your nutrition\n'
                     'plan is tailored just for you.',style: GoogleFonts.poppins(
                        fontSize: 14.sp,fontWeight: FontWeight.w400,
                        color: Color(0xff3A3734)
                    ),textAlign: TextAlign.center,)
                  ],
                ),
              ),
            ),
            SizedBox(height: 150.h,),

            // gender option
            Center(
              child: Container(
                width: 310.w,
                height: 206.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        activeGender(Gender.male);
                        showBottomSheet(context);
                      },
                      child: Container(
                        width: 310.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Color(0xffF0EEEE),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: selectedGender == Gender.male ? Color(0xff000000) :
                                Colors.transparent,
                          )
                        ),
                        child: Center(child: Text(male,style: GoogleFonts.poppins(
                          fontSize: 15.sp,fontWeight: FontWeight.w500,height: 1.0,
                          color: Color(0xff000000)
                        ),)),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        activeGender(Gender.female);
                        showBottomSheet(context);
                      },
                      child: Container(
                        width: 310.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            color: Color(0xffF0EEEE),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: selectedGender == Gender.female ? Color(0xff000000) :
                              Colors.transparent,
                            )
                        ),
                        child: Center(child: Text(female,style: GoogleFonts.poppins(
                            fontSize: 15.sp,fontWeight: FontWeight.w500,height: 1.0,
                            color: Color(0xff000000)
                        ),)),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        activeGender(Gender.other);
                        showBottomSheet(context);
                      },
                      child: Container(
                        width: 310.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            color: Color(0xffF0EEEE),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: selectedGender == Gender.other ? Color(0xff000000) :
                              Colors.transparent,
                            )
                        ),
                        child: Center(child: Text(other,style: GoogleFonts.poppins(
                            fontSize: 15.sp,fontWeight: FontWeight.w500,height: 1.0,
                            color: Color(0xff000000)
                        ),)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Container(
            )
          ],
        ),
      ),
    );
  }
  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                HeightWeightScreen(selectedGender: selectedGenderText)));
          },
          child: Container(
              padding: EdgeInsets.all(20),
              height: 100,
              width: double.infinity,
              child: CustomButton(text: 'Next')
          ),
        );
      },
    );
  }
}
