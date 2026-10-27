---
title: "BIND"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND é o Edge descritivo que liga ao Subject um nome que a máquina compara (UTF8-TEXT sem idioma) (Codec 0x03)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIND é o Edge descritivo que liga ao Subject um nome que a máquina compara. Codec `0x03`.

É uma nomeação. O nome legível por pessoas (título por idioma) fica com [LABEL](/pt/grammar/edge/label/). O nome de um símbolo de programa e o nome usado no endereço de um documento escrevem-se com o mesmo registro.

## Layout

```
TAG WORD          0001 0LLL L000 0011
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference, ou 1 WORD de TAG WORD de codec
Nome              1 Value UTF8-TEXT-*
```

## Interpretação e validade

- O Subject é exatamente um registro [Reference](/pt/grammar/reference/) completo. Se for LOCAL, é um alvo deste documento (símbolo etc.); se for Reference de indicação, é um alvo de outro documento. O próprio documento é [DOC-POINTER](/pt/grammar/reference/doc-pointer/) e o próprio Issuer é [ISSUER-POINTER](/pt/grammar/reference/issuer-pointer/).
- Ou então o Subject é uma TAG WORD de codec (só Kind e Codec, `LLLL = 0`, sem Payload). Isso não é um registro com Payload vazio, e sim o próprio código direto, isto é, o seu documento de especificação (documento do Issuer GEUL `0x000000000000<TAG>`) ([Documento de especificação de Codec](/pt/grammar/codec-spec/), [DECLARE](/pt/grammar/edge/declare/)). Exemplo: `1018` é PUBLICATION. No índice de nomes usa-se o Subject DOC-POINTER. Codecs de formato Issuer não se usam.
- Outros registros (Value etc.) não podem ser Subject. O FIELD do documento de especificação de BIND declara o Subject apenas com largura `0` (registro), por isso esta restrição é uma regra do corpo de BIND.
- O nome é exatamente um Value [UTF8-TEXT](/pt/grammar/value/text/utf8-text/). Não tem idioma e não é normalizado. Só é o mesmo nome se os bytes forem iguais.
- O âmbito do nome é o documento que contém o BIND. Em um documento, o mesmo nome não se liga a Subjects diferentes.
- Pode-se ligar vários nomes a um Subject (alias, nome antigo). Se o documento não determinar outra coisa, o último BIND é o nome representativo.
- Os outros registros apontam o alvo por LOCAL ID, não por nome. O nome serve para casar com o exterior (funções do host, entrada de endereços, pessoas).
- Os caracteres permitidos no nome dependem do uso. O nome usado em endereço de documento segue a regra de nome de documento (slug ASCII em minúsculas) ([Endereço de publicação e lista de versões](/pt/grammar/publishing/#nome-do-documento)).

## Comprimento

```
total = 1 + N_len + N_id + N_subject + N_name WORD
```

## Exemplo (não normativo)

Símbolo de programa: Edge Id `0003`, Subject LOCAL 7, nome `main`.

- O nome `main` tem 4 bytes (par), então são 3 WORDs: `0940 6d61 696e`.
- O Edge tem TAG 1 + Edge Id 2 + Subject 2 + nome 3 = 8 WORDs, TAG `1383`.

```
1383 0088 0003 0088 0007 0940 6d61 696e
```

Nome de documento (dentro do documento da lista de versões `0x0000/0xffff000000000002/versions.geul` desse documento): Edge Id `0005`, Subject `DOC-POINTER` (Issuer `0x0000`, documento `0xffff000000000002`, versão `0` = o próprio documento), nome `this-is-sample-doc`.

- O Subject é TAG `03B8` + Issuer 1 + ID do documento 4 + ID da versão 2 = 8 WORDs.
- O nome tem 18 bytes (par), então TAG `0CC0` + 9 WORDs = 10 WORDs.
- O Edge tem TAG 1 + extensão de Length 1 + Edge Id 2 + Subject 8 + nome 10 = 22 WORDs, então `LLLL=1110`, TAG `1703`, extensão `0016`.

```
1703 0016 0088 0005 03B8 0000 ffff 0000 0000 0002 0000 0000 0CC0 7468 6973 2d69 732d 7361 6d70 6c65 2d64 6f63
```

## Páginas relacionadas

- [Edge](/pt/grammar/edge/), [LABEL](/pt/grammar/edge/label/), [PUBLICATION](/pt/grammar/edge/publication/) (nome de documento do documento da lista de versões)
- [LOCAL](/pt/grammar/reference/local/), [DOC-POINTER](/pt/grammar/reference/doc-pointer/), [ISSUER-POINTER](/pt/grammar/reference/issuer-pointer/)
