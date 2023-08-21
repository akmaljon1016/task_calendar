import 'package:calendar/core/di/dependency_injection.dart';
import 'package:calendar/core/util/app_constants.dart';
import 'package:calendar/data/model/callback_model.dart';
import 'package:calendar/presentation/bloc/calendar_bloc.dart';
import 'package:calendar/presentation/widgets/calendar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  static Widget screen() {
    return BlocProvider<CalendarBloc>(
      create: (context) => di<CalendarBloc>(),
      child: CalendarPage(),
    );
  }

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarBloc calendarBloc;

  @override
  void initState() {
    super.initState();
    calendarBloc = BlocProvider.of<CalendarBloc>(context);
    calendarBloc.add(LoadCalendarEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        calendarBloc.add(LoadCalendarEvent());
      },
      child: BlocConsumer<CalendarBloc, CalendarState>(
        listener: (context, state) {
          if (state is CalendarSuccess) {
          } else if (state is CalendarFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is CalendarLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CalendarWidget(
                  onDateClickedCallBack: (CallBackModel? callBackModel) {},
                ),
                Container(
                  height: 90.h,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30.h,
                      ),
                      CupertinoActivityIndicator(
                        color: Colors.black,
                        radius: 12.r,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        loading,
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else if (state is CalendarSuccess) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CalendarWidget(
                    combinedModel: state.combinedModel,
                    onDateClickedCallBack: (CallBackModel? callBackModel) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(callBackModel.toString())));
                    },
                  ),
                  Container(
                    height: 90.h,
                    child: IconButton(
                      onPressed: () {
                        calendarBloc.add(LoadCalendarEvent());
                      },
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.blue,
                        weight: 30.w,
                        size: 40.w,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (state is CalendarFailure) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CalendarWidget(
                  onDateClickedCallBack: (CallBackModel? callBackModel) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(callBackModel.toString())));
                  },
                ),
                Container(
                  height: 90.h,
                  child: Column(
                    children: [
                      Text(
                        "${state.message}",
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w500),
                      ),
                      MaterialButton(
                        onPressed: () {
                          calendarBloc.add(LoadCalendarEvent());
                        },
                        color: Colors.blue,
                        child: const Text(
                          reloading,
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CalendarWidget(
                  onDateClickedCallBack: (CallBackModel? callBackModel) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(callBackModel.toString())));
                  },
                ),
                Container(
                  height: 90.h,
                  child: Column(
                    children: [
                      Text(unKnownError),
                      MaterialButton(
                        onPressed: () {
                          calendarBloc.add(LoadCalendarEvent());
                        },
                        child: const Text(
                          reloading,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }
        },
      ),
    ));
  }
}
