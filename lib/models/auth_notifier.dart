
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';




/// Repository to handle the authentication process with Firebase.
/// 
/// The singleton pattern is achieved with the classic method with a 
/// factory constructor.
class AuthenticationNotifier extends ChangeNotifier {

  static final AuthenticationNotifier _instance = AuthenticationNotifier._();

  factory AuthenticationNotifier() {
    return _instance;
  }

  AuthenticationNotifier._() {
    _initUserSnapshot();
  }
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isInit = false;
  User user;


  _initUserSnapshot() {
    var streamTransformer = StreamTransformer<FirebaseUser, User>.fromHandlers(
      handleData: (fbUser, sink) {
        sink.add(fbUser == null ? null : User(fbUser));
      }
    );

    _auth.onAuthStateChanged.transform(streamTransformer).listen(
      (u) {
        user = u;
        isInit = true;
        notifyListeners();
      }, 
      onDone: () {isInit = true; notifyListeners();},
      onError: (_) {isInit = true; notifyListeners();}
    );
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }


  Future<void> logout() async {
    user = null;
    notifyListeners();
    await _auth.signOut();
  }

}

class User {
  FirebaseUser _fbUser;

  User(this._fbUser);

  get name => _fbUser.displayName??_fbUser.email??_fbUser.uid;
}