---
title: "SIGNATURE"
weight: 66
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNATURE は、ドキュメントのコンテンツハッシュに対する署名を、アルゴリズム ID、署名者、署名として書く検証 Meta だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ドキュメントのコンテンツハッシュに対する署名だ(git の署名コミット・タグ)。

## レイアウト

```
TAG WORD          0001 1LLL L100 0001      Codec 0x41
[Length 拡張 TAG]
アルゴリズム ID   1 WORD (0x0001 = Ed25519)
署名者            ISSUER-POINTER(Issuer) Reference レコード
署名              残りすべて。幅はアルゴリズムが決める (Ed25519 32 WORD)
```

- Codec: Meta `0x41`、検証クラス(`100`)
- Payload: アルゴリズム ID(生値 1 WORD)+ 署名者(組み込み Reference)+ 署名(生値、残り)
- 個数: 複数可

## 解釈と有効性

- 署名の対象はコンテンツハッシュだ。BODY だけに署名しない([署名](/ja/grammar/issuer/#署名))。
- 検証クラスなので、コンテンツハッシュから除かれる。署名を足してもハッシュは同じだ。
- 「署名があれば確認する」ではなく、「定められた鍵の署名がなければならない」で検証する。
- バージョン一覧ドキュメントは、公表元が署名する。
- 署名者は、Issuer 自身を指す [ISSUER-POINTER](/ja/grammar/reference/issuer-pointer/)(Issuer)だ。Reference レコードなので自分の Length で終わり、署名の幅がアルゴリズムごとに異なっても、レイアウトが一つに決まる([DECLARE](/ja/grammar/edge/declare/) の残りフィールド)。
- 署名の WORD 数がアルゴリズムの定めた幅と異なれば invalid だ。

## 未解決の問題

- 署名時刻も併せて署名するか。
