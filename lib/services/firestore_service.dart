

import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService{
  final _db = FirebaseFirestore.instance;
  final String userCollection = 'users_collection';

  Future<void> uploadUserData(String userId,
      String gender,String height,String weight,DateTime birthdayDate,
      ) async{
    try{
      await _db.collection(userCollection).doc(userId).set(
        {
          'Gender' : gender,
          'Height' : height,
          'Weight' : weight,
          'BirthdayDate' : birthdayDate,
        }
      );
    }catch(e){
      print('FireStore error ---->${e.toString()}');
    }
  }

}