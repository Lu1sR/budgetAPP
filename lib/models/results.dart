import 'package:meta/meta.dart';

class Results {
  final double otros;
  final double vivienda;
  final double salud;
  final double alimentacion;
  final double vestimenta;
  Results({
    @required this.otros,
    @required this.vivienda,
    @required this.salud,
    @required this.alimentacion,
    @required this.vestimenta,
  });

  factory Results.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final double otros = data['Otros'];
    final double vivienda = data['Vivienda'];
    final double salud = data['Salud'];
    final double alimentacion = data['Alimentacion'];
    final double vestimenta = data['Vestimenta'];

    return Results(
      otros: otros,
      vivienda: vivienda,
      salud: salud,
      alimentacion: alimentacion,
      vestimenta: vestimenta,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Otros': otros,
      'Vivienda': vivienda,
      'Salud': salud,
      'Alimentacion': alimentacion,
      'Vestimenta': vestimenta
    };
  }
}
