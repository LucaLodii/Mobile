import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dominio/nomes_store.dart';
import 'estados.dart';
import 'formato.dart';
import 'painel_nome.dart';

// A única tela do app: busca, painel do nome buscado, filtro e ranking.
class TelaNomes extends StatefulWidget {
  const TelaNomes({super.key});

  @override
  State<TelaNomes> createState() => _TelaNomesState();
}

class _TelaNomesState extends State<TelaNomes> {
  final _busca = TextEditingController();

  @override
  void dispose() {
    _busca.dispose();
    super.dispose();
  }

  void _buscar(String texto) {
    if (texto.trim().isEmpty) return;
    context.read<NomesStore>().buscar(texto.trim());
    _busca.clear();
  }

  Widget _chip(NomesStore loja, String rotulo, String? sexo) {
    return ChoiceChip(
      label: Text(rotulo),
      selected: loja.sexo == sexo,
      onSelected: (_) => loja.trocarSexo(sexo),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loja = context.watch<NomesStore>();

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
              controller: _busca,
              decoration: const InputDecoration(
                labelText: 'Buscar um nome',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: _buscar,
            ),
          ),
          if (loja.nomeBuscado != null) const PainelNome(),
          // Wrap em vez de Row: em tela estreita o chip desce de linha em vez de estourar.
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              _chip(loja, 'Todos', null),
              _chip(loja, 'Mulheres', 'F'),
              _chip(loja, 'Homens', 'M'),
            ],
          ),
          const Divider(height: 1),
          Expanded(child: _ranking(loja)),
        ],
      ),
    );
  }

  Widget _ranking(NomesStore loja) {
    switch (loja.estado) {
      case Estado.carregando:
        return const Center(child: CircularProgressIndicator());
      case Estado.erro:
        return TelaDeErro(
          mensagem: loja.mensagemErro!,
          aoTentarDeNovo: () => loja.carregar(),
        );
      case Estado.pronto:
        if (loja.ranking.isEmpty) return const TelaVazia('O IBGE não devolveu nenhum nome.');
        return ListView.separated(
          itemCount: loja.ranking.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, indice) {
            final nome = loja.ranking[indice];

            return ListTile(
              selected: nome.nome == loja.nomeBuscado?.toUpperCase(),
              leading: Text(
                '${nome.ranking}º',
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
              title: Text(
                nome.nome,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${formatarNumero(nome.frequencia)} pessoas'),
              onTap: () => loja.buscar(nome.nome),
            );
          },
        );
    }
  }
}
