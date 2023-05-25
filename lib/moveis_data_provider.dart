import 'package:dio/dio.dart';

class MoveisDataProvider {
  final Dio _dio = Dio();

  Future<void> adicionarMovel(String nomeMovel) async {
    try {
      final response = await _dio.post(
        'https://apt293-4f9ac-default-rtdb.firebaseio.com/moveis.json',
        data: {'nome': nomeMovel},
      );
      // Processar a resposta se necessário
    } catch (e) {
      // Tratar erros
      throw Exception('Erro ao adicionar móvel.');
    }
  }

  Future<List<String>> listarMoveis() async {
    try {
      final response = await _dio
          .get('https://apt293-4f9ac-default-rtdb.firebaseio.com/moveis.json');
      final data = response.data as Map<String, dynamic>;
      final moveis = data.values.map((item) => item['nome'] as String).toList();
      return moveis;
    } catch (e) {
      // Tratar erros
      throw Exception('Erro ao listar móveis.');
    }
  }

  Future<void> removerMovel(String nomeMovel) async {
    try {
      final response = await _dio.delete(
          'https://apt293-4f9ac-default-rtdb.firebaseio.com/moveis/$nomeMovel.json');
      // Processar a resposta se necessário
    } catch (e) {
      // Tratar erros
      throw Exception('Erro ao remover móvel.');
    }
  }

  Future<void> atualizarMovel(
      String nomeMovelAntigo, String nomeMovelNovo) async {
    try {
      final response = await _dio.patch(
        'https://apt293-4f9ac-default-rtdb.firebaseio.com/moveis/$nomeMovelAntigo.json',
        data: {'nome': nomeMovelNovo},
      );
      // Processar a resposta se necessário
    } catch (e) {
      // Tratar erros
      throw Exception('Erro ao atualizar móvel.');
    }
  }
}
