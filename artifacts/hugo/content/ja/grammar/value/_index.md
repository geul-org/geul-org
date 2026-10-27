---
title: "Value"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value は値そのものを収めるレコードだ。Codec の上位2ビットが系列(数・10進数、時間、テキスト、バイナリ)で、よく使う形式は直接コード、残りは標準団体ごとの Issuer 形式に置く。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value は、値そのものを収めるレコードだ。Codec が Payload の解釈を決める。

## レイアウト

```
TAG WORD          0000 1LLL LCCC CCCC
[Length 拡張 TAG]
[Codec 拡張 TAG]  Issuer 形式のとき
Payload
```

- `LLLL` は TAG WORD を含む全 WORD 数 − 1 だ。1~14 WORD は直接長さ、15 WORD 以上は拡張長さだ。
- Issuer 形式なら、Codec 拡張 TAG に Issuer(Codec が定めた幅 1/2/4/16 WORD)と形式番号 1 WORD を置く。形式番号の上位2ビットが系列だ。
- デコーダは、形式を知らなくても系列と Length が分かる。

## 系列

Codec の上位2ビットが系列だ。直接コード(7ビット)と Issuer 形式番号(16ビット)が同じ規則に従う。そのためコードブックなしでも系列が分かる。

| 上位2ビット | 系列 | 直接コード | 形式番号 |
|---|---|---|---|
| `00` | NUMERIC / DECIMAL | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | TIME | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | TEXT | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | BINARY | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

- NUMERIC / DECIMAL は、3番目のビットでさらに分ける。`000` は NUMERIC、`001` は DECIMAL だ。
- ベクトル、テンソル、複素数、分数、区間のような数値は NUMERIC だ。例外として BIT-VECTOR は BINARY だ。言語コードは TEXT だ。
- Issuer 形式のレコードには、Codec 拡張 TAG(Issuer と形式番号)が付く。Payload が長ければ(全体 15 WORD 以上)Length 拡張 TAG を使う。

## 直接コード

| Codec | 名前 | 系列 | 説明 |
|---|---|---|---|
| `0x00` | [BOOL](/ja/grammar/value/numeric/bool/) | NUMERIC | false または true |
| `0x01` | [SIGNED-INTEGER](/ja/grammar/value/numeric/signed-integer/) | NUMERIC | 最小 WORD の2の補数整数 |
| `0x02` | [UNSIGNED-INTEGER](/ja/grammar/value/numeric/unsigned-integer/) | NUMERIC | 最小 WORD の符号なし整数 |
| `0x03` | [BINARY-FLOAT](/ja/grammar/value/numeric/binary-float/) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x04` | [COORDINATE-EARTH](/ja/grammar/value/numeric/coordinate-earth/) | NUMERIC | 地球(WGS 84)の緯度・経度と不確かさ(単位 Reference) |
| `0x05` | [COORDINATE-GEO](/ja/grammar/value/numeric/coordinate-geo/) | NUMERIC | 天体 Reference と緯度・経度、不確かさ(単位 Reference) |
| `0x06` | [QUANTITY](/ja/grammar/value/numeric/quantity/) | NUMERIC | 10進数の量、単位 Reference、下限・上限 |
| `0x10` | [SIGNED-DECIMAL](/ja/grammar/value/decimal/signed-decimal/) | DECIMAL | `C × 10^E`、符号付き係数 |
| `0x11` | [UNSIGNED-DECIMAL](/ja/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C × 10^E`、符号なし係数 |
| `0x20` | [GREGORIAN-DATE](/ja/grammar/value/time/gregorian-date/) | TIME | 1970-01-01 からの日数 (グレゴリオ暦) |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/ja/grammar/value/time/civil-time-nanoseconds/) | TIME | 午前0時からのナノ秒 |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/ja/grammar/value/time/posix-timestamp-seconds/) | TIME | Unix epoch からの秒 |
| `0x23` | [DURATION-SECONDS](/ja/grammar/value/time/duration-seconds/) | TIME | 経過時間(秒) |
| `0x24`/`0x25` | [EDTF](/ja/grammar/value/time/edtf/) | TIME | ISO 8601-2 拡張日付文字列 (年・月の精度、不確実、区間) |
| `0x26`/`0x27` | [GEDCOM-DATE](/ja/grammar/value/time/gedcom-date/) | TIME | GEDCOM 7 日付文字列 (ユリウス暦など他の暦) |
| `0x40`/`0x41` | [UTF8-TEXT](/ja/grammar/value/text/utf8-text/) | TEXT | 言語のない UTF-8 文字列 |
| `0x44`/`0x45` | [URI](/ja/grammar/value/text/uri/) | TEXT | RFC 3986 URI |
| `0x46`/`0x47` | [LANGUAGE-BCP47-CODE](/ja/grammar/value/text/language-bcp47-code/) | TEXT | BCP 47 言語タグ |
| `0x48` | [LANGUAGE-SHORT-CODE](/ja/grammar/value/text/language-short-code/) | TEXT | 1 WORD 圧縮言語コード |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/ja/grammar/value/text/utf8-language-text/) | TEXT | 言語付きテキスト |
| `0x60` | [UUID](/ja/grammar/value/binary/uuid/) | BINARY | RFC 9562 UUID |
| `0x61` | [SHA-256-DIGEST](/ja/grammar/value/binary/sha-256-digest/) | BINARY | SHA-256 の結果 |
| `0x62` | [SHA1-DIGEST](/ja/grammar/value/binary/sha1-digest/) | BINARY | SHA-1 の結果 (git オブジェクト ID のような識別用途) |

- 偶数・奇数でペアになったコードは、可変長のバイト列だ。偶数コードはバイト数が偶数、奇数コードは奇数だ([レコードと TAG WORD](/ja/grammar/record/))。
- 表にない直接コードは予約だ。

## Issuer 形式

直接コードにない形式は、その形式を制定した団体の Issuer の下の形式番号で置く。制定団体のない慣例的な形式は ADHOC(`0x0001`)、GEUL 固有の形式は GEUL(`0x0000`)の下に置く。

| Issuer | 形式の例 |
|---|---|
| GEUL `0x0000` | DURATION-NANOSECONDS、OPAQUE-BYTES、BIT-VECTOR |
| ADHOC `0x0001` | BFLOAT16、整数・実数ベクトル、テンソル、複素数、分数、区間、四元数、BLAKE3 |
| IETF `0x0020` | 相対 URI、CRC32C、IPv4・IPv6 アドレス |
| IEEE `0x0040` | IEEE 754 decimal32/64/128、POSIX ナノ秒タイムスタンプ、MAC アドレス |
| KHRONOS `0x0041` | RGBA8・BGRA8 ピクセル |
| ONNX `0x0043`、OCP `0x0044` | FP8、FP4 |
| BIPM `0x0060` | TAI タイムスタンプ |
| NIST `0x0062` | SHA-512、SHA3-256 |
| GPS `0x0063` | GPS タイムスタンプ |

- 形式を知らないデコーダは、形式番号の系列だけを知り、Payload を読み飛ばす。
- 画像・動画のような大きな値は、直接入れるより URI と SHA-256 で参照することを勧める。
- バイト列内の著作物は、元のライセンスに従う。出典とライセンスは Meta で記録する。

## 形式のまとまり

各形式のレイアウト、解釈、有効性、例は、まとまりごとのドキュメントにある。

| まとまり | 系列 | 形式 |
|---|---|---|
| [numeric](/ja/grammar/value/numeric/) | NUMERIC | BOOL、整数、浮動小数点、座標、QUANTITY |
| [decimal](/ja/grammar/value/decimal/) | DECIMAL | SIGNED-DECIMAL、UNSIGNED-DECIMAL、IEEE 754 decimal32/64/128 |
| [time](/ja/grammar/value/time/) | TIME | 日付、時刻、タイムスタンプ、経過時間、EDTF、GEDCOM 日付 |
| [text](/ja/grammar/value/text/) | TEXT | UTF-8 テキスト、言語付きテキスト、URI、言語コード |
| [binary](/ja/grammar/value/binary/) | BINARY | UUID、ダイジェスト、CRC、ネットワークアドレス、不明バイト列、ビットベクトル |
| [vector](/ja/grammar/value/vector/) | NUMERIC | 整数・実数の密ベクトル、点・バウンディングボックス、RGBA・BGRA ピクセル |
| [tensor](/ja/grammar/value/tensor/) | NUMERIC | 形式・rank・shape を付けた dense・packed テンソル |
| [etc](/ja/grammar/value/etc/) | NUMERIC | 複素数、分数、閉区間、四元数 |

- vector、tensor、etc のまとまりは、すべて NUMERIC 系列の Issuer 形式(ADHOC、KHRONOS)だ。

## テキスト

言語のあるテキストとないテキストは、異なる値だ。"Paris"(文字列)と "Paris"(フランス語)は同じではない。

| 形式 | 使う場所 |
|---|---|
| UTF8-TEXT | 識別子、コード、ファイル名、外部 ID のように言語のない文字列 |
| UTF8-LANGUAGE-TEXT | 名前、タイトル、文のように言語のあるテキスト |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 1LLL L100 101P   (P = テキストが奇数バイト)
[Length 拡張 TAG]
言語              LANGUAGE-SHORT-CODE または LANGUAGE-BCP47-CODE レコード
テキスト          UTF-8 バイト (奇数なら最後に 0x00)
```

- テキストは well-formed な UTF-8 で、原文のまま保存する。正規化は、比較・インデックスする側が担う。
- 複数の言語に共通の名前は言語 `mul`、言語未定は `und` で書く。言語の内容がない文字列は UTF8-TEXT だ。

例: `"Douglas Adams"@en` (13 バイト、奇数)

```
0CCB  08C6 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   言語 en    D o  u g  l a  s ␠  A d  a m  s (パディング)
```

## 10進数と数量

正確な10進数は `C × 10^E` で書く。指数 `E` は 32 ビット、係数 `C` は最小 WORD の2の補数だ。元の表記の桁数をそのまま収める: `1.20` は `C=120, E=−2`、`1.2` は `C=12, E=−1` だ。二つの表記は同じ数を表すが、バイトが異なる別個のレコードだ。エンコーダは表記を勝手に正規化しない。二つのレコードの値の同値性と quantum(有効数字)の意味は未解決の問題だ([SIGNED-DECIMAL](/ja/grammar/value/decimal/signed-decimal/#未解決の問題))。

QUANTITY は、量と単位、境界を一つの値に収める。

```
TAG WORD          0000 1LLL L000 0110
[Length 拡張 TAG]
量                SIGNED-DECIMAL レコード
単位              Reference レコード (単位項目)、単位なしなら 0x0000
下限              SIGNED-DECIMAL レコード、省略なら 0x0000 ABSENT
上限              SIGNED-DECIMAL レコード、省略なら 0x0000 ABSENT
```

- 単位は値の一部だ。単位を切り離して別の場所に書かない(切り離すと `652` が km か m か分からない)。
- SI 単位に換算した値は収めない。単位と換算表から計算できる。
- `0x0000` は、オプションフィールドを省略したというマーカー ABSENT だ([Codec 規格ドキュメント](/ja/grammar/codec-spec/))。

例: `652 km`、範囲 `[651, 653]` (km = Wikidata Q828224)

```
0F06 0011                    TAG (拡張長さ 17 WORD)
0990 0000 0000 028C          量 652
0120 000C A340               単位 Q828224
0990 0000 0000 028B          下限 651
0990 0000 0000 028D          上限 653
```

## 日付

| 精度 | 形式 |
|---|---|
| 日付(グレゴリオ暦) | GREGORIAN-DATE |
| 年・月、不確実(`1971~`)、区間 | EDTF |
| 他の暦の原表記(ユリウス暦など) | GEDCOM-DATE |
| 時刻 | POSIX・TAI・GPS タイムスタンプ |

- GREGORIAN-DATE で書ける日付は EDTF で書かない。

## 未解決の問題

- 公開メディア形式(JPEG、PNG、MP4、MOV など)は、IANA Issuer(`0x0021`)の BINARY 形式番号で置く。メディアタイプと形式番号の対応表の管理方式。
- Value 直接コードの最終一覧。法令・業務会話のサンプルの Value 頻度を測定して決める(金額、パーセント、日付区間が候補)。
- 小さなスカラー 7 個(ADHOC BFLOAT16、ONNX FP8 4 種、OCP FP8-E8M0FNU・FP4-E2M1FN)の詳細規格と配置。NUMERIC 直接コードの予約区間(`0x07`~`0x0F`)に移すかは決めていない。今は形式番号だけを割り当てている。
