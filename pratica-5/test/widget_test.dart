import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/dados/ibge_api.dart';
import 'package:flutter_application_1/dominio/decada.dart';
import 'package:flutter_application_1/dominio/nome.dart';
import 'package:flutter_application_1/dominio/nomes_store.dart';
import 'package:flutter_application_1/main.dart';

// Os testes do Flutter bloqueiam a internet, então a API é trocada por dados fixos.
class FakeIbgeApi extends IbgeApi {
  FakeIbgeApi({this.semInternet = false});
  final bool semInternet;

  @override
  Future<List<Nome>> ranking({String? sexo}) async {
    if (semInternet) throw Exception('sem internet');
    return [
      Nome(nome: 'MARIA', frequencia: 11734129, ranking: 1),
      Nome(nome: 'JOSE', frequencia: 5754529, ranking: 2),
    ];
  }

  @override
  Future<List<Decada>> historico(String nome) async {
    if (nome.toUpperCase() == 'XYZ') return [];
    return [
      Decada(rotulo: '1990', frequencia: 3308),
      Decada(rotulo: '2000', frequencia: 7013),
    ];
  }
}

// Cada pedido fica parado até o teste decidir quando ele "chega".
class FakeLenta extends IbgeApi {
  final pedidos = <String?, Completer<List<Nome>>>{};

  @override
  Future<List<Nome>> ranking({String? sexo}) {
    pedidos[sexo] = Completer<List<Nome>>();
    return pedidos[sexo]!.future;
  }
}

Future<void> abrirApp(WidgetTester tester, IbgeApi api) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => NomesStore(api),
      child: const MeuApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('mostra o ranking e o painel do nome na mesma tela', (WidgetTester tester) async {
    // Tamanho de um celular comum, para pegar estouro de layout.
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await abrirApp(tester, FakeIbgeApi());

    expect(find.text('MARIA'), findsOneWidget);
    expect(find.text('11.734.129 pessoas'), findsOneWidget);

    await tester.tap(find.text('JOSE'));
    await tester.pumpAndSettle();

    expect(find.text('10.321 pessoas'), findsOneWidget);
    expect(find.text('nascidas por década, pico em 2000'), findsOneWidget);
    expect(find.text('MARIA'), findsOneWidget); // o ranking continua na tela

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text('10.321 pessoas'), findsNothing);
  });

  testWidgets('nome que não existe mostra o estado vazio', (WidgetTester tester) async {
    await abrirApp(tester, FakeIbgeApi());

    await tester.enterText(find.byType(TextField), 'xyz');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('Nome não encontrado no Censo.'), findsOneWidget);
    expect(find.text('Tentar de novo'), findsNothing);
  });

  testWidgets('sem internet mostra o erro e o botão de tentar de novo', (WidgetTester tester) async {
    await abrirApp(tester, FakeIbgeApi(semInternet: true));

    expect(find.text('Não foi possível carregar. Verifique a internet.'), findsOneWidget);
    expect(find.text('Tentar de novo'), findsOneWidget);
  });

  test('resposta atrasada não sobrescreve o filtro mais novo', () async {
    final api = FakeLenta();
    final loja = NomesStore(api); // pede o ranking de todos
    loja.trocarSexo('F');
    loja.trocarSexo('M');

    // Homens chega primeiro, Mulheres chega depois, atrasada.
    api.pedidos['M']!.complete([Nome(nome: 'JOSE', frequencia: 1, ranking: 1)]);
    api.pedidos['F']!.complete([Nome(nome: 'MARIA', frequencia: 1, ranking: 1)]);
    api.pedidos[null]!.complete([]);
    await Future<void>.delayed(Duration.zero);

    expect(loja.sexo, 'M');
    expect(loja.ranking.single.nome, 'JOSE');
    expect(loja.estado, Estado.pronto);
  });
}
