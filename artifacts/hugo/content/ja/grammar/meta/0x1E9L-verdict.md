---
title: "VERDICT (0x1E9L)"
weight: 489
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "ドキュメント全体の判定結果を記す。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `VERDICT` (規格ドキュメント BIND `VERDICT`) |
| TAG ID | `0x1E9L` |
| Codec ID | `0x00001E90` |
| 規格ドキュメント | `0x00000000/codecs/0x00001E90/` (DECLARE 対象 `1E90`) |
| セクション | 15 `1111` (Meta)、セクション内オフセット C = 9 |
| Kind | Meta · クラス: 検証 |
| TAG WORD | `0001 1110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | ドキュメント全体の判定結果。Pass、Review、Fail。ノード・レコード単位は [TOULMIN](../toulmin/_index.md) `VERDICT`(Edge `0x118L`) |
| Hugo 側 | `meta/verification/verdict.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `verdict` | #2 | 生値 1 WORD |  | `0x0000` pass, `0x0001` review, `0x0002` fail |

ドキュメント全体の判定結果を記す。ノード・レコード単位の判定は [TOULMIN](../toulmin/_index.md) `VERDICT`(Edge `0x118L`)が担う。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1110 1001 LLLL      Codec 0x1E9L
[Length 拡張 TAG]
判定              1 WORD (0 Pass、1 Review、2 Fail)
```

- Codec: Meta `0x1E9L`、検証クラス
- Payload: 生値(判定 1 WORD)
- 個数: 多くても 1 つ

## 解釈と有効性 {#해석과-유효성}

- 検証クラスなのでコンテンツハッシュから除かれる。
- 他のドキュメントに対する判定は、判定の対象とは別のドキュメントの BODY に置く。

## 未解決の問題 {#열린-문제}

- 判定の主体と根拠を併せて記すか。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001E90/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E9000000000
BODY
#1 DECLARE 0x1E90
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "VERDICT"
#7 BIND #2 "verdict"
#8 BIND #3 "pass"
#9 BIND #4 "review"
#10 BIND #5 "fail"
```
