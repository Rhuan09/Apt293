import 'package:cloud_firestore/cloud_firestore.dart';

class GastosFixosDataProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, double>> fetchGastosFixos(String apartamento) async {
    // Buscar os dados dos gastos fixos do apartamento no Firestore

    print('fetchGastosFixos chamado com apartamento: $apartamento');
    final snapshot = await _firestore
        .collection('gastosfixos')
        .where('apartmentId', isEqualTo: apartamento)
        .get();

    final gastosFixos = <String, double>{};
    for (final doc in snapshot.docs) {
      final data = doc.data();
      gastosFixos['Luz'] = data['luz'] ?? 0;
      gastosFixos['Aluguel'] = data['aluguel'] ?? 0;
      gastosFixos['Internet'] = data['internet'] ?? 0;
    }

    return gastosFixos;
  }

  Future<void> saveGastosFixos(
      String apartamento, Map<String, double> gastosFixos) async {
    // Salvar os dados dos gastos fixos do apartamento no Firestore
    await _firestore.collection('gastosfixos').doc(apartamento).set({
      'luz': gastosFixos['Luz'],
      'aluguel': gastosFixos['Aluguel'],
      'internet': gastosFixos['Internet'],
      'apartmentId': apartamento
    }, SetOptions(merge: true));
  }
}
