import 'package:flutter/material.dart';

mixin Utils {
  final List<String> animalNames = [
    'Panda',
    'Sloth',
    'Cat',
    'Tortoise',
    'Elephant',
    'Fox',
    'Dolphin',
    'Reindeer',
  ];

  final ValueNotifier<bool> isLikedNotifier = ValueNotifier(false);
}
