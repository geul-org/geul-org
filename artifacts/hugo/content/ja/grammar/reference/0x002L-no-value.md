---
title: "NO-VALUE (0x002L)"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "NO-VALUE は「なし」を表すプレースホルダだ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NO-VALUE は「なし」を表す[プレースホルダ](../slot-marker.md)だ。値が存在しないという世界についての断言だ。

| 項目 | 値 |
|---|---|
| 名前 | `NO-VALUE` (規格ドキュメント BIND `NO-VALUE`) |
| TAG ID | `0x002L` |
| Codec ID | `0x00000020` |
| 規格ドキュメント | `0x00000000/codecs/0x00000020/` (DECLARE 対象 `0020`) |
| セクション | 0 `0000` (Reference エンティティ)、セクション内オフセット C = 2 |
| Kind | Reference · 分類: プレースホルダ |
| TAG WORD | `0000 0000 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | なし。値が存在しない(Wikidata `novalue`) |
| Hugo 側 | `reference/slot-marker.md` |

## レイアウト {#레이아웃}

```
TAG WORD          0000 0000 0010 0000      WORD 0x0020, 1 WORD
```

- Payload はない。対象 ID も Quantifier もない([プレースホルダ](../slot-marker.md#레이아웃))。
- `0x002L` で Payload のある形(L ≥ 1)は Reserved だ。
- `geul show`・`geul add` のテキスト表記: `NONE`。

## 意味 {#뜻}

| 項目 | なし |
|---|---|
| 何についての言明か | **世界**: 値が存在しない |
| 論理 | `¬∃x. P(s, x)` |
| 世界の仮定 | (s, P, 限定条件)について閉世界 |
| Wikidata | `novalue` |

## 受理 {#수용}

- CODEC 対象 `0020` を置いたフィールドだけが受け取る。そのフィールドは「なし」という断言を受け取る。例: [TRIPLE](../edge/0x0AAL-triple.md) Object、[QUALIFIER](../edge/0x0ABL-qualifier.md) Value。
- ワイルドカード、CODEC のないフィールド、HEAD・BODY のレコード位置、Edge Id 位置、生値フィールドでは使えない([プレースホルダ](../slot-marker.md#수용-규칙)共通規則)。

## 読む側の義務 {#읽는-쪽의-의무}

- **NO-VALUE はその命題の限定条件の中で閉じる。** QUALIFIER が付けば、その範囲でだけ閉じる。Q30 P1304 NO-VALUE(P580 1811, P582 1816)は、1811~1816 年にだけ中央銀行がなかったという意味で、同じプロパティの値 TRIPLE(連邦準備制度, preferred)と矛盾しない。
- 同じ Subject・Predicate に NO-VALUE と値 TRIPLE が同じ rank で、限定条件が区別されないまま共存していれば矛盾だ。検査器は警告を出す。拒否はしない。Wikidata にもある状態で、読む側が rank で選ぶ。
- **rank は同じように適用される。** 代表値(truthy)を選ぶとき、NO-VALUE TRIPLE も候補に入る。
- **QUALIFIER の値として使うと、その限定の意味が変わる。** `P582 = NONE` なら、終了していないと断言する。P582 QUALIFIER がそもそもなければ、終了したかどうか分からない。
- 「ない」は NO-VALUE で**書いて**はじめて言える。TRIPLE がドキュメントにないのは記載なしだ(開世界)。

## 例 {#예시}

`0x0020` 1 WORD。例: 子(P40)なしは `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000` だ(TRIPLE、Object 位置が `0020`)。

## Codec ドキュメント {#코덱-문서}

Codec ドキュメントは DECLARE(対象 `0020`)を 1 つだけ置く。Payload がないので FIELD はない。デコーダはマーカーの意味と受理規則を内蔵する([層 0](../publishing.md#층))。マーカーを読むのに Codec ドキュメントは参照しない。

## 関連ページ {#관련-페이지}

- [プレースホルダ](../slot-marker.md)、[ABSENT](0x000L-absent.md)、[UNKNOWN-VALUE](0x001L-unknown-value.md)
- [CODEC](../edge/0x0BEL-codec.md)、[Codec 規格ドキュメント](../codec-spec.md)、[TRIPLE](../edge/0x0AAL-triple.md)、[QUALIFIER](../edge/0x0ABL-qualifier.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000020/latest.geul` を `geul show` で読んだ様子だ(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000002000000000
BODY
#1 DECLARE 0x0020
#2 BIND #1 "NO-VALUE"
```
