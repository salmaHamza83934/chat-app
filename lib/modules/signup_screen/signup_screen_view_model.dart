import 'package:chat_app/database/database_utils.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../connector/connector.dart';

class SignupScreenViewModel extends ChangeNotifier {

  late Connector connector;

  void register(String userName,String email, String password) async {
    try {
      connector.showLoading();
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      connector.hideLoading();
      connector.showMessage('Account successfully created.');
      MyUser myUser = MyUser(id: credential.user!.uid,
          userName: userName,
          email: credential.user!.email!,
      );
      await DatabaseUtils.registerUser(myUser);
      print(credential.user?.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        connector.hideLoading();
        connector.showMessage('The password provided is too weak.');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        connector.hideLoading();
        connector.showMessage('The account already exists for that email.');
        print('The account already exists for that email.');
      }
    } catch (e) {
      connector.hideLoading();
      connector.showMessage(e.toString());
      print(e);
    }
  }
}