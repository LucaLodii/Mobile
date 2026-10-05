# Atividade Prática 4 – Diário de Hábitos

Luca Lodi

## Requisitos

**Funcionais**
- RF01 O usuário cadastra um hábito com nome e meta.
- RF02 O usuário vê a lista dos seus hábitos.
- RF03 O usuário exclui um hábito.
- RF04 O usuário marca um hábito como feito no dia. *(a fazer)*
- RF05 O usuário vê quantos dias seguidos cumpriu um hábito. *(a fazer)*

**Não funcionais**
- RNF01 A lista abre em menos de 2 segundos com 300 hábitos.
- RNF02 Todas as funções funcionam sem internet (teste em modo avião).
- RNF03 Os hábitos continuam salvos depois de fechar e reabrir o app.

## Mapeamento (caminhos a partir de `lib/`)

| RF | Interface | Domínio | Dados |
|---|---|---|---|
| RF01 | `ui/tela_novo_habito.dart`, `salvar()` | `dominio/habitos_store.dart`, `adicionar()` | `dados/habitos_repositorio.dart`, `salvar()` |
| RF02 | `ui/tela_habitos.dart`, a lista | `dominio/habitos_store.dart`, `carregar()` | `dados/habitos_repositorio.dart`, `carregar()` |
| RF03 | `ui/tela_detalhe_habito.dart`, botão Excluir | `dominio/habitos_store.dart`, `remover()` | `dados/habitos_repositorio.dart`, `remover()` |
| RF04 | `ui/tela_detalhe_habito.dart`, botão Feito hoje | `dominio/habitos_store.dart`, `marcarFeito()` | `dados/habitos_repositorio.dart`, `salvar()` |
| RF05 | `ui/tela_detalhe_habito.dart`, card dias seguidos | `dominio/habitos_store.dart`, `diasSeguidos()` | `dados/habitos_repositorio.dart`, `carregar()` |
| Config. | `ui/tela_principal.dart`, aba inicial | – | `dados/preferencias.dart`, `lerUltimaAba()` / `salvarUltimaAba()` |

## Persistência local

**Parte A.** A lista de hábitos está em SQLite (`sqflite`), tabela `habitos` com `id`, `nome`, `meta` e `icone`. Só o corpo de `dados/habitos_repositorio.dart` mudou; as assinaturas `carregar()`, `salvar()` e `remover()` são as mesmas, e `habitos_store.dart` não foi alterado. O modelo `dominio/habito.dart` ganhou `id` e a tradução `toMap()` / `fromMap()`.

**Parte B.** A última aba aberta está em `shared_preferences`, chave `ultima_aba`, em `dados/preferencias.dart`. `ui/tela_principal.dart` lê o valor ao iniciar e grava ao trocar de aba.

**Parte C: qual dado foi para onde e por quê**

1. A lista de hábitos foi para tabela porque cada hábito é um registro com a mesma forma (nome, meta, ícone), a exclusão precisa identificar um entre muitos (por isso o `id` gerado pelo banco), e o RNF01 exige a lista aberta em menos de 2 segundos com 300 hábitos, o que pede ler só o necessário em vez de tudo de uma vez.
2. A última aba foi para chave e valor porque é um único inteiro de configuração, lido uma vez na abertura, sem busca, sem ordenação e sem relação com nenhum hábito.
3. O que separa os dois casos: se a chave da aba for apagada, o app abre na primeira aba e nenhum dado do usuário se perde; se a tabela for apagada, todos os hábitos somem. Configuração é o que pode ser perdido sem perder o produto.

## Uso de IA

Usei IA (Claude) para planejar a troca do repositório para SQLite, escrever o código de persistência seguindo o roteiro da aula e rascunhar este documento. Revisei o código e a justificativa.
