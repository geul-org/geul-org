---
title: "מאגרים"
date: 2026-02-28T12:00:00+09:00
summary: "מאגרי GitHub המרכיבים את פרויקט GEUL. מפרט שפה, ספרי קודים דקדוקיים, חיפוש, DSL ואתר אינטרנט."
image: "/images/og-default.webp"
---

כל המאגרים נמצאים בארגון [geul-org](https://github.com/geul-org) ב-GitHub.

---

## שפה

### geul

שפה מלאכותית מיושרת סמנטית ופורמט זרם בינארי לבינה מלאכותית.

מערכת שפה של 2 בתים (65,536 סמלים) שתוכננה לתקשורת חד-משמעית בין בני אדם ובינה מלאכותית. כל היגד נושא את מקורו, חותמת הזמן שלו ורמת הביטחון שלו. לכל ישות יש מזהה ייחודי. פורמט הזרם פועל ביחידות של 16 ביט, ומגדיר 10 סוגי חבילות (Verb Edge, Entity Node, Triple Edge ועוד) תחת סכמת קידומת של 10 ביט.

| | |
|---|---|
| GitHub | [geul-org/geul](https://github.com/geul-org/geul) |
| שפה | Go, Python |
| רישיון | MIT |

---

## דקדוק

### geul-verb

ספר קודים של פעלים SIDX ב-16 ביט (מבוסס WordNet).

ממפה סינסטים של פעלים מ-WordNet לקודים של 16 ביט לשימוש בחבילות GEUL Verb Edge. מספק את אוצר המילים של הפעלים שפורמט הזרם צורך.

| | |
|---|---|
| GitHub | [geul-org/geul-verb](https://github.com/geul-org/geul-verb) |
| שפה | Python |
| רישיון | MIT |

### geul-entity

ספר קודים של ישויות SIDX ב-48 ביט (מבוסס Wikidata).

מקודד ישויות Wikidata למזהים מובנים של 48 ביט. מגדיר סוגי ישויות, מעצב סכמות תכונות לכל סוג, ובונה את ספרי הקודים ש-SILK צורך.

| | |
|---|---|
| GitHub | [geul-org/geul-entity](https://github.com/geul-org/geul-entity) |
| שפה | Python |
| רישיון | MIT |

### geul-quantities

ספר קודים של צמתי כמות.

מגדיר את סכמת הקידוד לערכי כמות — מספרים עם יחידות, טווחים ודיוק — המשמשים בחבילות GEUL Quantity Node.

| | |
|---|---|
| GitHub | [geul-org/geul-quantities](https://github.com/geul-org/geul-quantities) |
| שפה | Python |
| רישיון | MIT |

### geul-ast

ספר קודים של קשתות AST.

מגדיר את סכמת הקידוד לקשתות עץ תחביר מופשט, ומאפשר ייצוג קוד מובנה בתוך פורמט הזרם של GEUL.

| | |
|---|---|
| GitHub | [geul-org/geul-ast](https://github.com/geul-org/geul-ast) |
| שפה | Python |
| רישיון | MIT |

---

## חיפוש

### silk

SILK (Symbolic Index for LLM Knowledge) — ארכיטקטורת חיפוש נוירו-סמלית.

מחפש באמצעות מספרים שלמים של 64 ביט. אין צורך במסד נתונים וקטורי, גרף ANN או מודל הטמעה. פעולת AND ביטית אחת ב-NumPy מחפשת ב-100 מיליון רשומות, והטענה המרכזית היא ש-Python לבדה עולה על חיפוש וקטורי ממוטב ב-C++/Rust. מספק צינור שאילתות היברידי המשלב חיפוש בספר קודים עם סיוע LLM.

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| שפה | Python |
| רישיון | MIT |

---

## DSL

### fullend

Full-stack SSOT Orchestrator — מאמת עקביות בין 5 מקורות SSOT (STML, OpenAPI, SSaC, SQL DDL, Terraform) ומייצר קוד מהם.

מפעיל את כלי האימות הפרטניים של כל שכבה, ואז מבצע אימות צולב של הגבולות בין השכבות. לאחר מעבר האימות, מתזמר יצירת קוד מ-sqlc, oapi-codegen, SSaC ו-STML, ומפיק קוד חיבור.

| | |
|---|---|
| GitHub | [geul-org/fullend](https://github.com/geul-org/fullend) |
| שפה | Go |
| רישיון | MIT |

### ssac

Service Sequences as Code — מפרסר לוגיקת שירות הצהרתית מהערות Go ומייצר קוד מימוש ב-Go דרך CLI.

מגדיר זרימות שירות כהערות מובנות בקבצי מקור Go. ה-CLI קורא הצהרות אלה ומייצר את קוד המימוש המתאים, ומבטל קוד תבניתי תוך שמירה על קריאות הלוגיקה ובקרת גרסאות.

| | |
|---|---|
| GitHub | [geul-org/ssac](https://github.com/geul-org/ssac) |
| שפה | Go |
| רישיון | MIT |

### stml

SSOT Template Markup Language — קישור הצהרתי UI-ל-API עם תכונות HTML5 data-*, אימות סמלי מול OpenAPI, ויצירת קוד React.

מקשר תבניות UI לסכמות API באמצעות תכונות HTML5 data. מאמת סמלית מול מפרטי OpenAPI בזמן בנייה, ואז מייצר רכיבי React בטוחי טיפוס. מקור אמת יחיד מהסכמה למסך.

| | |
|---|---|
| GitHub | [geul-org/stml](https://github.com/geul-org/stml) |
| שפה | TypeScript |
| רישיון | MIT |

---

## אתר

### geul-org

קוד המקור של אתר זה.

מחולל אתרים סטטיים Hugo התומך ב-12 שפות. מופעל דרך S3 + CloudFront, עם CloudFront Function לזיהוי שפה וכתובות URL נקיות.

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| שפה | Hugo (Go Templates), CSS |
| רישיון | MIT |
