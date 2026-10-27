---
title: "TOULMIN"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Edge של TOULMIN (Codec 0x60~0x7B) כותבות גרפי הכרעה וביצוע לפי מודל הטיעון של טולמין. הדף הזה קובע את כללי מסמך TOULMIN, השדות המשותפים, טבלת הקודים, כללי הערכים המספריים והליבה הקבועה של התיקון העצמי."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge ממשפחת TOULMIN (שני הביטים העליונים של ה-Codec `11`, קודים ישירים `0x60`~`0x7B`) כותבות גרפי הכרעה וביצוע לפי מודל הטיעון של טולמין. הצהרה על טענה, ראיית-נגד וחריג, יחסי תקיפה ודחיקה, קישורי ביצוע ותוצאות הכרעה הם כולם Edge. מסמך TANGEUL אחד (שפת הכללים של מנוע toulmin) הופך למסמך GEUL אחד. סיומת הקובץ זהה לשאר המסמכים: `.geul`.

מה שהדף הזה אינו קובע נקבע לפי הכללים המשותפים של [Edge](/he/grammar/edge/) ושל [רשומות ו-TAG WORD](/he/grammar/record/).

## מטא-קוגניציה ותיקון עצמי

TOULMIN הוא Codec של GEUL כדי ש-GEUL תוכל לבצע מטא-קוגניציה על עצמה. רק כשגם כללי ההכרעה והביצוע מתוארים ב-GEUL, TOULMIN יכול לקחת אותם כיעד ולתקן את עצמו. לכן TOULMIN אינו פרופיל יישומי אלא ליבת ההפעלה של GEUL, והוא ממוקם במרחב הקודים הישירים של Edge (`0x60`~`0x7B`).

- תיאור עצמי מאפשר שיפור עצמי, אך מסכן בשגיאה מעגלית. אם כלל מכריע בעצמו על תיקון של עצמו, גם תיקון שמרפה את קריטריון ההכרעה יכול לעבור (שיעור המעבר עולה והדיוק בפועל יורד).
- מקבלים את המעגליות כסיכון ושוברים אותה במבנה.
  - **ליבה קבועה**: משמעות ההכרעה (Pass·Review·Fail, תקיפה·דחיקה·עדיפות, הערכה תלת-ערכית וגם U → Review ב[הכרעה על בסיס לא ידוע](#הכרעה-על-בסיס-לא-ידוע) להלן) קבועה במפרט הזה. אי אפשר להמיר אותה למסמך TOULMIN. זהו אותו מקום כמו הכללים המוטמעים במפענח (שכבה 0 ב[כתובת פרסום ורשימת גרסאות](/he/grammar/publishing/#שכבות)).
  - **הפרדת מהדורות**: תיקון של מסמך כללים v(n) מוכרע לפי כללי v(n−1) ובדיקה חיצונית. כלל אינו מכריע על עצמו. תוצאת ההכרעה ממוקמת במסמך שונה מהיעד (hash התוכן של היעד אינו משתנה).
  - **היסטוריה בלתי משתנה**: תיקונים נערמים כגרסאות חדשות (`PARENT`, hash תוכן, חתימה). מכיוון שהגרסאות הישנות נשארות, אפשר למצוא שגיאה מעגלית בדיעבד ולבטל אותה. רשת הביטחון של תיקון עצמי היא מודל המהדורות של GEUL ([מסמך](/he/grammar/document/#תיקון)).
  - **קריטריון חיצוני**: מחזיקים בנפרד אוסף מקרי בדיקה שמסלול התיקון אינו יכול לגעת בו. אימוץ תיקון מאומת לפי תוצאות האוסף הזה.
- בדיקת הפרכה: מזריעים בכוונה כלל שגוי אחד. אם המערכת מתקנת אותו וציון הקריטריון החיצוני עולה, השיפור העצמי פועל. אם רק שיעור המעבר עולה וציון הקריטריון החיצוני יורד, זו שגיאה מעגלית.

## קודים

רשומת TOULMIN משתמשת באחת משלוש פריסות. הפריסה נקבעת לפי ה-Codec (או מספר הפורמט).

| פריסה | שימוש | דף |
|---|---|---|
| NODE | צומת בגרף, כמו מקרה, כלל, הגדרה, נקודת כניסה | [NODE](/he/grammar/edge/toulmin/node/) |
| LINK | יחס בין צמתים (תקיפה, דחיקה, ביצוע, הגדרה) | [LINK](/he/grammar/edge/toulmin/link/) |
| EXPR | ביטוי תנאי (פרדיקט) | [EXPR](/he/grammar/edge/toulmin/expr/) |

רשומות טקסט המקור והחלוקה (SOURCE, TEXT, SECTION, CASE-BEGIN·CASE-END, PROSE) נקבעות ב-[SOURCE וחלוקה](/he/grammar/edge/toulmin/source/).

### קודים ישירים

| Codec | שם | פריסה | TANGEUL | משמעות |
|---|---|---|---|---|
| `0x60` | [CASE-DECLARE](/he/grammar/edge/toulmin/node/) | NODE | `in case of` | הצהרת מקרה. גרף הכרעה שמכיל צמתים ויחסים |
| `0x61` | [PREDICATE-DECLARE](/he/grammar/edge/toulmin/expr/) | EXPR | ביטוי תנאי ב-Rules | הצהרת פרדיקט. ביטוי הכרעה |
| `0x62` | [SPEC-DECLARE](/he/grammar/edge/toulmin/node/) | NODE | פריט ב-Definitions | הצהרת קריטריון שיפוט (Backing). ביט role הוא סוג ההגדרה |
| `0x63` | [RULE-DECLARE](/he/grammar/edge/toulmin/node/) | NODE | general rule, שם כלל ב-Rules | הצהרת טענה (Warrant). אפשר לתקוף אותה |
| `0x64` | [COUNTER-DECLARE](/he/grammar/edge/toulmin/node/) | NODE | counter rule | הצהרת ראיית-נגד. תוקפת ויש לה מסקנה משלה. ה-Level כברירת מחדל הוא Fail |
| `0x65` | [EXCEPT-DECLARE](/he/grammar/edge/toulmin/node/) | NODE | except rule | הצהרת חריג. תוקף בלי מסקנה משלו. ה-Level כברירת מחדל הוא Review |
| `0x68` | [ATTACKS](/he/grammar/edge/toulmin/link/) | LINK | `don't X when Y` | יחס תקיפה. ההכרעה של התוקף מקטינה בהדרגה את ההכרעה של היעד |
| `0x69` | [SUPERSEDES](/he/grammar/edge/toulmin/link/) | LINK | `X supersedes Y` | יחס דחיקה. כשהתוקף Active, היעד מוצא באופן מכריע מהצבירה. שרשרת (`A > B > C`) נכתבת כרשומה אחת לכל זוג |
| `0x6A` | SUPERSEDE-CHAIN | — | | שרשרת עדיפויות `A > B > C`. קיצור של SUPERSEDES בזוגות. הוקצה רק הקוד, ועדיין אין פריסה |
| `0x70` | [RUN](/he/grammar/edge/toulmin/link/) | LINK | `run c when n` | הרכבת ביצוע. כשהצומת Active, מריצה מקרה משנה (DAG) |
| `0x71` | [DO](/he/grammar/edge/toulmin/link/) | LINK | `do fn when n` | פעולה שמתבצעת כשהצומת Active |
| `0x72` | [DO-ONCE](/he/grammar/edge/toulmin/link/) | LINK | `do fn once when n` | פעולה שמתבצעת פעם אחת בלבד גם בניסיון חוזר |
| `0x73` | [UNDO](/he/grammar/edge/toulmin/link/) | LINK | `undo fn when n` | פעולת פיצוי של DO (saga). אם שלב מאוחר נכשל, מתבצעת בסדר הפוך |
| `0x74` | [CHECKING](/he/grammar/edge/toulmin/link/) | LINK | `checking c` | קישור שרק מכריע, בלי תופעות לוואי |
| `0x75` | [ENTRY](/he/grammar/edge/toulmin/node/) | NODE | `provides x` | נקודת כניסה חיצונית. מריצה או מכריעה מקרה |
| `0x76` | [TRIGGER](/he/grammar/edge/toulmin/node/) | NODE | `on`, `every`, `until` | נקודת כניסה של אירוע או מחזור, בלי קריאה חיצונית |
| `0x78` | VERDICT | — | | תוצאת הכרעה של צומת או רשומה. תוצאה (Pass, Review, Fail), ערך הכרעה, Activated, Excluded, Level. הוקצה רק הקוד, ועדיין אין פריסה |
| `0x79` | EVIDENCE | — | | ראיה להכרעה. מיקום, ערך צפוי, ערך בפועל (Fact). הוקצה רק הקוד, ועדיין אין פריסה |
| `0x7C`~`0x7F` | ISSUER-* | | | פורמט שה-Issuer הגדיר. ראו להלן פורמט ISSUER |

- קודים ישירים שאינם בטבלה (`0x66`·`0x67`, `0x6B`~`0x6F`, `0x77`, `0x7A`·`0x7B`) שמורים.
- שני הביטים העליונים של 5 הביטים התחתונים של ה-Codec הם הקבוצה: `00` הצהרה, `01` יחס, `10` ביצוע, `11` תוצאה (`0x7C`~`0x7F` הם ISSUER).
- ההכרעה של המסמך כולו היא תפקידו של Meta [VERDICT](/he/grammar/meta/verification/verdict/) (`0x44`), וההכרעה של צומת או רשומה היא תפקידו של `VERDICT` ב-TOULMIN (Edge `0x78`). אלה שני Codec נפרדים עם Kind שונה.

### פורמט ISSUER

רשומות TOULMIN שאין להן מספיק קודים ישירים מוצבות ב-`ISSUER-1WORD` (`0x7C`) כמספר פורמט תחת Issuer `0x0000` (GEUL). מספר הפורמט שייך למשפחת TOULMIN (`0xC000`~`0xFFFF`, שני ביטים עליונים `11`).

```
TAG WORD          0001 0LLL L111 1100      Edge, Codec 0x7C
[Length extension TAG]
Issuer            0x0000
מספר פורמט        0xC000~0xC029
Edge Id           רשומת LOCAL Reference
רכיבים            הפריסה שהפורמט קובע
```

| מספר פורמט | שם | פריסה | משמעות |
|---|---|---|---|
| `0xC000` | [SOURCE](/he/grammar/edge/toulmin/source/) | ID, WORD של רוחב SPAN, Value של UTF8 | טקסט מקור של הכותב |
| `0xC001` | [TEXT](/he/grammar/edge/toulmin/source/) | ID, Value של UTF8 | שם או מחרוזת |
| `0xC002` | [SECTION](/he/grammar/edge/toulmin/source/) | ID, קוד סעיף של WORD אחד | תחילת סעיף |
| `0xC003` | [CASE-BEGIN](/he/grammar/edge/toulmin/source/) | ID, REF (מקרה) | תחילת טווח של מקרה |
| `0xC004` | [CASE-END](/he/grammar/edge/toulmin/source/) | ID, REF (מקרה) | סוף טווח של מקרה |
| `0xC005` | [PROSE](/he/grammar/edge/toulmin/source/) | ID, SPAN | פסקת תיאור |
| `0xC010` | [NAMESPACE](/he/grammar/edge/toulmin/node/) | NODE | `this document is` |
| `0xC011` | [FUNC](/he/grammar/edge/toulmin/node/) | NODE | הפניה לפונקציה |
| `0xC012` | [FIELD](/he/grammar/edge/toulmin/node/) | NODE | `is required` |
| `0xC013` | [ALIAS](/he/grammar/edge/toulmin/node/) | NODE | `see … from` |
| `0xC014` | [GROUP](/he/grammar/edge/toulmin/node/) | NODE | קבוצת ביצוע סדורה |
| `0xC020` | [REQUIRES](/he/grammar/edge/toulmin/link/) | LINK | מקרה → שדה |
| `0xC021` | [MEANS](/he/grammar/edge/toulmin/link/) | LINK | פריט הגדרה → ערך או טיפוס |
| `0xC022` | [HAS](/he/grammar/edge/toulmin/link/) | LINK | פריט הגדרה → שדה |
| `0xC023` | [RUNS](/he/grammar/edge/toulmin/link/) | LINK | נקודת כניסה → מקרה, ביצוע |
| `0xC024` | [EVALUATES](/he/grammar/edge/toulmin/link/) | LINK | נקודת כניסה → מקרה, הכרעה |
| `0xC025` | [TRIGGERS](/he/grammar/edge/toulmin/link/) | LINK | trigger → מקרה |
| `0xC026` | [UNTIL](/he/grammar/edge/toulmin/link/) | LINK | trigger → מקרה (`every … until`) |
| `0xC027` | [SAME-AS](/he/grammar/edge/toulmin/link/) | LINK | צומת → מזהה גלובלי |
| `0xC028` | [IMPORTED-FROM](/he/grammar/edge/toulmin/link/) | LINK | כינוי → נתיב (TEXT) |
| `0xC029` | [LABEL](/he/grammar/edge/toulmin/link/) | LINK | צומת → TEXT, רישום שם |

- מרחב מספרי הפורמט נפרד לכל Kind. הפורמט `0xC000` של GEUL ב-Value (OPAQUE-BYTES-EVEN) ו-`0xC000` ב-Edge (SOURCE) הם פורמטים שונים.
- מספרי פורמט רק נוספים. מספר שהוקצה לא משתמשים בו שוב לפורמט אחר.

## מסמך

קובץ `.geul` אחד הוא DOC אחד. מחוץ ל-DOC לא מציבים בייטים אחרים.

```
DOC-1WORD/2WORD/4WORD     אורך כולל
  SPEC-VERSION            0x0001 (v1, מספר שלם בלי Value מוטמע)
  PROFILE                 Value של UTF8 "tangeul-<major>.<minor>". כרגע "tangeul-1.0"
  [DEFAULT-LANGUAGE]      Value של LANGUAGE-BCP47-CODE. הלוקאל של הכתיבה ("en", "ko")
BODY
  SOURCE                  טקסט מקור של הכותב. הרשומה הראשונה ב-BODY
  רשומות משפט …           לפי סדר ההצהרה במסמך
END
```

- HEAD: [SPEC-VERSION](/he/grammar/meta/declaration/spec-version/), [PROFILE](/he/grammar/meta/declaration/profile/), ואופציונלית [DEFAULT-LANGUAGE](/he/grammar/meta/declaration/default-language/).
- המפענח דוחה אם SPEC-VERSION שונה או אם ה-major של PROFILE שונה. אם רק ה-minor שונה, הוא קורא.
- הרשומה הראשונה ב-BODY היא SOURCE. כל SPAN הוא טווח בתוך הטקסט המקורי הזה.
- סדר רשומות המשפט זהה לסדר ההצהרה במסמך. סדר הביצוע (הפעלת `do` ו-`run`, פיצוי `undo` בסדר הפוך) נשען על הסדר הזה. במסמך TOULMIN לסדר ה-Edge יש משמעות (חריג לכלל הסדר ב-[Edge](/he/grammar/edge/)).
- כל הרשומות ב-BODY הן Edge. לא מציבים רשומת Value עצמאית. ערכים מוטמעים ב-Payload של ה-Edge.
- הזהות של המקרה והייבוא משתמשים ב-Meta [DOC-ID](/he/grammar/meta/declaration/doc-id/) ו-[IMPORT-DOC](/he/grammar/meta/import/import-doc/) (Subject ו-See ב-TANGEUL).

## שדות משותפים

| שדה | רוחב | הסבר |
|---|---|---|
| ID | רשומת LOCAL Reference | ה-Edge Id של הרשומה. הרכיב הראשון ב-Payload של כל רשומה |
| REF | רשומת LOCAL Reference | Edge Id שמצביע על רשומה אחרת במסמך הזה. `0` פירושו אין |
| SPAN | הרוחב ש-SOURCE קובע × 2 | טווח בתוך טקסט המקור של הכותב. בייט התחלה, מספר בייטים |

- ID ו-REF הם רשומות [LOCAL](/he/grammar/reference/local/) Reference מוטמעות (`0000 0LLL L000 1000` + ID ברוחב הקצר ביותר). הרוחב נקבע לפי ה-Length של אותה רשומה ואינו מוצהר ברמת המסמך.
- REF `0` (LOCAL `0`) פירושו "אין". זהו כלל Codec שמשתמש ב-LOCAL `0` כ"אין" ([LOCAL](/he/grammar/reference/local/)).
- מקצים Edge Id החל מ-1, ולא חוזרים עליו בתוך מסמך. `0` הוא "אין" של REF ולכן אינו משמש כ-Edge Id.
- לצמתים מפנים הפניות קדימה רשומות אחרות, ולכן הם מקבלים מספרים ראשונים לפי סדר ההצהרה במסמך. שאר הרשומות (SOURCE, TEXT, LINK, FUNC, רשומות חלוקה) מקבלות מספרים מהמספר שאחרי הצמתים, והמקודד מקצה אותם.
- המפענח רק בודק שה-Edge Id אינו 0 ושאין כפילות. סדר ההקצאה אינו משמש בפירוש.
- צמתים ויחסים מוצבעים באמצעות Edge Id.
- Value מוטמע הוא רשומת Value כמות שהיא, כולל ה-TAG WORD. האורך נקבע לפי אותו TAG.

## ערכים מספריים

- ערך ההכרעה (−1~1) ו-Qualifier (0~1) הם Value מסוג [SIGNED-DECIMAL](/he/grammar/value/decimal/signed-decimal/). לא מציבים פורמט נפרד של נקודה קבועה.
- המקודד מוחק אפסים בסוף המקדם. 0.8 הוא `C=8, E=−1`. המפענח מקבל עד 4 ספרות אחרי הנקודה.
- שער ודאות (למשל `at least 75%`) נכתב כאופרטור השוואה של WORD אחד וכ-[UNSIGNED-DECIMAL](/he/grammar/value/decimal/unsigned-decimal/) באחוזים (`E=0`) ([LINK](/he/grammar/edge/toulmin/link/) F_GATE).

## צירי הצהרה על צומת

- הצהרת צומת (RULE·COUNTER·EXCEPT-DECLARE) כוללת תפקיד (טענה, ראיית-נגד, חריג), Qualifier (0~1) ו-Level (Unset, Fail, Review). התפקיד נמצא ב-Codec וב-role שבכותרת ה-NODE, ה-Qualifier ב-F_QUAL, וה-Level ב-level שבכותרת ([NODE](/he/grammar/edge/toulmin/node/)).
- עוצמה (Strict, Defeasible, Defeater) היא ציר נפרד מהתפקיד. מיקום העוצמה טרם נקבע.

## הכרעה על בסיס לא ידוע

כשגרף הכרעה מקבל עובדות GEUL כקלט, שלושת המושגים של [סמן מקום](/he/grammar/reference/slot-marker/) (לא נכתב, לא ידוע, אין) מוערכים באופן שונה. הערכת אופרטורי ההשוואה של [EXPR](/he/grammar/edge/toulmin/expr/) היא כדלקמן.

| קלט | `is empty` | `is not empty` | `equals` / `is in` / השוואת גודל |
|---|---|---|---|
| ערך v | שקר | אמת | מוערך לפי v |
| NO-VALUE (אין) | **אמת** | שקר | שקר |
| UNKNOWN-VALUE (לא ידוע) | שקר | **אמת** | **לא מוכרע (U)** |
| ABSENT (לא נכתב) / אין תיאור | U (עולם פתוח) | U | U |

- הלוגיקה היא תלת-ערכית חזקה של Kleene. `NOT U = U`, `שקר AND U = שקר`, `אמת OR U = אמת`. בשאר הצירופים U נשאר U.
- `EXISTS any` הוא אמת אם אחד האיברים אמת. אם אין אמת ויש U, התוצאה U, ואם כולם שקר, התוצאה שקר.
- **אם הפרדיקט הוא U, ההכרעה של הצומת אינה Pass או Fail אלא Review.** כשלא יודעים, מעבירים לאדם (או לשלב הבא).
- כדי לראות ABSENT כ-empty ולא כ-U, צד הקלט חייב **להצהיר** על עולם סגור (להזריק כקריטריון שיפוט SPEC, למשל: "הקלט של המקרה הזה שלם"). בלי הצהרה זה U.
- הטבלה הזו וההתאמה U → Review הן משמעות ההכרעה, ולכן הן **ליבה קבועה**. אי אפשר להמיר אותן למסמך TOULMIN.
- דוגמה: הכלל "סופרים רק גבולות שעדיין בתוקף" (`P582 is empty`) מוציא (שקר) כש-P582 = UNKNOWN-VALUE, כולל (אמת) כש-P582 = NO-VALUE, ושולח ל-Review (U) כשאין P582.

## תוצאת הכרעה

- תוצאות הכרעה (`VERDICT`, `EVIDENCE`) ממוקמות במסמך שונה ממסמך היעד. מסמך התוצאה מייבא את מסמך היעד ב-[IMPORT-DOC](/he/grammar/meta/import/import-doc/) ומצביע עליו ב-[EXTERNAL-POINTER-*](/he/grammar/reference/external-pointer/). לכן גם אחרי הכרעה ה-hash של תוכן מסמך היעד אינו משתנה.
- ההכרעה של המסמך כולו היא Meta `VERDICT`, וההכרעה של צומת או רשומה היא `VERDICT` ב-TOULMIN.
- גם הכללים שבוחרים איזו מהדורה חלה בתיקון (הוראות מעבר, בחירה בין החוק בזמן המעשה לחוק חדש) ופרשנות ופסיקה נכתבים ככללי הכרעה ([מסמך](/he/grammar/document/#תיקון)).

## שאלות פתוחות

- הפריסה של SUPERSEDE-CHAIN (`0x6A`), VERDICT (`0x78`) ו-EVIDENCE (`0x79`). האם בשיטה הנוכחית, שבה SUPERSEDES נכתב לכל זוג, מספיקה שרשרת.
- מיקום עוצמת הצומת (Strict, Defeasible, Defeater).
- מספר הצמתים בתוך EXPR, מספר התוויות ואינדקס התווית הם WORD אחד, ומספר הצאצאים הוא 13 ביט. הגבולות העליונים קבועים.
- פריסת PROVENANCE (מקור הכלל והנחות היסוד).
- האם לשים שמות בגרשיים הפוכים כ-[LABEL](/he/grammar/edge/label/) ו-[BIND](/he/grammar/edge/bind/) תיאוריים במקום TEXT + LABEL (`0xC029`).
- טבלת ערכי הקוד של predicate ו-mode ב-Claim, וערכי הקוד של VerbCode ב-FuncRef.
- האם ההצהרה על עולם סגור (קריאת ABSENT כ-empty) תהיה לפי קריטריון שיפוט (SPEC) או לפי מקרה.
- [מסמך מפרט Codec](/he/grammar/codec-spec/) של Codec ב-TOULMIN. התנאים הרשותיים בשדות של NODE ו-LINK ורוחב ה-SPAN ש-SOURCE קובע הם פריסות שאי אפשר להצהיר עליהן כ-FIELD.

## דפים קשורים

- [NODE](/he/grammar/edge/toulmin/node/), [LINK](/he/grammar/edge/toulmin/link/), [EXPR](/he/grammar/edge/toulmin/expr/), [SOURCE וחלוקה](/he/grammar/edge/toulmin/source/)
- [Edge](/he/grammar/edge/), [מסמך](/he/grammar/document/), [PROFILE](/he/grammar/meta/declaration/profile/)
