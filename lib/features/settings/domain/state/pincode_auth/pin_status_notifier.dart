import 'package:flutter/material.dart';

class PinStatusNotifier extends ValueNotifier<bool> {
  PinStatusNotifier({required bool isPinSet}) : super(isPinSet);

  void setPinStatus(bool isSet) => value = isSet;
}
