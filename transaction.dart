// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';

class Transaction {
  final String id;
  final String titles;
  final double amount;
  final DateTime date;

  Transaction(
      {required this.id,
      required this.titles,
      required this.amount,
      required this.date});
}
