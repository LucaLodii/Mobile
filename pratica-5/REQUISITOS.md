# Atividade Prática 5 – Nomes do Brasil

Luca Lodi

Um aplicativo de uma tela só que consome a API de Nomes do IBGE (Censo 2010): `https://servicodados.ibge.gov.br/api/v2/censos/nomes`.

## Justificativa da API

Escolhi a API de Nomes do IBGE porque devolve o ranking com `nome`, `frequencia` e `ranking` (com filtro `sexo` na própria URL) e, para qualquer nome, a frequência por década em `periodo` e `frequencia`, o que me deixou filtrar a lista e desenhar um gráfico por década na mesma tela. Não pede chave.

## Requisitos

**Funcionais**
- RF01 O usuário vê o ranking dos 20 nomes mais comuns do Brasil.
- RF02 O usuário filtra o ranking por Todos, Mulheres ou Homens.
- RF03 O usuário busca qualquer nome, ou toca num nome do ranking.
- RF04 O usuário vê quantas pessoas têm o nome e um gráfico de nascidos por década, com a década de pico destacada.

**Não funcionais**
- RNF01 Uma tela só, sem navegação: o nome buscado aparece num painel acima do ranking, e o ranking nunca sai da tela.
- RNF02 Sem internet, ou se a resposta passar de 10 segundos, aparece o erro e o botão "Tentar de novo" (teste em modo avião).
- RNF03 Só a resposta do pedido mais recente aparece: trocar o filtro rápido não mostra a lista do filtro anterior.
- RNF04 Nomes com acento (ex.: "José") funcionam na busca.

## Os quatro estados

O ranking (`estado`) e o painel do nome (`estadoBusca`) têm cada um o seu `Estado`, e cada um passa pelos quatro casos.

| Estado | Ranking | Painel do nome |
|---|---|---|
| Carregando | Indicador ao abrir e ao trocar o filtro | Indicador ao buscar |
| Conteúdo | A lista dos 20 nomes | Total de pessoas e gráfico por década |
| Vazio | "O IBGE não devolveu nenhum nome." | "Nome não encontrado no Censo." (ex.: buscar "xyzqwk") |
| Erro | Mensagem e "Tentar de novo", que chama o mesmo `carregar()` | Mensagem e "Tentar de novo", que chama o mesmo `buscar()` |

O erro cobre sem internet, timeout, status diferente de 200 e JSON em formato inesperado.

## Mapeamento (caminhos a partir de `lib/`)

| RF | Interface | Domínio | Dados |
|---|---|---|---|
| RF01 | `ui/tela_nomes.dart`, a lista | `dominio/nomes_store.dart`, `carregar()` | `dados/ibge_api.dart`, `ranking()` |
| RF02 | `ui/tela_nomes.dart`, chips de filtro | `dominio/nomes_store.dart`, `trocarSexo()` | `dados/ibge_api.dart`, `ranking(sexo:)` |
| RF03 | `ui/tela_nomes.dart`, campo de busca e toque na lista | `dominio/nomes_store.dart`, `buscar()` / `fecharBusca()` | `dados/ibge_api.dart`, `historico()` |
| RF04 | `ui/painel_nome.dart`, total e gráfico | `dominio/nomes_store.dart`, `decadas` | `dados/ibge_api.dart`, `historico()` |
| Estados | `ui/estados.dart`, `TelaDeErro` e `TelaVazia` | `dominio/nomes_store.dart`, `enum Estado` | – |

A tradução do JSON fica só nos modelos, `dominio/nome.dart` e `dominio/decada.dart` (`fromMap`), com todo campo lido como `as Tipo? ?? padrão`.

## Uso de IA

Usei IA (Claude) para escolher a API, planejar a tela, escrever o código seguindo a estrutura `dados` / `dominio` / `ui` das práticas anteriores e rascunhar este documento. Revisei o código e o documento.
