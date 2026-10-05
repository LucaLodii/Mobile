import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dominio/habitos_store.dart';

const Map<String, IconData> opcoesIcones = {
  'estrela': Icons.star,
  'livro': Icons.book,
  'academia': Icons.fitness_center,
  'tela': Icons.monitor,
  'cafe': Icons.local_cafe,
  'corrida': Icons.directions_run,
  'musica': Icons.music_note,
  'ideia': Icons.lightbulb,
  'coracao': Icons.favorite,
  'pet': Icons.pets,
};

class TelaNovoHabito extends StatefulWidget {
  const TelaNovoHabito({super.key});

  @override
  State<TelaNovoHabito> createState() => _TelaNovoHabitoState();
}

class _TelaNovoHabitoState extends State<TelaNovoHabito> {
  final nomeController = TextEditingController();
  final metaController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    metaController.dispose();
    super.dispose();
  }

  void salvar() {
    final nome = nomeController.text.trim();
    final meta = metaController.text.trim();

    if (nome.isEmpty || meta.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha o nome e a meta.'),
        ),
      );
      return;
    }

    final random = Random();
    final indiceSorteado = random.nextInt(opcoesIcones.length);
    final iconeAleatorio = opcoesIcones.keys.toList()[indiceSorteado];

    context.read<HabitosStore>().adicionar(nome, meta, iconeAleatorio);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Hábito'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do hábito',
                hintText: 'Ex: Ler',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: metaController,
              decoration: const InputDecoration(
                labelText: 'Meta',
                hintText: 'Ex: 10 páginas por dia',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: salvar,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const RoundedRectangleBorder(),
                ),
                child: const Text('Salvar Hábito'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
