import 'package:calendar/core/di/dependency_injection.dart';
import 'package:calendar/core/function/function.dart';
import 'package:calendar/core/logic/calendar.dart';
import 'package:calendar/core/util/app_constants.dart';
import 'package:calendar/data/model/callback_model.dart';
import 'package:calendar/data/model/combined_model.dart';
import 'package:calendar/data/model/day_color.dart';
import 'package:calendar/data/model/day_model.dart';
import 'package:calendar/data/model/days.dart';
import 'package:calendar/presentation/bloc/calendar_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarWidget extends StatefulWidget {
  final CombinedModel? combinedModel;
  final Function(CallBackModel? callBackModel) onDateClickedCallBack;

  const CalendarWidget(
      {super.key, this.combinedModel, required this.onDateClickedCallBack});

  static Widget screen(CombinedModel combinedModel,
      Function(CallBackModel? callBackModel) onDateClickedCallBack) {
    return BlocProvider<CalendarBloc>(
      create: (context) => di<CalendarBloc>(),
      child: CalendarWidget(
        combinedModel: combinedModel,
        onDateClickedCallBack: onDateClickedCallBack,
      ),
    );
  }

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

enum CalendarViews { dates, months, year }

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currentDateTime;
  late DateTime _selectedDateTime;
  late List<Calendar> _sequentialDates;
  late int midYear;
  late DayModel dayModel;
  CalendarViews _currentView = CalendarViews.dates;
  late CalendarBloc calendarBloc;
  final List<String> _weekDays = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN'
  ];
  final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    final date = DateTime.now();
    _currentDateTime = DateTime(date.year, date.month);
    _selectedDateTime = DateTime(date.year, date.month, date.day);
    calendarBloc = BlocProvider.of<CalendarBloc>(context);
    midYear = date.year;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _getCalendar());
    });
    _getCalendar();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.6,
        child: (_currentView == CalendarViews.dates)
            ? _datesView(widget.combinedModel)
            : (_currentView == CalendarViews.months)
                ? _showMonthsList()
                : _yearsView(midYear ?? _currentDateTime.year));
  }

  Widget _datesView([CombinedModel? combinedModel]) {
    return Column(
      children: <Widget>[
        // header
        Row(
          children: <Widget>[
            // prev month button
            _toggleBtn(false),
            // month and year
            Expanded(
              child: InkWell(
                onTap: () =>
                    setState(() => _currentView = CalendarViews.months),
                child: Center(
                  child: Text(
                    '${_monthNames[_currentDateTime.month - 1]} ${_currentDateTime.year}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            // next month button
            _toggleBtn(true),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Divider(
          color: Colors.white,
        ),
        SizedBox(
          height: 20,
        ),
        Flexible(child: _calendarBody(combinedModel)),
      ],
    );
  }

// next / prev month buttons
  Widget _toggleBtn(bool next) {
    return InkWell(
      onTap: () {
        // calendarBloc.add(LoadCalendarEvent());
        if (_currentView == CalendarViews.dates) {
          setState(() => (next) ? _getNextMonth() : _getPrevMonth());
        } else if (_currentView == CalendarViews.year) {
          if (next) {
            midYear =
                (midYear == null) ? _currentDateTime.year + 9 : midYear + 9;
          } else {
            midYear =
                (midYear == null) ? _currentDateTime.year - 9 : midYear - 9;
          }
          setState(() {});
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.transparent),
        ),
        child: Icon(
          (next) ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
    );
  }

// calendar
  Widget _calendarBody(CombinedModel? combinedModel) {
    if (_sequentialDates == null) {
      return Container();
    } else {
      return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: _sequentialDates.length + 7,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10,
          crossAxisCount: 7,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          if (index < 7) return _weekDayTitle(index);
          if (_sequentialDates[index - 7].date == _selectedDateTime)
            return _selector(_sequentialDates[index - 7],
                combinedModel?.dayColors, combinedModel?.dayModel);
          return _calendarDates(_sequentialDates[index - 7],
              combinedModel?.dayModel, combinedModel?.dayColors);
        },
      );
    }
  }

// calendar header
  Widget _weekDayTitle(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        _weekDays[index],
        style: TextStyle(
            color: index == 6 ? Colors.red : Colors.black, fontSize: 16),
      ),
    );
  }

  Color setColor(DayModel? dayModel, Calendar calendarDate) {
    if (dayModel?.month == calendarDate.date.month.toString()) {
      for (var element in dayModel?.days ?? []) {
        if (element.day == calendarDate.date.day) {
          return Colors.red;
        }
      }
      return Colors.transparent;
    } else {
      return Colors.transparent;
    }
  }

// date selector
  Widget _calendarDates(
      Calendar calendarDate, DayModel? dayModel, List<DayColor>? dayColors) {
    final bool isThisMonth = calendarDate.thisMonth;
    final bool isSunday = calendarDate.date.weekday == DateTime.sunday;

    getCircleAvatarBackgroundColor(calendarDate, dayModel, dayColors);

    void handleDateTap() {
      if (_selectedDateTime != calendarDate.date) {
        if (calendarDate.nextMonth) {
          _getNextMonth();
        } else if (calendarDate.prevMonth) {
          _getPrevMonth();
        }

        if (getCircleAvatarBackgroundColor(calendarDate, dayModel, dayColors) !=
            null) {
          widget.onDateClickedCallBack(getCircleAvatarBackgroundColor(
              calendarDate, dayModel, dayColors));
        }
        setState(() => _selectedDateTime = calendarDate.date);
      }
    }

    return Visibility(
      visible: isThisMonth,
      child: InkWell(
        onTap: () {
          handleDateTap();
        },
        child: CircleAvatar(
          backgroundColor:
              getCircleAvatarBackgroundColor(calendarDate, dayModel, dayColors)
                      ?.color ??
                  Colors.transparent,
          child: Center(
            child: Text(
              '${calendarDate.date.day}',
              style: TextStyle(
                color: isThisMonth
                    ? (isSunday ? Colors.red : Colors.black)
                    : (isSunday
                        ? Colors.red.withOpacity(0.5)
                        : Colors.black.withOpacity(0.5)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  CallBackModel? getCircleAvatarBackgroundColor(
      Calendar calendarDate, DayModel? dayModel, List<DayColor>? dayColors) {
    if (dayModel?.month == calendarDate.date.month.toString()) {
      for (var element in dayModel?.days ?? []) {
        if (element.day == calendarDate.date.day) {
          for (var element1 in dayColors ?? []) {
            if (element1.type == element.type) {
              return CallBackModel(
                  color: HexColor.fromHex(element1.color ?? "FFFFFF"),
                  type: element1.type);
            }
          }
        }
      }
    }
    return null;
  }

  Widget _selector(Calendar calendarDate, List<DayColor>? dayColors,
      [DayModel? dayModel]) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getCircleAvatarBackgroundColor(calendarDate, dayModel, dayColors)
                ?.color ??
            Colors.transparent,
        border: Border.all(color: Colors.black, width: 4),
      ),
      child: Center(
        child: Text(
          '${calendarDate.date.day}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

// get next month calendar
  void _getNextMonth() {
    if (_currentDateTime.month == 12) {
      _currentDateTime = DateTime(_currentDateTime.year + 1, 1);
    } else {
      _currentDateTime =
          DateTime(_currentDateTime.year, _currentDateTime.month + 1);
    }
    _getCalendar();
  }

// get previous month calendar
  void _getPrevMonth() {
    if (_currentDateTime.month == 1) {
      _currentDateTime = DateTime(_currentDateTime.year - 1, 12);
    } else {
      _currentDateTime =
          DateTime(_currentDateTime.year, _currentDateTime.month - 1);
    }
    _getCalendar();
  }

// get calendar for current month
  void _getCalendar() {
    _sequentialDates = CustomCalendar().getMonthCalendar(
        _currentDateTime.month, _currentDateTime.year,
        startWeekDay: StartWeekDay.monday);
  }

// show months list
  Widget _showMonthsList() {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () => setState(() => _currentView = CalendarViews.year),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              '${_currentDateTime.year}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
        ),
        Divider(
          color: Colors.white,
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _monthNames.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                _currentDateTime = DateTime(_currentDateTime.year, index + 1);
                _getCalendar();
                setState(() => _currentView = CalendarViews.dates);
              },
              title: Center(
                child: Text(
                  _monthNames[index],
                  style: TextStyle(
                      fontSize: 18,
                      color: (index == _currentDateTime.month - 1)
                          ? Colors.green
                          : Colors.black),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

// years list views
  Widget _yearsView(int midYear) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            _toggleBtn(false),
            Spacer(),
            _toggleBtn(true),
          ],
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: GridView.builder(
                padding: EdgeInsets.only(left: 30),
                shrinkWrap: true,
                itemCount: 9,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  int thisYear;
                  if (index < 4) {
                    thisYear = midYear - (4 - index);
                  } else if (index > 4) {
                    thisYear = midYear + (index - 4);
                  } else {
                    thisYear = midYear;
                  }
                  return ListTile(
                    onTap: () {
                      _currentDateTime =
                          DateTime(thisYear, _currentDateTime.month);
                      _getCalendar();
                      setState(() => _currentView = CalendarViews.months);
                    },
                    title: Text(
                      '$thisYear',
                      style: TextStyle(
                          fontSize: 18,
                          color: (thisYear == _currentDateTime.year)
                              ? Colors.green
                              : Colors.black),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
