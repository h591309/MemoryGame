import 'package:flutter/material.dart';

class CardModel {
  final int id;
  final int value;
  bool isFlipped;
  bool isMatched;
  Icon icon;

  CardModel({
    required this.id,
    required this.value,
    this.isFlipped = false,
    this.isMatched = false,
    required this.icon,
  });
}
