import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      var weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      print(DateFormat.E().format(weekDay).substring(0, 1));
      print(totalSum);
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((any) {
            return Flexible(
              fit: FlexFit.tight,
              // flex: 1,
              child: ChartBar(
                any['day'] as String,
                any['amount'] as double,
                totalSpending == 0
                    ? 0
                    : ((any['amount']) as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
