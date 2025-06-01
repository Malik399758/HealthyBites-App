
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  // get data from FireBaseFireStore
  Stream<DocumentSnapshot<Map<String, dynamic>>> getData(){
    return FirebaseFirestore.instance.collection('users_collection').doc(currentUser).snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',style: GoogleFonts.poppins(
          fontSize: 23.sp,fontWeight: FontWeight.w600,color: Color(0xff000000)
        ),),
      ),
      body: StreamBuilder(
          stream: getData(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: Text('Loading....'));
            }else if(snapshot.hasError){
              return Center(child: Text('Something went wrong'));
            }else if(!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists){
              return Center(child: Text('Data not found'));
            } else {
              final data = snapshot.data!.data();
              if (data == null) {
                return Center(child: Text('No user data found'));
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 0.2,
                                spreadRadius: 0.1,
                                color: Colors.grey
                            )
                          ],
                          color: Color(0xffF0EEEE),
                          borderRadius: BorderRadius.circular(10.r)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Card(
                          color: Color(0xff3A3734),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Gender : ${data['Gender'] ?? 'Not set'}',style: GoogleFonts.poppins(
                                    fontSize: 15.sp,fontWeight: FontWeight.w400,color: Colors.white,
                                ),),
                              )),
                          Card(
                              color: Color(0xff3A3734),
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Height : ${data['Height']  ?? 'Not set'} cm',style: GoogleFonts.poppins(
                                fontSize: 15.sp,fontWeight: FontWeight.w400,color: Colors.white,
                            ),),
                          )),
                          Card(
                              color: Color(0xff3A3734),
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Weight : ${data['Weight'] ?? 'Not set'} kg',style: GoogleFonts.poppins(
                                fontSize: 15.sp,fontWeight: FontWeight.w400,color: Colors.white,
                            ),),
                          )),
                          Card(
                            color: Color(0xff3A3734),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Date of Birth : ${data['BirthdayDate'] != null && data['BirthdayDate'] is Timestamp ? (data['BirthdayDate'] as Timestamp).toDate().toString().split(' ')[0] : 'Not set'}',
            style: GoogleFonts.poppins(
            fontSize: 15.sp,fontWeight: FontWeight.w400,color: Colors.white,
            ),),
                            ),
                          ),


                        ],
                      ),
                    ),
                  ],
                ),
              );

            }
          })
    );
  }
}
