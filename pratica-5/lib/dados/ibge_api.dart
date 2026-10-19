import 'dart:convert';

import 'package:http/http.dart' as http;

import '../dominio/decada.dart';
import '../dominio/nome.dart';

// Só lê: a API do IBGE não grava, e o repositório não finge que grava.
class IbgeApi {
  static const _base = 'https://servicodados.ibge.gov.br/api/v2/censos/nomes';

  // O IBGE embrulha tudo em [{ ..., "res": [ ... ] }]; devolve só a lista de dentro.
  Future<List<Map<String, Object?>>> _get(String url) async {
    final resposta = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

    if (resposta.statusCode != 200) {
      throw Exception('O servidor respondeu ${resposta.statusCode}');
    }

    final List<dynamic> bruto = jsonDecode(resposta.body);
    if (bruto.isEmpty) return [];
    final res = (bruto.first as Map<String, Object?>)['res'] as List<dynamic>? ?? [];
    return res.cast<Map<String, Object?>>();
  }

  // sexo: null (todos), 'F' ou 'M'
  Future<List<Nome>> ranking({String? sexo}) async {
    final res = await _get(sexo == null ? '$_base/ranking' : '$_base/ranking?sexo=$sexo');
    return res.map(Nome.fromMap).toList();
  }

  Future<List<Decada>> historico(String nome) async {
    final res = await _get('$_base/${Uri.encodeComponent(nome)}');
    return res.map(Decada.fromMap).toList();
  }
}
