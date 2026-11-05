---
title: "ABSENT (0x000L)"
weight: 0
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "ABSENT は「記載なし」を表すプレースホルダだ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ABSENT は「記載なし」を表す[プレースホルダ](../slot-marker.md)だ。この位置を埋めなかったという、ドキュメントについての言明であり、世界については何も断言しない。

| 項目 | 値 |
|---|---|
| 名前 | `ABSENT` (規格ドキュメント BIND `ABSENT`) |
| TAG ID | `0x000L` |
| Codec ID | `0x00000000` |
| 規格ドキュメント | `0x00000000/codecs/0x00000000/` (DECLARE 対象 `0000`) |
| セクション | 0 `0000` (Reference エンティティ)、セクション内オフセット C = 0 |
| Kind | Reference · 分類: プレースホルダ |
| TAG WORD | `0000 0000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 記載なし。選択フィールドを省略した。世界については何も断言しない |
| Hugo 側 | `reference/slot-marker.md` |

## レイアウト {#레이아웃}

```
TAG WORD          0000 0000 0000 0000      WORD 0x0000, 1 WORD
```

- Payload はない。対象 ID も Quantifier もない([プレースホルダ](../slot-marker.md#레이아웃))。
- `0x000L` で Payload のある形(L ≥ 1)は Reserved だ。
- `geul show`・`geul add` のテキスト表記: `ABSENT`。

## 意味 {#뜻}

| 項目 | 記載なし |
|---|---|
| 何についての言明か | **ドキュメント**: この位置を埋めなかった |
| 論理 | 何も断言しない |
| 世界の仮定 | 開世界(情報なし) |
| Wikidata | 該当する snak がない |

## 受理 {#수용}

- CODEC 対象 `0000` を置いたフィールドだけが受け取る。そのフィールドは**選択フィールド**だ。選択フィールドを省略するときは、その位置に WORD `0x0000` を 1 つ書く。選択フィールドも位置は常に占める([Codec 規格ドキュメント](../codec-spec.md#선택-필드와-자리-표지))。例: [SOURCE](../edge/0x0C0L-source.md) Origin、[QUANTITY](../value/0x066L-quantity.md) の単位・下限・上限。
- ワイルドカード、CODEC のないフィールド、HEAD・BODY のレコード位置、Edge Id 位置、生値フィールドでは使えない([プレースホルダ](../slot-marker.md#수용-규칙)共通規則)。

## 読む側の義務 {#읽는-쪽의-의무}

- **ABSENT は世界について何も言わない。** UNKNOWN-VALUE や NO-VALUE として読まない。
- 変換器が移せなかった値(原典には存在する値)を UNKNOWN-VALUE として書くことは禁止する。原典では値が分かっているからだ。原典が語らなかった位置(例: 原典を記述していない出典の [SOURCE](../edge/0x0C0L-source.md) Origin)も、変換器は ABSENT で書く。
- 判定グラフでは、ABSENT と叙述なしは、すべての比較演算子で未定(U)になる。ABSENT を empty として読むには、入力側が閉世界を宣言しなければならない([TOULMIN](../toulmin/_index.md#미상-위에서-판정하기))。

## 例 {#예시}

`0x0000` 1 WORD。例: 単位を記載していない QUANTITY の単位位置。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE(対象 `0000`)を 1 つだけ置く。Payload がないので FIELD はない。デコーダはマーカーの意味と受理規則を内蔵する([層 0](../publishing.md#층))。マーカーを読むのに Codec ドキュメントは参照しない。

## 関連ページ {#관련-페이지}

- [プレースホルダ](../slot-marker.md)、[UNKNOWN-VALUE](0x001L-unknown-value.md)、[NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md)、[Codec 規格ドキュメント](../codec-spec.md)、[TRIPLE](../edge/0x0AAL-triple.md)、[QUALIFIER](../edge/0x0ABL-qualifier.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000000/latest.geul` を `geul show` で読んだ様子だ(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000000000000000
BODY
#1 DECLARE 0x0000
#2 BIND #1 "ABSENT"
```
