import 'package:calendar/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:calendar/core/di/dependency_injection.dart' as di;

void main() async {
  await di.init();
  runApp(MaterialApp(
    home: Scaffold(
      body: CalendarWidget.screen(),
    ),
  ));
}
