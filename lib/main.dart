import 'dart:async';
import 'dart:developer';

import 'package:calendar/main.dart' as calendar;
import 'package:flutter/material.dart';
void main()async{
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    calendar.main();
  }, (error, stack) {
    log('runZonedGuarded Errors: $error');
    debugPrint("task_calendar");
  });
}
