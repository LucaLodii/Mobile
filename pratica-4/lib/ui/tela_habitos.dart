import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dominio/habitos_store.dart';
import 'tela_novo_habito.dart';
import 'tela_detalhe_habito.dart';

class TelaHabitos extends StatelessWidget {
  const TelaHabitos({super.key});

  @override
  Widget build(BuildContext context) {
    final habitos = context.watch<HabitosStore>().habitos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Hábitos'),
        centerTitle: true,
        elevation: 0,
      ),
      body: habitos.isEmpty
          ? const Center(
              child: Text(
                'Nenhum hábito cadastrado.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.separated(
              itemCount: habitos.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, indice) {
                final habito = habitos[indice];

                return ListTile(
                  leading: Icon(opcoesIcones[habito.icone], color: Colors.black54),
                  title: Text(
                    habito.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(habito.meta),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaDetalheHabito(habito: habito),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TelaNovoHabito(),
            ),
          );
        },
        shape: const RoundedRectangleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
