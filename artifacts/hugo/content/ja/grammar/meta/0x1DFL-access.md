---
title: "ACCESS (0x1DFL)"
weight: 479
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "ドキュメントの公開範囲を記す。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `ACCESS` (規格ドキュメント BIND `ACCESS`) |
| TAG ID | `0x1DFL` |
| Codec ID | `0x00001DF0` |
| 規格ドキュメント | `0x00000000/codecs/0x00001DF0/` (DECLARE 対象 `1DF0`) |
| セクション | 14 `1110` (Meta)、セクション内オフセット C = 31 |
| Kind | Meta · クラス: ポリシー |
| TAG WORD | `0001 1101 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | 公開範囲 |
| Hugo 側 | `meta/policy/access.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload フィールドの順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | 生値 1 WORD |  | `0x0000` public, `0x0001` internal, `0x0002` confidential |

ドキュメントの公開範囲を記す。

## レイアウト {#레이아웃}

```
TAG WORD          0001 1101 1111 LLLL      Codec 0x1DFL
[Length 拡張 TAG]
等級              1 WORD (0 公開、1 社内、2 社外秘、それ以外 Reserved)
```

- Codec: Meta `0x1DFL`、ポリシークラス
- Payload: 生値(等級 1 WORD)
- 個数: 多くても 1 つ

## 解釈と有効性 {#해석과-유효성}

- 社外秘のドキュメントは公表しない([Issuer](../issuer.md))。
- 解釈を変えない。取り扱いだけを定める。

## 未解決の問題 {#열린-문제}

- 等級コード表。

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00001DF0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DF000000000
BODY
#1 DECLARE 0x1DF0
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "ACCESS"
#7 BIND #2 "level"
#8 BIND #3 "public"
#9 BIND #4 "internal"
#10 BIND #5 "confidential"
```
