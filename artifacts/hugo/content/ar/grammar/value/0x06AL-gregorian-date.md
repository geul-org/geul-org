---
title: "GREGORIAN-DATE (0x06AL)"
weight: 106
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE عدد أيام signed يعدّ proleptic Gregorian 1970-01-01 اليوم 0."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `GREGORIAN-DATE` (مستند المواصفة BIND `GREGORIAN-DATE`) |
| TAG ID | `0x06AL` |
| Codec ID | `0x000006A0` |
| مستند المواصفة | `0x00000000/codecs/0x000006A0/` (هدف DECLARE هو `06A0`) |
| القسم | 3 `0011` (Value)، الإزاحة داخل القسم C = 10 |
| Kind | Value · العائلة: TIME |
| TAG WORD | `0000 0110 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | عدد أيام signed بالنسبة إلى proleptic Gregorian `1970-01-01` |
| جهة Hugo | `value/time/gregorian-date.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `days` | #2 | قيمة خام 2 WORD |  |  |

GREGORIAN-DATE عدد أيام signed يعدّ proleptic Gregorian `1970-01-01` اليوم 0. لا تُحفظ المنطقة الزمنية ولا الوقت من اليوم.

## التخطيط {#레이아웃}

- الرمز: رمز مباشر في Value هو `0x06AL`. العائلة TIME.
- يستخدم النوع الفيزيائي signed int32 ثابت العرض نفسه في Arrow Date32 وParquet `DATE`.

```
TAG WORD          0x06A2 (0000 0110 1010 0010)  المجموع 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## التفسير والصلاحية {#해석과-유효성}

- يُقرأ Payload كله (WORD اثنتان) على أنه عدد أيام signed بمتمم الاثنين ذي 32 بت بترتيب WORD من نوع big-endian.
- المدى الصالح هو من `-2^31` إلى `2^31-1` يوماً. والقيمة السالبة تاريخ قبل epoch.
- عند حساب السنة والشهر واليوم من عدد الأيام يُستخدم تقويم proleptic Gregorian دون أي انتقال تقويمي تاريخي.
- تُستخدم دائماً WORD اثنتان حتى للقيم الصغيرة.

## الطول {#길이}

- المجموع هو TAG (1 WORD) وPayload (2 WORD)، أي 3 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0010`. لا يوجد TAG ممتد لـ Length ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه WORD اثنتين تماماً.

## مثال {#예시}

| التاريخ | Payload | Length الكلي |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `FFFF FFFF` | 3 WORD (`LLLL=0010`) |

## العلاقة بـ EDTF {#edtf와의-관계}

- الدقة الأقل من اليوم، وعدم اليقين والتقريب، والفترات تُكتب بـ [EDTF](0x06EL-edtf.md). أما التاريخ الذي يمكن كتابته بدقة بـ GREGORIAN-DATE فلا يُكتب بـ EDTF (الصيغة القياسية لـ EDTF).

## الأساس المعياري {#표준-근거}

- `DATE` في [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) هو `int32` يخزن عدد الأيام منذ 1970-01-01 (Unix epoch) ويستخدم ترتيب signed.
- Date32 في [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) وفي [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) المرجعي يخزن عدد الأيام منذ Unix epoch بعدد صحيح signed من 32 بت.
- حساب proleptic Gregorian هو calendar profile في GEUL تعتمده هذه الصيغة. يبقى معنى int32 لعدد الأيام في Arrow/Parquet كما هو، ولا يُضاف إلا TAG وإطار WORD ذي 16 بت بترتيب big-endian.

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يظهر عند قراءة مستند المواصفة `0x00000000/codecs/0x000006A0/latest.geul` بالأمر `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006A000000000
BODY
#1 DECLARE 0x06A0
#2 FIELD #1 0x0002
#3 BIND #1 "GREGORIAN-DATE"
#4 BIND #2 "days"
```
