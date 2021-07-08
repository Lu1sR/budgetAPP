import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Transaction {
  final double amount;
  final double deducible;
  final String nameRUC;
  final String id;
  final Timestamp date;
  final String category;

  Transaction(
      {@required this.id,
      @required this.amount,
      @required this.deducible,
      @required this.nameRUC,
      @required this.date,
      @required this.category});

  factory Transaction.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    final double amount = data['amount'];
    final double deducible = data['deducible'];
    final String nameRUC = data['nameRUC'];
    final Timestamp date = data['date'];
    final String category = data['category'];

    return Transaction(
      category: category,
      date: date,
      id: documentID,
      amount: amount,
      deducible: deducible,
      nameRUC: nameRUC,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'amount': amount,
      'deducible': deducible,
      'nameRUC': nameRUC,
      'date': date,
    };
  }
}
