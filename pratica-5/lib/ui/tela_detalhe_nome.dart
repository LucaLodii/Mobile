import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dominio/decada.dart';
import '../dominio/nomes_store.dart';
import 'formato.dart';

class TelaDetalheNome extends StatefulWidget {
  final String nome;

  const TelaDetalheNome({
    super.key,
    required this.nome,
  });

  @override
  State<TelaDetalheNome> createState() => _TelaDetalheNomeState();
}

class _TelaDetalheNomeState extends State<TelaDetalheNome> {
  late final Future<List<Decada>> _historico;

  @override
  void initState() {
    super.initState();
    _historico = context.read<NomesStore>().historico(widget.nome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nome.toUpperCase()),
        elevation: 0,
      ),
      body: FutureBuilder<List<Decada>>(
        future: _historico,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Não foi possível carregar. Verifique a internet.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final decadas = snapshot.data!;
          if (decadas.isEmpty) {
            return const Center(
              child: Text(
                'Nome não encontrado no Censo.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final total = decadas.fold(0, (soma, d) => soma + d.frequencia);
          final maior = decadas.map((d) => d.frequencia).reduce((a, b) => a > b ? a : b);

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Container(
                width: double.infinity,
                color: Colors.grey.shade200,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${formatarNumero(total)} pessoas',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'se chamam ${widget.nome.toUpperCase()} no Brasil (Censo 2010)',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Nascidos por década',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              for (final d in decadas)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(width: 56, child: Text(d.rotulo)),
                      Expanded(
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: d.frequencia / maior,
                          child: Container(height: 18, color: Colors.blue),
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: Text(
                          formatarNumero(d.frequencia),
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
