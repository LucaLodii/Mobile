import 'package:flutter/foundation.dart';
import '../dados/habitos_repositorio.dart';
import 'habito.dart';

class HabitosStore extends ChangeNotifier {
  HabitosStore(this._repo);
  final HabitosRepositorio _repo;

  List<Habito> _habitos = [];
  List<Habito> get habitos => List.unmodifiable(_habitos);

  Future<void> carregar() async {
    _habitos = await _repo.carregar();
    notifyListeners();
  }

  Future<void> adicionar(String nome, String meta, String icone) async {
    final h = Habito(nome: nome, meta: meta, icone: icone);
    await _repo.salvar(h);
    await carregar();
  }

  Future<void> remover(Habito h) async {
    await _repo.remover(h);
    await carregar();
  }
}
