

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_bite_project/controllers/providers/sign_in_google_provider.dart';
import 'package:healthy_bite_project/services/firestore_service.dart';
import 'package:healthy_bite_project/views/components/custom_button.dart';
import 'package:healthy_bite_project/views/screens/auth_module/select_gender_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final fireStoreService = FireStoreService();

  void clearUserDataOnLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstTimeLogin', true);
  }




  void logoutDialog(BuildContext context)async{
    final provider = Provider.of<SignInGoogleProvider>(context,listen: false);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout Account',style: GoogleFonts.poppins(
              fontSize: 18.sp,fontWeight: FontWeight.w600,
            ),),
            content: Text('Do you want to logout this account?',style: GoogleFonts.poppins(
            fontSize: 15.sp,fontWeight: FontWeight.w500,
            )),
            actions: [
              TextButton(
                child: Text('No',style: GoogleFonts.poppins(
          fontSize: 14.sp,fontWeight: FontWeight.w500,
          )),onPressed: (){
                  Navigator.pop(context);
              },),
              GestureDetector(
                onTap: (){
                  provider.signOut();
                  clearUserDataOnLogout();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Logout Successfully!')));
                  print('Logout Successfully!');
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      SelectGenderScreen()));
                },
                child: Container(
                  width: 70.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Color(0xff3A3734)
                  ),
                  child: Center(
                    child: Text('Yes',style: GoogleFonts.poppins(
                            fontSize: 15.sp,fontWeight: FontWeight.w500,
                      color: Colors.white
                            )),
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignInGoogleProvider>(
      builder: (context,provider,value){
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: GestureDetector(
                  onTap: (){
                    logoutDialog(context);
                  },
                  child: CustomButton(text: 'Logout',width: 200,)))
            ],
          ),
        );
      },
    );
  }
}
