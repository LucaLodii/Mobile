# Atividade Prática 3 – Diário de Hábitos

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
- RNF03 Os hábitos continuam salvos depois de fechar e reabrir o app. *(próxima entrega; hoje ficam só na memória)*

## Mapeamento (caminhos a partir de `lib/`)

| RF | Interface | Domínio | Dados |
|---|---|---|---|
| RF01 | `ui/tela_novo_habito.dart`, `salvar()` | `dominio/habitos_store.dart`, `adicionar()` | `dados/habitos_repositorio.dart`, `salvar()` |
| RF02 | `ui/tela_habitos.dart`, a lista | `dominio/habitos_store.dart`, `carregar()` | `dados/habitos_repositorio.dart`, `carregar()` |
| RF03 | `ui/tela_detalhe_habito.dart`, botão Excluir | `dominio/habitos_store.dart`, `remover()` | `dados/habitos_repositorio.dart`, `remover()` |
| RF04 | `ui/tela_detalhe_habito.dart`, botão Feito hoje | `dominio/habitos_store.dart`, `marcarFeito()` | `dados/habitos_repositorio.dart`, `salvar()` |
| RF05 | `ui/tela_detalhe_habito.dart`, card dias seguidos | `dominio/habitos_store.dart`, `diasSeguidos()` | `dados/habitos_repositorio.dart`, `carregar()` |

## Uso de IA

Usei IA (Claude) para recriar o código do projeto e rascunhar este documento. Conferi o mapeamento com os arquivos do projeto.
