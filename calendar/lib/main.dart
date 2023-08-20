import 'package:calendar/presentation/pages/calendar_page.dart';
import 'package:flutter/material.dart';
import 'package:calendar/core/di/dependency_injection.dart' as di;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  await di.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ScreenUtilInit(builder: (context, child) {
    return MaterialApp(
      builder: (context, widget) {
        ScreenUtil.init(
          context,
          designSize: const Size(360, 640),
          minTextAdapt: true,
        );
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: widget!,
        );
      },
      home: CalendarPage.screen(),
      debugShowCheckedModeBanner: false,
    );
  }));
}
