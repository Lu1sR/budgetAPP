import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FiresetoreService {
  FiresetoreService._();
  static final instance = FiresetoreService._();

  Future<void> deletePedido({@required String path}) async {
    final reference = Firestore.instance.document(path);
    await reference.delete();
  }

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    await reference.setData(data);
  }

  Future<void> updateCounter({String path, double data, String rubro}) async {
    final reference = Firestore.instance.document(path);
    final valorRubro =
        await reference.get().then((snapshot) => snapshot.data['$rubro']);
    double newValue = valorRubro + data;
    await reference.updateData({'$rubro': newValue});
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents
        .map((snapshot) => builder(snapshot.data, snapshot.documentID))
        .toList());
  }

  Stream documentStream<T>({
    @required String path,
    @required String id,
  }) {
    final reference = Firestore.instance.collection(path).document(id);
    final snapshots = reference.snapshots();
    return snapshots;
  }
}
