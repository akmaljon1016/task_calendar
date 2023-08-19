import 'days.dart';

class DayModel {
  DayModel({
      this.month, 
      this.year, 
      this.days,});

  DayModel.fromJson(dynamic json) {
    month = json['month'];
    year = json['year'];
    if (json['days'] != null) {
      days = [];
      json['days'].forEach((v) {
        days?.add(Days.fromJson(v));
      });
    }
  }
  String? month;
  int? year;
  List<Days>? days;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['month'] = month;
    map['year'] = year;
    if (days != null) {
      map['days'] = days?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  @override
  String toString() {
    return 'DayModel{month: $month, year: $year, days: $days}';
  }
}