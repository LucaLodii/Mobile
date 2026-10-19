import 'package:flutter/foundation.dart';
import '../dados/ibge_api.dart';
import 'decada.dart';
import 'nome.dart';

class NomesStore extends ChangeNotifier {
  NomesStore(this._api);
  final IbgeApi _api;

  List<Nome> _ranking = [];
  List<Nome> get ranking => List.unmodifiable(_ranking);

  String? _sexo; // null = todos
  String? get sexo => _sexo;

  bool _carregando = false;
  bool get carregando => _carregando;

  String? _erro;
  String? get erro => _erro;

  Future<void> carregar() async {
    _carregando = true;
    _erro = null;
    notifyListeners();
    try {
      _ranking = await _api.ranking(sexo: _sexo);
    } catch (_) {
      _erro = 'Não foi possível carregar. Verifique a internet.';
    }
    _carregando = false;
    notifyListeners();
  }

  Future<void> trocarSexo(String? sexo) async {
    _sexo = sexo;
    await carregar();
  }

  Future<List<Decada>> historico(String nome) => _api.historico(nome);
}
