import 'package:flutter/material.dart';
import 'package:ProFlow/navigation/my project/core/values/icons.dart';
import 'package:ProFlow/navigation/my project/core/values/colors.dart';

List<Icon> getIcons() {
  return const [
    Icon(
      IconData(dueToday, fontFamily: 'MaterialIcons'),
      color: yellow,
    ),
    Icon(
      IconData(nextWeek, fontFamily: 'MaterialIcons'),
      color: pink,
    ),
    Icon(IconData(dueLater, fontFamily: 'MaterialIcons'),
        color: grey),
  ];
}
