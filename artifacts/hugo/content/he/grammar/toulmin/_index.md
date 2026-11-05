---
title: "TOULMIN"
weight: 130
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "כותב גרף פסק דין וביצוע לפי מודל הטיעון של טולמין."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

כותב גרף פסק דין וביצוע לפי מודל הטיעון של טולמין. זו משפחת הליבה שבאמצעותה GEUL מתארת את כלליה שלה ב-GEUL ומתקנת את עצמה.

| קבוצה | Codec |
|---|---|
| הצהרה | [CASE-DECLARE](0x100L-case-declare.md) (מקרה), [PREDICATE-DECLARE](0x101L-predicate-declare.md) (פרדיקט), [SPEC-DECLARE](0x102L-spec-declare.md) (קריטריון שיפוט), [RULE-DECLARE](0x103L-rule-declare.md) (טענה), [COUNTER-DECLARE](0x104L-counter-declare.md) (ראיית נגד), [EXCEPT-DECLARE](0x105L-except-declare.md) (חריג) — [NODE](#node) |
| קשר | [ATTACKS](0x108L-attacks.md) (תקיפה), [SUPERSEDES](0x109L-supersedes.md) (הדרה) — [LINK](#link), [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) (שרשרת עדיפויות, הפריסה טרם נקבעה) |
| ביצוע | [RUN](0x110L-run.md), [DO](0x111L-do.md), [DO-ONCE](0x112L-do-once.md), [UNDO](0x113L-undo.md), [CHECKING](0x114L-checking.md) — [LINK](#link), [ENTRY](0x115L-entry.md), [TRIGGER](0x116L-trigger.md) — [NODE](#node) |
| תוצאה | [VERDICT](0x118L-verdict.md) (תוצאת פסק דין: Pass·Review·Fail), [EVIDENCE](0x119L-evidence.md) (ראיה לפסק הדין) — הפריסה טרם נקבעה |

- צמתי טקסט המקור, החלוקה למקטעים וצמתי העזר והקשרים הם הקודים הישירים `0x120L~0x134L` של משפחת פורמט TOULMIN ([SOURCE ומקטעים](#source와-구획), [TOULMIN](#toulmin-형식)).
- תוצאת פסק הדין נשמרת במסמך שונה מהמסמך שנפסק. מסמך התוצאה מייבא את מסמך היעד ומצביע עליו. לכן פסק הדין אינו משנה את hash התוכן של מסמך היעד.

ה-Edge של משפחת TOULMIN (קודים ישירים `0x100L~0x11BL`, ורשומות העזר במשפחת פורמט TOULMIN `0x120L~0x134L`) כותבים גרף פסק דין וביצוע לפי מודל הטיעון של טולמין. הצהרות של טענה, ראיית נגד וחריג, יחסי תקיפה והדרה, חיבורי ביצוע ותוצאות פסק דין הם כולם Edge. מסמך TANGEUL אחד (שפת הכללים של מנוע toulmin) הופך למסמך GEUL אחד. סיומת הקובץ היא `.geul`, כמו בשאר המסמכים.

מה שהמסמך הזה לא קובע נקבע לפי הכללים המשותפים של [Edge](../edge/_index.md) ו-[רשומה ו-TAG WORD](../record.md).

## מטא-קוגניציה ותיקון עצמי {#메타-인지와-자기-개정}

TOULMIN הוא Codec של GEUL כדי ש-GEUL תוכל להכיר את עצמה (מטא-קוגניציה). רק אם גם כללי פסק הדין והביצוע מתוארים ב-GEUL, יכול TOULMIN לקחת את הכללים האלה כיעד ולתקן אותם בעצמו. לכן TOULMIN אינו פרופיל יישומי אלא ליבת ההפעלה של GEUL, והוא ממוקם במרחב הקודים הישירים של Edge (`0x100L~0x11BL`).

- תיאור עצמי מאפשר שיפור עצמי, אך נושא סיכון של שגיאה מעגלית. אם כלל פוסק בעצמו על תיקון של עצמו, גם תיקון שמרפה את קריטריון השיפוט יכול לעבור (שיעור המעבר עולה והדיוק האמיתי יורד).
- מקבלים את המעגליות כסיכון, וקוטעים אותה באמצעות מבנה.
  - **ליבה קבועה**: משמעות פסק הדין (Pass·Review·Fail, תקיפה·הדרה·עדיפות, ההערכה בשלושה ערכים ו-U → Review שב[פסק דין על קלט לא ידוע](#미상-위에서-판정하기) להלן) קבועה במפרט הזה. אי אפשר לשנות אותה באמצעות מסמך TOULMIN. זהו אותו מקום של הכללים המשובצים במפענח (שכבה 0 ב[כתובת פרסום ורשימת גרסאות](../publishing.md#층)).
  - **הפרדת מהדורות**: תיקון של מסמך כללים v(n) נפסק לפי כללי v(n−1) ובדיקה חיצונית. כלל אינו פוסק על עצמו. תוצאת פסק הדין נשמרת במסמך שונה מהיעד (hash התוכן של היעד אינו משתנה).
  - **היסטוריה בלתי משתנה**: תיקונים נערמים כגרסאות חדשות (`PARENT`, hash תוכן, חתימה). הגרסאות הישנות נשארות, ולכן אפשר למצוא שגיאה מעגלית בדיעבד ולהחזיר אחורה. רשת הביטחון של תיקון עצמי היא מודל המהדורות של GEUL ([מסמך](../document.md#개정)).
  - **אמת מידה חיצונית**: מחזיקים בנפרד קבוצת מקרי בדיקה שנתיב התיקון אינו יכול לגעת בה. קבלת תיקון מאומתת לפי תוצאת הקבוצה הזו.
- בדיקת הפרכה: מטמיעים בכוונה כלל שגוי אחד. אם המערכת מתקנת אותו וציון אמת המידה החיצונית עולה, השיפור העצמי פועל. אם רק שיעור המעבר עולה וציון אמת המידה החיצונית יורד, זו שגיאה מעגלית.

## קוד {#코드}

רשומת TOULMIN משתמשת באחת משלוש פריסות. הפריסה נקבעת לפי ה-Codec.

| פריסה | שימוש | דף |
|---|---|---|
| NODE | צמתי גרף כגון מקרה, כלל, הגדרה, נקודת כניסה | [NODE](#node) |
| LINK | קשרים בין צמתים (תקיפה, הדרה, ביצוע, הגדרה) | [LINK](#link) |
| EXPR | ביטוי תנאי (פרדיקט) | [EXPR](0x101L-predicate-declare.md) |

רשומות טקסט המקור והחלוקה למקטעים (SOURCE, TEXT, SECTION, CASE-BEGIN·CASE-END, PROSE) נקבעות ב-[SOURCE ומקטעים](#source와-구획).

### קוד ישיר {#직접-코드}

| Codec | שם | פריסה | TANGEUL | משמעות |
|---|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | NODE | `in case of` | הצהרת מקרה. גרף פסק דין שנושא צמתים וקשרים |
| `0x101L` | [PREDICATE-DECLARE](0x101L-predicate-declare.md) | EXPR | ביטוי תנאי ב-Rules | הצהרת פרדיקט. ביטוי פסק דין |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | NODE | פריט Definitions | הצהרת קריטריון שיפוט (Backing). ביט ה-role קובע את סוג ההגדרה |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | NODE | general rule, שם הכלל ב-Rules | הצהרת טענה (Warrant). אפשר לתקוף אותה |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | NODE | counter rule | הצהרת ראיית נגד. תוקפת עם מסקנה משלה. ה-Level המשתמע הוא Fail |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | NODE | except rule | הצהרת חריג. תוקף ללא מסקנה משלו. ה-Level המשתמע הוא Review |
| `0x108L` | [ATTACKS](0x108L-attacks.md) | LINK | `don't X when Y` | יחס תקיפה. פסק התוקף מקטין בהדרגה את פסק היעד בעוצמת התקיפה (0~1, ברירת מחדל 1) |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | LINK | `X supersedes Y` | יחס הדרה. אם התוקף Active, הוא מוציא את היעד מהצבירה באופן מכריע. שרשרת (`A > B > C`) נכתבת בקשר אחד לכל זוג |
| `0x10AL` | [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) | — | | שרשרת עדיפויות `A > B > C`. קיצור של SUPERSEDES לפי זוגות. הוקצה רק הקוד, ועדיין אין פריסה |
| `0x110L` | [RUN](0x110L-run.md) | LINK | `run c when n` | הרכבת ביצוע. אם הצומת Active, מריצים את המקרה התחתון (DAG) |
| `0x111L` | [DO](0x111L-do.md) | LINK | `do fn when n` | פעולה שמבוצעת כשהצומת Active |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | LINK | `do fn once when n` | פעולה שמבוצעת פעם אחת בלבד גם בניסיון חוזר |
| `0x113L` | [UNDO](0x113L-undo.md) | LINK | `undo fn when n` | פעולת פיצוי של DO‏ (saga). אם שלב מאוחר יותר נכשל, מבוצעת בסדר הפוך |
| `0x114L` | [CHECKING](0x114L-checking.md) | LINK | `checking c` | חיבור שרק פוסק, ללא תופעות לוואי |
| `0x115L` | [ENTRY](0x115L-entry.md) | NODE | `provides x` | נקודת כניסה חיצונית. מריצה או פוסקת מקרה |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | NODE | `on`, `every`, `until` | נקודת כניסה של אירוע או מחזור, ללא קריאה חיצונית |
| `0x118L` | [VERDICT](0x118L-verdict.md) | — | | תוצאת פסק הדין של צומת או רשומה. תוצאה (Pass, Review, Fail), ערך פסק דין, Activated, Excluded, Level. הוקצה רק הקוד, ועדיין אין פריסה |
| `0x119L` | [EVIDENCE](0x119L-evidence.md) | — | | ראיה לפסק הדין. מיקום, ערך צפוי, ערך בפועל (Fact). הוקצה רק הקוד, ועדיין אין פריסה |
| `0x11CL~0x11FL` | Reserved | | | |

- קודים ישירים שאינם בטבלה (`0x106L`·`0x107L`, `0x10BL`~`0x10FL`, `0x117L`, `0x11AL`·`0x11BL`) הם Reserved.
- הקבוצות הן `0x100L~0x107L` הצהרה, `0x108L~0x10FL` קשר, `0x110L~0x117L` ביצוע, `0x118L~0x11FL` תוצאה (`0x11CL~0x11FL` הם Reserved).
- פסק הדין של המסמך כולו מוטל על `VERDICT` של Meta‏ ([VERDICT](../meta/0x1E9L-verdict.md), `0x1E9L`), ופסק הדין של צומת או רשומה מוטל על `VERDICT` של TOULMIN‏ (Edge ‏`0x118L`). השניים הם Codec נפרדים עם Kind שונה.

### פורמט TOULMIN {#toulmin-형식}

טקסט המקור, החלוקה למקטעים והצמתים והקשרים העזר נמצאים בקודים הישירים `0x120L~0x134L` של משפחת Edge פורמט TOULMIN. אין שדות Issuer ומספר Codec, וה-Payload בא ישר אחרי ה-TAG.

```
TAG WORD          0001 0010 0000 LLLL      Edge, Codec 0x120L (SOURCE). קודים אחרים באותו מקום
[TAG הרחבת Length]
Edge Id           רשומת LOCAL Reference
רכיבים            הפריסה שהפורמט קובע
```

| Codec | שם | פריסה | משמעות |
|---|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, WORD רוחב SPAN, UTF8 Value | טקסט המקור של הכתיבה |
| `0x121L` | [TEXT](0x121L-text.md) | ID, UTF8 Value | שם או מחרוזת |
| `0x122L` | [SECTION](0x122L-section.md) | ID, קוד קטע ב-WORD אחד | תחילת קטע |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF (מקרה) | תחילת טווח המקרה |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF (מקרה) | סוף טווח המקרה |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN | פסקת תיאור |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | NODE | `this document is` |
| `0x127L` | [FUNC](0x127L-func.md) | NODE | הפניה לפונקציה |
| `0x128L` | [FIELD](0x128L-field.md) | NODE | `is required` |
| `0x129L` | [ALIAS](0x129L-alias.md) | NODE | `see … from` |
| `0x12AL` | [GROUP](0x12AL-group.md) | NODE | קבוצת ביצוע מסודרת |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | LINK | מקרה → שדה |
| `0x12CL` | [MEANS](0x12CL-means.md) | LINK | פריט הגדרה → ערך או טיפוס |
| `0x12DL` | [HAS](0x12DL-has.md) | LINK | פריט הגדרה → שדה |
| `0x12EL` | [RUNS](0x12EL-runs.md) | LINK | נקודת כניסה → מקרה, ביצוע |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | LINK | נקודת כניסה → מקרה, פסק דין |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | LINK | טריגר → מקרה |
| `0x131L` | [UNTIL](0x131L-until.md) | LINK | טריגר → מקרה (`every … until`) |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | LINK | צומת → מזהה גלובלי |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | LINK | כינוי → נתיב (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | LINK | צומת → TEXT, סימון שם |

## מסמך {#문서}

קובץ `.geul` אחד הוא DOC אחד. אין להניח בתים אחרים מחוץ ל-DOC.

```
DOC-1WORD/2WORD/4WORD     אורך כולל
  SPEC-VERSION            0x0001 (v1, מספר שלם ללא Value משובץ)
  PROFILE                 UTF8 Value "tangeul-<major>.<minor>". כעת "tangeul-1.0"
  [DEFAULT-LANGUAGE]      LANGUAGE-BCP47-CODE Value. אזור השפה של הכתיבה ("en", "ko")
BODY
  SOURCE                  טקסט המקור של הכתיבה. הרשומה הראשונה ב-BODY
  רשומות משפט …            לפי סדר ההצהרה במסמך
END
```

- HEAD: ‏[SPEC-VERSION](../meta/0x1C5L-spec-version.md), ‏[PROFILE](../meta/0x1C6L-profile.md), ו-[DEFAULT-LANGUAGE](../meta/0x1CAL-default-language.md) אופציונלי.
- המפענח דוחה אם SPEC-VERSION שונה או שה-major של PROFILE שונה. אם רק ה-minor שונה, הוא קורא.
- הרשומה הראשונה ב-BODY היא SOURCE. כל SPAN הוא טווח בתוך טקסט המקור הזה.
- סדר רשומות המשפט שווה לסדר ההצהרה במסמך. סדר הביצוע (הפעלת `do`·`run`, ופיצוי בסדר הפוך של `undo`) נשען על הסדר הזה. במסמך TOULMIN לסדר ה-Edge יש משמעות (יוצא דופן בכלל הסדר שב[פריסת Edge](../edge/_index.md#레이아웃)).
- כל הרשומות ב-BODY הן Edge. אין רשומות Value עצמאיות. ערכים משובצים ב-Payload של ה-Edge.
- זהות המקרה והייבוא נכתבים ב-[DOC-ID](../meta/0x1C7L-doc-id.md) וב-[IMPORT-DOC](../meta/0x1E4L-import-doc.md) של Meta (Subject ו-See של TANGEUL).

## שדות משותפים {#공통-필드}

| שדה | רוחב | הסבר |
|---|---|---|
| ID | רשומת LOCAL Reference | ה-Edge Id של הרשומה. האיבר הראשון ב-Payload של כל רשומה |
| REF | רשומת LOCAL Reference | Edge Id שמצביע על רשומה אחרת במסמך הזה. `0` פירושו אין |
| SPAN | הרוחב שקבע SOURCE × 2 | טווח בטקסט המקור של הכתיבה. בייט התחלה, מספר בייטים |

- ID ו-REF הם רשומות [LOCAL](../reference/0x005L-local.md) Reference משובצות (`0000 0000 0101 LLLL` + ID ברוחב הקצר ביותר). הרוחב נקבע לפי Length של הרשומה ואינו מוצהר ברמת המסמך.
- REF ‏`0` (‏LOCAL ‏`0`) פירושו «אין». זהו כלל של Codec שמשתמש ב-LOCAL ‏`0` כ«אין» ([LOCAL](../reference/0x005L-local.md)).
- Edge Id מוקצה מ-1 ואינו חוזר בתוך המסמך. `0` הוא «אין» של REF ולכן אינו משמש כ-Edge Id.
- צמתים מקבלים מספר ראשונים לפי סדר ההצהרה במסמך, כי רשומות אחרות מפנות אליהם קדימה. שאר הרשומות (SOURCE, TEXT, LINK, FUNC, רשומות החלוקה למקטעים) מקבלות מהמקודד מספרים אחרי הצמתים.
- המפענח בודק רק ש-Edge Id אינו 0 ושאין כפילויות. סדר ההקצאה אינו משמש בפירוש.
- צמתים וקשרים מוצבעים באמצעות Edge Id.
- Value משובץ הוא רשומת Value כפי שהיא, כולל TAG WORD. אורכו נקבע לפי ה-TAG שלו.

## ערכים מספריים {#수치}

- ערך פסק דין (−1~1), Qualifier (0~1) ועוצמת תקיפה (0~1) הם [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md) Value. אין פורמט נקודה קבועה נפרד.
- המקודד מוחק אפסים בסוף המקדם. 0.8 הוא `C=8, E=−1`. המפענח מקבל עד ארבע ספרות אחרי הנקודה.
- שער ביטחון (למשל `at least 75%`) נכתב כאופרטור השוואה ב-WORD אחד ו-[UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md) Value של אחוזים (`E=0`) ([LINK](#link) F_GATE).
- עוצמת תקיפה היא שדה F_FORCE של ATTACKS ([LINK](#공격-세기)). מחוץ לטווח, דוחים.

## צירי הצהרת צומת {#노드-선언의-축}

- הצהרת צומת (RULE·COUNTER·EXCEPT-DECLARE) כוללת תפקיד (טענה, ראיית נגד, חריג), Qualifier‏ (0~1) ו-Level‏ (Unset, Fail, Review). התפקיד נישא ב-role של ה-Codec וכותרת NODE, ה-Qualifier ב-F_QUAL, וה-Level ב-level של הכותרת ([NODE](#node)).
- חוזק (Strict, Defeasible, Defeater) הוא ציר נפרד מהתפקיד. מיקום החוזק טרם נקבע.
- עוצמת תקיפה (Force) היא ערך של קשת ATTACKS ולא של צומת ([LINK](#공격-세기) F_FORCE). זהו ציר שונה מחוזק.

## פסק דין על קלט לא ידוע {#미상-위에서-판정하기}

כשגרף פסק דין מקבל עובדות GEUL כקלט, שלושת המושגים של [סמן מקום](../slot-marker.md) (לא נכתב, לא ידוע, אין) מוערכים באופן שונה. הערכת אופרטורי ההשוואה של [EXPR](0x101L-predicate-declare.md) היא כדלקמן.

| קלט | `is empty` | `is not empty` | `equals` / `is in` / השוואת גודל |
|---|---|---|---|
| ערך v | שקר | אמת | מוערך לפי v |
| NO-VALUE (אין) | **אמת** | שקר | שקר |
| UNKNOWN-VALUE (לא ידוע) | שקר | **אמת** | **לא מוכרע (U)** |
| ABSENT (לא נכתב) / היעדר היגד | U (עולם פתוח) | U | U |

- הלוגיקה היא Kleene החזקה בשלושה ערכים. `NOT U = U`, ‏`שקר AND U = שקר`, ‏`אמת OR U = אמת`. בשאר הצירופים U הוא U.
- `EXISTS any` הוא אמת אם אחד האיברים לפחות אמת. אם אין אמת ויש U, התוצאה U, ואם כולם שקר, התוצאה שקר.
- **אם הפרדיקט הוא U, פסק הצומת אינו Pass או Fail אלא Review.** מה שלא ידוע מועבר לאדם (או לשלב הבא).
- כדי לקרוא ABSENT כ-empty ולא כ-U, צד הקלט חייב **להצהיר** על עולם סגור (הזרקה כקריטריון שיפוט SPEC, למשל: «הקלט של המקרה הזה שלם»). בלי הצהרה זה U.
- הטבלה הזו והמיפוי U → Review הם משמעות פסק הדין ולכן **ליבה קבועה**. אי אפשר לשנות אותם באמצעות מסמך TOULMIN.
- דוגמה: כלל «סופרים רק גבולות שעדיין בתוקף» (`P582 is empty`): אם P582 = UNKNOWN-VALUE הוא שקר ולכן מוציא את הגבול; אם P582 = NO-VALUE הוא אמת ולכן כולל אותו; ואם P582 חסר הוא U ולכן שולח ל-Review.

## תוצאת פסק דין {#판정-결과}

- תוצאת פסק הדין (`VERDICT`, `EVIDENCE`) נשמרת במסמך שונה ממסמך היעד. מסמך התוצאה מייבא את מסמך היעד באמצעות [IMPORT-DOC](../meta/0x1E4L-import-doc.md) ומצביע עליו באמצעות [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md). לכן פסק הדין אינו משנה את hash התוכן של מסמך היעד.
- פסק הדין של המסמך כולו הוא `VERDICT` של Meta, ופסק הדין של צומת או רשומה הוא `VERDICT` של TOULMIN.
- גם הכללים לבחירת המהדורה שחלה בתיקון (הוראות מעבר, בחירה בין החוק בעת המעשה לחוק החדש), וכן פרשנויות ופסיקה, משמשים ככללי פסק דין ([מסמך](../document.md#개정)).

## בעיות פתוחות {#열린-문제}

- הפריסה של SUPERSEDE-CHAIN‏ (`0x10AL`), VERDICT‏ (`0x118L`) ו-EVIDENCE‏ (`0x119L`). והאם הדרך הנוכחית, SUPERSEDES אחד לכל זוג, מספיקה לשרשרת.
- מיקום חוזק הצומת (Strict, Defeasible, Defeater).
- ל-ATTACKS שכתוב בו עוצמת תקיפה 1 ול-ATTACKS שלא כתוב בו אותו פסק דין זהה אך הבייטים שונים. כדי לדעת אם פסק הדין זהה יש להשוות את הערכים המפורשים ולא את הבייטים.
- מספר הצמתים, מספר התוויות ואינדקס התווית בתוך EXPR הם 1 WORD, ומספר הילדים הוא 13 ביט. הגבול העליון קבוע.
- פריסת PROVENANCE (מקור הכלל ותנאיו המקדימים).
- האם לתת לשם בגרשיים הפוכים תפקיד של [LABEL](../edge/0x0A4L-label.md) ו-[BIND](../edge/0x0A3L-bind.md) מסוג Edge של היגד במקום TEXT + LABEL‏ (`0x134L`).
- טבלת ערכי הקוד של predicate ו-mode ב-Claim, וערכי הקוד של VerbCode ב-FuncRef.
- האם הצהרת עולם סגור (קריאת ABSENT כ-empty) נעשית בקריטריון שיפוט (SPEC) או ברמת המקרה.
- [מסמך המפרט של Codec](../codec-spec.md) עבור Codec של TOULMIN. השדות המותנים של NODE ו-LINK ורוחב ה-SPAN שקובע SOURCE הם פריסות שאי אפשר להצהיר עליהן באמצעות FIELD.

## דפים קשורים {#관련-페이지}

- [NODE](#node), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [SOURCE ומקטעים](#source와-구획)
- [מסמך](../document.md), [PROFILE](../meta/0x1C6L-profile.md)

## NODE {#node}

NODE היא פריסה שכותבת צומת בגרף פסק הדין והביצוע של TOULMIN. סוג הצומת נקבע לפי ה-Codec, ו-WORD כותרת אחד קובע את התפקיד, ה-Level, צורת ה-Claim והשדות המותנים.

### Codec {#codec}

| Codec | שם | TANGEUL | צומת |
|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | `in case of` | מקרה |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | פריטי Definitions (`means`, `has`) | קריטריון שיפוט (Backing). ה-role הוא סוג ההגדרה |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | general rule | טענה (Warrant) |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | counter rule | ראיית נגד (Rebuttal) |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | except rule | חריג (Defeater) |
| `0x115L` | [ENTRY](0x115L-entry.md) | `provides x` | נקודת כניסה חיצונית |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | `on`, `every`, `until` | נקודת כניסה של אירוע או מחזור |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | `this document is` | מרחב השמות של המסמך |
| `0x127L` | [FUNC](0x127L-func.md) | הפניה לפונקציה | פונקציה חיצונית (למשל `bank.withdraw`) |
| `0x128L` | [FIELD](0x128L-field.md) | `x is required [as Type]` | שדה חובה |
| `0x129L` | [ALIAS](0x129L-alias.md) | `see a from path` | כינוי של חבילה שיובאה |
| `0x12AL` | [GROUP](0x12AL-group.md) | `1.` רשימה ממוספרת | קבוצת ביצוע מסודרת |

`0x126L~0x12AL` הם קודים ישירים של משפחת Edge פורמט TOULMIN ([TOULMIN](#toulmin-형식)).

### פריסה {#레이아웃}

```
ID               רשומת LOCAL Reference (Edge Id)
כותרת 1 WORD     role 2b | Reserved 2b | F_GROUNDS 1b | level 2b | סוג object 2b | flags 7b
[F_FUNC]         FuncRef: REF(ALIAS, או 0 אם אין) + VerbCode ב-WORD אחד
[F_QUAL]         SIGNED-DECIMAL Value. Qualifier
[F_CHECK]        REF(מקרה)
[F_CLAIM]        Claim: REF(subject) + predicate ב-WORD אחד + object + mode ב-WORD אחד
[F_VERDICT]      SIGNED-DECIMAL Value. ערך התחלתי של ערך פסק הדין
[F_WITH]         מספר (UNSIGNED-INTEGER Value) + REF(TEXT) × מספר
[F_GROUNDS]      מספר (UNSIGNED-INTEGER Value) + REF(TEXT) × מספר
SPAN             הרוחב שקבע SOURCE × 2 (בייט התחלה, מספר בייטים)
```

#### WORD כותרת {#헤더-word}

| ביטים | שדה | ערך |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | Reserved | 0 |
| 11 | F_GROUNDS | יש רשימת ראיות |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 Reserved) |
| 8–7 | סוג object | צורת ה-object של Claim. 0 REF, 1 UNSIGNED-INTEGER Value, 2 SPAN |
| 6–0 | flags | הטבלה להלן |

| ביט | flag | משמעות |
|---|---|---|
| b0 | F_FUNC | יש שדה FuncRef |
| b1 | F_QUAL | יש שדה Qualifier |
| b2 | F_CHECK | יש שדה מקרה יעד של `checking` |
| b3 | F_CLAIM | יש שדה Claim |
| b4 | F_VERDICT | יש שדה ערך התחלתי של ערך פסק הדין |
| b5 | F_STRIKE | הצהרה שנמחקה בקו חוצה. אין שדה |
| b6 | F_WITH | יש שדה רשימת קריטריונים |

- השדות המותנים מסודרים לפי סדר ה-flags (F_FUNC, F_QUAL, F_CHECK, F_CLAIM, F_VERDICT, F_WITH, F_GROUNDS). שדה שה-flag שלו כבוי אינו תופס מקום.
- אם flag דלוק ואין שדה, דוחים. המיקום שאליו הגיעה קריאת השדות לפי הסדר, אחרי SPAN, חייב להתיישר בדיוק עם סוף הרשומה.

### שדות {#필드}

| שדה | הסבר |
|---|---|
| FuncRef | מקום הפונקציה. REF הוא רשומת ALIAS שייבאה את הפונקציה, ואם הפונקציה שייכת למסמך הזה הוא `0`. VerbCode הוא קוד ב-WORD אחד שעדיין לא הוקצה (`0x0000` מותר). הכתיב המקורי של הפונקציה נכתב בנפרד כ-TEXT + [LABEL](#link) |
| Qualifier | רמת הביטחון של הצומת (0~1) |
| מקרה | F_CHECK: המקרה שהצומת הזה רק פוסק בו (`checking c`) |
| Claim | הטענה שהצומת נושא. REF של subject, predicate ב-WORD אחד, object, ו-mode ב-WORD אחד. צורת ה-object נקבעת לפי סוג ה-object בכותרת |
| ערך פסק דין | ערך התחלתי של ערך פסק הדין (−1~1) |
| F_WITH | קריטריון השיפוט בזמן ההצהרה (`기준으로 하는`, «המשתמש בקריטריון»). רשימת REF של רשומות TEXT |
| F_GROUNDS | שמות עובדות חיצוניות שנפתרות בזמן ההערכה (`근거로 하는`, «המסתמך על»). רשימת REF של רשומות TEXT |
| SPAN | טווח טקסט המקור שממנו יצאה ההצהרה |

- רישום ערך פסק הדין וה-Qualifier נקבע לפי הכללים המספריים של [TOULMIN](#수치).
- מספר הפריטים ברשימה הוא רשומת [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md) Value משובצת.
- הצורה הבסיסית של Claim תיאורי היא subject ו-predicate ‏`0` ו-object ‏SPAN (סוג object 2). והיא מקובעת לכתיב המקורי.

### פירוש ותוקף {#해석과-유효성}

- ב-RULE·COUNTER·EXCEPT-DECLARE, ה-role חייב להיות זהה ל-Codec (0 general, 1 counter, 2 except). ב-SPEC-DECLARE הוא סוג ההגדרה. בשאר ה-Codec הוא 0.
- אם level הוא 0 (Unset), משתמשים בברירת המחדל של המנוע: Fail ב-COUNTER-DECLARE, ו-Review ב-EXCEPT-DECLARE.
- כלל פונקציית המארח של TANGEUL ‏`tangl:규칙` (`쓰는 규칙이다`, «כלל שמשתמש בפונקציה») נכתב כ-NODE של RULE-DECLARE מחוץ למקרה. הפונקציה ב-F_FUNC, הקריטריון ב-F_WITH, והראיות ב-F_GROUNDS. רק בכלל של ביטוי תנאי מניחים לפניו [PREDICATE-DECLARE](0x101L-predicate-declare.md).
- ביטי Reserved (13–12) חייבים להיות 0. אם ביט Reserved דלוק, או שה-role אינו תואם ל-Codec, דוחים.

### דפים קשורים {#관련-페이지-1}

- [TOULMIN](_index.md), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [SOURCE ומקטעים](#source와-구획)
- [LOCAL](../reference/0x005L-local.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## LINK {#link}

LINK היא פריסה שכותבת קשרים בין צמתים בגרף TOULMIN. סוג הקשר נקבע לפי ה-Codec.

### Codec {#codec-1}

| Codec | שם | TANGEUL | src → dst |
|---|---|---|---|
| `0x108L` | [ATTACKS](0x108L-attacks.md) | `don't X when Y` | כלל → כלל. מקטין בהדרגה את הפסק בעוצמת התקיפה |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | `X supersedes Y` | כלל → כלל. אם Active, מוציא את היעד מהצבירה |
| `0x110L` | [RUN](0x110L-run.md) | `run c when n` | כלל → מקרה |
| `0x111L` | [DO](0x111L-do.md) | `do fn when n` | כלל → FuncRef |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | `do fn once when n` | כלל → FuncRef |
| `0x113L` | [UNDO](0x113L-undo.md) | `undo fn when n` | כלל → FuncRef |
| `0x114L` | [CHECKING](0x114L-checking.md) | `checking c` | כלל → מקרה. פסק דין ללא תופעות לוואי |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | `f is required` | מקרה → שדה |
| `0x12CL` | [MEANS](0x12CL-means.md) | Definitions ‏`means` | פריט הגדרה → ערך או טיפוס |
| `0x12DL` | [HAS](0x12DL-has.md) | Definitions ‏`has` | פריט הגדרה → שדה |
| `0x12EL` | [RUNS](0x12EL-runs.md) | נקודת כניסה `run c` | נקודת כניסה → מקרה (ביצוע) |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | נקודת כניסה `check c` | נקודת כניסה → מקרה (פסק דין) |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | טריגר `run c` | טריגר → מקרה |
| `0x131L` | [UNTIL](0x131L-until.md) | `every … until c` | טריגר → מקרה |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | | צומת → מזהה גלובלי |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | `see a from path` | כינוי → נתיב (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | שם בגרשיים הפוכים (backtick) | צומת → TEXT. סימון שם |

### פריסה {#레이아웃-1}

```
ID               רשומת LOCAL Reference (Edge Id)
src              REF
dst              REF. ב-DO·DO-ONCE·UNDO הוא FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         אופרטור ב-WORD אחד (2 הביטים העליונים) + UNSIGNED-DECIMAL Value (אחוזים)
[F_FORCE]        SIGNED-DECIMAL Value. עוצמת תקיפה (0~1). ATTACKS בלבד
SPAN             הרוחב שקבע SOURCE × 2
```

| flag | משמעות |
|---|---|
| b0 F_ONCE | מבוצע פעם אחת בלבד (ה-`once` של UNDO) |
| b1 F_GATE | יש שדה שער ביטחון |
| b2 F_STRIKE | קשר שנמחק בקו חוצה |
| b3 F_ORDERED | שייך לרשימה ממוספרת `1.` |
| b4 F_FORCE | יש שדה עוצמת תקיפה. ATTACKS בלבד |

| אופרטור שער | משמעות |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- השדות המותנים מסודרים לפי סדר ה-flags (F_GATE, F_FORCE). שדה שה-flag שלו כבוי אינו תופס מקום.

### עוצמת תקיפה {#공격-세기}

עוצמת תקיפה (F_FORCE) משמשת רק את [ATTACKS](0x108L-attacks.md#공격-세기). נוסחת פסק הדין, הכתיב והדוגמה נמצאים שם.

### פירוש ותוקף {#해석과-유효성-1}

- REF הוא Edge Id של רשומה במסמך הזה (שדות משותפים של [TOULMIN](#공통-필드)).
- צורת ה-dst נקבעת לפי ה-Codec. ב-DO·DO-ONCE·UNDO הוא FuncRef (REF(ALIAS, או 0 אם אין) + VerbCode ב-WORD אחד, [NODE](#필드)), ב-LABEL·IMPORTED-FROM הוא REF של רשומת TEXT, ובשאר הוא REF של צומת.
- `do … once` מיוצג על ידי ה-Codec DO-ONCE. ב-flags של DO-ONCE לא משתמשים ב-F_ONCE (אם הוא מודלק, דוחים). ה-`once` של UNDO נכתב ב-F_ONCE.
- אופרטור השער הוא 2 הביטים העליונים של ה-WORD של האופרטור, ו-14 הביטים הנותרים הם 0. האחוז הוא UNSIGNED-DECIMAL Value עם `E=0`, בטווח 0~100.
- ביטים b5~b15 של flags הם Reserved וחייבים להיות 0. אחרת דוחים.
- F_FORCE משמש רק ב-ATTACKS. אם הוא מודלק ב-Codec אחר (SUPERSEDES, חיבורי ביצוע ופסק דין, קשרי פורמט TOULMIN), דוחים.
- אם עוצמת התקיפה אינה SIGNED-DECIMAL Value, או מחוץ ל-0~1, או שאי אפשר לייצג אותה במדויק בארבע ספרות אחרי הנקודה, דוחים.
- שרשרת `A > B > C` של SUPERSEDES נכתבת ב-SUPERSEDES אחד לכל זוג.

### דפים קשורים {#관련-페이지-2}

- [TOULMIN](_index.md), [NODE](#node), [SOURCE ומקטעים](#source와-구획)
- [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## SOURCE ומקטעים {#source와-구획}

רשומות שכותבות את טקסט המקור והחלוקה למקטעים של מסמך TOULMIN. כולן קודים ישירים `0x120L~0x125L` של משפחת Edge פורמט TOULMIN ([TOULMIN](#toulmin-형식)). אין שדות Issuer ומספר Codec, וה-Payload בא אחרי ה-TAG.

### פורמט {#형식}

| Codec | שם | פריסה |
|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, WORD רוחב SPAN, UTF8 Value |
| `0x121L` | [TEXT](0x121L-text.md) | ID, UTF8 Value |
| `0x122L` | [SECTION](0x122L-section.md) | ID, קוד קטע ב-WORD אחד |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF (מקרה) |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF (מקרה) |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN |

- ID הוא Edge Id, ו-REF הוא ה-Edge Id של רשומת המסמך הזו (שדות משותפים של [TOULMIN](#공통-필드)).
- UTF8 Value היא רשומת [UTF8-TEXT](../value/0x072L-utf8-text.md) Value. היא נושאת את הבייטים כפי שהם.

### דפים לפי פורמט {#형식별-쪽}

לכל פורמט יש דף משלו עם הפריסה, טבלת קודי הקטעים והפירוש.

- [SOURCE](0x120L-source.md): טקסט המקור של הכתיבה. הרשומה הראשונה ב-BODY, וקובעת את רוחב ה-SPAN
- [TEXT](0x121L-text.md): שם או מחרוזת
- [SECTION](0x122L-section.md): תחילת קטע וקוד הקטע
- [CASE-BEGIN](0x123L-case-begin.md), [CASE-END](0x124L-case-end.md): טווח המקרה
- [PROSE](0x125L-prose.md): פסקת תיאור

### דפים קשורים {#관련-페이지-3}

- [TOULMIN](_index.md), [NODE](#node), [LINK](#link)
