import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_bite_project/controllers/providers/stripe_payment_provider.dart';
import 'package:healthy_bite_project/models/calories_model.dart';
import 'package:healthy_bite_project/models/food_item_model.dart';
import 'package:healthy_bite_project/services/calories_data_service.dart';
import 'package:healthy_bite_project/services/food_manager.dart';
import 'package:healthy_bite_project/services/food_storage_service.dart';
import 'package:healthy_bite_project/services/local_notification_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> listName = ['Milk', 'apple', 'Tomato'];
  final caloriesData = CaloriesDataService();
  File? _image;
  final ImagePicker imagePicker = ImagePicker();
  bool _showDetails = false;
  late final String userId;
  List<CaloriesModel> caloriesList = [];
  final foodManager = FoodManager();
  List<FoodItem> foodItem = [];
  DateTime selectedDay = DateTime.now();
  final weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
  final days = List.generate(30, (index) => index + 1);

  // Notification
  List<String> items = [];

  void addItemNotification() {
    setState(() {
      items.add("Item ${items.length + 1}");
    });
    NotificationService.showNotification(
      title: "Item Added",
      body: "You added Item ${items.length}",
    );
  }




  DateTime? _selectedDate;

  String? currentUserId;
  @override
  void initState() {
    super.initState();
    loadItemsForSelectedDate();
    _image;
    _selectedDate = DateTime.now();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;
    } else {
      currentUserId = null;
      print('User not logged in!');
    }
  }

  void loadItemsForSelectedDate() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('firstTimeLogin') ?? true;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (isFirstTime) {
      setState(() {
        foodItem = [];
      });
      return;
    }

    final allItems = await foodManager.loadItems();

    final filtered = allItems.where((item) {
      return item.userId == user.uid &&
          item.dateTime.year == selectedDay.year &&
          item.dateTime.month == selectedDay.month &&
          item.dateTime.day == selectedDay.day;
    }).toList();

    setState(() {
      foodItem = filtered;
    });
  }

  void addItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (_image == null) return;

    final newItem = FoodItem(
      itemName: "Orange",
      calories: 500,
      protein: 9.0,
      carbs: 3.0,
      fats: 6.0,
      dateTime: selectedDay,
      imagePath: _image!.path,
      userId: user.uid,
    );

    await FoodStorageService.addFoodItem(newItem);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstTimeLogin', false);

    loadItemsForSelectedDate();
  }

  // image picker
  Future<void> showImagePicker() async {
    final XFile? selectedFile =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (selectedFile != null) {
      setState(() {
        _image = File(selectedFile.path);
        _showDetails = true;
      });
    } else {
      print('Not selected');
    }
  }

  // get data from firebase
  Stream<DocumentSnapshot<Map<String, dynamic>>> getData() {
    if (currentUserId == null) {
      throw Exception('currentUserId is null');
    }
    return FirebaseFirestore.instance
        .collection('item_collection')
        .doc(currentUserId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return Scaffold(
        body: Center(child: Text('Please log in')),
      );
    }
    return Consumer<StripePaymentProvider>(
      builder: (context, provider, value) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: Text(
              'HealthyBites',
              style: GoogleFonts.poppins(
                fontSize: 25.sp,
                fontWeight: FontWeight.w500,
                height: 1.0,
                color: Color(0xff000000),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                    stream: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Text('Loading'));
                      } else if (snapshot.hasError) {
                        return Text('Error ${snapshot.error}');
                      } else if (!snapshot.hasData ||
                          snapshot.data == null ||
                          snapshot.data!.data() == null) {
                        return Center(child: Text('no recent logs found'));
                      } else {
                        final data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        final totalCalories =
                            double.tryParse(data['totalCalories'].toString()) ??
                                0.0;
                        final protein =
                            double.tryParse(data['protein'].toString()) ?? 0.0;
                        final carbs =
                            double.tryParse(data['carbs'].toString()) ?? 0.0;
                        final fats =
                            double.tryParse(data['fats'].toString()) ?? 0.0;

                        final Timestamp? timestamp = data['dateTime'];
                        DateTime dateTime;

                        if (timestamp != null) {
                          dateTime = timestamp.toDate();
                        } else {
                          dateTime = DateTime.now();
                        }

                        return Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TableCalendar(
                                    firstDay: DateTime.utc(2020, 1, 1),
                                    lastDay: DateTime.utc(2030, 12, 31),
                                    focusedDay: selectedDay,
                                    selectedDayPredicate: (day) {
                                      return isSameDay(selectedDay, day);
                                    },
                                    onDaySelected: (selected, focused) {
                                      setState(() {
                                        selectedDay = selected;
                                      });
                                      loadItemsForSelectedDate();
                                    },
                                    calendarFormat:
                                        CalendarFormat.week,
                                  ),

                                  //  Show firebase data here
                                  SizedBox(height: 30.h),
                                  Container(
                                    width: double.infinity,
                                    height: 150.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 100.w,
                                          height: 150.h,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 0.2,
                                                spreadRadius: 0.1,
                                                color: Colors.grey
                                              )
                                            ],
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              color: Color(0xffFFFFFF)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                totalCalories.toString(),
                                                style: GoogleFonts.poppins(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xff3A3734),
                                                    height: 1.0),
                                              ),
                                              Text(
                                                'Total Calories',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff000000),
                                                    height: 1.0),
                                              ),
                                              Container(
                                                width: 60.w,
                                                height: 60.h,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Color(0xffD9D9D9),
                                                    )
                                                ),
                                                child: Center(
                                                    child: Image.asset(
                                                  'assets/images/calories_image.png',
                                                  height: 30.h,
                                                )),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // protein ,carbs and fats data
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 190.w,
                                              height: 40.h,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 0.2,
                                                        spreadRadius: 0.1,
                                                        color: Colors.grey
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  color: Color(0xffFFFFFF)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    '$protein g',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff3A3734),
                                                        height: 1.0),
                                                  ),
                                                  Text(
                                                    'Protein',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff000000),
                                                        height: 1.0),
                                                  ),
                                                  Container(
                                                    width: 26.w,
                                                    height: 26.h,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Color(
                                                                0xffD9D9D9),
                                                            width: 1.w)),
                                                    child: Center(
                                                        child: Image.asset(
                                                      'assets/images/protein_image.png',
                                                      height: 12.h,
                                                    )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 190.w,
                                              height: 40.h,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 0.2,
                                                        spreadRadius: 0.1,
                                                        color: Colors.grey
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  color: Color(0xffFFFFFF)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    '$carbs g',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff3A3734),
                                                        height: 1.0),
                                                  ),
                                                  Text(
                                                    'Carbs',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff000000),
                                                        height: 1.0),
                                                  ),
                                                  Container(
                                                    width: 26.w,
                                                    height: 26.h,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Color(
                                                                0xffD9D9D9),
                                                            width: 1.w)),
                                                    child: Center(
                                                        child: Image.asset(
                                                      'assets/images/carbs_image.png',
                                                      height: 12.h,
                                                    )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 190.w,
                                              height: 40.h,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 0.2,
                                                        spreadRadius: 0.1,
                                                        color: Colors.grey
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  color: Color(0xffFFFFFF)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    '$fats g',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff3A3734),
                                                        height: 1.0),
                                                  ),
                                                  Text(
                                                    'Fats\t\t\t\t',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Color(0xff000000),
                                                        height: 1.0),
                                                  ),
                                                  // SizedBox(width: 3.w,),
                                                  Container(
                                                    width: 26.w,
                                                    height: 26.h,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Color(
                                                                0xffD9D9D9),
                                                            width: 1.w)),
                                                    child: Center(
                                                        child: Image.asset(
                                                      'assets/images/fats.webp',
                                                      height: 12.h,
                                                    )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30.h),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Recently logged',
                                      style: GoogleFonts.poppins(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff000000),
                                          height: 1.0),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),

                                  foodItem.isEmpty
                                      ? Text('No food items found')
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: foodItem.length,
                                          itemBuilder: (context, index) {
                                            final foodList = foodItem[index];
                                            final formattedDate =
                                                DateFormat('dd MMM, hh:mm a')
                                                    .format(foodList.dateTime);

                                            return Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              width: double.infinity,
                                              height: 100.h,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 0.2,
                                                      spreadRadius: 0.1,
                                                      color: Colors.grey
                                                  )
                                                ],
                                                color: Color(0xffF0EEEE),
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              child: Row(
                                                children: [
                                                  Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        foodList.imagePath!
                                                                .isNotEmpty
                                                            ? CircleAvatar(
                                                                radius: 30,
                                                                backgroundImage:
                                                                    FileImage(File(
                                                                        foodList.imagePath ??
                                                                            '')),
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                              )
                                                            : CircleAvatar(
                                                                radius: 40,
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        300],
                                                                child: Icon(
                                                                    Icons
                                                                        .camera_alt,
                                                                    color: Colors
                                                                            .grey[
                                                                        700],
                                                                    size: 30),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(height: 15.h),
                                                      Container(
                                                        width: 200,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                foodList
                                                                    .itemName
                                                                    .toString(),
                                                                style: GoogleFonts
                                                                    .poppins(
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 1.0,
                                                                  color: Color(
                                                                      0xff000000),
                                                                )),
                                                            Text(
                                                                formattedDate,
                                                                style: GoogleFonts
                                                                    .poppins(
                                                                  fontSize:
                                                                      8.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  height: 1.0,
                                                                  color: Color(
                                                                      0xff000000),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 10.h),
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                              'assets/images/calories_image.png',
                                                              height: 20),
                                                          SizedBox(width: 10),
                                                          Text(
                                                              '${foodList.calories} calories',
                                                              style:
                                                                  GoogleFonts
                                                                      .poppins(
                                                                fontSize:
                                                                    14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                height: 1.0,
                                                                color: Color(
                                                                    0xff000000),
                                                              )),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10.h),
                                                      Container(
                                                        width: 210.w,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Image.asset(
                                                                    'assets/images/protein_image.png',
                                                                    height: 10),
                                                                SizedBox(width: 5),
                                                                Text(
                                                                    '${foodList.protein} g',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                            fontSize:
                                                                                9.sp)),
                                                                SizedBox(width: 5),
                                                                Image.asset(
                                                                    'assets/images/carbs_image.png',
                                                                    height: 10),
                                                                SizedBox(width: 5),
                                                                Text(
                                                                    '${foodList.carbs} g',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                            fontSize:
                                                                                9.sp)),
                                                                SizedBox(width: 5),
                                                                Image.asset(
                                                                    'assets/images/fats.webp',
                                                                    height: 10),
                                                                SizedBox(width: 5),
                                                                Text(
                                                                    '${foodList.fats} g',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                            fontSize:
                                                                                9.sp)),
                                                                // SizedBox(
                                                                //   width: 25.w,
                                                                // ),
                                                              ],
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                provider
                                                                    .makePayment(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                width: 60,
                                                                height: 25,
                                                                decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      7.r),
                                                                  color: Color(
                                                                      0xff3A3734),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                      'Rs 100',
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize: 12
                                                                              .sp,
                                                                          color:
                                                                          Colors.white)),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }),
              ],
            ),
          ),

          //  Floating action button
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xff3A3734),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            onPressed: handleAddCalories,
            child: Icon(Icons.camera_alt),
          ),
        );
      },
    );
  }

  // Handle  calories
  void handleAddCalories() async {
    try {
      await showImagePicker();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('User not logged in');
        return;
      }
      print('Custom item with image added and displayed');

      // Add data to Firebase
      await caloriesData.addItemData(
          user.uid, '2000', '800', '700', '500', DateTime.now());
      addItemNotification();
      addItems();
      print('Data added and displayed locally');
    } catch (e) {
      print('Error adding data: ${e.toString()}');
    }
  }
}
