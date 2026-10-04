import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dominio/habito.dart';
import '../dominio/habitos_store.dart';
import 'tela_novo_habito.dart';

class TelaDetalheHabito extends StatelessWidget {
  final Habito habito;

  const TelaDetalheHabito({
    super.key,
    required this.habito,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(habito.nome),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(opcoesIcones[habito.icone], size: 36, color: Colors.black87),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habito.nome,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Meta: ${habito.meta}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                    padding: const EdgeInsets.all(12.0),
                    child: const Column(
                      children: [
                        Text('12', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('dias seguidos', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                    padding: const EdgeInsets.all(12.0),
                    child: const Column(
                      children: [
                        Text('5 / 8', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('hoje', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                    padding: const EdgeInsets.all(12.0),
                    child: const Column(
                      children: [
                        Text('62%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('no mês', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sobre este hábito',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lembre-se que a sua meta é: ${habito.meta}.\n\nMantenha a consistência para atingir o objetivo diário.',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<HabitosStore>().remover(habito);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const RoundedRectangleBorder(),
                ),
                child: const Text('Excluir Hábito', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
