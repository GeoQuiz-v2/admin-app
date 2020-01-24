import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';



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
  final Firestore _firestore = firestore();

  bool isInit = false;
  User user;


  _initUserSnapshot() {
    var streamTransformer = StreamTransformer<FirebaseUser, User>.fromHandlers(
      handleData: (fbUser, sink) {
        _firestore.collection("admin").doc("config").get()
          .then((docSnap) {
            bool isAdmin = (docSnap.data()["administrators"] as List<String>).contains(fbUser.uid);
            sink.add(fbUser == null ? null : User(fbUser, admin: isAdmin));
          })
          .catchError((_) => sink.add(fbUser == null ? null : User(fbUser)));
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
  bool admin;
  FirebaseUser _fbUser;

  User(this._fbUser, {this.admin = false});

  get name => _fbUser.displayName??_fbUser.email??_fbUser.uid;
}