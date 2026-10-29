---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE は、GEUL Language Registry が番号を与えた BCP 47 tag 一つを 1 WORD に収める GEUL 言語コード Value だ(Codec 0x48)。レジストリはこの Codec の規格ドキュメントの ENUM だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE は、GEUL Language Registry で番号が割り当てられた BCP 47 tag 一つを 1 WORD に収める GEUL 圧縮言語コードだ。Payload はちょうど 1 WORD だ。

## レイアウト

- コード: Value 直接コード `0x48`。系統 TEXT。
- Payload はちょうど 1 WORD の unsigned 16 ビットコードだ。

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  全体 2 WORD
Payload WORD 1st (16 ビット)           GEUL Language Registry 番号 (uint16)
```

## 解釈と有効性

- Payload の 1 WORD を unsigned 16 ビット整数として読む。
- この値は GEUL Language Registry が割り当てた tag 一つだ。レジストリの正式な表現は、この Codec の規格ドキュメント `0x0000/0x0000000000000848` だ。コード値ごとに FIELD `code` に [ENUM](/ja/grammar/edge/enum/) が一つあり、その ENUM の Edge Id に [BIND](/ja/grammar/edge/bind/) で結ばれた名前が、正規の大文字小文字の BCP 47 tag だ。
- レジストリは閉じたリストだ。規格ドキュメントに ENUM のない値は invalid だ。この Codec 規則は ENUM の一般規則(「宣言されていないコード値はエラーではない」)より優先する。
- 割り当て対象は次の三つだ。
  - IANA Language Subtag Registry の `Type: language` レコードのうち、`Scope: private-use`(`qaa..qtz`)を除いたもの。collection、macrolanguage、special(`mul`・`und`・`zxx`・`mis`)は除かない。
  - IANA が丸ごと登録した tag: grandfathered と redundant(`zh-Hans`、`sr-Latn`、`zh-min-nan` など)。
  - 公開 CC0 ソースで観測された有効な組み合わせ tag(`pt-BR`、`en-GB`、`be-tarask` など)。language・extlang・script・region・variant subtag だけでできた tag だ。extension(`-u-`・`-t-`)や private-use(`-x-`)を含む tag は受けない。
- 番号のない tag はこの形式で書けない。[LANGUAGE-BCP47-CODE](/ja/grammar/value/text/language-bcp47-code/)(`0x46`・`0x47`)で書く。SHORT-CODE の中に escape の経路はない。
- `0x0000` と `0xffff` は永久に割り当てない。この Value では両方とも invalid だ。どちらも `null`・`unknown`・`und` の意味では使わない。
- 値の区間は割り当ての慣例だ。デコーダは値の範囲から tag の種類を推定しない。値の意味は規格ドキュメントだけから来る。

| 区間 | 用途 |
|---|---|
| `0x0000` | 割り当てない(invalid) |
| `0x0001`–`0x3fff` | language subtag 一つの tag |
| `0x4000`–`0x7fff` | subtag 二つ以上の tag(IANA の丸ごと tag、観測された組み合わせ tag) |
| `0x8000`–`0xfffe` | あふれ。上のブロックが埋まればここで続けて割り当てる |
| `0xffff` | 割り当てない(invalid) |

- 初版はブロック内で tag の小文字 ASCII 順に番号を付ける。`0x4000` ブロックは IANA の丸ごと tag(grandfathered・redundant を混ぜた ASCII 順)の次に、観測された組み合わせ tag(ASCII 順)が来る。IANA ファイルの物理的な順序や使用頻度は番号の規則ではない。
- 割り当ては追記だけだ(append-only)。新しい tag はブロックの末尾に追記し、ブロックが埋まればあふれ区間に追記する。一度与えた番号の tag(大文字小文字を区別しない)は変えず、消さず、再利用しない。
- 新しい tag は、規格ドキュメントの新しいバージョンに ENUM と BIND を追記して入れる。既存の ENUM・BIND は直さない。そのため、どのバージョンも前のバージョンの上位集合だ。
- 65,534 個がすべて埋まれば、それ以上は割り当てない。その後の新しい tag は LANGUAGE-BCP47-CODE で書く。表現力は減らず、圧縮の利得がないだけだ。
- 同じ言語: SHORT-CODE `n` と、レジストリが `n` に結んだ tag の LANGUAGE-BCP47-CODE(大文字小文字を区別しない)は同じ言語だ。
- レジストリの版は規格ドキュメントのバージョンだ。各版は、根拠とした IANA registry ファイル(File-Date、SHA-256)を規格ドキュメント HEAD の [SOURCE](/ja/grammar/edge/source/) として記す。値を解釈した版を示す必要があるときは、そのバージョン(`0x0000/0x0000000000000848@n`)を一緒に残す。
- Codec 規格は、同じ 1 WORD コードを TAG のない生値フィールドに収めることができる(生値フィールドの [CODEC](/ja/grammar/codec-spec/#codec))。これはその Codec 規格の規則であり、独立した Value の wire form は常に TAG 1 WORD + Payload 1 WORD だ。

## 標準の根拠

- tag の意味と subtag の有効性は、[IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) と [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646) に従う。IANA と IETF は、プロトコルレジストリに関する自らの権利を CC0 1.0 の下に置いている([IANA Licensing Terms](https://www.iana.org/help/licensing-terms))。
- レジストリ番号(ASCII 順の append-only 割り当て、ブロック構成、`0x0000`・`0xffff` の非割り当て、閉じたリスト)、規格ドキュメントの ENUM が正式な表現であること、TAG のない生値フィールド embedding との区別は GEUL の規則だ。

## 長さ

- 全体は TAG 1 WORD と Payload 1 WORD を合わせたちょうど 2 WORD で、直接長 `LLLL=0001` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 1 WORD でなければ拒否する。

## 例

レジストリ v2(規格ドキュメント `0x0000/0x0000000000000848` バージョン 2、IANA File-Date 2026-09-17)の番号だ。8,678 個を割り当てた(language 8,275、grandfathered 26、redundant 67、観測された組み合わせ 310)。

| tag | コード | 全体 WORD |
|---|---|---|
| `en` | `0x0784` | `08C8 0784` |
| `ko` | `0x0d06` | `08C8 0D06` |
| `zh-Hans` | `0x404c` | `08C8 404C` |
| `pt-BR` | `0x4130` | `08C8 4130` |

- 規格ドキュメントで `en` は `ENUM #2 0x0784` と、その Edge Id に結ばれた `BIND "en"` だ。
- `de-x-formal`(private-use)、`nl-u-sd-bebru`(extension)は番号がないので LANGUAGE-BCP47-CODE で書く。

## 未解決の問題

- 版をまたぐ解釈: 読み手の持つ版より新しい番号に出会ったとき、invalid として捨てるか、元の値を保ったまま「未知のコード」として扱うか。append-only なので最新版一つで常に足りるが、オフラインのデコーダのための規則が要る。
- 正規形: 番号のある tag を SHORT-CODE で書くべき(SHOULD/MUST)か。MUST なら表記が一つに決まるが、新しい版が出ると以前に書いたドキュメントが正規形でなくなる。
- deprecated tag と Preferred-Value を規格ドキュメントで表す方法(今の版にはない)。
- 観測された組み合わせ tag を追記する手続き(ソース、観測の下限)。

## 関連ページ

- [LANGUAGE-BCP47-CODE](/ja/grammar/value/text/language-bcp47-code/)、[UTF8-LANGUAGE-TEXT](/ja/grammar/value/text/utf8-language-text/)、[LABEL](/ja/grammar/edge/label/)
- [Codec 規格ドキュメント](/ja/grammar/codec-spec/)、[ENUM](/ja/grammar/edge/enum/)、[BIND](/ja/grammar/edge/bind/)、[SOURCE](/ja/grammar/edge/source/)
