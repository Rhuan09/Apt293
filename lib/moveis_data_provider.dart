import 'package:cloud_firestore/cloud_firestore.dart';

class MoveisDataProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarMovel(String nomeMovel) async {
    try {
      await _firestore.collection('moveis').add({'nome': nomeMovel});
    } catch (e) {
      print(e);
      throw Exception('Erro ao adicionar móvel.');
    }
  }

  Future<List<String>> listarMoveis() async {
    try {
      final snapshot = await _firestore.collection('moveis').get();
      final moveis = snapshot.docs.map((doc) => doc['nome'] as String).toList();
      return moveis;
    } catch (e) {
      print(e);
      throw Exception('Erro ao listar móveis.');
    }
  }

  Future<void> removerMovel(String nomeMovel) async {
    try {
      final snapshot = await _firestore
          .collection('moveis')
          .where('nome', isEqualTo: nomeMovel)
          .get();
      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();
      } else {
        throw Exception('Móvel não encontrado.');
      }
    } catch (e) {
      // Tratar erros
      throw Exception('Erro ao remover móvel.');
    }
  }

  Future<void> atualizarMovel(
      String nomeMovelAntigo, String nomeMovelNovo) async {
    try {
      final snapshot = await _firestore
          .collection('moveis')
          .where('nome', isEqualTo: nomeMovelAntigo)
          .get();
      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.update({'nome': nomeMovelNovo});
      } else {
        throw Exception('Móvel não encontrado.');
      }
    } catch (e) {
      // Tratar erros
      throw Exception('Erro ao atualizar móvel.');
    }
  }
}
