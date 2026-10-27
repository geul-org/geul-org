---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE は、primary language subtag だけを 1 WORD に圧縮して収める GEUL 言語コードの Value だ(Codec 0x48)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE は、BCP 47 の完全な tag ではなく、primary language subtag だけを収める GEUL の圧縮言語コードだ。Payload はちょうど 1 WORD だ。

## レイアウト

- コード: Value 直接コード `0x48`。系列 TEXT。
- Payload は、ちょうど 1 WORD の unsigned 16ビットコードだ。

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  全体 2 WORD
Payload WORD 1st (16ビット)           GEUL language code (uint16)
```

## 解釈と有効性

- Payload 1 WORD を unsigned 16ビット整数として読む。
- この値は、primary language subtag の圧縮コードだ。script、region、variant、extension、private-use は収めない。そのような情報が必要なら、[LANGUAGE-BCP47-CODE](/ja/grammar/value/text/language-bcp47-code/)(`0x46`・`0x47`)を使う。
- `0x0000..0xfffe` は、GEUL Language Registry の割り当て範囲だ。この範囲内でも、該当する registry version に実際に割り当てられていない値は invalid だ。
- 初期の割り当て対象は、特定の IANA Language Subtag Registry snapshot の `Type: language` のうち、`Scope: private-use` を除いた公開レコードだ。collections、macrolanguage、special は除かない。
- 初期の割り当ては、その公開レコードを ASCII の subtag 順に並べて ID を付ける。IANA ファイルの物理的な順序は ID の規則ではない。
- 以後の新しい `Type: language` subtag は、既存の番号を変えずに末尾に足す(append-only)。
- deprecated な language subtag の ID は、消したり再利用したりしない。Preferred-Value の関係と deprecated 状態は、registry metadata で保存する。
- `0xffff` は拡張 escape として予約する。拡張形式が別に定義されるまで、独立した LANGUAGE-SHORT-CODE Value では invalid だ。`null`、`unknown`、`und` のような意味で使わない。
- 将来 Lemma Edge のような別の schema が `0xffff` の後ろの解釈規則を定義することはありうる。しかしその規則が、この形式の Payload 長を延ばしたり、後続の Payload を許したりするという意味ではない。
- 一部の Lemma Edge schema は、同じ 1 WORD コードを TAG なしの compact field として inline できる。これは Edge schema の規則であり、独立した Value の wire form は、常に TAG 1 WORD + Payload 1 WORD だ。
- 値の意味を判定するには、使用した GEUL Language Registry version と、その version が固定した IANA registry snapshot の日付を併せて保存しなければならない。

## 標準の根拠

- primary language subtag の原典 registry と deprecated/Preferred-Value metadata は、[IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) に従う。
- BCP 47 language subtag 体系の基本的な意味は、[RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646) に従う。
- ASCII 順の append-only ID 付与、`0xffff` の予約、TAG なしの Lemma compact embedding との区別は、GEUL の規則だ。

## 長さ

- 全体は、TAG 1 WORD と Payload 1 WORD を合わせたちょうど 2 WORD で、直接長さ `LLLL=0001` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 1 WORD でなければ拒否する。

## 例

- registry snapshot と実際のコード表がまだ決まっていないので、特定の言語の数値 ID の例は載せない。

## 未解決の問題

- 初期 IANA snapshot の日付、GEUL Language Registry version の名前、全体のマッピング表。決まるまで、具体的な数値の例やコード表は確定しない。
