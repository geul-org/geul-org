---
title: "UNKNOWN-VALUE (0x001L)"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "UNKNOWN-VALUE は「不明」を表すプレースホルダだ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNKNOWN-VALUE は「不明」を表す[プレースホルダ](../slot-marker.md)だ。値は存在するが何なのかは分からない、という世界についての断言だ。

| 項目 | 値 |
|---|---|
| 名前 | `UNKNOWN-VALUE` (規格ドキュメント BIND `UNKNOWN-VALUE`) |
| TAG ID | `0x001L` |
| Codec ID | `0x00000010` |
| 規格ドキュメント | `0x00000000/codecs/0x00000010/` (DECLARE 対象 `0010`) |
| セクション | 0 `0000` (Reference エンティティ)、セクション内オフセット C = 1 |
| Kind | Reference · 分類: プレースホルダ |
| TAG WORD | `0000 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 不明。値は存在するが何なのか分からない(Wikidata `somevalue`) |
| Hugo 側 | `reference/slot-marker.md` |

## レイアウト {#레이아웃}

```
TAG WORD          0000 0000 0001 0000      WORD 0x0010, 1 WORD
```

- Payload はない。対象 ID も Quantifier もない([プレースホルダ](../slot-marker.md#레이아웃))。
- `0x001L` で Payload のある形(L ≥ 1)は Reserved だ。
- `geul show`・`geul add` のテキスト表記: `UNKNOWN`。

## 意味 {#뜻}

| 項目 | 不明 |
|---|---|
| 何についての言明か | **世界**: 値が存在する。何なのかは分からない |
| 論理 | `∃x. P(s, x)`、x は特定されていない |
| 世界の仮定 | 存在は閉じ、正体は開いている |
| Wikidata | `somevalue` |

## 受理 {#수용}

- CODEC 対象 `0010` を置いたフィールドだけが受け取る。そのフィールドは「不明」という断言を受け取る。例: [TRIPLE](../edge/0x0AAL-triple.md) Object、[QUALIFIER](../edge/0x0ABL-qualifier.md) Value、[SOURCE](../edge/0x0C0L-source.md) Origin。
- ワイルドカード、CODEC のないフィールド、HEAD・BODY のレコード位置、Edge Id 位置、生値フィールドでは使えない([プレースホルダ](../slot-marker.md#수용-규칙)共通規則)。

## 読む側の義務 {#읽는-쪽의-의무}

- **UNKNOWN-VALUE は値ではなく存在の断言だ。** 他のどんな値とも等しくなく、異なりもしない(比較結果は未定)。UNKNOWN-VALUE 同士も同じ値とは見なさない。出現ごとに独立した存在量化だ(Wikidata の空白ノードと同じ)。
- したがってバイトが同じ TRIPLE 2 つ(`P40 Q… UNKNOWN` ×2)は重複ではない。子が 2 人かもしれず、1 人かもしれない。UNKNOWN-VALUE を含む TRIPLE は重複統合しない。
- 後で正体が判明したら、その TRIPLE を直した新しい版を出す。UNKNOWN-VALUE は指せない。共参照が必要なら LOCAL Variable を使う([Reference](_index.md#quantifier) Variable)。
- **rank は同じように適用される。** 代表値(truthy)を選ぶとき、UNKNOWN-VALUE TRIPLE も候補に入る。
- **QUALIFIER の値として使うと、その限定の意味が変わる。** `P582 = UNKNOWN` なら、終了していて時点が分からない。今も有効な命題としては読まない。
- UNKNOWN-VALUE は「ある」という断言なので、原典がそう述べるときにだけ使う。移せなかった値を UNKNOWN-VALUE として書かない。

## 例 {#예시}

`0x0010` 1 WORD。例: Q30–Q34266 の国境の終了時点(P582)が分からない: `0AB7 0051 0C58 0191 0246 0051 080C 0010`(QUALIFIER、Value 位置が `0010`)。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE(対象 `0010`)を 1 つだけ置く。Payload がないので FIELD はない。デコーダはマーカーの意味と受理規則を内蔵する([層 0](../publishing.md#층))。マーカーを読むのに Codec ドキュメントは参照しない。

## 関連ページ {#관련-페이지}

- [プレースホルダ](../slot-marker.md)、[ABSENT](0x000L-absent.md)、[NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md)、[Codec 規格ドキュメント](../codec-spec.md)、[TRIPLE](../edge/0x0AAL-triple.md)、[QUALIFIER](../edge/0x0ABL-qualifier.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000010/latest.geul` を `geul show` で読んだ様子だ(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000001000000000
BODY
#1 DECLARE 0x0010
#2 BIND #1 "UNKNOWN-VALUE"
```
