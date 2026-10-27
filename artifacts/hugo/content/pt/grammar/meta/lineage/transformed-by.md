---
title: "TRANSFORMED-BY"
weight: 52
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TRANSFORMED-BY é o Meta de linhagem que registra a ferramenta que converteu outra representação neste documento e a versão do seu código-fonte (digest do commit)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra o método que converteu outra representação neste documento (por exemplo, um conversor do Wikidata, um codificador de linguagem natural). Tool é com o que se converteu, e Version é com qual código-fonte dessa ferramenta se converteu. É preciso ter os dois para poder refazer o mesmo documento a partir da mesma entrada.

## Layout

```
TAG WORD          0001 1LLL L011 0011      Codec 0x33
[TAG estendida de Length]
Tool              1 registro Reference (ferramenta ou regra de transformação)
Version           1 registro Value (SHA-256-DIGEST ou SHA1-DIGEST)
```

- Codec: Meta `0x33`, classe de linhagem (`011`)
- Payload: Reference embutida (ferramenta) + Value embutido (digest da versão do código-fonte)
- Quantidade: pode haver vários (um por ferramenta)

## Interpretação e validade

- Tool é exatamente um registro Reference completo. Pode ser qualquer Reference que aponte para a ferramenta.
  - Ferramenta do documento de ferramentas do geul.org: [EXTERNAL-ISSUER](/pt/grammar/reference/external-issuer/) (`0x0000`, ID de documento `0x0001xxxx xxxxxxxx`, e o seu LOCAL). Um documento por ferramenta ([Issuer](/pt/grammar/issuer/) documento de definição de termos).
  - Se o codec for um documento GEUL, aponta-se esse documento por [DOC-POINTER](/pt/grammar/reference/doc-pointer/).
- Version é exatamente um registro Value completo e é o ID do objeto de controle de versão do código-fonte de Tool. No git, é o ID completo do objeto commit.
  - Se o formato de objetos do repositório git for SHA-256, é [SHA-256-DIGEST](/pt/grammar/value/binary/sha-256-digest/) (`0x61`, 16 WORD); se for SHA-1, é [SHA1-DIGEST](/pt/grammar/value/binary/sha1-digest/) (`0x62`, 10 WORD). O formato do repositório se confirma com `git rev-parse --show-object-format`.
  - Não se usam IDs abreviados (`2bd496f` etc.). O Value de digest não permite valores truncados.
  - Não se escreve como texto hex (UTF8-TEXT). O mesmo valor ocupa 22 WORD em SHA-1 (11 em binário) e 34 WORD em SHA-256 (18 em binário).
- Version é obrigatório. Um registro de ferramenta cuja versão do código-fonte se desconhece não serve de base para reproduzir. Se a ferramenta estiver fora de controle de versão, usa-se o SHA-256 do artefato distribuído (SHA-256-DIGEST).
- Version aponta para o código-fonte commitado. Para um documento feito com uma árvore de trabalho com mudanças não commitadas, não se usa o ID de commit (recomenda-se que a ferramenta se recuse a executar).
- Se a ferramenta depende de código fora do repositório (por exemplo, uma biblioteca local apontada por `replace` do Go), esse código também se registra à parte com TRANSFORMED-BY. O ID de commit da ferramenta, sozinho, não determina esse código.
- Uma ferramenta que apenas transcreve a origem sem perdas (por exemplo, uma ferramenta que carrega um dump no banco de dados tal como o texto original) não determina o conteúdo do documento e, por isso, não se registra. Uma carga com perdas muda o documento e, por isso, se registra como ferramenta.
- O documento de especificação do geul.org (`0x1833`) escreve com dois campos de registro: Tool (largura 0, qualquer Reference, portanto sem CODEC) e Version (largura 0, [CODEC](/pt/grammar/edge/codec/) `0861`, `0862`).

## Comprimento

```
total = 1 + N_len + N_tool + N_version WORD
```

- O cursor depois de ler o último registro deve coincidir exatamente com o fim do Meta.
- Se Tool for EXTERNAL-ISSUER-1WORD (7 WORD) e Version for SHA1-DIGEST (11 WORD), são 1 + 1 + 7 + 11 = 20 WORD no total, e usa-se o comprimento estendido. Com SHA-256-DIGEST (18 WORD), são 27 WORD.

## Exemplo

Exemplo não normativo. A ferramenta é o LOCAL 2 (`0360 0000 0001 0000 0000 0001 0002`) do documento de ferramentas `0x0001000000000001` do geul.org, e o código-fonte é o commit `ddc0719974a32aaa7b422ee84221a9721085ce4c` (SHA-1).

```
1F33 0014
0360 0000 0001 0000 0000 0001 0002
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## Questões em aberto

- Se a versão de [GENERATED-BY](/pt/grammar/meta/lineage/generated-by/) deve ser tratada do mesmo modo (digest obrigatório ou outro formato). A versão de um modelo não é um ID de commit.

## Páginas relacionadas

- [Meta](/pt/grammar/meta/), [GENERATED-BY](/pt/grammar/meta/lineage/generated-by/), [DERIVED-FROM](/pt/grammar/meta/lineage/derived-from/)
- [EXTERNAL-ISSUER](/pt/grammar/reference/external-issuer/), [DOC-POINTER](/pt/grammar/reference/doc-pointer/), [SHA-256-DIGEST](/pt/grammar/value/binary/sha-256-digest/), [SHA1-DIGEST](/pt/grammar/value/binary/sha1-digest/), [CODEC](/pt/grammar/edge/codec/)
