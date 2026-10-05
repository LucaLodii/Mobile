import 'package:shared_preferences/shared_preferences.dart';

const _chaveUltimaAba = 'ultima_aba';

Future<void> salvarUltimaAba(int indice) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(_chaveUltimaAba, indice);
}

Future<int> lerUltimaAba() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(_chaveUltimaAba) ?? 0;
}
