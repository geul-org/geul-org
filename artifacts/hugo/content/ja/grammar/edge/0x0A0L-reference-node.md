---
title: "REFERENCE-NODE (0x0A0L)"
weight: 160
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE は Reference 一つを Object レコード一つに結びつけ、その Reference が何であるかを定義またはバインドする方向性のある叙述 Edge である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `REFERENCE-NODE` (規格ドキュメント BIND `REFERENCE-NODE`) |
| TAG ID | `0x0A0L` |
| Codec ID | `0x00000A00` |
| 規格ドキュメント | `0x00000000/codecs/0x00000A00/` (DECLARE 対象 `0A00`) |
| セクション | 5 `0101` (Edge 叙述)、セクション内オフセット C = 0 |
| Kind | Edge · 系列: 叙述、まとまり: 指示と名前 |
| TAG WORD | `0000 1010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | Reference である Subject が Object を指す方向性バインディング |
| Hugo 側 | `edge/reference-node.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。Edge の Edge Id は FIELD で宣言しない。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受け取る形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | レコード | 任意のレコード(プレースホルダを除く) |  |
| 2 | `object` | #3 | レコード | `000F` セクション 0 全体(ワイルドカード、Reference)、`020F` セクション 1 全体(ワイルドカード、Reference)、`040F` セクション 2 全体(ワイルドカード、Reference)、`060F` セクション 3 全体(ワイルドカード、Value)、`080F` セクション 4 全体(ワイルドカード、Value) |  |

REFERENCE-NODE は、Reference 一つを Object レコード一つに結びつけ、その Reference が何であるかを定義またはバインドする方向性のある叙述 Edge である。Codec `0x0A0L`。

Subject が Object を指す。このバインディングは、意味上の同一性を主張する [SAME-NODE](0x0A1L-same-node.md) ではなく、二つのレコードの byte が同じという意味でもない。

## レイアウト {#레이아웃}

```
TAG WORD          0000 1010 0000 LLLL
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Subject           Reference レコード 1個
Object            Reference または Value レコード 1個
```

## 解釈と有効性 {#해석과-유효성}

- Subject は、ちょうど一つの完全な [Reference](../reference/_index.md) レコードでなければならない。Subject 自体の Length で境界を見つけ、Reference でない、または不完全であれば invalid である。
- Object は、ちょうど一つの完全な Reference または Value レコードでなければならない。Object 自体の Length で境界を見つけ、Edge・Meta である、または不完全であれば invalid である。
- Object が Reference であれば、REFERENCE-NODE バインディングでたどる Reference チェーンは循環してはならず、LOCAL は最終的に解決されなければならない。解決の循環と dangling LOCAL は invalid である。
- 同じドキュメントで LOCAL ID 一つが互いに衝突する Object にバインドされたら invalid である。LOCAL の範囲、ID、最小幅とマージ規則は [LOCAL](../reference/0x005L-local.md) に従う。
- すべての Reference が REFERENCE-NODE でバインドされなければならないわけではない。
- 代表的な用例は `LOCAL → UTF8-LANGUAGE-TEXT` である。[LABEL](0x0A4L-label.md) の Object に LOCAL を置いたとき、同じドキュメントのこのバインディングでテキストを解決する。

Subject が Object を指す方向を逆に解釈してはならない。SAME と DIFFERENT の意味と細部の規則は、各形式が別に定める。

## 長さ {#길이}

```
全体 = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` は Length 拡張 TAG WORD 数、`N_id` は Edge Id LOCAL レコードの WORD 数、`N_subject`・`N_object` は各レコードの全 WORD 数である。Subject と Object を読み終えたカーソルは、Edge の終端とちょうど一致しなければならない。

## 例 (非規範) {#예시-비규범}

Edge Id は `0008`、Subject は LOCAL 1、Object は `Donald Trump`(en)の [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) である。

- Edge Id は `0051 0008` で 2 WORD である。
- Subject は `0051 0001` で 2 WORD である。
- Object は言語 `0761 656E`(BCP47 `en`) + テキスト 12 byte(偶数)なので `UTF8-LANGUAGE-TEXT-EVEN`(`0x078L`)、全体 9 WORD である。TAG は `0788` である。
- Edge は TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD、`LLLL=1101` である。TAG は `0A0D` である。

```
0A0D 0051 0008 0051 0001 0788 0761 656E 446F 6E61 6C64 2054 7275 6D70
```

## 関連ページ {#관련-페이지}

- [Edge](_index.md), [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [LABEL](0x0A4L-label.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x00000A00/latest.geul` を `geul show` で読んだ姿である(16進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A0000000000
BODY
#1 DECLARE 0x0A00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "REFERENCE-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x000F
#9 CODEC #3 0x020F
#10 CODEC #3 0x040F
#8 CODEC #3 0x060F
#11 CODEC #3 0x080F
```
