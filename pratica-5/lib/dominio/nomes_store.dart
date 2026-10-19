import 'package:flutter/foundation.dart';
import '../dados/ibge_api.dart';
import 'decada.dart';
import 'nome.dart';

enum Estado { carregando, pronto, erro }

const _mensagemErro = 'Não foi possível carregar. Verifique a internet.';

class NomesStore extends ChangeNotifier {
  NomesStore(this._api) {
    carregar(); // alguém precisa dar a partida
  }
  final IbgeApi _api;

  // ---- Ranking (a lista) ----

  Estado estado = Estado.carregando;
  String? mensagemErro;

  String? _sexo; // null = todos
  String? get sexo => _sexo;

  List<Nome> _ranking = [];
  List<Nome> get ranking => List.unmodifiable(_ranking);

  // Cada pedido ganha um número; resposta de pedido antigo que chega atrasada é ignorada.
  int _pedidoRanking = 0;

  Future<void> carregar() async {
    final pedido = ++_pedidoRanking;
    estado = Estado.carregando;
    notifyListeners(); // a tela mostra o indicador
    try {
      final ranking = await _api.ranking(sexo: _sexo);
      if (pedido != _pedidoRanking) return;
      _ranking = ranking;
      estado = Estado.pronto;
    } catch (e) {
      if (pedido != _pedidoRanking) return;
      estado = Estado.erro;
      mensagemErro = _mensagemErro;
    }
    notifyListeners(); // a tela mostra o resultado
  }

  Future<void> trocarSexo(String? sexo) {
    _sexo = sexo;
    return carregar();
  }

  // ---- Busca (o painel acima da lista) ----

  String? _nomeBuscado; // null = painel fechado
  String? get nomeBuscado => _nomeBuscado;

  Estado estadoBusca = Estado.pronto;
  String? mensagemErroBusca;

  List<Decada> _decadas = [];
  List<Decada> get decadas => List.unmodifiable(_decadas);

  int _pedidoBusca = 0;

  // "Tentar de novo" no painel chama este mesmo método com o mesmo nome.
  Future<void> buscar(String nome) async {
    final pedido = ++_pedidoBusca;
    _nomeBuscado = nome;
    estadoBusca = Estado.carregando;
    notifyListeners();
    try {
      final decadas = await _api.historico(nome);
      if (pedido != _pedidoBusca) return;
      _decadas = decadas;
      estadoBusca = Estado.pronto;
    } catch (e) {
      if (pedido != _pedidoBusca) return;
      estadoBusca = Estado.erro;
      mensagemErroBusca = _mensagemErro;
    }
    notifyListeners();
  }

  void fecharBusca() {
    _pedidoBusca++; // descarta uma resposta que ainda esteja a caminho
    _nomeBuscado = null;
    notifyListeners();
  }
}
