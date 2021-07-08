import 'package:budget/models/results.dart';

import 'firestore_service.dart';
import 'package:budget/services/api_path.dart';
import 'package:budget/models/transactions.dart';
import 'package:meta/meta.dart';

abstract class Database {
  Stream<List<Transaction>> pedidosStream();
  Future<void> createTransaction(Transaction transaction);
  Future<void> deletePedido({@required Transaction transaction});
  Stream resultStream();
  Future<void> updateCounter(String rubro, double counter);
}

String doucmentIFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoresDatabase implements Database {
  FirestoresDatabase({@required this.uid});
  final _service = FiresetoreService.instance;
  final String uid;

  Future<void> deletePedido({@required Transaction transaction}) async =>
      await _service.deletePedido(
          path: ApiPath.transaction(uid, transaction.id));

  Future<void> createTransaction(Transaction transaction) async =>
      await _service.setData(
        path: ApiPath.transaction(uid, transaction.id),
        data: transaction.toMap(),
      );
  Future<void> updateField(Transaction transaction) async =>
      await _service.setData(
        path: ApiPath.transaction(uid, transaction.id),
        data: transaction.toMap(),
      );
  Future<void> updateCounter(String rubro, double counter) async =>
      await _service.updateCounter(
        rubro: rubro,
        path: 'users/$uid',
        data: counter,
      );
  Stream<List<Transaction>> pedidosStream() => _service.collectionStream(
        path: ApiPath.transactions(uid),
        builder: (data, documentID) => Transaction.fromMap(data, documentID),
      );

  Stream resultStream() => _service.documentStream(
        id: uid,
        path: ApiPath.results(),
      );
}
