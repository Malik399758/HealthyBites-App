import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_bite_project/views/components/custom_button.dart';
import 'package:healthy_bite_project/views/screens/auth_module/birthday_date_screen.dart';

class HeightWeightScreen extends StatefulWidget {
  String selectedGender;
  HeightWeightScreen({super.key,required this.selectedGender});

  @override
  State<HeightWeightScreen> createState() => _HeightWeightScreenState();
}

class _HeightWeightScreenState extends State<HeightWeightScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  void _submit() {
    final height = _heightController.text;
    final weight = _weightController.text;


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Height: $height cm, Weight: $weight kg'),
      ),
    );
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
            SizedBox(height: 25.h,),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                width: 35.w,
                height: 35.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffF0EEEE)
                ),
                child: Icon(Icons.arrow_back,color: Color(0xff000000),
                  size: 20.sp,),
              ),
            ),
            SizedBox(height: 16.h,),
            Center(
              child: Container(
                width: 260.w,
                height: 87.h,
                decoration: BoxDecoration(
                ),
                child: Column(
                  children: [
                    Text('Height & Weight',style: GoogleFonts.poppins(
                        fontSize: 25.sp,fontWeight: FontWeight.w700,height: 1.0,
                        color: Color(0xff3A3734)
                    ),),
                    SizedBox(height: 10.h,),
                    Text('This activity level helps you to tailor'
                      'your fitness insights!',style: GoogleFonts.poppins(
                        fontSize: 14.sp,fontWeight: FontWeight.w400,
                        color: Color(0xff3A3734),
                    ),textAlign: TextAlign.center,)
                  ],
                ),
              ),
            ),
            SizedBox(height: 100.h,),

            SizedBox(height: 20.h),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xffF0EEEE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.height),
                  prefixStyle: GoogleFonts.poppins(
                    color: Color(0xff3A3734),
                  ),
                  labelText: 'Height (cm)',
                  labelStyle: GoogleFonts.poppins(
                      fontSize: 12,fontWeight: FontWeight.w500,
                      color: Color(0xff3A3734)
                  ),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xffF0EEEE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.line_weight),
                  prefixStyle: GoogleFonts.poppins(
                      color: Color(0xff3A3734),
                  ),
                  labelText: 'Weight (kg)',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 12,fontWeight: FontWeight.w500,
                    color: Color(0xff3A3734)
                  ),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: (){
                if(_heightController.text.isNotEmpty && _weightController.text.isNotEmpty){
                  showBottomSheet(context);
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please enter height and weight')));
                }
              },
              child: Center(
                child: Container(
                  width: 120.h,
                  height: 40.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Color(0xff3A3734),
                  ),
                  child: Center(
                    child: Text('Submit',style: GoogleFonts.poppins(
                      color: Colors.white,fontSize: 15.sp,fontWeight: FontWeight.w400
                    ),),
                  ),
                ),
              ),
            ),
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
        return  GestureDetector(
            onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context) =>
             BirthdayDateScreen(
                 height: _heightController.text,
                 weight: _weightController.text,
                 selectedGender:widget.selectedGender)));
              _submit();
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
