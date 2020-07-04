import 'package:flutter/foundation.dart';

class Environment {
  final String apiKey;
  final String authDomain;
  final String databaseURL;
  final String projectId;
  final String storageBucket;
  final String messagingSenderId;
  final String appId;
  final String firebaseURL;
  final String githubURL;
  final String playConsoleURL;
  final String adMobURL;

  Environment({
    @required this.apiKey,
    @required this.authDomain,
    @required this.databaseURL,
    @required this.projectId,
    @required this.storageBucket,
    @required this.messagingSenderId,
    @required this.appId,
    @required this.firebaseURL,
    @required this.githubURL,
    @required this.playConsoleURL,
    @required this.adMobURL,
  });
}