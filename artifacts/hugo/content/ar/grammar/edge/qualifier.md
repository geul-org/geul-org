---
title: "QUALIFIER"
weight: 12
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER هو Edge وصف يلحق شرط تقييد واحداً بقضية Edge آخر (غالباً TRIPLE) (Codec 0x0B). يمكن أن تُكتب في Value بدل القيمة علامة غير معروف (UNKNOWN-VALUE) أو لا شيء (NO-VALUE)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUALIFIER هو Edge وصف يلحق شرط تقييد واحداً بالقضية التي يحملها Edge آخر (غالباً [TRIPLE](/ar/grammar/edge/triple/)). Codec `0x0B`.

يطابق qualifier (snak) واحداً في ويكي بيانات: خاصية واحدة وقيمة واحدة.

## التخطيط

```
TAG WORD          0001 0LLL L000 1011
[Length ممتد TAG]
Edge Id           سجل Reference من نوع LOCAL
Property          سجل Reference (WIKIDATA-PID وغيره)
Target            سجل Reference من نوع LOCAL (Edge Id الخاص بالـ Edge الذي يقيّده)
Value             سجل Reference أو Value، أو علامة الموضع 0x0001 UNKNOWN-VALUE·0x0002 NO-VALUE
```

- ترتيب المكوّنات مثل TRIPLE (Property ↔ Predicate وTarget ↔ Subject وValue ↔ Object). يقرأ المفكك بالمسار نفسه. والأدوار يحددها Codec.

## التفسير والصلاحية

- Property وTarget كل منهما سجل Reference كامل واحد بالضبط، وTarget هو Reference من نوع LOCAL. تضع مواصفة geul.org في Target [CODEC](/ar/grammar/edge/codec/) من LOCAL (`0008`). وValue هو سجل Reference أو Value كامل واحد بالضبط، أو [علامة موضع](/ar/grammar/reference/slot-marker/) من 1 WORD هي `0x0001` (UNKNOWN-VALUE) أو `0x0002` (NO-VALUE). وتضع المواصفة في Value القيم CODEC `0780` و`0F80` و`0001` و`0002`. ولا يقبل ABSENT (`0x0000`). ولا يقبل Property وTarget علامات الموضع. ويجب أن يتطابق المؤشر بعد قراءة Value مع نهاية Edge.
- Target هو Edge Id في المستند نفسه. ويوضع QUALIFIER في المستند نفسه الذي فيه الـ Edge الذي يقيّده.
- إذا كان Target هو [SOURCE](/ar/grammar/edge/source/#مصدر-المستند-كله) في HEAD (مصدر المستند كله) فيوضع QUALIFIER أيضاً في HEAD بعد ذلك SOURCE. وما سوى ذلك من QUALIFIER يوضع في BODY. وإذا وُجد في BODY ما هدفه SOURCE في HEAD فهو invalid.
- يمكن أن يكون Target غير TRIPLE من Edge. فـ QUALIFIER المُلحق بـ [SOURCE](/ar/grammar/edge/source/) يقيّد فعل الاقتباس (تاريخ الاطلاع والموضع داخل المصدر وغيرهما). ومعنى SOURCE أيضاً هو مجموع كل QUALIFIER التي تشير إليه.
- **QUALIFIER جزء من القضية.** ليس دعوى مستقلة عن القضية بل يقيّد الشروط التي تصح بها القضية. ومعنى TRIPLE الهدف هو مجموع كل QUALIFIER التي تشير إليه.
  - مصدر القضية يُكتب بـ [SOURCE](/ar/grammar/edge/source/). وخصائص عقدة المصدر (العنوان والمؤلف وغيرهما) تُكتب بـ TRIPLE يكون المصدر فيه Subject.
- يجوز وجود عدة QUALIFIER بالخاصية نفسها لـ Target واحد. وترتيب QUALIFIER ذات Target واحد هو ترتيبها في المستند (استثناء يُعطى فيه ترتيب Edge معنى).

## غير معروف ولا شيء

إذا كانت Value في QUALIFIER علامة موضع تغيّر معنى ذلك التقييد. وخذ وقت الانتهاء (P582) مثالاً.

| ما أُلحق بـ TRIPLE الهدف | المعنى | هل القضية سارية الآن |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | انتهت في 1974 | لا |
| `QUALIFIER P582 #n UNKNOWN` | انتهت. لا يُعرف متى (`somevalue` في ويكي بيانات) | لا |
| `QUALIFIER P582 #n NONE` | يقرر أنها لم تنتهِ (`novalue` في ويكي بيانات) | نعم |
| لا يوجد QUALIFIER P582 | لا يُعرف هل انتهت (عالم مفتوح) | لا يُعرف |

- إسقاط `somevalue` و`novalue` في qualifier ويكي بيانات يوسّع القضية. فـ TRIPLE الحدود التي أُسقط منها somevalue لوقت الانتهاء تُقرأ على أنها "حدود سارية الآن". لذلك تُنقل بعلامة عند النقل.
- لا تُعدّ علامتا UNKNOWN-VALUE قيمة واحدة. ونتيجة المقارنة غير محددة.

## أمثلة (غير معيارية)

Q42 P69 (educated at) Q691283 (St John's College)، من 1971 إلى 1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG (1) + Edge Id (2) + Property (2) + Target (2) + Value (3) = 10 WORD. وValue هي [EDTF](/ar/grammar/value/time/edtf/) `"1971"`.

```
148B 0088 000A 00A8 0244 0088 0009 0924 3139 3731
```

حدود Q30 (الولايات المتحدة) – Q34266 (الإمبراطورية الروسية) (P47)، ووقت الانتهاء مجهول. Edge Id `2060` و`3160`.

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `138B` = `000 10 0111 0001011`: Edge، و8 WORD، وCodec `0x0B`. TAG (1) + Edge Id (2) + Property P582 (`00A8 0246`) (2) + Target #2060 (`0088 080C`) (2) + علامة (1).

يُلحق بـ TRIPLE `#3161` من نوع NO-VALUE للبنك المركزي لـ Q30 (P1304) مدة. لم يكن موجوداً في السنوات 1811~1816 فقط.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## صفحات ذات صلة

- [Edge](/ar/grammar/edge/)، [TRIPLE](/ar/grammar/edge/triple/)، [SOURCE](/ar/grammar/edge/source/)، [WIKIDATA-PID](/ar/grammar/reference/wikidata-pid/)، [EDTF](/ar/grammar/value/time/edtf/)، [علامة موضع](/ar/grammar/reference/slot-marker/)
