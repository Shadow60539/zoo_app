import 'package:flutter/material.dart';

class ScratchNotifier extends ValueNotifier<List<String>> {
  ScratchNotifier() : super([]);

  void addToScrated(String animal) {
    value.add(animal);
    notifyListeners();
  }

  bool isContains(String animal) {
    return value.contains(animal);
  }
}
