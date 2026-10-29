---
title: "Por Que MD/JSON/XML Nao Funcionam"
weight: 9
date: 2026-02-26T12:00:15+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["formato", "JSON", "XML"]
summary: "Markdown, JSON e XML foram criados para épocas e propósitos diferentes. Têm estrutura, mas não um significado unificado, nem lugar para fontes. Por que é preciso um formato à parte para registrar e acumular o raciocínio da IA."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## Formatos estruturados ja existem. Entao por que uma nova linguagem e necessaria?

---

## A Objecao Mais Comum

Quando alguem encontra pela primeira vez a ideia de uma linguagem de raciocinio para IA, a primeira coisa que diz e:

"Formatos estruturados ja existem, nao e?"

Eles estao certos. Existem. Muitos deles.

Existe Markdown.
Existe JSON.
Existe XML.
YAML, TOML, Protocol Buffers, MessagePack, CSV...

O mundo transborda de formatos de dados.
Entao por que a IA ainda pensa em linguagem natural?

Para responder essa pergunta, precisamos identificar exatamente o que cada formato faz bem
e o que ele nao pode fazer.

---

## Markdown: A Memoria Atual dos Agentes de IA

Em 2026, o formato mais amplamente usado por agentes de IA e o Markdown.

O Claude Code lembra em arquivos `.md`.
Agentes baseados em GPT tambem deixam notas em Markdown.
CLAUDE.md, memory.md, notes.md.
A memoria de longo prazo da IA se sustenta no Markdown neste exato momento.

Por que Markdown? A razao e simples.
LLMs leem e escrevem Markdown bem.
Markdown e abundante nos dados de treinamento,
e sua estrutura e simples o suficiente para geracao e parsing faceis.

Mas Markdown e **um formato de documento feito para humanos lerem.**

```markdown
# Status do Projeto
## Estrategia de Cache
- Bitmask SIMD adotada (decidido em 28/01)
- Aceleracao por GPU em analise
## Nao Resolvido
- Metodo de geracao de consulta a definir
```

Como uma maquina interpreta isso?

Ha um cabecalho de secao chamado "Estrategia de Cache".
Abaixo dele, ha um item "Bitmask SIMD adotada".
Ha uma data "(28/01)" entre parenteses.

Uma maquina nao consegue entender isso estruturalmente.
Ela pode dizer pelo `##` que "Estrategia de Cache" e um cabecalho de secao,
mas a relacao semantica de que e "um subtopico de arquitetura" nao existe no Markdown.
Um humano sabe que "28/01" e uma data, mas uma maquina tem que adivinhar.
28 de janeiro, ou um vinte e oito avos?

Em ultima analise, para "entender" Markdown, um LLM deve realizar interpretacao de linguagem natural.
Markdown e linguagem natural com indentacao por cima ---
nao sao dados estruturados.

---

## JSON: Estrutura Sem Significado

JSON vai um passo alem do Markdown.

```json
{
  "entity": "Yi Sun-sin",
  "birth": "1545",
  "death": "1598",
  "occupation": "naval_commander"
}
```

Ha estrutura. Pares chave-valor sao explicitos.
Uma maquina pode parsear. Campos sao acessiveis.

Mas ha um problema.

**JSON nao sabe o que a chave "entity" significa.**

A pessoa que criou esse JSON sabe que "entity" significa "um objeto".
No JSON de outra pessoa, o mesmo conceito pode ser "name", "subject" ou "item".

```json
{"name": "Yi Sun-sin"}
{"subject": "Yi Sun-sin"}
{"item": "Yi Sun-sin"}
{"entity": "Yi Sun-sin"}
```

Quatro JSONs expressam a mesma coisa,
mas uma maquina nao pode saber que sao iguais.

JSON carece de **semantica compartilhada.**
Ha estrutura, mas nao ha acordo sobre o que essa estrutura significa.

Cada projeto cria seu proprio schema.
Cada API usa seus proprios nomes de campo.
Conectar schema A ao schema B requer mais uma camada de transformacao.

Isso e a Torre de Babel.
A estrutura existe, mas ninguem entende a estrutura do outro.

---

## XML: O Imposto da Verbosidade

XML tentou resolver o problema do JSON.

Namespaces, definicoes de schema (XSD), definicoes de tipo de documento (DTD).
Ele fornece meta-estruturas que definem o significado das estruturas.

```xml
<entity xmlns="http://example.org/schema">
  <name>Yi Sun-sin</name>
  <birth>
    <year>1545</year>
    <calendar>lunar</calendar>
  </birth>
  <death>
    <year>1598</year>
    <cause>killed_in_action</cause>
  </death>
</entity>
```

O significado pode ser definido. A estrutura pode ser aplicada com schemas.
E mais rigoroso que JSON.

Mas XML tem um problema fatal.

**E verboso.**

No XML acima, a informacao real e "Yi Sun-sin, 1545, 1598, killed_in_action."
Todo o resto sao tags. Tags de abertura e fechamento superam a informacao.

Por que isso e um problema para IA?

A janela de contexto de um LLM e finita.
Se transmitir a mesma informacao requer 3x os tokens,
a quantidade de informacao que cabe no contexto encolhe para um terco.

XML e verboso para que humanos possam le-lo facilmente.
Uma linguagem de raciocinio de IA nao deve ter esse desperdicio.
Para um LLM, a tag `<name>` e desperdicio.

E o XML é um design do fim dos anos 1990.
Foi criado numa época em que os LLMs não existiam, para humanos e software tradicional.
Nunca foi projetado como linguagem de raciocínio para IA.

---

## A limitação compartilhada

Markdown, JSON, XML.
Cada um dos três formatos tem seus pontos fortes, mas eles compartilham limitações.

**São baseados em texto.**
Todos são serializados como strings.
Uma máquina precisa analisá-los para processá-los.
Análise é custo.

O GEUL é uma sequência de palavras de 16 bits.
A primeira palavra de cada registro informa seu tipo e comprimento,
então os limites dos registros são conhecidos de imediato, sem interpretar strings.

**Foram projetados antes da era dos LLMs.**
Markdown é de 2004. JSON, de 2001. XML, de 1998.
Foram projetados numa época em que o conceito de LLM não existia,
para humanos ou software tradicional.

Uma linguagem de raciocínio para IA deve ser projetada na era dos LLMs, para os LLMs.
Dimensionar a palavra de 16 bits ao vocabulário dos LLMs
pressupõe a existência dos LLMs.

**Seu sistema semântico unificado está ausente ou incompleto.**
Markdown não tem sistema semântico algum.
JSON tem estrutura, mas não significado.
XML pode definir esquemas, mas eles não são unificados.

O GEUL aponta para os alvos por ID, não por nome:
Reference como um QID do Wikidata ou um ID de documento emitido por um Issuer.
Onde quer que seja usado, o mesmo ID é o mesmo alvo. Sem necessidade de conversão.

---

## Resumo

| Formato | Estrutura | Significado | Amigável a LLM | Binário | Lugar para fontes | Qualificadores |
|--------|-----------|---------|---------------|--------|---------------|----------------|
| Markdown | Fraca | Nenhum | Alta | Não | Nenhum | Nenhum |
| JSON | Sim | Nenhum | Média | Não | Nenhum | Nenhum |
| XML | Sim | Parcial | Baixa | Não | Nenhum | Nenhum |
| **Linguagem de raciocínio ideal** | **Sim** | **Sim** | **Alta** | **Sim** | **Sim** | **Sim** |

Um novo formato e necessario nao porque os formatos existentes sao ruins.
E porque os formatos existentes foram feitos em uma era diferente, para um proposito diferente.

Markdown foi feito para documentos que humanos leem.
JSON foi feito para troca de dados em APIs web.
XML foi feito para serializacao de proposito geral de documentos e dados.

Um formato para registrar e acumular o raciocinio da IA. Isso ainda nao existe.

Quando o proposito e diferente, a ferramenta deve ser diferente.
