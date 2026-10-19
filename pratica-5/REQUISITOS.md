# Atividade Prática 5 – Nomes do Brasil

Luca Lodi

App que consome a API de Nomes do IBGE (Censo 2010), pública e sem chave: `https://servicodados.ibge.gov.br/api/v2/censos/nomes`.

## Requisitos

**Funcionais**
- RF01 O usuário vê o ranking dos 20 nomes mais comuns do Brasil.
- RF02 O usuário filtra o ranking por Todos, Mulheres ou Homens.
- RF03 O usuário busca qualquer nome.
- RF04 O usuário vê quantas pessoas têm o nome e quantas nasceram em cada década.

**Não funcionais**
- RNF01 Sem internet, o app mostra uma mensagem e um botão "Tentar de novo" em vez de travar (teste em modo avião).
- RNF02 Nomes com acento (ex.: "José") funcionam na busca.

## Mapeamento (caminhos a partir de `lib/`)

| RF | Interface | Domínio | Dados |
|---|---|---|---|
| RF01 | `ui/tela_nomes.dart`, a lista | `dominio/nomes_store.dart`, `carregar()` | `dados/ibge_api.dart`, `ranking()` |
| RF02 | `ui/tela_nomes.dart`, chips de filtro | `dominio/nomes_store.dart`, `trocarSexo()` | `dados/ibge_api.dart`, `ranking(sexo:)` |
| RF03 | `ui/tela_nomes.dart`, campo de busca | – | – |
| RF04 | `ui/tela_detalhe_nome.dart`, total e barras | `dominio/nomes_store.dart`, `historico()` | `dados/ibge_api.dart`, `historico()` |

## Endpoints usados

| Endpoint | Resposta usada |
|---|---|
| `GET /ranking?sexo=F` (ou `M`, ou sem `sexo`) | `res[]` com `nome`, `frequencia`, `ranking` → `dominio/nome.dart` |
| `GET /{nome}` | `res[]` com `periodo` e `frequencia` → `dominio/decada.dart`; lista vazia quando o nome não existe |

## Uso de IA

Usei IA (Claude) para escolher a API, planejar as telas, escrever o código seguindo a estrutura `dados` / `dominio` / `ui` das práticas anteriores e rascunhar este documento. Revisei o código e o documento.
