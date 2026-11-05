---
title: "LANGUAGE-SHORT-CODE (0x07AL)"
weight: 122
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE は GEUL Language Registry に番号が割り当てられた BCP 47 tag 一つを 1 WORD で収める、GEUL の圧縮言語コードである。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 項目 | 値 |
|---|---|
| 名前 | `LANGUAGE-SHORT-CODE` (規格ドキュメント BIND `LANGUAGE-SHORT-CODE`) |
| TAG ID | `0x07AL` |
| Codec ID | `0x000007A0` |
| 規格ドキュメント | `0x00000000/codecs/0x000007A0/` (DECLARE の対象 `07A0`) |
| セクション | 3 `0011` (Value)、セクション内オフセット C = 26 |
| Kind | Value · 系列: TEXT |
| TAG WORD | `0000 0111 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引の説明 | GEUL Language Registry の番号で書いた BCP 47 tag(Payload 1 WORD) |
| Hugo 側 | `value/text/language-short-code.md` |

## フィールド (規格ドキュメント) {#필드-규격-문서}

FIELD のドキュメント内の順序が Payload のフィールド順序である([Codec 規格ドキュメント](../codec-spec.md))。

| 順序 | フィールド(BIND) | FIELD | 幅 | 受ける形式(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | 生値 1 WORD |  | ENUM 8678 個。例: `0x0001` aa, `0x0002` aaa, `0x0003` aab, `0x0004` aac, `0x0005` aad … |

LANGUAGE-SHORT-CODE は GEUL Language Registry に番号が割り当てられた BCP 47 tag 一つを 1 WORD で収める、GEUL の圧縮言語コードである。Payload はちょうど 1 WORD である。

## レイアウト {#레이아웃}

- コード: Value 直接コード `0x07AL`。系列 TEXT。
- Payload はちょうど 1 WORD の unsigned 16 ビットコードである。

```
TAG WORD          0x07A1 (0000 0111 1010 0001)  全体 2 WORD
Payload WORD 1st (16ビット)           GEUL Language Registry 番号 (uint16)
```

## 解釈と有効性 {#해석과-유효성}

- Payload の 1 WORD を unsigned 16 ビット整数として読む。
- この値は GEUL Language Registry が割り当てた tag 一つである。レジストリの正式な表現はこの Codec の規格ドキュメント `0x00000000/codecs/0x000007A0` である。コード値ごとに FIELD `code` に [ENUM](../edge/0x0BDL-enum.md) が一つあり、その ENUM Edge Id に [BIND](../edge/0x0A3L-bind.md) で結び付けられた名前が、正規の大文字小文字の BCP 47 tag である。
- レジストリは閉じた一覧である。規格ドキュメントに ENUM がない値は invalid である。ENUM の一般規則(「宣言されていないコード値はエラーではない」)よりこの Codec の規則が優先する。
- 割り当て対象は次の三つである。
  - IANA Language Subtag Registry の `Type: language` レコードのうち、`Scope: private-use`(`qaa..qtz`)を除いたもの。collection、macrolanguage、special(`mul`·`und`·`zxx`·`mis`)は除かない。
  - IANA が丸ごと登録した tag: grandfathered と redundant(`zh-Hans`, `sr-Latn`, `zh-min-nan` など)。
  - 公開の CC0 原データで観測された有効な組み合わせ tag(`pt-BR`, `en-GB`, `be-tarask` など)。language·extlang·script·region·variant の subtag だけでできた tag である。extension(`-u-`·`-t-`)と private-use(`-x-`)を含む tag は受け付けない。
- 番号のない tag はこの形式で書けない。[LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md)(`0x076L`·`0x077L`)で書く。SHORT-CODE の中に escape 経路はない。
- `0x0000` と `0xFFFF` は永久に割り当てない。この Value ではどちらも invalid である。どちらも `null`·`unknown`·`und` の意味では使わない。
- 値の区間は割り当ての慣例である。デコーダは値の範囲から tag の種類を推測しない。値の意味は規格ドキュメントからのみ得られる。

| 区間 | 用途 |
|---|---|
| `0x0000` | 未割り当て(invalid) |
| `0x0001`–`0x3FFF` | language subtag 一つの tag |
| `0x4000`–`0x7FFF` | subtag が二つ以上の tag(IANA の丸ごと tag、観測された組み合わせ tag) |
| `0x8000`–`0xFFFE` | あふれ。上のブロックが埋まったらここで続けて割り当てる |
| `0xFFFF` | 未割り当て(invalid) |

- 初版はブロック内で tag の小文字 ASCII 順に番号を付ける。`0x4000` ブロックは IANA の丸ごと tag(grandfathered·redundant を混ぜた ASCII 順)の次に、観測された組み合わせ tag(ASCII 順)が来る。IANA ファイルの物理的な順序と使用頻度は番号の規則ではない。
- 割り当ては追加のみ(append-only)である。新しい tag はブロックの末尾に追加し、ブロックが埋まればあふれ区間に追加する。一度付けた番号の tag(大文字小文字を無視)は変更せず、削除も再利用もしない。
- 新しい tag は規格ドキュメントの新しいバージョンに ENUM と BIND を追加して入れる。既存の ENUM·BIND は直さない。そのため、どのバージョンも前のバージョンの上位集合である。
- 65,534 個がすべて埋まったら、それ以上は割り当てない。その後の新しい tag は LANGUAGE-BCP47-CODE で書く。表現力は減らず、圧縮の利点がないだけである。
- 同じ言語: SHORT-CODE `n` と、レジストリが `n` に結び付けた tag の LANGUAGE-BCP47-CODE(大文字小文字を無視)は同じ言語である。
- レジストリの版は規格ドキュメントのバージョンである。各版は根拠とした IANA registry ファイル(File-Date, SHA-256)を規格ドキュメント HEAD の [SOURCE](../edge/0x0C0L-source.md) として記す。値を解釈した版を示す必要があるときは、そのバージョン([CODEC-POINTER](../reference/0x042L-codec-pointer.md)(`0x00000000`, `0x000007A0`, バージョン ID `n`))を併せて残す。
- Codec 規格は同じ 1 WORD コードを TAG のない生値フィールドとして収められる(生値フィールドの [CODEC](../codec-spec.md#codec))。これはその Codec 規格の規則であり、独立した Value の wire form は常に TAG 1 WORD + Payload 1 WORD である。

## 標準の根拠 {#표준-근거}

- tag の意味と subtag の有効性は [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) と [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646) に従う。IANA·IETF はプロトコルレジストリに対する権利を CC0 1.0 としている([IANA Licensing Terms](https://www.iana.org/help/licensing-terms))。
- レジストリ番号(ASCII 順 append-only の割り当て、ブロック構成、`0x0000`·`0xFFFF` の未割り当て、閉じた一覧)、規格ドキュメントの ENUM が正式な表現であること、TAG のない生値フィールドへの埋め込みとの区別は GEUL の規則である。

## 長さ {#길이}

- 全体は TAG 1 WORD と Payload 1 WORD を合わせたちょうど 2 WORD で、直接長 `LLLL=0001` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 1 WORD でなければ拒否する。

## 例 {#예시}

レジストリ v2(規格ドキュメント `0x00000000/codecs/0x000007A0` バージョン 2、IANA File-Date 2026-09-17)の番号である。8,678 個を割り当てた(language 8,275、grandfathered 26、redundant 67、観測された組み合わせ 310)。

| tag | コード | 全体 WORD |
|---|---|---|
| `en` | `0x0784` | `07A1 0784` |
| `ko` | `0x0D06` | `07A1 0D06` |
| `zh-Hans` | `0x404C` | `07A1 404C` |
| `pt-BR` | `0x4130` | `07A1 4130` |

- 規格ドキュメントでは、`en` は `ENUM #2 0x0784` とその Edge Id に結び付けた `BIND "en"` である。
- `de-x-formal`(private-use)、`nl-u-sd-bebru`(extension)は番号がないので LANGUAGE-BCP47-CODE で書く。

## 未解決の問題 {#열린-문제}

- 版をまたぐ解釈: 読み手が持つ版より新しい番号に出会ったとき、invalid として捨てるか、原値を保存したまま「未知のコード」として扱うか。append-only なので最新版一つで常に足りるが、オフラインのデコーダのための規則が要る。
- 正規形: 番号のある tag を SHORT-CODE で書かなければならない(SHOULD/MUST)のか。MUST なら表記が一つに定まるが、新しい版が出ると、先に書いたドキュメントが正規形でなくなる。
- deprecated tag と Preferred-Value を規格ドキュメントに表す方法(今の版にはない)。
- 観測された組み合わせ tag を追加する手続き(原データ、観測の下限)。

## 関連ページ {#관련-페이지}

- [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md), [LABEL](../edge/0x0A4L-label.md)
- [Codec 規格ドキュメント](../codec-spec.md), [ENUM](../edge/0x0BDL-enum.md), [BIND](../edge/0x0A3L-bind.md), [SOURCE](../edge/0x0C0L-source.md)

## 規格ドキュメント原文 {#규격-문서-원문}

規格ドキュメント `0x00000000/codecs/0x000007A0/latest.geul` を `geul show` で読んだ様子である(16 進は大文字)。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007A000000000
#17368 SOURCE #0 #17362
#17369 QUALIFIER P577 #17368 GREGORIAN-DATE(2026-09-17)
#17370 QUALIFIER P813 #17368 GREGORIAN-DATE(2026-10-29)
#17371 QUALIFIER P4092 #17368 SHA-256-DIGEST(0x755FAD43283BE7B41EBE3C89AD054B6EAF928F404F9C0EDB74799E0EAB74BEB1)
#17372 SOURCE #0 Q2013
#17373 QUALIFIER P813 #17372 GREGORIAN-DATE(2026-10-29)
BODY
#1 DECLARE 0x07A0
#2 FIELD #1 0x0001
#3 BIND #1 "LANGUAGE-SHORT-CODE"
#4 BIND #2 "code"
#5 ENUM #2 0x0001
#6 BIND #5 "aa"
#7 ENUM #2 0x0002
#8 BIND #7 "aaa"
#9 ENUM #2 0x0003
#10 BIND #9 "aab"
#11 ENUM #2 0x0004
#12 BIND #11 "aac"
#13 ENUM #2 0x0005
#14 BIND #13 "aad"
… (ENUM·BIND 17346 行を省略)
#17361 REFERENCE-NODE #17362 <https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry>
#17363 TRIPLE P275 #17362 Q6938433 normal
#17364 REFERENCE-NODE #17365 <https://www.iana.org/help/licensing-terms>
#17366 SOURCE #17363 #17365
#17367 QUALIFIER P813 #17366 GREGORIAN-DATE(2026-10-29)
```
