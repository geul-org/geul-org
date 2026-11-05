---
title: "EXTERNAL-POINTER-4WORD (0x02AL~0x02EL)"
weight: 42
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER هو Reference إشاري يشير إلى LOCAL ID في مستند استُورد بـIMPORT-DOC في HEAD."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER هو Reference إشاري يشير إلى LOCAL ID في مستند استُورد بـIMPORT-DOC في HEAD.

| البند | القيمة |
|---|---|
| الاسم | `EXTERNAL-POINTER-4WORD` (حزمة 5Q. اسم كل رمز في جدول الأعضاء أدناه) |
| TAG ID | `0x02AL~0x02EL` |
| القسم | 1 `0001` (Reference EXTERNAL)، الإزاحة داخل القسم C = 10~14 |
| Kind | Reference · التصنيف: إشاري |
| جهة Hugo | `reference/external-pointer.md` (تتناول تلك الصفحة أيضًا [EXTERNAL-POINTER-1WORD](0x020L-external-pointer-1word.md) و[EXTERNAL-POINTER-2WORD](0x025L-external-pointer-2word.md)) |

## الأعضاء {#구성원}

تتناول هذه الصفحة منظومة 5Q واحدة، أي خمسة رموز معًا. التكميم هو الإزاحة داخل القسم `C % 5` ([Reference](_index.md#quantifier)). لكل رمز مستند Codec واحد. حقول مستندات Codec الخمسة واحدة، ويختلف فقط هدف DECLARE والاسم (BIND).

| TAG ID | الاسم | التكميم | Codec ID | مستند المواصفة | TAG WORD |
|---|---|---|---|---|---|
| `0x02AL` | `EXTERNAL-POINTER-4WORD-IDENTIFIED` | Identified | `0x000002A0` | `0x00000000/codecs/0x000002A0/` | `0000 0010 1010 LLLL` |
| `0x02BL` | `EXTERNAL-POINTER-4WORD-GENERIC` | Generic | `0x000002B0` | `0x00000000/codecs/0x000002B0/` | `0000 0010 1011 LLLL` |
| `0x02CL` | `EXTERNAL-POINTER-4WORD-FREE-CHOICE` | Free-choice | `0x000002C0` | `0x00000000/codecs/0x000002C0/` | `0000 0010 1100 LLLL` |
| `0x02DL` | `EXTERNAL-POINTER-4WORD-UNIVERSAL` | Universal | `0x000002D0` | `0x00000000/codecs/0x000002D0/` | `0000 0010 1101 LLLL` |
| `0x02EL` | `EXTERNAL-POINTER-4WORD-VARIABLE` | Variable | `0x000002E0` | `0x00000000/codecs/0x000002E0/` | `0000 0010 1110 LLLL` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `import-id` | #2 | قيمة خام 4 WORD |  |  |
| 2 | `target-id` | #3 | قيمة خام متبقية (`0xFFFF`) |  |  |

EXTERNAL-POINTER هو Reference إشاري يشير إلى LOCAL ID في مستند استُورد بـ[IMPORT-DOC](../meta/0x1E4L-import-doc.md) في HEAD.

## التخطيط {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x020L~0x02EL (القسم 1)
[TAG الامتداد Length]
IMPORT ID         العرض الذي تحدده Codec (1/2/4 WORD)
معرّف الهدف       كل ما تبقى. LOCAL ID في المستند المستورد، بأقصر عرض
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | الاسم | عرض IMPORT ID |
|---|---|---|
| `0x020L~0x024L` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `0x025L~0x029L` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `0x02AL~0x02EL` | EXTERNAL-POINTER-4WORD | 4 WORD |

- يتحدد العرض برقم المنظومة: إذا كان (رقم المنظومة − 6) (أي `C / 5` للإزاحة داخل القسم `C`) يساوي 0 أو 1 أو 2 فالعرض 1 أو 2 أو 4 WORD. والتكميم هو `C % 5`.

- تُستخدم أضيق Codec تتسع لقيمة IMPORT ID.
- IMPORT ID هو القيمة التي خصّصها `IMPORT-DOC` في هذا المستند. لا يُكتب Issuer في EXTERNAL-POINTER. يُؤخذ الـIssuer ومعرّف المستند من ذلك `IMPORT-DOC`. والإصدار أيضًا يحدده ذلك `IMPORT-DOC` (مثبَّت أو الأحدث).
- إذا كان LOCAL ID في المستند المستورد واحدًا فهو الهدف نفسه، سواء كُتب LOCAL داخل ذلك المستند أو EXTERNAL-POINTER هنا.
- في حالة Variable يكون متغير LOCAL في المستند المستورد.

## الصلاحية {#유효성}

- يكون invalid إذا لم يوجد في هذا المستند `IMPORT-DOC` يخصص IMPORT ID ذاك.
- إذا كان IMPORT ID يتسع في Codec أضيق واستُخدمت أوسع رُفض لأنه non-minimal.
- يكون invalid إذا كان معرّف الهدف `0`. يُشار إلى المستند المستورد نفسه بـ[DOC-POINTER](0x041L-doc-pointer.md).
- يُمنع وجود WORD `0x0000` في بداية معرّف الهدف.

## مثال {#예시}

| الهدف | WORD sequence |
|---|---|
| LOCAL 5 لـIMPORT ID 1 | `0202 0001 0005` |
| LOCAL 65536 لـIMPORT ID 1 | `0203 0001 0001 0000` |
| LOCAL 5 لـIMPORT ID 70000 | `0253 0001 1170 0005` |

## صفحات ذات صلة {#관련-페이지}

- [Reference](_index.md)، [LOCAL](0x005L-local.md)، [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md)، [DOC-POINTER](0x041L-doc-pointer.md)
- [IMPORT-DOC](../meta/0x1E4L-import-doc.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x000002A0/latest.geul` مقروءًا بـ`geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000002A000000000
BODY
#1 DECLARE 0x02A0
#2 FIELD #1 0x0004
#3 FIELD #1 rest
#4 BIND #1 "EXTERNAL-POINTER-4WORD-IDENTIFIED"
#5 BIND #2 "import-id"
#6 BIND #3 "target-id"
```

ما سبق هو مستند Codec لـ`EXTERNAL-POINTER-4WORD-IDENTIFIED` (`0x02AL`). أما مستندات Codec للأعضاء الآخرين (`EXTERNAL-POINTER-4WORD-GENERIC` و`EXTERNAL-POINTER-4WORD-FREE-CHOICE` و`EXTERNAL-POINTER-4WORD-UNIVERSAL` و`EXTERNAL-POINTER-4WORD-VARIABLE`) فيختلف فيها فقط Codec ID في DOC-ID وهدف DECLARE والاسم المربوط (BIND) في `#1`.
