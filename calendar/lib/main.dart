import 'package:calendar/presentation/pages/calendar_page.dart';
import 'package:calendar/presentation/widgets/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:calendar/core/di/dependency_injection.dart' as di;

void main() async {
  await di.init();
  runApp(MaterialApp(
    home: CalendarPage.screen(),
  ));
}
