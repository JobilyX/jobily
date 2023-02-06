import 'package:flutter/material.dart';

import '../../main.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppNavigator {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<void> push({required Widget screen}) async {
    await navigatorKey.currentState!
        .push(MaterialPageRoute(builder: (context) => screen));
  }

  Future<void> pushReplacement({required Widget screen}) async {
    await navigatorKey.currentState!
        .pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }

  dynamic pop({dynamic object}) {
    return navigatorKey.currentState!.pop<dynamic>(object);
  }

  dynamic popToFrist({dynamic object}) {
    return navigatorKey.currentState!.popUntil((rout) => rout.isFirst);
  }

  dynamic popTojobily({dynamic object}) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => const MyApp()),
        (Route<dynamic> route) => false);
  }
}
