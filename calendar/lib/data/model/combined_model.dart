import 'package:calendar/data/model/day_color.dart';
import 'package:calendar/data/model/day_model.dart';

class CombinedModel {
  DayModel dayModel;
  List<DayColor> dayColors;
  CombinedModel({required this.dayModel, required this.dayColors});
}
