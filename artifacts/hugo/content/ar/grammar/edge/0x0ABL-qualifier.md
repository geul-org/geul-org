---
title: "QUALIFIER (0x0ABL)"
weight: 171
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER هو Edge عبارة يُلحق شرطاً واحداً يحدِّد القضية التي يحملها Edge آخر (غالباً TRIPLE)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `QUALIFIER` (BIND مستند المواصفة `QUALIFIER`) |
| TAG ID | `0x0ABL` |
| Codec ID | `0x00000AB0` |
| مستند المواصفة | `0x00000000/codecs/0x00000AB0/` (هدف DECLARE `0AB0`) |
| القسم | 5 `0101` (Edge العبارة)، الإزاحة داخل القسم C = 11 |
| Kind | Edge · العائلة: العبارة، الحزمة: القضية |
| TAG WORD | `0000 1010 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | شرط واحد يحدِّد قضية Edge آخر. Property وTarget (Edge Id) وValue (قيمة أو علامة UNKNOWN-VALUE·NO-VALUE). هو جزء من القضية |
| جانب Hugo | `edge/qualifier.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)). لا يُصرَّح بـ Edge Id الخاص بـ Edge عبر FIELD.

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `property` | #2 | سجل | أي سجل (عدا علامة الموضع) |  |
| 2 | `target` | #3 | سجل | `0050` LOCAL |  |
| 3 | `value` | #4 | سجل | `000F` القسم 0 كله (حرف بدل، Reference)، `020F` القسم 1 كله (حرف بدل، Reference)، `040F` القسم 2 كله (حرف بدل، Reference)، `060F` القسم 3 كله (حرف بدل، Value)، `080F` القسم 4 كله (حرف بدل، Value)، `0010` UNKNOWN-VALUE، `0020` NO-VALUE |  |

QUALIFIER هو Edge عبارة يُلحق شرطاً واحداً يحدِّد القضية التي يحملها Edge آخر (غالباً [TRIPLE](0x0AAL-triple.md)). Codec `0x0ABL`.

يماثل qualifier (snak) واحداً في ويكيداتا: خاصية واحدة وقيمة واحدة.

## التخطيط {#레이아웃}

```
TAG WORD          0000 1010 1011 LLLL
[Length TAG ممتد]
Edge Id           سجل LOCAL Reference
Property          سجل Reference (WIKIDATA-PID ونحوه)
Target            سجل LOCAL Reference (Edge Id للـ Edge المحدَّد)
Value             سجل Reference أو Value، أو علامة الموضع 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
```

- ترتيب المكوّنات مثل TRIPLE (Property ↔ Predicate، Target ↔ Subject، Value ↔ Object). يقرأ المفكِّك بالمسار نفسه. ويحدد Codec الأدوار.

## التفسير والصلاحية {#해석과-유효성}

- Property وTarget سجل Reference واحد كامل تماماً لكل منهما، وTarget هو LOCAL Reference. يضع مستند مواصفة geul.org في Target الـ [CODEC](0x0BEL-codec.md) LOCAL (`0050`). وValue هو سجل Reference أو Value واحد كامل تماماً، أو [علامة الموضع](../slot-marker.md) `0x0010` (UNKNOWN-VALUE) أو `0x0020` (NO-VALUE) من 1 WORD. ويضع مستند المواصفة في Value الـ CODEC `000F` و`020F` و`040F` (أي Reference) و`060F` و`080F` (أي Value) و`0010` و`0020`. لا يقبل ABSENT (`0x0000`). ولا يقبل Property وTarget علامة الموضع. يجب أن يطابق المؤشر بعد قراءة Value نهاية Edge.
- Target هو Edge Id داخل الوثيقة نفسها. يوضع QUALIFIER في الوثيقة نفسها التي فيها Edge الذي يحدِّده.
- إذا كان Target هو [SOURCE](0x0C0L-source.md#문서-전체의-출처) في HEAD (أصل الوثيقة كلها) فيوضع QUALIFIER في HEAD أيضاً بعد ذلك SOURCE. وغير ذلك من QUALIFIER يوضع في BODY. فإن وُجد في BODY QUALIFIER هدفه SOURCE في HEAD فهو invalid.
- قد يكون Target Edge غير TRIPLE. يحدِّد QUALIFIER الملحق بـ [SOURCE](0x0C0L-source.md) فعلَ الاقتباس (تاريخ الاطلاع، والموضع داخل الأصل، ونحوها). ومعنى SOURCE أيضاً هو مجموع كل QUALIFIER التي تشير إليه.
- **QUALIFIER جزء من القضية.** وهو ليس ادعاءً منفصلاً عن القضية، بل يحدِّد الشروط التي تصير بها القضية صحيحة. ومعنى TRIPLE الهدف هو مجموع كل QUALIFIER التي تشير إليه.
  - يُكتب مصدر القضية بـ [SOURCE](0x0C0L-source.md). وتُكتب خصائص عقدة الأصل (العنوان والمؤلف ونحوها) بـ TRIPLE يكون الأصل Subject فيه.
- يجوز أن توجد عدة QUALIFIER بـ Property نفسها لـ Target نفسه. وترتيب QUALIFIER ذات Target نفسه هو ترتيبها في الوثيقة (استثناء يمنح ترتيب Edge معنى).

## غير معروف ولا شيء {#알-수-없음과-없음}

إذا كان Value في QUALIFIER علامة موضع تغيّر معنى ذلك التحديد. نأخذ وقت الانتهاء (P582) مثالاً.

| ما أُلحق بـ TRIPLE الهدف | المعنى | هل القضية سارية الآن |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | انتهت في 1974 | لا |
| `QUALIFIER P582 #n UNKNOWN` | انتهت. لا يُعرف متى (`somevalue` في ويكيداتا) | لا |
| `QUALIFIER P582 #n NONE` | يؤكَّد أنها لم تنتهِ (`novalue` في ويكيداتا) | نعم |
| لا QUALIFIER لـ P582 | لا يُعرف هل انتهت (العالم المفتوح) | لا يُعرف |

- إذا أُسقطت `somevalue`·`novalue` من qualifier ويكيداتا اتسعت القضية. فـ TRIPLE الحدود الذي أُسقط منه somevalue لوقت الانتهاء يُقرأ «حدود سارية الآن». لذلك تُنقل بوصفها علامات.
- لا يُعدّ UNKNOWN-VALUE قيمةً مساوية لـ UNKNOWN-VALUE آخر. نتيجة المقارنة غير محددة.

## مثال (غير معياري) {#예시-비규범}

Q42 P69 (educated at) Q691283 (St John's College)، 1971~1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD. Value هو [EDTF](../value/0x06EL-edtf.md) `"1971"`.

```
0AB9 0051 000A 0191 0244 0051 0009 06E2 3139 3731
```

الحدود (P47) بين Q30 (الولايات المتحدة) وQ34266 (الإمبراطورية الروسية)، ولا يُعرف وقت الانتهاء. Edge Id هما `2060` و`3160`.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `0AB7` = `000 0101 01011 0111` (القسم 5): Edge، Codec `0x0ABL`، 8 WORD. TAG 1 + Edge Id 2 + Property P582 (`0191 0246`) 2 + Target #2060 (`0051 080C`) 2 + علامة 1.

يُلحق بـ TRIPLE `#3161` من نوع NO-VALUE لـ Q30 والبنك المركزي (P1304) فترةٌ زمنية. كان غيابه في 1811~1816 فقط.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## صفحات ذات صلة {#관련-페이지}

- [Edge](_index.md)، [TRIPLE](0x0AAL-triple.md)، [SOURCE](0x0C0L-source.md)، [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md)، [EDTF](../value/0x06EL-edtf.md)، [علامة الموضع](../slot-marker.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000AB0/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AB000000000
BODY
#1 DECLARE 0x0AB0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 BIND #1 "QUALIFIER"
#6 BIND #2 "property"
#7 BIND #3 "target"
#8 BIND #4 "value"
#9 CODEC #3 0x0050
#10 CODEC #4 0x000F
#14 CODEC #4 0x020F
#15 CODEC #4 0x040F
#11 CODEC #4 0x060F
#16 CODEC #4 0x080F
#12 CODEC #4 0x0010
#13 CODEC #4 0x0020
```
