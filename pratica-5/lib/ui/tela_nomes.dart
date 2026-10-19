import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dominio/nomes_store.dart';
import 'formato.dart';
import 'tela_detalhe_nome.dart';

class TelaNomes extends StatelessWidget {
  const TelaNomes({super.key});

  void _abrir(BuildContext context, String nome) {
    if (nome.trim().isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaDetalheNome(nome: nome.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<NomesStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nomes do Brasil'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar um nome',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (texto) => _abrir(context, texto),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final (rotulo, sexo) in const [('Todos', null), ('Mulheres', 'F'), ('Homens', 'M')])
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(rotulo),
                    selected: store.sexo == sexo,
                    onSelected: (_) => store.trocarSexo(sexo),
                  ),
                ),
            ],
          ),
          const Divider(height: 1),
          Expanded(child: _lista(context, store)),
        ],
      ),
    );
  }

  Widget _lista(BuildContext context, NomesStore store) {
    if (store.carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (store.erro != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(store.erro!, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: store.carregar,
              child: const Text('Tentar de novo'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: store.ranking.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, indice) {
        final nome = store.ranking[indice];

        return ListTile(
          leading: Text(
            '${nome.ranking}º',
            style: const TextStyle(fontSize: 18, color: Colors.black54),
          ),
          title: Text(
            nome.nome,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('${formatarNumero(nome.frequencia)} pessoas'),
          onTap: () => _abrir(context, nome.nome),
        );
      },
    );
  }
}
