---
title: "REFERENCE-NODE"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE は Reference 一つを Object レコード一つに結びつけて、その Reference が何であるかを定義する方向性のある記述 Edge だ(Codec 0x00)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-NODE は、Reference 一つを Object レコード一つに結びつけて、その Reference が何であるかを定義またはバインドする方向性のある記述 Edge だ。Codec `0x00`。

Subject が Object を指示する。このバインディングは、意味上の同一性を主張する [SAME-NODE](/ja/grammar/edge/same-node/) ではなく、二つのレコードの byte が同じという意味でもない。

## レイアウト

```
TAG WORD          0001 0LLL L000 0000
[Length 拡張 TAG]
Edge Id           LOCAL Reference レコード
Subject           Reference レコード 1個
Object            Reference または Value レコード 1個
```

## 解釈と有効性

- Subject は、ちょうど一つの完全な [Reference](/ja/grammar/reference/) レコードでなければならない。Subject 自体の Length で境界を見つけ、Reference でなかったり不完全であれば invalid だ。
- Object は、ちょうど一つの完全な Reference または Value レコードでなければならない。Object 自体の Length で境界を見つけ、Edge・Meta であったり不完全であれば invalid だ。
- Object が Reference なら、REFERENCE-NODE バインディングでたどる Reference チェーンは循環してはならず、LOCAL は最終的に解決されなければならない。解決の循環と dangling LOCAL は invalid だ。
- 同じドキュメントで LOCAL ID 一つが互いに衝突する Object にバインドされたら invalid だ。LOCAL の範囲、ID、最小幅とマージ規則は [LOCAL](/ja/grammar/reference/local/) に従う。
- すべての Reference が REFERENCE-NODE でバインドされなければならないわけではない。
- 代表的な用例は `LOCAL → UTF8-LANGUAGE-TEXT` だ。[LABEL](/ja/grammar/edge/label/) の Object に LOCAL を置いたとき、同じドキュメントのこのバインディングでテキストを解決する。

Subject が Object を指示する方向を逆に解釈してはならない。SAME と DIFFERENT の意味と細部の規則は、各形式が別に定める。

## 長さ

```
全体 = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` は Length 拡張 TAG WORD 数、`N_id` は Edge Id LOCAL レコードの WORD 数、`N_subject`・`N_object` は各レコードの全 WORD 数だ。Subject と Object を読み終えたカーソルは、Edge の終わりとちょうど合わなければならない。

## 例 (非規範)

Edge Id `0008`、Subject は LOCAL 1、Object は `Donald Trump`(en)の [UTF8-LANGUAGE-TEXT](/ja/grammar/value/text/utf8-language-text/) だ。

- Edge Id は `0088 0008` で 2 WORD だ。
- Subject は `0088 0001` で 2 WORD だ。
- Object は言語 `08C6 656e`(BCP47 `en`)+ テキスト 12 byte(偶数)なので `UTF8-LANGUAGE-TEXT-EVEN`(`0x4A`)、全体 9 WORD だ。TAG は `0C4A` だ。
- Edge は TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD、`LLLL=1101` だ。TAG は `1680` だ。

```
1680 0088 0008 0088 0001 0C4A 08C6 656e 446f 6e61 6c64 2054 7275 6d70
```

## 関連ページ

- [Edge](/ja/grammar/edge/)、[SAME-NODE](/ja/grammar/edge/same-node/)、[DIFFERENT-NODE](/ja/grammar/edge/different-node/)、[LABEL](/ja/grammar/edge/label/)
- [Reference](/ja/grammar/reference/)、[LOCAL](/ja/grammar/reference/local/)、[UTF8-LANGUAGE-TEXT](/ja/grammar/value/text/utf8-language-text/)
