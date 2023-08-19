class Days {
  Days({
      this.day, 
      this.type,});

  Days.fromJson(dynamic json) {
    day = json['day'];
    type = json['type'];
  }
  int? day;
  int? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['day'] = day;
    map['type'] = type;
    return map;
  }

}