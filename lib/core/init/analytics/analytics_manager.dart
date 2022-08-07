import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class AnalytcisManager {
  static final AnalytcisManager _instance = AnalytcisManager._init();
  static AnalytcisManager get instance => _instance;
  AnalytcisManager._init() {
    init();
  }

  static final _analytics = FirebaseAnalytics.instance;

  final List<NavigatorObserver> observer = [
    FirebaseAnalyticsObserver(analytics: _analytics)
  ];

  Future<void> init() async {
    await _analytics.setAnalyticsCollectionEnabled(true);
  }

  Future<void> customEvent(String name) async {
    await _analytics.logEvent(name: name);
  }

  Future setUserAnalytics({String? userID, String? name, String? value}) async {
    await _analytics.setUserId(id: userID);

    if (name != null && value != null) {
      await _analytics.setUserProperty(name: name, value: value);
    }
  }

  Future<void> userLogin(String signUpMethod) async {
    await _analytics.logLogin(loginMethod: signUpMethod);
  }

  Future<void> userSignUp(String signUpMethod) async {
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }
}
