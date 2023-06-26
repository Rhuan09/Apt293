import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class MoveisDataProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> getMoveis(String apartmentId) async {
    final moveis = <Map<String, dynamic>>[];
    final snapshot = await _firestore
        .collection('moveis')
        .where('apartmentId', isEqualTo: apartmentId)
        .get();
    for (final doc in snapshot.docs) {
      moveis.add({
        'name': doc['name'],
        'imageUrl': doc['imageUrl'],
      });
    }
    return moveis;
  }

  Future<void> addMovel(
      String apartmentId, String movel, XFile? imagemMovel) async {
    String? imageUrl;
    if (imagemMovel != null) {
      // Faz o upload da imagem para o armazenamento em nuvem do Firebase
      final ref = _storage.ref().child('moveis').child(imagemMovel.name);
      await ref.putFile(File(imagemMovel.path));
      imageUrl = await ref.getDownloadURL();
    }

    await _firestore.collection('moveis').add({
      'name': movel,
      'apartmentId': apartmentId,
      'imageUrl': imageUrl,
    });
  }

  Future<void> updateMovel(
      String apartmentId, String movelAntigo, String movelNovo) async {
    final snapshot = await _firestore
        .collection('moveis')
        .where('apartmentId', isEqualTo: apartmentId)
        .where('name', isEqualTo: movelAntigo)
        .get();
    if (snapshot.docs.isNotEmpty) {
      await snapshot.docs.first.reference.update({'name': movelNovo});
    }
  }

  Future<void> removeMovel(String apartmentId, String movel) async {
    final snapshot = await _firestore
        .collection('moveis')
        .where('apartmentId', isEqualTo: apartmentId)
        .where('name', isEqualTo: movel)
        .get();
    if (snapshot.docs.isNotEmpty) {
      // Remove a imagem do armazenamento em nuvem do Firebase
      final imageUrl = snapshot.docs.first['imageUrl'];
      if (imageUrl != null) {
        final ref = _storage.refFromURL(imageUrl);
        await ref.delete();
      }

      await snapshot.docs.first.reference.delete();
    }
  }
}
