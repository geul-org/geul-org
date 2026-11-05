---
title: "Value"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value は値そのものを収めるレコードである。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value は値そのものを収めるレコードである。Codec が Payload の解釈を定める。

## レイアウト {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      セクション 3·4 (0x060L~0x09FL)
[Length 拡張 TAG]
[Codec 拡張 TAG]  Issuer 形式のとき
Payload
```

- `LLLL` は TAG WORD を含む全体の WORD 数 − 1 である。1~14 WORD は直接長、15 WORD 以上は拡張長である。
- Issuer 形式なら、Codec 拡張 TAG に Issuer(Codec が定める幅 2/4/16 WORD)と Codec 番号 2 WORD を置く。Codec 番号は Issuer が定める。
- デコーダは形式を知らなくても Kind、Length、Issuer、Codec 番号までは分かる。

## 系列 {#계열}

Value の番号は系列を意味しない。直接コードはビットで系列を表さず、Issuer 形式にも系列の規則はない。系列は主題によるまとまりである。

| 系列 | 直接コード |
|---|---|
| NUMERIC | `0x060L~0x067L` |
| DECIMAL | `0x068L~0x069L` |
| TIME | `0x06AL~0x071L`, `0x081L` |
| TEXT | `0x072L~0x07AL` |
| BINARY | `0x07BL~0x080L` |

- ベクトル、テンソル、複素数、分数、区間のような数値は NUMERIC である。例外として BIT-VECTOR は BINARY である。言語コードは TEXT である。
- Issuer 形式のレコードには Codec 拡張 TAG(Issuer と Codec 番号)が付く。Payload が長ければ(全体 15 WORD 以上)Length 拡張 TAG を使う。

## 直接コード {#직접-코드}

| Codec | 名前 | 系列 | 説明 |
|---|---|---|---|
| `0x060L` | [BOOL](0x060L-bool.md) | NUMERIC | false または true |
| `0x061L` | [SIGNED-INTEGER](0x061L-signed-integer.md) | NUMERIC | 最小 WORD の 2 の補数整数 |
| `0x062L` | [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) | NUMERIC | 最小 WORD の符号なし整数 |
| `0x063L` | [BINARY-FLOAT](0x063L-binary-float.md) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x064L` | [COORDINATE-EARTH](0x064L-coordinate-earth.md) | NUMERIC | 地球(WGS 84)の緯度·経度と不確かさ(単位 Reference) |
| `0x065L` | [COORDINATE-GEO](0x065L-coordinate-geo.md) | NUMERIC | 天体 Reference と緯度·経度、不確かさ(単位 Reference) |
| `0x066L` | [QUANTITY](0x066L-quantity.md) | NUMERIC | 数値の量(整数·BINARY-FLOAT·10 進数·分数)、単位 Reference、下限·上限 |
| `0x067L` | [FRACTION](0x067L-fraction.md) | NUMERIC | 表記を保存する分数(分子·分母レコード、約分しない) |
| `0x068L` | [SIGNED-DECIMAL](0x068L-signed-decimal.md) | DECIMAL | `C × 10^E`、符号付き係数 |
| `0x069L` | [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) | DECIMAL | `C × 10^E`、符号なし係数 |
| `0x06AL` | [GREGORIAN-DATE](0x06AL-gregorian-date.md) | TIME | 1970-01-01 からの日数 (グレゴリオ暦) |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](0x06BL-civil-time-nanoseconds.md) | TIME | 零時からのナノ秒 |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](0x06CL-posix-timestamp-seconds.md) | TIME | Unix epoch からの秒 |
| `0x06DL` | [DURATION-SECONDS](0x06DL-duration-seconds.md) | TIME | 経過時間(秒) |
| `0x06EL`/`0x06FL` | [EDTF](0x06EL-edtf.md) | TIME | ISO 8601-2 拡張日付文字列 (年·月精度、不確実、区間) |
| `0x070L`/`0x071L` | [GEDCOM-DATE](0x070L-gedcom-date.md) | TIME | GEDCOM 7 日付文字列 (ユリウス暦など他の暦) |
| `0x072L`/`0x073L` | [UTF8-TEXT](0x072L-utf8-text.md) | TEXT | 言語を持たない UTF-8 文字列 |
| `0x074L`/`0x075L` | [URI](0x074L-uri.md) | TEXT | RFC 3986 URI |
| `0x076L`/`0x077L` | [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) | TEXT | BCP 47 言語タグ |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md) | TEXT | 言語付きテキスト |
| `0x07AL` | [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) | TEXT | 1 WORD の圧縮言語コード |
| `0x07BL` | [UUID](0x07BL-uuid.md) | BINARY | RFC 9562 UUID |
| `0x07CL` | [SHA-256-DIGEST](0x07CL-sha-256-digest.md) | BINARY | SHA-256 の結果 |
| `0x07DL` | [SHA1-DIGEST](0x07DL-sha1-digest.md) | BINARY | SHA-1 の結果 (git オブジェクト ID のような識別用途) |
| `0x07EL`/`0x07FL` | [OPAQUE-BYTES](0x07EL-opaque-bytes.md) | BINARY | 意味·形式が不明のバイト列。偶数·奇数バイト |
| `0x080L` | [BIT-VECTOR](0x080L-bit-vector.md) | BINARY | bit-count の後に MSB-first で保存した N bit |
| `0x081L` | [DURATION-NANOSECONDS](0x081L-duration-nanoseconds.md) | TIME | 経過時間(ナノ秒) |

- 偶奇でペアにしたコードは可変長のバイト列である。偶数コードはバイト数が偶数、奇数コードは奇数である([レコードと TAG WORD](../record.md))。
- 直接コードは `0x060L~0x081L` に Reserved なしで並ぶ。`0x082L~0x09CL` は Reserved で、`0x09DL~0x09FL` は [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md)·[4WORD](0x09EL-value-issuer-4word.md)·[16WORD](0x09FL-value-issuer-16word.md) である。

## Issuer 形式 {#issuer-형식}

直接コードにない形式は、その形式を制定した団体の Issuer の下に Codec 番号として置く。制定団体のない慣例の形式は ADHOC(`0x00000002`)の下に置く。GEUL 固有の形式(OPAQUE-BYTES、BIT-VECTOR、DURATION-NANOSECONDS)は直接コードである。

| Issuer | 形式の例 |
|---|---|
| ADHOC `0x00000002` | BFLOAT16、整数·実数ベクトル、テンソル、複素数、分数、区間、四元数、BLAKE3 |
| IETF `0x00000007` | 相対 URI、CRC32C、IPv4·IPv6 アドレス |
| IEEE `0x0000000D` | IEEE 754 decimal32/64/128、POSIX ナノ秒タイムスタンプ、MAC アドレス |
| KHRONOS `0x0000000E` | RGBA8·BGRA8 ピクセル |
| ONNX `0x00000010`, OCP `0x00000011` | FP8, FP4 |
| BIPM `0x00000013` | TAI タイムスタンプ |
| NIST `0x00000015` | SHA-512, SHA3-256 |
| GPS `0x00000016` | GPS タイムスタンプ |

- 形式を知らないデコーダは、Issuer と Codec 番号までを知り、Length で読み飛ばす。
- Codec ドキュメントはその Issuer の `codecs/` の下に、レコードの Codec 番号で置く。例: IETF CRC32C は `0x00000007/codecs/0x0000C000/` である([公表アドレスとバージョン一覧](../publishing.md))。
- 画像·動画のような大きな値は、直接入れるより URI と SHA-256 で参照することを勧める。
- バイト列の中の著作物は元のライセンスに従う。出典とライセンスは Meta で記録する。

## 形式のまとまり {#형식-묶음}

まとまりごとの説明は下にある。各形式のレイアウト、解釈、有効性、例は形式別のドキュメントにある。

| まとまり | 系列 | 形式 |
|---|---|---|
| [numeric](#numeric) | NUMERIC | BOOL、整数、浮動小数、座標、QUANTITY、FRACTION |
| [decimal](#decimal) | DECIMAL | SIGNED-DECIMAL、UNSIGNED-DECIMAL、IEEE 754 decimal32/64/128 |
| [time](#time) | TIME | 日付、時刻、タイムスタンプ、経過時間、EDTF、GEDCOM 日付 |
| [text](#text) | TEXT | UTF-8 テキスト、言語付きテキスト、URI、言語コード |
| [binary](#binary) | BINARY | UUID、ダイジェスト、CRC、ネットワークアドレス、不明バイト列、ビットベクトル |
| [vector](#vector) | NUMERIC | 整数·実数の密ベクトル、点·境界ボックス、RGBA·BGRA ピクセル |
| [tensor](#tensor) | NUMERIC | 形式·rank·shape を付けた dense·packed テンソル |
| [etc](#etc) | NUMERIC | 複素数、分数、閉区間、四元数 |

- vector、tensor、etc のまとまりはすべて NUMERIC 系列の Issuer 形式(ADHOC、KHRONOS)である。

### numeric {#numeric}

NUMERIC 系列の基本的な数の形式である。直接コード `0x060L~0x067L` に置く。

- BOOL、符号付き·符号なし整数、IEEE 754 binary 浮動小数、地球(WGS 84)·天体の座標、量·単位·境界をまとめた QUANTITY、原文の表記どおりの分数 FRACTION がある。
- 整数は値が入る最小の WORD で書く。
- 小さなスカラの Issuer 形式(BFLOAT16、FP8、FP4)は Codec 番号だけが割り当てられていて、詳細な規格がない([Value](#열린-문제)の未解決の問題)。
- ベクトル、テンソル、複素数、既約分数(RATIONAL-I64)、区間も NUMERIC 系列だが Issuer 形式なので、[vector](#vector)、[tensor](#tensor)、[etc](#etc) のまとまりに置く。

### decimal {#decimal}

DECIMAL 系列は正確な 10 進数の形式である。直接コード `0x068L~0x069L` に置く。

- 直接コード SIGNED-DECIMAL·UNSIGNED-DECIMAL は `C × 10^E` で書き、元の表記の桁数をそのまま収める。`1.20`(`C=120, E=−2`)と `1.2`(`C=12, E=−1`)は別のレコードである。値の等価性と quantum の保存は [SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제) の未解決の問題である。
- IEEE 754 decimal32/64/128 の DPD·BID エンコーディングは IEEE Issuer(`0x0000000D`)の形式である。

### time {#time}

TIME 系列は日付と時刻の形式である。直接コード `0x06AL~0x071L` と `0x081L`(DURATION-NANOSECONDS)に置く。

| 精度 | 形式 |
|---|---|
| 日付(グレゴリオ暦) | GREGORIAN-DATE |
| 年·月、不確実、区間 | EDTF |
| 他の暦の原表記(ユリウス暦など) | GEDCOM-DATE |
| 時刻 | POSIX·TAI·GPS タイムスタンプ |
| 経過時間 | DURATION-SECONDS、DURATION-NANOSECONDS |

- GREGORIAN-DATE で書ける日付は EDTF で書かない。
- ナノ秒タイムスタンプと TAI·GPS 形式は、各標準団体の Issuer(IEEE、BIPM、GPS)の下の形式である。

### text {#text}

TEXT 系列はテキストと文字列識別子の形式である。直接コード `0x072L~0x07AL` に置く。

- 言語を持たない文字列は UTF8-TEXT、名前·題名·文のように言語を持つテキストは UTF8-LANGUAGE-TEXT である。
- 言語コード(LANGUAGE-SHORT-CODE、LANGUAGE-BCP47-CODE)も TEXT 系列である。
- 可変長のバイト列は偶奇の Codec ペアで置く。最下位ビットが `1` ならバイト数が奇数で、最後の WORD の下位バイトは `0x00` のパディングである([レコードと TAG WORD](../record.md))。

### binary {#binary}

BINARY 系列はバイト列の形式である。直接コード `0x07BL~0x080L` に置く。

- UUID、SHA-256、SHA-1、不明バイト列(OPAQUE-BYTES)、ビットベクトル(BIT-VECTOR)は直接コードである。残りのダイジェスト、CRC32C、IPv4·IPv6·MAC アドレスは Issuer 形式である。
- 固定サイズの値(UUID、ダイジェスト、アドレス)はサイズが決まっているので、偶奇のペアを置かない。
- 画像·動画のような公開メディアは IANA Issuer(`0x00000008`)の形式として置く。Codec 番号は偶奇のペアで割り当て、Payload はバイト列である。Length の上限は 2^32−1 WORD である。大きな値は直接入れるより URI と SHA-256 で参照することを勧める。
- バイト列の中の著作物は元のライセンスに従う。出典とライセンスは Meta で記録する。

### vector {#vector}

ベクトル形式は NUMERIC 系列の Issuer 形式である。整数·実数の密ベクトルと点·境界ボックスは ADHOC(`0x00000002`)の Codec 番号 `0x00000500`~`0x0000050C`、ピクセル形式は KHRONOS(`0x0000000E`)の下に置く。

- 密ベクトルの要素は big-endian で連続して保存する。
- Issuer 形式なので、Codec 拡張 TAG に Issuer 2 WORD と Codec 番号 2 WORD が付く。

### tensor {#tensor}

テンソル形式は NUMERIC 系列の Issuer 形式である。ADHOC(`0x00000002`)の Codec 番号 `0x00000600`~`0x00000601` に置く。

- DESCRIBED-DENSE-TENSOR は要素形式·rank·shape と C-contiguous の dense payload を収める。
- DESCRIBED-PACKED-TENSOR は packed 形式·rank·shape と、octet 内 low-bit-first の packed payload を収める。

### etc {#etc}

その他の数の形式は NUMERIC 系列の Issuer 形式である。ADHOC(`0x00000002`)の Codec 番号 `0x00000700`~`0x00000704` に置く。

- 複素数(COMPLEX64、COMPLEX128)、正規化した分数(RATIONAL-I64)、binary64 の閉区間、binary32 の四元数がある。

## テキスト {#텍스트}

言語を持つテキストと持たないテキストは別の値である。"Paris"(文字列)と "Paris"(フランス語)は等しくない。

| 形式 | 使う場所 |
|---|---|
| UTF8-TEXT | 識別子、コード、ファイル名、外部 ID のように言語を持たない文字列 |
| UTF8-LANGUAGE-TEXT | 名前、題名、文のように言語を持つテキスト |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 0111 100P LLLL   (P = テキストが奇数バイト)
[Length 拡張 TAG]
言語              LANGUAGE-SHORT-CODE または LANGUAGE-BCP47-CODE レコード
テキスト          UTF-8 バイト (奇数なら最後に 0x00)
```

- テキストは well-formed な UTF-8 で、原文のまま保存する。正規化は比較·索引する側が受け持つ。
- 複数の言語に共通する名前は言語 `mul`、言語未定は `und` と書く。言語的内容のない文字列は UTF8-TEXT である。

例: `"Douglas Adams"@en` (13 バイト、奇数)

```
0799  0761 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   言語 en    D o  u g  l a  s ␠  A d  a m  s (パディング)
```

## 10 進数と数量 {#10진수와-수량}

正確な 10 進数は `C × 10^E` で書く。指数 `E` は 32 ビット、係数 `C` は最小 WORD の 2 の補数である。元の表記の桁数をそのまま収める: `1.20` は `C=120, E=−2`、`1.2` は `C=12, E=−1` である。二つの表記は同じ数を表すが、バイトが異なる別のレコードである。エンコーダは表記を勝手に正規化しない。二つのレコードの値の等価性と quantum(有効数字)の意味は未解決の問題である([SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제))。

QUANTITY は量と単位、境界を一つの値に収める。

```
TAG WORD          0000 0110 0110 LLLL
[Length 拡張 TAG]
量                数値 Value レコード (整数·BINARY-FLOAT·10 進数·分数)
単位              Reference レコード (単位の項目)、単位なしなら 0x0000
下限              数値 Value レコード、省略すれば 0x0000 ABSENT
上限              数値 Value レコード、省略すれば 0x0000 ABSENT
```

- 単位は値の一部である。単位を切り離して別の場所に書かない(切り離すと `652` が km か m か分からない)。
- SI 単位に換算した値は収めない。単位と換算表から計算できる。
- `0x0000` は選択フィールドを省略したことを示す標識 ABSENT である([Codec 規格ドキュメント](../codec-spec.md))。

例: `652 km`、範囲 `[651, 653]` (km = Wikidata Q828224)

```
066E 0011                    TAG (拡張長 17 WORD)
0683 0000 0000 028C          量 652
0142 000C A340               単位 Q828224
0683 0000 0000 028B          下限 651
0683 0000 0000 028D          上限 653
```

## 日付 {#날짜}

| 精度 | 形式 |
|---|---|
| 日付(グレゴリオ暦) | GREGORIAN-DATE |
| 年·月、不確実(`1971~`)、区間 | EDTF |
| 他の暦の原表記(ユリウス暦など) | GEDCOM-DATE |
| 時刻 | POSIX·TAI·GPS タイムスタンプ |

- GREGORIAN-DATE で書ける日付は EDTF で書かない。

## 未解決の問題 {#열린-문제}

- 公開メディア形式(JPEG、PNG、MP4、MOV など)は IANA Issuer(`0x00000008`)の Codec 番号として置く。メディアタイプと Codec 番号の対応表の管理方法。
- Value 直接コードの最終的な一覧。法令·業務会話のサンプルで Value の頻度を測って決める(金額、百分率、日付区間の候補)。
- 小さなスカラ 7 個(ADHOC BFLOAT16、ONNX FP8 4 種、OCP FP8-E8M0FNU·FP4-E2M1FN)の詳細な規格と配置。直接コードに移すかは決めていない。今は Codec 番号だけが割り当てられている。
