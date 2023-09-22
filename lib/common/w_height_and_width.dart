import 'package:flutter/material.dart';

final Height height30 = Height(height: 30);
final Height height20 = Height(height: 20);
final Height height10 = Height(height: 10);
final Height height5 = Height(height: 5);


final Width width30 = Width(width: 30);
final Width width20 = Width(width: 20);
final Width width10 = Width(width: 10);
final Width width5 = Width(width: 5);

class Height extends StatelessWidget {
  double height;
  Height( {required this.height, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(height: height);
  }
}


class Width extends StatelessWidget {
  double width;
  Width( {required this.width, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(height: width);
  }
}