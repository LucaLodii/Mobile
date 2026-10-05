import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dados/habitos_repositorio.dart';
import 'dominio/habitos_store.dart';
import 'ui/tela_principal.dart';

void main() {
  final repo = HabitosRepositorio();

  runApp(
    ChangeNotifierProvider(
      create: (_) => HabitosStore(repo)..carregar(),
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
      title: 'Diário de Hábitos',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const TelaPrincipal(),
    );
  }
}
