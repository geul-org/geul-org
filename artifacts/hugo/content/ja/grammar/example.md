---
title: "例: Wikidata 項目"
weight: 140
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "Wikidata 項目 Q42(Douglas Adams)に関する小さなドキュメントを最初から最後まで読む。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Wikidata 項目 Q42(Douglas Adams)に関する小さなドキュメントを最初から最後まで読む。含まれる内容は次のとおりだ。

- 英語名: Douglas Adams
- Q42 は人間(Q5)のインスタンスである(P31)。
- Q42 は St John's College(Q691283)で教育を受けた(P69)。開始時点(P580)は1971年だ。

ドキュメントは Issuer `0x00000001` のドキュメント `0x510000000000002A` で、全体で63 WORD(126バイト)だ。

## 全体 {#전체}

```
1C01 003F 1C51 0001 1C79 0418 0000 0001 5100 0000 0000 002A 0000 0000
1C30
0A4E 0010 0051 0001 0141 002A 0799 0761 656E 446F 7567 6C61 7320 4164 616D 7300
0AA9 0051 0002 0191 001F 0141 002A 0141 0005 0000
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731
1C40
```

## HEAD {#head}

```
1C01 003F
```

`1C01` は Meta(セクション14)、Codec `0x1C0L`(DOC-1WORD)、Length 2 WORD だ。値 `003F`(63)がドキュメント全体の WORD 数だ。デコーダはこの値でドキュメントの終わりをあらかじめ知る。

```
1C51 0001
```

Meta `0x1C5L` SPEC-VERSION。このドキュメントが従う仕様版だ。v1 は `0001` である。

```
1C79 0418 0000 0001 5100 0000 0000 002A 0000 0000
```

Meta `0x1C7L` DOC-ID、全体10 WORD。Payload は DOC-POINTER Reference 一つだ。

| WORD | 意味 |
|---|---|
| `0418` | Reference、Codec `0x041L`(DOC-POINTER)、9 WORD |
| `0000 0001` | Issuer `0x00000001` (2 WORD) |
| `5100 0000 0000 002A` | ドキュメント ID `0x510000000000002A` |
| `0000 0000` | バージョン `0` (自分自身) |

```
1C30
```

BODY。HEAD が終わり、BODY が始まる。

## BODY {#body}

### #1 LABEL — 英語名 {#1-label--영어-이름}

```
0A4E 0010 0051 0001 0141 002A 0799 0761 656E 446F 7567 6C61 7320 4164 616D 7300
```

| WORD | 意味 |
|---|---|
| `0A4E` | Edge、Codec `0x0A4L` LABEL、Length `1110`(拡張) |
| `0010` | 拡張長: 全体16 WORD |
| `0051 0001` | Edge Id: LOCAL 1 |
| `0141 002A` | Subject: Wikidata Q42 |
| `0799` | Object: UTF8-LANGUAGE-TEXT、奇数バイト(`0x079L`)、10 WORD |
| `0761 656E` | 言語: BCP 47 `en` |
| `446F … 7300` | `Douglas Adams` 13バイト + パディング `00` |

### #2 TRIPLE — Q42 は人間である {#2-triple--q42는-사람이다}

```
0AA9 0051 0002 0191 001F 0141 002A 0141 0005 0000
```

| WORD | 意味 |
|---|---|
| `0AA9` | Edge、Codec `0x0AAL` TRIPLE、10 WORD |
| `0051 0002` | Edge Id: LOCAL 2 |
| `0191 001F` | Predicate: P31 (instance of) |
| `0141 002A` | Subject: Q42 |
| `0141 0005` | Object: Q5 (人間) |
| `0000` | Rank: normal |

### #3 TRIPLE — Q42 は St John's College で教育を受けた {#3-triple--q42는-st-johns-college에서-교육받았다}

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000
```

| WORD | 意味 |
|---|---|
| `0AAA` | Edge、TRIPLE、11 WORD |
| `0051 0003` | Edge Id: LOCAL 3 |
| `0191 0045` | Predicate: P69 (educated at) |
| `0141 002A` | Subject: Q42 |
| `0142 000A 8C53` | Object: Q691283。値が16ビットを超えるため3 WORD の Reference だ |
| `0000` | Rank: normal |

### #4 QUALIFIER — 開始時点 1971年 {#4-qualifier--시작-시점-1971년}

```
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731
```

| WORD | 意味 |
|---|---|
| `0AB9` | Edge、Codec `0x0ABL` QUALIFIER、10 WORD |
| `0051 0004` | Edge Id: LOCAL 4 |
| `0191 0244` | Property: P580 (start time) |
| `0051 0003` | Target: #3 (上の TRIPLE) |
| `06E2 3139 3731` | Value: EDTF `1971` (年精度なので GREGORIAN-DATE ではなく EDTF) |

#3 の意味は、#3 自体と #3 を指す QUALIFIER をすべて集めたものだ。「Q42 は1971年から St John's College で教育を受けた。」

```
1C40
```

END。ここまでが63 WORD だ。

## コードブックなしで読むと {#코덱북-없이-읽으면}

コードブックを知らないデコーダでも次のことがわかる。

- ドキュメントが63 WORD で、HEAD に Meta が2個、BODY に Edge が4個ある。
- 各 Edge の Codec(LABEL、TRIPLE、TRIPLE、QUALIFIER)と Edge Id(1、2、3、4)。
- レコードごとの次のレコードの位置。

構成要素の役割(Predicate、Subject、Object、Rank)は、各 Codec の[規格ドキュメント](codec-spec.md)を読まないとわからない。

## コンテンツハッシュ {#내용-해시}

このドキュメントのコンテンツハッシュ(SHA-256)は次のとおりだ。公表すると、バージョン一覧にこのハッシュがバージョン ID とともに記録される。

```
0x561C157203D51AF8C754D53E20AD190F17E73ACDC4235BA47C87F608C946737F
```
