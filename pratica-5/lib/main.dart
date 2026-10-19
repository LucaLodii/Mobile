import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dados/ibge_api.dart';
import 'dominio/nomes_store.dart';
import 'ui/tela_nomes.dart';

void main() {
  final api = IbgeApi();

  runApp(
    ChangeNotifierProvider(
      create: (_) => NomesStore(api)..carregar(),
      child: const MeuApp(),
    ),
  );
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nomes do Brasil',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const TelaNomes(),
    );
  }
}
