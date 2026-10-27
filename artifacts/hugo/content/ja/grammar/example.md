---
title: "例: Wikidata 項目"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "Wikidata Q42(Douglas Adams)の名前一つ、命題二つ、限定条件一つを収めた GEUL ドキュメント63 WORD を、最初から最後まで読む。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Wikidata 項目 Q42(Douglas Adams)についての小さなドキュメントを、最初から最後まで読んでみる。収めた内容は次のとおりだ。

- 英語名: Douglas Adams
- Q42 は人間(Q5)のインスタンスだ(P31)。
- Q42 は St John's College(Q691283)で教育を受けた(P69)。開始時点(P580)は1971年だ。

ドキュメントは Issuer `0x00010000` のドキュメント `0x510000000000002a` で、全体で63 WORD(126バイト)だ。

## 全体

```
1880 003f 1890 0001 1c92 0438 0001 0000 5100 0000 0000 002a 0000 0000
180e
1704 0010 0088 0001 00a0 002a 0ccb 08c6 656e 446f 7567 6c61 7320 4164 616d 7300
148a 0088 0002 00a8 001f 00a0 002a 00a0 0005 0000
150a 0088 0003 00a8 0045 00a0 002a 0120 000a 8c53 0000
148b 0088 0004 00a8 0244 0088 0003 0924 3139 3731
180f
```

## HEAD

```
1880 003f
```

`1880` は Meta(`11`)、Length 2 WORD、Codec `0x00`(DOC-1WORD)だ。値 `003f`(63)がドキュメント全体の WORD 数だ。デコーダーはこの値でドキュメントの終わりを前もって知る。

```
1890 0001
```

Meta `0x10` SPEC-VERSION。このドキュメントが従う仕様の版だ。v1 は `0001` だ。

```
1c92 0438 0001 0000 5100 0000 0000 002a 0000 0000
```

Meta `0x12` DOC-ID、全体10 WORD。Payload は DOC-POINTER Reference 一つだ。

| WORD | 意味 |
|---|---|
| `0438` | Reference、9 WORD、Codec `0111`(DOC-POINTER)、Quantifier `000` |
| `0001 0000` | Issuer `0x00010000` (2 WORD) |
| `5100 0000 0000 002a` | ドキュメント ID `0x510000000000002a` |
| `0000 0000` | バージョン `0` (自分自身) |

```
180e
```

BODY。HEAD が終わり、BODY が始まる。

## BODY

### #1 LABEL — 英語名

```
1704 0010 0088 0001 00a0 002a 0ccb 08c6 656e 446f 7567 6c61 7320 4164 616d 7300
```

| WORD | 意味 |
|---|---|
| `1704` | Edge、Length `1110`(拡張)、Codec `0x04` LABEL |
| `0010` | 拡張された長さ: 全体16 WORD |
| `0088 0001` | Edge Id: LOCAL 1 |
| `00a0 002a` | Subject: Wikidata Q42 |
| `0ccb` | Object: UTF8-LANGUAGE-TEXT、10 WORD、奇数バイト(`0x4B`) |
| `08c6 656e` | 言語: BCP 47 `en` |
| `446f … 7300` | `Douglas Adams` 13バイト + パディング `00` |

### #2 TRIPLE — Q42 は人間である

```
148a 0088 0002 00a8 001f 00a0 002a 00a0 0005 0000
```

| WORD | 意味 |
|---|---|
| `148a` | Edge、10 WORD、Codec `0x0A` TRIPLE |
| `0088 0002` | Edge Id: LOCAL 2 |
| `00a8 001f` | Predicate: P31 (instance of) |
| `00a0 002a` | Subject: Q42 |
| `00a0 0005` | Object: Q5 (人間) |
| `0000` | Rank: normal |

### #3 TRIPLE — Q42 は St John's College で教育を受けた

```
150a 0088 0003 00a8 0045 00a0 002a 0120 000a 8c53 0000
```

| WORD | 意味 |
|---|---|
| `150a` | Edge、11 WORD、TRIPLE |
| `0088 0003` | Edge Id: LOCAL 3 |
| `00a8 0045` | Predicate: P69 (educated at) |
| `00a0 002a` | Subject: Q42 |
| `0120 000a 8c53` | Object: Q691283。値が16ビットを超えるので、3 WORD の Reference だ |
| `0000` | Rank: normal |

### #4 QUALIFIER — 開始時点 1971年

```
148b 0088 0004 00a8 0244 0088 0003 0924 3139 3731
```

| WORD | 意味 |
|---|---|
| `148b` | Edge、10 WORD、Codec `0x0B` QUALIFIER |
| `0088 0004` | Edge Id: LOCAL 4 |
| `00a8 0244` | Property: P580 (start time) |
| `0088 0003` | Target: #3 (上の TRIPLE) |
| `0924 3139 3731` | Value: EDTF `1971` (年精度なので GREGORIAN-DATE ではなく EDTF) |

#3 の意味は、#3 自体と #3 を指す QUALIFIER をすべて集めたものだ。「Q42 は1971年から St John's College で教育を受けた。」

```
180f
```

END。ここまでで63 WORD だ。

## コードブックなしで読むと

コードブックを知らないデコーダーでも、次のことがわかる。

- ドキュメントが63 WORD で、HEAD に Meta が2個、BODY に Edge が4個ある。
- 各 Edge の Codec(LABEL, TRIPLE, TRIPLE, QUALIFIER)と Edge Id(1, 2, 3, 4)。
- レコードごとの、次のレコードの位置。

構成要素の役割(Predicate, Subject, Object, Rank)は、各 Codec の[規格ドキュメント](/ja/grammar/codec-spec/)を読まなければわからない。

## コンテンツハッシュ

このドキュメントのコンテンツハッシュ(SHA-256)は次のとおりだ。公表すると、バージョン一覧にこのハッシュがバージョン ID とともに記録される。

```
0x4f05137f92de70951f581156cf90f15471c254c7e87ad1ba100bf91dd705ebc1
```
