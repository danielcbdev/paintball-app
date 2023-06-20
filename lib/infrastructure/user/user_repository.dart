import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:picospaintballzone/models/user/user.model.dart';
import 'package:picospaintballzone/shared/exceptions.dart';

class UserRepository{

  Future<UserModel?> getCurrentUser() async {
    try{
      UserModel? userModel;
      final userAuth = FirebaseAuth.instance.currentUser;
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final snapshot = await usersCollection.doc(userAuth!.uid).get();
      userModel = UserModel.fromJson(snapshot.data()!);
      return userModel;
    } catch(e){
      throw UserException(e.toString());
    }
  }

}