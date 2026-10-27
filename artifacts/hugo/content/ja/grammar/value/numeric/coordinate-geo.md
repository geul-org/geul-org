---
title: "COORDINATE-GEO"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO は、天体 Reference と緯度・経度 binary64、不確かさ binary32 とその単位 Reference で、惑星・衛星などの天体上の一点を収める Value だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-GEO は、指定した天体(惑星、衛星、小惑星など)上の一点を、緯度・経度と不確かさで表す座標 Value だ。Value 直接コード `0x05`、系列 NUMERIC だ。[COORDINATE-EARTH](/ja/grammar/value/numeric/coordinate-earth/)(`0x04`)の前に天体(Globe)Reference を加えた形式で、緯度・経度・不確かさ・単位の規則は COORDINATE-EARTH と同じだ。

## レイアウト

```
TAG WORD          0000 1LLL L000 0101      Codec 0x05
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Globe             Reference レコード 1個 (天体を指す Reference、Quantifier Identified)
Latitude          4 WORD 生値、IEEE 754 binary64 (度)
Longitude         4 WORD 生値、IEEE 754 binary64 (度)
Uncertainty       2 WORD 生値、IEEE 754 binary32 (Unit の単位)
Unit              Reference レコード 1個、またはプレースホルダ 0x0000 ABSENT
```

## 解釈と有効性

- Payload は Globe レコードで始まる。Globe は完全な Reference レコードがちょうど一つで、Quantifier は Identified(`000`)だ。天体を指す任意の Reference が使える: [WIKIDATA-QID](/ja/grammar/reference/wikidata-qid/)(名前のある天体)、[GEUL](/ja/grammar/reference/geul/)、同じドキュメントの [LOCAL](/ja/grammar/reference/local/)(ドキュメント内で定義した天体)、他のドキュメントの天体([EXTERNAL-POINTER](/ja/grammar/reference/external-pointer/)・[EXTERNAL-ISSUER](/ja/grammar/reference/external-issuer/))など。天体は無数にあり、QID のある天体はその一部だ。
- Globe の後ろに、10 WORD(Latitude 4、Longitude 4、Uncertainty 2)と Unit レコード一つが来る。Unit を読み終えたカーソルは、レコードの終わりと合わなければならない。
- Latitude は `-90 ≤ φ ≤ 90`、Longitude は `-180 ≤ λ ≤ 360` だ。`(180, 360]` は、経度を 0~360° で数える天体の座標系の値をそのまま収めるために許す。その他の規則(binary64、有限値、軸の順序、Uncertainty・Unit の意味、不明の表現)は COORDINATE-EARTH と同じだ。
- 座標系は、天体ごとにその天体の慣例に従う(惑星中心緯度、東経または西経 0~360° など)。天体ごとの座標系は、別の GEUL ドキュメントで定める。
- 距離単位(メートルなど)の Uncertainty は、天体表面上の距離だ。角度単位(度・分角・秒角)は、天体の大きさと関係なく、緯度・経度の角度半径だ。
- 地球(Q2)の座標は、COORDINATE-EARTH を使うことを勧める。この形式に地球を書いても invalid ではなく、比較する側が同じ座標として突き合わせる。
- geul.org 規格ドキュメント `0x0000/0x0000000000000805` は、Latitude・Longitude・Uncertainty の生値フィールドに [CODEC](/ja/grammar/edge/codec/) BINARY-FLOAT(`0803`)を、Unit のレコードフィールドに CODEC `0780`(任意の Reference)・`0000`(ABSENT)を置く。

## 長さ

- 全体は、TAG 1 WORD + (Length 拡張 TAG)+ Globe レコード + 10 WORD + Unit レコードだ。
- Globe が 2 WORD(QID が 1 WORD に収まるとき)で Unit が ABSENT なら 14 WORD、`LLLL=1101`、TAG `0E85` だ。Unit が Reference(2 WORD 以上)なら 15 WORD を超えて拡張長さを使う: TAG `0F05`、次の WORD に全体の WORD 数([レコードと TAG WORD](/ja/grammar/record/))。

## Wikidata との対応

- globe が地球(Q2)ではない globecoordinate は、この形式で書く。Globe = WIKIDATA-QID(globe 項目)。緯度・経度、precision → Uncertainty・Unit の対応は COORDINATE-EARTH と同じだ(precision は度単位の記録解像度なので、天体の大きさと関係なくそのまま移す)。
- Wikidata サンプル(座標 claim 約 2.4 万件)の地球外の天体: 火星(Q111)、ケレス(Q596)、月(Q405)、水星(Q308)、金星(Q313)など 23 件。globe が空の 41 件は変換せず、原文を UTF8-TEXT で保存する。

## 例

火星(Q111) 4.5, 137.4、不確かさ不明:

```
0E85 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `0E85`(Codec `0x05`、`LLLL=1101`、14 WORD)、Globe `00A0 006F`(WIKIDATA-QID Q111)、Latitude `4012 0000 0000 0000`、Longitude `4061 2CCC CCCC CCCD`、Uncertainty `0000 0000`(+0)、Unit `0000`(ABSENT、不明)。
- テキスト表記: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`。

同じ点、precision 0.1°(Unit 度 Q28390):

```
0F05 0010 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 00A0 6EE6
```

- TAG `0F05`(`LLLL=1110`、拡張長さ)、全体 `0010`(16 WORD)、Uncertainty `3DCC CCCD`(binary32 0.1)、Unit `00A0 6EE6`(Q28390)。

## 標準の根拠

- 意味: [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) の緯度・経度・`u`(Unit がメートルのとき)。RFC 5870 の `crs` に登録された座標系は `wgs84` だけなので、地球外の天体は GEUL の Globe Reference で指定する。
- 数値: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64(緯度・経度)、binary32(不確かさ)。

## 未解決の問題

1. 天体ごとの座標系ドキュメント: 天体ごとの緯度の定義(惑星中心・惑星面)と経度の方向・範囲。

## 関連ページ

- [Value](/ja/grammar/value/)、[COORDINATE-EARTH](/ja/grammar/value/numeric/coordinate-earth/)、[WIKIDATA-QID](/ja/grammar/reference/wikidata-qid/)、[GEUL](/ja/grammar/reference/geul/)、[LOCAL](/ja/grammar/reference/local/)
