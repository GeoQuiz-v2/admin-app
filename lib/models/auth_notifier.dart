
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';




/// Repository to handle the authentication process with Firebase.
/// 
/// The singleton pattern is achieved with the classic method with a 
/// factory constructor.
class AuthenticationNotifier extends ChangeNotifier {

  // static final AuthenticationNotifier _instance = AuthenticationNotifier._();

  // factory AuthenticationNotifier() {
  //   return _instance;
  // }

  // AuthenticationNotifier._() {
  //   _initUserSnapshot();
  // }
  
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleProvider = GoogleSignIn();

  // bool isInit = false;
  // User user;


  // _initUserSnapshot() {
  //   var streamTransformer = StreamTransformer<FirebaseUser, User>.fromHandlers(
  //     handleData: (fbUser, sink) {
  //       // Future.delayed(const Duration(seconds: 0), () => sink.add(fbUser == null ? null : User(fbUser)));
  //       sink.add(fbUser == null ? null : User(fbUser));
  //     }
  //   );

  //   _auth.onAuthStateChanged.transform(streamTransformer).listen(
  //     (u) {
  //       user = u;
  //       isInit = true;
  //       notifyListeners();
  //     }, 
  //     onDone: () {isInit = true; notifyListeners();},
  //     onError: (_) {isInit = true; notifyListeners();}
  //   );
  // }


  // Future<User> signInWithGoogle() async {
  //   final GoogleSignInAccount googleUser = await _googleProvider.signIn();
  //   if (googleUser == null) // aborded
  //     return null;
  //   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  //   print("Sign in : " + user.uid);
  //   return User(user);
  // }


  // signInWithEmailPassword(String email, String password) {

  // }


  // signUpWithEmailPassword(String email, String password) {

  // }


  // Future<void> logout() async {
  //   return _auth.signOut();
  // }
  

  // Future<void> delete() async {
  //   (await _auth.currentUser()).delete();
  // }
}