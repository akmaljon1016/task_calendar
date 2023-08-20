import 'dart:ui';

class CallBackModel {
  Color color;
  int type;

  CallBackModel({required this.color, required this.type});

  @override
  String toString() {
    return 'CallBackModel{color: $color, type: $type}';
  }
}
