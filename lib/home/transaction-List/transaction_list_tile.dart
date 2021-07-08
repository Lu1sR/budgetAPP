import 'package:budget/services/format.dart';
import 'package:flutter/material.dart';
import 'package:budget/models/transactions.dart';

class TransactionListTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionListTile({Key key, this.transaction, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(Format.toDate(transaction.date).split(' ')[0]),
          Text(Format.toDate(transaction.date).split(' ')[1]),
        ],
      ),
      title: Text(
          '${transaction.nameRUC[0].toUpperCase()}${transaction.nameRUC.substring(1)}',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black54,
              fontSize: 16)),
      subtitle: Text(transaction.category),
      trailing: Text('\$${transaction.amount}',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: Colors.indigo, fontSize: 16)),
      onTap: onTap,
    );
  }
}
