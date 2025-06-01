
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_bite_project/views/components/custom_button.dart';
import 'package:healthy_bite_project/views/screens/auth_module/thank_you_screen.dart';

class BirthdayDateScreen extends StatefulWidget {
  final String height;
  final String weight;
  final String selectedGender;
  BirthdayDateScreen({super.key,required this.height,required this.weight,
  required this.selectedGender});

  @override
  State<BirthdayDateScreen> createState() => _BirthdayDateScreenState();
}

class _BirthdayDateScreenState extends State<BirthdayDateScreen> {
  TextEditingController _birthdayController = TextEditingController();
  DateTime? selectedDate;

  // initialize calender
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _birthdayController.text =
        "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: 100.h,
                child: Column(
                  children: [
                    Text('what is your birth\n'
               'date?',style: GoogleFonts.poppins(
                        fontSize: 25.sp,fontWeight: FontWeight.w700,height: 1.0,
                        color: Color(0xff3A3734)
                    ),textAlign: TextAlign.center,),
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

            Container(
              decoration: BoxDecoration(
                color: Color(0xffF0EEEE),
                borderRadius: BorderRadius.circular(10.r)
              ),
              height: 50.h,
              child: TextField(
                controller: _birthdayController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  labelText: 'Birthday',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 15.sp,fontWeight: FontWeight.w400,
                    color: Color(0xff3A3734)
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: (){
                if(_birthdayController.text.isNotEmpty){
                  showBottomSheet(context);
                  print("Selected Birthday: ${_birthdayController.text}");
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please enter your birthday')));
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
      )
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
                ThankYouScreen(
                    selectedGender: widget.selectedGender,
                    height: widget.height,
                    weight: widget.weight,
                    selectedBirthday: selectedDate!)));
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
