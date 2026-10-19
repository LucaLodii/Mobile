import 'dart:convert';

import 'package:http/http.dart' as http;

import '../dominio/decada.dart';
import '../dominio/nome.dart';

class IbgeApi {
  static const _base = 'https://servicodados.ibge.gov.br/api/v2/censos/nomes';

  Future<List<dynamic>> _get(String url) async {
    final resposta = await http.get(Uri.parse(url));
    if (resposta.statusCode != 200) {
      throw Exception('IBGE respondeu ${resposta.statusCode}');
    }
    return jsonDecode(resposta.body) as List<dynamic>;
  }

  // sexo: null (todos), 'F' ou 'M'
  Future<List<Nome>> ranking({String? sexo}) async {
    final json = await _get(sexo == null ? '$_base/ranking' : '$_base/ranking?sexo=$sexo');
    final res = json.first['res'] as List<dynamic>;
    return res.map((m) => Nome.fromJson(m)).toList();
  }

  Future<List<Decada>> historico(String nome) async {
    final json = await _get('$_base/${Uri.encodeComponent(nome)}');
    if (json.isEmpty) return [];
    final res = json.first['res'] as List<dynamic>;
    return res.map((m) => Decada.fromJson(m)).toList();
  }
}
