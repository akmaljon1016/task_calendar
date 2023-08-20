import 'package:calendar/presentation/bloc/calendar_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

class MockCalendarBlock extends MockBloc<CalendarEvent, CalendarState>
    implements CalendarBloc {}

void main() {
  late CalendarBloc calendarBloc;
  setUp(() {
    calendarBloc = MockCalendarBlock();
  });
  blocTest<CalendarBloc, CalendarState>("bloc",
      build: () => calendarBloc,
      act: (bloc) => calendarBloc.add(LoadCalendarEvent()),
      expect: () => []);
}
