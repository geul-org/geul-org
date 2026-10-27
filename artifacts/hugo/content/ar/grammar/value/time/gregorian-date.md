---
title: "GREGORIAN-DATE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE قيمة Value تحمل عدد الأيام signed int32 بجعل 1970-01-01 في proleptic Gregorian هو اليوم 0 (Codec 0x20)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GREGORIAN-DATE هو عدد أيام signed بجعل `1970-01-01` في proleptic Gregorian هو اليوم 0. لا يحمل المنطقة الزمنية ولا الوقت من اليوم.

## التخطيط

- الرمز: الرمز المباشر في Value هو `0x20`. العائلة TIME.
- يستخدم النوع الفيزيائي signed int32 ثابت العرض نفسه في Arrow Date32 وParquet `DATE`.

```
TAG WORD          0x0920 (0000 1001 0010 0000)  المجموع 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## التفسير والصلاحية

- تُقرأ WORD الاثنتان في Payload كلهما كعدد أيام signed من 32 بت بمتمم اثنين بترتيب WORD وفق big-endian.
- النطاق الصالح هو `-2^31`~`2^31-1` يوماً. القيمة السالبة تاريخ قبل epoch.
- عند حساب السنة والشهر واليوم من عدد الأيام يُستخدم تقويم proleptic Gregorian دون أي تحول تاريخي في التقويم.
- القيم الصغيرة أيضاً تستخدم 2 WORD دائماً.

## الطول

- المجموع هو TAG (1 WORD) وPayload (2 WORD)، أي 3 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0010`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 2 WORD تماماً.

## أمثلة

| التاريخ | Payload | الطول الكلي |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `ffff ffff` | 3 WORD (`LLLL=0010`) |

## العلاقة مع EDTF

- الدقة الأخشن من اليوم وعدم اليقين والتقريب والفترات تُكتب بـ [EDTF](/ar/grammar/value/time/edtf/). التاريخ الذي يمكن كتابته بدقة بـ GREGORIAN-DATE لا يُكتب بـ EDTF (الصيغة القياسية في EDTF).

## السند المعياري

- `DATE` في [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) هو `int32` يخزّن عدد الأيام منذ 1970-01-01 (Unix epoch) ويستخدم ترتيب signed.
- يخزّن Date32 في [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) و[Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) المرجعي عدد الأيام منذ Unix epoch كعدد صحيح signed من 32 بت.
- حساب proleptic Gregorian هو calendar profile في GEUL اعتمدته هذه الصيغة. يبقى معنى عدد الأيام int32 في Arrow/Parquet كما هو، ولا يُضاف سوى TAG وframing بـ WORD ذات 16 بت وفق big-endian.
