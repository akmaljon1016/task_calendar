import 'dart:convert';

List<DayColor> dayColorListFromJson(dynamic str) =>
    List.from(str.map((e) => DayColor.fromJson(e)));

class DayColor {
  DayColor({
    this.type,
    this.color,
  });

  DayColor.fromJson(dynamic json) {
    type = json['type'];
    color = json['color'];
  }

  int? type;
  String? color;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['color'] = color;
    return map;
  }

  @override
  String toString() {
    return 'DayColor{type: $type, color: $color}';
  }
}
