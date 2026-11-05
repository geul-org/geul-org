---
title: "EXTERNAL-ISSUER-2WORD (0x02FL~0x033L)"
weight: 47
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER هو Reference إشاري تصريحي يقتبس LOCAL ID في مستند نشره Issuer بسجل واحد دون IMPORT."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER هو Reference إشاري تصريحي يقتبس LOCAL ID في مستند نشره Issuer بسجل واحد دون IMPORT.

| البند | القيمة |
|---|---|
| الاسم | `EXTERNAL-ISSUER-2WORD` (حزمة 5Q. اسم كل رمز في جدول الأعضاء أدناه) |
| TAG ID | `0x02FL~0x033L` |
| القسم | 1 `0001` (Reference EXTERNAL)، الإزاحة داخل القسم C = 15~19 |
| Kind | Reference · التصنيف: إشاري تصريحي |
| جهة Hugo | `reference/external-issuer.md` (تتناول تلك الصفحة أيضًا [EXTERNAL-ISSUER-4WORD](0x034L-external-issuer-4word.md) و[EXTERNAL-ISSUER-16WORD](0x039L-external-issuer-16word.md)) |

## الأعضاء {#구성원}

تتناول هذه الصفحة منظومة 5Q واحدة، أي خمسة رموز معًا. التكميم هو الإزاحة داخل القسم `C % 5` ([Reference](_index.md#quantifier)). لكل رمز مستند Codec واحد. حقول مستندات Codec الخمسة واحدة، ويختلف فقط هدف DECLARE والاسم (BIND).

| TAG ID | الاسم | التكميم | Codec ID | مستند المواصفة | TAG WORD |
|---|---|---|---|---|---|
| `0x02FL` | `EXTERNAL-ISSUER-2WORD-IDENTIFIED` | Identified | `0x000002F0` | `0x00000000/codecs/0x000002F0/` | `0000 0010 1111 LLLL` |
| `0x030L` | `EXTERNAL-ISSUER-2WORD-GENERIC` | Generic | `0x00000300` | `0x00000000/codecs/0x00000300/` | `0000 0011 0000 LLLL` |
| `0x031L` | `EXTERNAL-ISSUER-2WORD-FREE-CHOICE` | Free-choice | `0x00000310` | `0x00000000/codecs/0x00000310/` | `0000 0011 0001 LLLL` |
| `0x032L` | `EXTERNAL-ISSUER-2WORD-UNIVERSAL` | Universal | `0x00000320` | `0x00000000/codecs/0x00000320/` | `0000 0011 0010 LLLL` |
| `0x033L` | `EXTERNAL-ISSUER-2WORD-VARIABLE` | Variable | `0x00000330` | `0x00000000/codecs/0x00000330/` | `0000 0011 0011 LLLL` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | قيمة خام 2 WORD |  |  |
| 2 | `doc` | #3 | قيمة خام 4 WORD |  |  |
| 3 | `target-id` | #4 | قيمة خام متبقية (`0xFFFF`) |  |  |

EXTERNAL-ISSUER هو Reference إشاري تصريحي يقتبس LOCAL ID في مستند نشره Issuer دون IMPORT. يكتمل معناه بسجل واحد ويتبع أحدث إصدار.

## التخطيط {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x02FL~0x03DL (القسم 1)
[TAG الامتداد Length]
Issuer            العرض الذي تحدده Codec (2/4/16 WORD)
معرّف المستند     4 WORD
معرّف الهدف       كل ما تبقى. LOCAL ID في ذلك المستند، بأقصر عرض
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | الاسم | عرض Issuer |
|---|---|---|
| `0x02FL~0x033L` | EXTERNAL-ISSUER-2WORD | 2 WORD (تسجيل في geul.org، إثبات النطاق) |
| `0x034L~0x038L` | EXTERNAL-ISSUER-4WORD | 4 WORD (تسجيل في geul.org، بلا إثبات) |
| `0x039L~0x03DL` | EXTERNAL-ISSUER-16WORD | 16 WORD (يُحسب من المفتاح العام) |

- يتحدد العرض برقم المنظومة: إذا كان (رقم المنظومة − 9) (أي `C / 5 − 3` للإزاحة داخل القسم `C`) يساوي 0 أو 1 أو 2 فالعرض 2 أو 4 أو 16 WORD. والتكميم هو `C % 5`.
- Issuer ID قيمة صحيحة. إذا تساوت القيمتان فهما الـIssuer نفسه. يُكتب Issuer بأقصر عرض تتسع له القيمة وتُختار Codec بذلك العرض (4 WORD فقط إذا كانت القيمة `2^32` فأكثر، و16 WORD فقط إذا كانت `2^64` فأكثر). والتمثيل بعرض أوسع invalid ([Issuer](../issuer.md)).
- يتولى geul.org تسجيل الـIssuer وإدارته.
- لا يُكتب الإصدار ويُتبع أحدث إصدار. ولتثبيت الإصدار يُستخدم [IMPORT-DOC](../meta/0x1E4L-import-doc.md) و[EXTERNAL-POINTER](0x020L-external-pointer-1word.md).
- يُعثر على الموقع بقاعدة عنوان النشر ([عنوان النشر وقائمة الإصدارات](../publishing.md)).
- إذا كان LOCAL ID في ذلك المستند واحدًا فهو الهدف نفسه، سواء كُتب LOCAL داخل ذلك المستند أو EXTERNAL-ISSUER في مستند آخر (أو EXTERNAL-POINTER بعد IMPORT).
- يشير إلى LOCAL في المستند فقط. يُشار إلى المستند نفسه بـ[DOC-POINTER](0x041L-doc-pointer.md)، وإلى الـIssuer نفسه بـ[ISSUER-POINTER](0x040L-issuer-pointer.md). لذلك لا يكون معرّف الهدف `0`. معرّف المستند `0` هو مستند فهرس تعريف مصطلحات الـIssuer.

## الصلاحية {#유효성}

- يكون invalid إذا لم يطابق عرض Issuer الـCodec، أو إذا كانت القيمة تتسع في عرض أضيق.
- يكون invalid إذا كان معرّف الهدف `0`. معرّف الهدف `0` (المستند نفسه) من اختصاص DOC-POINTER.
- يُمنع وجود WORD `0x0000` في بداية معرّف الهدف.

## مثال {#예시}

| الهدف | WORD sequence |
|---|---|
| Issuer `0x00000002`، المستند `0x…0002`، LOCAL 7 | `02F7 0000 0002 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`، المستند `0x…0002`، LOCAL 7 | `02F7 0001 2345 0000 0000 0000 0002 0007` |

## صفحات ذات صلة {#관련-페이지}

- [Reference](_index.md)، [DOC-POINTER](0x041L-doc-pointer.md)، [ISSUER-POINTER](0x040L-issuer-pointer.md)، [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Issuer والنشر](../issuer.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x000002F0/latest.geul` مقروءًا بـ`geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000002F000000000
BODY
#1 DECLARE 0x02F0
#2 FIELD #1 0x0002
#3 FIELD #1 0x0004
#4 FIELD #1 rest
#5 BIND #1 "EXTERNAL-ISSUER-2WORD-IDENTIFIED"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "target-id"
```

ما سبق هو مستند Codec لـ`EXTERNAL-ISSUER-2WORD-IDENTIFIED` (`0x02FL`). أما مستندات Codec للأعضاء الآخرين (`EXTERNAL-ISSUER-2WORD-GENERIC` و`EXTERNAL-ISSUER-2WORD-FREE-CHOICE` و`EXTERNAL-ISSUER-2WORD-UNIVERSAL` و`EXTERNAL-ISSUER-2WORD-VARIABLE`) فيختلف فيها فقط Codec ID في DOC-ID وهدف DECLARE والاسم المربوط (BIND) في `#1`.
