import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class GastosVariaveisDataProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getGastos(String apartmentId) async {
    final gastos = <Map<String, dynamic>>[];
    final snapshot = await _firestore
        .collection('gastosvariaveis')
        .where('apartmentId', isEqualTo: apartmentId)
        .get();
    for (final doc in snapshot.docs) {
      gastos.add({
        'id': doc.id,
        'gasto': doc['name'],
        'tipo': doc['tipo'],
        'valor': doc['valor']
      });
    }
    return gastos;
  }

  Future<void> addGastos(
      String apartmentId, String gasto, String tipo, String valor) async {
    await _firestore.collection('gastosvariaveis').add({
      'name': gasto,
      'apartmentId': apartmentId,
      'tipo': tipo,
      'valor': valor
    });
  }

  Future<void> updateGastos(
      String apartmentId, String gastoAntigo, String gastoNovo) async {
    final snapshot = await _firestore
        .collection('gastosvariaveis')
        .where('apartmentId', isEqualTo: apartmentId)
        .where('name', isEqualTo: gastoAntigo)
        .get();
    if (snapshot.docs.isNotEmpty) {
      await snapshot.docs.first.reference.update({'name': gastoNovo});
    }
  }

  Future<void> removeGasto(String gastoId) async {
    await _firestore.collection('gastosvariaveis').doc(gastoId).delete();
  }
}
