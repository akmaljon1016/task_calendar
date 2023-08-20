import 'package:calendar/core/di/dependency_injection.dart';
import 'package:calendar/presentation/bloc/calendar_bloc.dart';
import 'package:calendar/presentation/widgets/calendar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        body: BlocConsumer<CalendarBloc, CalendarState>(
      listener: (context, state) {
        if (state is CalendarSuccess) {
          print("result1: ${state.combinedModel.dayModel}");
          print("result2:${state.combinedModel.dayColors}");
        } else if (state is CalendarFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is CalendarLoading) {
          return Column(
            children: [
              CalendarWidget(),
              SizedBox(
                height: 20,
              ),
              CupertinoActivityIndicator(),
              Text("ma'lumotlar yuklanmoqda")
            ],
          );
        } else if (state is CalendarSuccess) {
          return CalendarWidget(
            combinedModel: state.combinedModel,
          );
        } else if (state is CalendarFailure) {
          return Column(
            children: [
              const CalendarWidget(),
              Text("${state.message}"),
              MaterialButton(
                onPressed: () {
                  calendarBloc.add(LoadCalendarEvent());
                },
                color: Colors.blue,
                child: const Text(
                  "Qayta Yuklash",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        }
        else{
          return Column(
            children: [
              const CalendarWidget(),
              Text("Noma'lum xatolik sodir bo'ldi"),
              MaterialButton(
                onPressed: () {
                  calendarBloc.add(LoadCalendarEvent());
                },
                color: Colors.blue,
                child: const Text(
                  "Qayta Yuklash",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        }
      },
    ));
  }
}
