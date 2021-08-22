import 'package:flutter/material.dart';
import './transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                SizedBox(height: 10),
                Text('No Transactions added yet',
                    style: Theme.of(context).textTheme.headline6),
                SizedBox(height: 10),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : Column(
            children: transactions.map((tx) {
              return Card(
                elevation: 9,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: FittedBox(child: Text(tx.amount.toString())),
                    ),
                  ),
                  title: Text("${tx.titles}",
                      style: Theme.of(context).textTheme.headline6),
                  subtitle: Text(DateFormat.yMMMEd().format(tx.date)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () => deleteTx(tx.id),
                  ),
                ),
              );
            }).toList(),
          );
  }
}
