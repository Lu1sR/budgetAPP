import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Format {
  static String toDate(Timestamp date) {
    DateTime fecha = date.toDate();
    return DateFormat.MMMd('es').format(fecha);
  }
}
