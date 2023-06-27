import 'package:cloud_firestore/cloud_firestore.dart';

class ApartamentosDataProvider {
  final _firestore = FirebaseFirestore.instance;

  // Lê os apartamentos do usuário do Cloud Firestore
  Future<List<String>> getApartments(String userId) async {
    final snapshot =
        await _firestore.collection('apartments').doc(userId).get();

    if (snapshot.exists) {
      return List<String>.from(snapshot.data()?['apartments'] ?? []);
    } else {
      return [];
    }
  }

  // Adiciona um novo apartamento ao Cloud Firestore
  Future<void> addApartment(String userId, String apartment) async {
    final snapshot =
        await _firestore.collection('apartments').doc(userId).get();

    if (snapshot.exists) {
      final apartments = List<String>.from(snapshot.data()?['apartments'] ?? [])
        ..add(apartment);
      await _firestore
          .collection('apartments')
          .doc(userId)
          .update({'apartments': apartments});
    } else {
      await _firestore.collection('apartments').doc(userId).set({
        'apartments': [apartment]
      });
    }
  }

  // Remove um apartamento do Cloud Firestore
  Future<void> removeApartment(String userId, String apartment) async {
    final snapshot =
        await _firestore.collection('apartments').doc(userId).get();
    if (snapshot.exists) {
      final apartments = List<String>.from(snapshot.data()?['apartments'] ?? [])
        ..remove(apartment);
      await _firestore
          .collection('apartments')
          .doc(userId)
          .update({'apartments': apartments});
    }
  }
}
