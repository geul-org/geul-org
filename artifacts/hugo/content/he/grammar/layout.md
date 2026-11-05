---
title: "פריסת הקטעים"
weight: 70
date: 2026-11-05T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar"]
summary: "קובעת את פריסת 16 הקטעים של 4 הסיביות העליונות ב-TAG WORD ו-32 התאים של היסט 5 הסיביות בתוך קטע. תא שאינו בטבלה הוא Reserved."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

זוהי פריסת plan2 (migration1). ה-TAG WORD הוא `000K KKKC CCCC LLLL`, כאשר 4 הסיביות העליונות `KKKK` הן הקטע ו-`C` הוא היסט 5 הסיביות בתוך הקטע. קטע אחד הוא 32 תאים ([רשומה ו-TAG WORD](record.md)). תא שאינו בטבלה הוא Reserved.

## קטעים {#섹션}

| קטע | טווח | שם | Kind | הוקצו | Reserved |
|---|---|---|---|---:|---:|
| 0 `0000` | `0x000L~0x01FL` | ישויות Reference | Reference | 28 | 4 |
| 1 `0001` | `0x020L~0x03FL` | Reference EXTERNAL | Reference | 30 | 2 |
| 2 `0010` | `0x040L~0x05FL` | Reference אחר | Reference | 6 | 26 |
| 3 `0011` | `0x060L~0x07FL` | Value | Value | 32 | 0 |
| 4 `0100` | `0x080L~0x09FL` | Value | Value | 5 | 27 |
| 5 `0101` | `0x0A0L~0x0BFL` | Edge של היגד | Edge | 21 | 11 |
| 6 `0110` | `0x0C0L~0x0DFL` | Edge של ראיות | Edge | 1 | 31 |
| 7 `0111` | `0x0E0L~0x0FFL` | Edge של ביצוע | Edge | 20 | 12 |
| 8 `1000` | `0x100L~0x11FL` | Edge TOULMIN | Edge | 18 | 14 |
| 9 `1001` | `0x120L~0x13FL` | פורמט Edge TOULMIN | Edge | 21 | 11 |
| 10 `1010` | `0x140L~0x15FL` | Edge (כל הקטע Reserved) | Edge | 0 | 32 |
| 11 `1011` | `0x160L~0x17FL` | Edge (כל הקטע Reserved) | Edge | 0 | 32 |
| 12 `1100` | `0x180L~0x19FL` | Edge (כל הקטע Reserved) | Edge | 0 | 32 |
| 13 `1101` | `0x1A0L~0x1BFL` | Edge (3 התאים האחרונים ISSUER) | Edge | 3 | 29 |
| 14 `1110` | `0x1C0L~0x1DFL` | Meta | Meta | 32 | 0 |
| 15 `1111` | `0x1E0L~0x1FFL` | Meta | Meta | 10 | 22 |

- ה-Kind נקבע לפי טווח הקטע בלבד: `w < 0x0600` Reference, `w < 0x0A00` Value, `w < 0x1C00` Edge, והשאר Meta ([אינדקס Codec](codec-index.md)).
- שלושת התאים האחרונים בתחומי Reference, Value ו-Edge הם ISSUER (`..DL` 2 WORD, `..EL` 4 WORD, `..FL` 16 WORD). ל-Meta אין ISSUER.
- `0x11CL~0x11FL` הם תאים שהוגדרו כ-Reserved (נכללים ב-14 תאי ה-Reserved של קטע 8). סך התאים שהוקצו הוא 227.

## תאים {#칸}

אלה התאים שהוקצו והתאים שהוגדרו כ-Reserved. השם הוא שם לפי קוד (ב-5Q: `<מערך>-<כימות>`, בזוג זוגי-אי-זוגי: `<שם>-EVEN`·`<שם>-ODD`). לכל תא שהוקצה יש מסמך Codec אחד לכל קוד של ה-Issuer GEUL (`0x00000000`). Codec ID הוא ה-TAG WORD (L=0) כתוב כ-32 סיביות. ״דף״ הוא קובץ ה-md של הדקדוק שעוסק בקוד, ובמערך 5Q ובזוג זוגי-אי-זוגי קובץ md מאוגד אחד מטפל בכל החברים יחד.

| TAG ID | שם | Kind | קטע | Codec ID | דף |
|---|---|---|---|---|---|
| `0x000L` | ABSENT | Reference | 0 | `0x00000000` | [0x000L-absent](reference/0x000L-absent.md) |
| `0x001L` | UNKNOWN-VALUE | Reference | 0 | `0x00000010` | [0x001L-unknown-value](reference/0x001L-unknown-value.md) |
| `0x002L` | NO-VALUE | Reference | 0 | `0x00000020` | [0x002L-no-value](reference/0x002L-no-value.md) |
| `0x005L` | LOCAL-IDENTIFIED | Reference | 0 | `0x00000050` | [0x005L-local](reference/0x005L-local.md) |
| `0x006L` | LOCAL-GENERIC | Reference | 0 | `0x00000060` | [0x005L-local](reference/0x005L-local.md) |
| `0x007L` | LOCAL-FREE-CHOICE | Reference | 0 | `0x00000070` | [0x005L-local](reference/0x005L-local.md) |
| `0x008L` | LOCAL-UNIVERSAL | Reference | 0 | `0x00000080` | [0x005L-local](reference/0x005L-local.md) |
| `0x009L` | LOCAL-VARIABLE | Reference | 0 | `0x00000090` | [0x005L-local](reference/0x005L-local.md) |
| `0x00AL` | GEUL-IDENTIFIED | Reference | 0 | `0x000000A0` | [0x00AL-geul](reference/0x00AL-geul.md) |
| `0x00BL` | GEUL-GENERIC | Reference | 0 | `0x000000B0` | [0x00AL-geul](reference/0x00AL-geul.md) |
| `0x00CL` | GEUL-FREE-CHOICE | Reference | 0 | `0x000000C0` | [0x00AL-geul](reference/0x00AL-geul.md) |
| `0x00DL` | GEUL-UNIVERSAL | Reference | 0 | `0x000000D0` | [0x00AL-geul](reference/0x00AL-geul.md) |
| `0x00EL` | GEUL-VARIABLE | Reference | 0 | `0x000000E0` | [0x00AL-geul](reference/0x00AL-geul.md) |
| `0x00FL` | GEUL-SIDX-IDENTIFIED | Reference | 0 | `0x000000F0` | [0x00FL-geul-sidx](reference/0x00FL-geul-sidx.md) |
| `0x010L` | GEUL-SIDX-GENERIC | Reference | 0 | `0x00000100` | [0x00FL-geul-sidx](reference/0x00FL-geul-sidx.md) |
| `0x011L` | GEUL-SIDX-FREE-CHOICE | Reference | 0 | `0x00000110` | [0x00FL-geul-sidx](reference/0x00FL-geul-sidx.md) |
| `0x012L` | GEUL-SIDX-UNIVERSAL | Reference | 0 | `0x00000120` | [0x00FL-geul-sidx](reference/0x00FL-geul-sidx.md) |
| `0x013L` | GEUL-SIDX-VARIABLE | Reference | 0 | `0x00000130` | [0x00FL-geul-sidx](reference/0x00FL-geul-sidx.md) |
| `0x014L` | WIKIDATA-QID-IDENTIFIED | Reference | 0 | `0x00000140` | [0x014L-wikidata-qid](reference/0x014L-wikidata-qid.md) |
| `0x015L` | WIKIDATA-QID-GENERIC | Reference | 0 | `0x00000150` | [0x014L-wikidata-qid](reference/0x014L-wikidata-qid.md) |
| `0x016L` | WIKIDATA-QID-FREE-CHOICE | Reference | 0 | `0x00000160` | [0x014L-wikidata-qid](reference/0x014L-wikidata-qid.md) |
| `0x017L` | WIKIDATA-QID-UNIVERSAL | Reference | 0 | `0x00000170` | [0x014L-wikidata-qid](reference/0x014L-wikidata-qid.md) |
| `0x018L` | WIKIDATA-QID-VARIABLE | Reference | 0 | `0x00000180` | [0x014L-wikidata-qid](reference/0x014L-wikidata-qid.md) |
| `0x019L` | WIKIDATA-PID-IDENTIFIED | Reference | 0 | `0x00000190` | [0x019L-wikidata-pid](reference/0x019L-wikidata-pid.md) |
| `0x01AL` | WIKIDATA-PID-GENERIC | Reference | 0 | `0x000001A0` | [0x019L-wikidata-pid](reference/0x019L-wikidata-pid.md) |
| `0x01BL` | WIKIDATA-PID-FREE-CHOICE | Reference | 0 | `0x000001B0` | [0x019L-wikidata-pid](reference/0x019L-wikidata-pid.md) |
| `0x01CL` | WIKIDATA-PID-UNIVERSAL | Reference | 0 | `0x000001C0` | [0x019L-wikidata-pid](reference/0x019L-wikidata-pid.md) |
| `0x01DL` | WIKIDATA-PID-VARIABLE | Reference | 0 | `0x000001D0` | [0x019L-wikidata-pid](reference/0x019L-wikidata-pid.md) |
| `0x020L` | EXTERNAL-POINTER-1WORD-IDENTIFIED | Reference | 1 | `0x00000200` | [0x020L-external-pointer-1word](reference/0x020L-external-pointer-1word.md) |
| `0x021L` | EXTERNAL-POINTER-1WORD-GENERIC | Reference | 1 | `0x00000210` | [0x020L-external-pointer-1word](reference/0x020L-external-pointer-1word.md) |
| `0x022L` | EXTERNAL-POINTER-1WORD-FREE-CHOICE | Reference | 1 | `0x00000220` | [0x020L-external-pointer-1word](reference/0x020L-external-pointer-1word.md) |
| `0x023L` | EXTERNAL-POINTER-1WORD-UNIVERSAL | Reference | 1 | `0x00000230` | [0x020L-external-pointer-1word](reference/0x020L-external-pointer-1word.md) |
| `0x024L` | EXTERNAL-POINTER-1WORD-VARIABLE | Reference | 1 | `0x00000240` | [0x020L-external-pointer-1word](reference/0x020L-external-pointer-1word.md) |
| `0x025L` | EXTERNAL-POINTER-2WORD-IDENTIFIED | Reference | 1 | `0x00000250` | [0x025L-external-pointer-2word](reference/0x025L-external-pointer-2word.md) |
| `0x026L` | EXTERNAL-POINTER-2WORD-GENERIC | Reference | 1 | `0x00000260` | [0x025L-external-pointer-2word](reference/0x025L-external-pointer-2word.md) |
| `0x027L` | EXTERNAL-POINTER-2WORD-FREE-CHOICE | Reference | 1 | `0x00000270` | [0x025L-external-pointer-2word](reference/0x025L-external-pointer-2word.md) |
| `0x028L` | EXTERNAL-POINTER-2WORD-UNIVERSAL | Reference | 1 | `0x00000280` | [0x025L-external-pointer-2word](reference/0x025L-external-pointer-2word.md) |
| `0x029L` | EXTERNAL-POINTER-2WORD-VARIABLE | Reference | 1 | `0x00000290` | [0x025L-external-pointer-2word](reference/0x025L-external-pointer-2word.md) |
| `0x02AL` | EXTERNAL-POINTER-4WORD-IDENTIFIED | Reference | 1 | `0x000002A0` | [0x02AL-external-pointer-4word](reference/0x02AL-external-pointer-4word.md) |
| `0x02BL` | EXTERNAL-POINTER-4WORD-GENERIC | Reference | 1 | `0x000002B0` | [0x02AL-external-pointer-4word](reference/0x02AL-external-pointer-4word.md) |
| `0x02CL` | EXTERNAL-POINTER-4WORD-FREE-CHOICE | Reference | 1 | `0x000002C0` | [0x02AL-external-pointer-4word](reference/0x02AL-external-pointer-4word.md) |
| `0x02DL` | EXTERNAL-POINTER-4WORD-UNIVERSAL | Reference | 1 | `0x000002D0` | [0x02AL-external-pointer-4word](reference/0x02AL-external-pointer-4word.md) |
| `0x02EL` | EXTERNAL-POINTER-4WORD-VARIABLE | Reference | 1 | `0x000002E0` | [0x02AL-external-pointer-4word](reference/0x02AL-external-pointer-4word.md) |
| `0x02FL` | EXTERNAL-ISSUER-2WORD-IDENTIFIED | Reference | 1 | `0x000002F0` | [0x02FL-external-issuer-2word](reference/0x02FL-external-issuer-2word.md) |
| `0x030L` | EXTERNAL-ISSUER-2WORD-GENERIC | Reference | 1 | `0x00000300` | [0x02FL-external-issuer-2word](reference/0x02FL-external-issuer-2word.md) |
| `0x031L` | EXTERNAL-ISSUER-2WORD-FREE-CHOICE | Reference | 1 | `0x00000310` | [0x02FL-external-issuer-2word](reference/0x02FL-external-issuer-2word.md) |
| `0x032L` | EXTERNAL-ISSUER-2WORD-UNIVERSAL | Reference | 1 | `0x00000320` | [0x02FL-external-issuer-2word](reference/0x02FL-external-issuer-2word.md) |
| `0x033L` | EXTERNAL-ISSUER-2WORD-VARIABLE | Reference | 1 | `0x00000330` | [0x02FL-external-issuer-2word](reference/0x02FL-external-issuer-2word.md) |
| `0x034L` | EXTERNAL-ISSUER-4WORD-IDENTIFIED | Reference | 1 | `0x00000340` | [0x034L-external-issuer-4word](reference/0x034L-external-issuer-4word.md) |
| `0x035L` | EXTERNAL-ISSUER-4WORD-GENERIC | Reference | 1 | `0x00000350` | [0x034L-external-issuer-4word](reference/0x034L-external-issuer-4word.md) |
| `0x036L` | EXTERNAL-ISSUER-4WORD-FREE-CHOICE | Reference | 1 | `0x00000360` | [0x034L-external-issuer-4word](reference/0x034L-external-issuer-4word.md) |
| `0x037L` | EXTERNAL-ISSUER-4WORD-UNIVERSAL | Reference | 1 | `0x00000370` | [0x034L-external-issuer-4word](reference/0x034L-external-issuer-4word.md) |
| `0x038L` | EXTERNAL-ISSUER-4WORD-VARIABLE | Reference | 1 | `0x00000380` | [0x034L-external-issuer-4word](reference/0x034L-external-issuer-4word.md) |
| `0x039L` | EXTERNAL-ISSUER-16WORD-IDENTIFIED | Reference | 1 | `0x00000390` | [0x039L-external-issuer-16word](reference/0x039L-external-issuer-16word.md) |
| `0x03AL` | EXTERNAL-ISSUER-16WORD-GENERIC | Reference | 1 | `0x000003A0` | [0x039L-external-issuer-16word](reference/0x039L-external-issuer-16word.md) |
| `0x03BL` | EXTERNAL-ISSUER-16WORD-FREE-CHOICE | Reference | 1 | `0x000003B0` | [0x039L-external-issuer-16word](reference/0x039L-external-issuer-16word.md) |
| `0x03CL` | EXTERNAL-ISSUER-16WORD-UNIVERSAL | Reference | 1 | `0x000003C0` | [0x039L-external-issuer-16word](reference/0x039L-external-issuer-16word.md) |
| `0x03DL` | EXTERNAL-ISSUER-16WORD-VARIABLE | Reference | 1 | `0x000003D0` | [0x039L-external-issuer-16word](reference/0x039L-external-issuer-16word.md) |
| `0x040L` | ISSUER-POINTER | Reference | 2 | `0x00000400` | [0x040L-issuer-pointer](reference/0x040L-issuer-pointer.md) |
| `0x041L` | DOC-POINTER | Reference | 2 | `0x00000410` | [0x041L-doc-pointer](reference/0x041L-doc-pointer.md) |
| `0x042L` | CODEC-POINTER | Reference | 2 | `0x00000420` | [0x042L-codec-pointer](reference/0x042L-codec-pointer.md) |
| `0x05DL` | REFERENCE-ISSUER-2WORD | Reference | 2 | `0x000005D0` | [0x05DL-reference-issuer-2word](reference/0x05DL-reference-issuer-2word.md) |
| `0x05EL` | REFERENCE-ISSUER-4WORD | Reference | 2 | `0x000005E0` | [0x05EL-reference-issuer-4word](reference/0x05EL-reference-issuer-4word.md) |
| `0x05FL` | REFERENCE-ISSUER-16WORD | Reference | 2 | `0x000005F0` | [0x05FL-reference-issuer-16word](reference/0x05FL-reference-issuer-16word.md) |
| `0x060L` | BOOL | Value | 3 | `0x00000600` | [0x060L-bool](value/0x060L-bool.md) |
| `0x061L` | SIGNED-INTEGER | Value | 3 | `0x00000610` | [0x061L-signed-integer](value/0x061L-signed-integer.md) |
| `0x062L` | UNSIGNED-INTEGER | Value | 3 | `0x00000620` | [0x062L-unsigned-integer](value/0x062L-unsigned-integer.md) |
| `0x063L` | BINARY-FLOAT | Value | 3 | `0x00000630` | [0x063L-binary-float](value/0x063L-binary-float.md) |
| `0x064L` | COORDINATE-EARTH | Value | 3 | `0x00000640` | [0x064L-coordinate-earth](value/0x064L-coordinate-earth.md) |
| `0x065L` | COORDINATE-GEO | Value | 3 | `0x00000650` | [0x065L-coordinate-geo](value/0x065L-coordinate-geo.md) |
| `0x066L` | QUANTITY | Value | 3 | `0x00000660` | [0x066L-quantity](value/0x066L-quantity.md) |
| `0x067L` | FRACTION | Value | 3 | `0x00000670` | [0x067L-fraction](value/0x067L-fraction.md) |
| `0x068L` | SIGNED-DECIMAL | Value | 3 | `0x00000680` | [0x068L-signed-decimal](value/0x068L-signed-decimal.md) |
| `0x069L` | UNSIGNED-DECIMAL | Value | 3 | `0x00000690` | [0x069L-unsigned-decimal](value/0x069L-unsigned-decimal.md) |
| `0x06AL` | GREGORIAN-DATE | Value | 3 | `0x000006A0` | [0x06AL-gregorian-date](value/0x06AL-gregorian-date.md) |
| `0x06BL` | CIVIL-TIME-NANOSECONDS | Value | 3 | `0x000006B0` | [0x06BL-civil-time-nanoseconds](value/0x06BL-civil-time-nanoseconds.md) |
| `0x06CL` | POSIX-TIMESTAMP-SECONDS | Value | 3 | `0x000006C0` | [0x06CL-posix-timestamp-seconds](value/0x06CL-posix-timestamp-seconds.md) |
| `0x06DL` | DURATION-SECONDS | Value | 3 | `0x000006D0` | [0x06DL-duration-seconds](value/0x06DL-duration-seconds.md) |
| `0x06EL` | EDTF-EVEN | Value | 3 | `0x000006E0` | [0x06EL-edtf](value/0x06EL-edtf.md) |
| `0x06FL` | EDTF-ODD | Value | 3 | `0x000006F0` | [0x06EL-edtf](value/0x06EL-edtf.md) |
| `0x070L` | GEDCOM-DATE-EVEN | Value | 3 | `0x00000700` | [0x070L-gedcom-date](value/0x070L-gedcom-date.md) |
| `0x071L` | GEDCOM-DATE-ODD | Value | 3 | `0x00000710` | [0x070L-gedcom-date](value/0x070L-gedcom-date.md) |
| `0x072L` | UTF8-TEXT-EVEN | Value | 3 | `0x00000720` | [0x072L-utf8-text](value/0x072L-utf8-text.md) |
| `0x073L` | UTF8-TEXT-ODD | Value | 3 | `0x00000730` | [0x072L-utf8-text](value/0x072L-utf8-text.md) |
| `0x074L` | URI-EVEN | Value | 3 | `0x00000740` | [0x074L-uri](value/0x074L-uri.md) |
| `0x075L` | URI-ODD | Value | 3 | `0x00000750` | [0x074L-uri](value/0x074L-uri.md) |
| `0x076L` | LANGUAGE-BCP47-CODE-EVEN | Value | 3 | `0x00000760` | [0x076L-language-bcp47-code](value/0x076L-language-bcp47-code.md) |
| `0x077L` | LANGUAGE-BCP47-CODE-ODD | Value | 3 | `0x00000770` | [0x076L-language-bcp47-code](value/0x076L-language-bcp47-code.md) |
| `0x078L` | UTF8-LANGUAGE-TEXT-EVEN | Value | 3 | `0x00000780` | [0x078L-utf8-language-text](value/0x078L-utf8-language-text.md) |
| `0x079L` | UTF8-LANGUAGE-TEXT-ODD | Value | 3 | `0x00000790` | [0x078L-utf8-language-text](value/0x078L-utf8-language-text.md) |
| `0x07AL` | LANGUAGE-SHORT-CODE | Value | 3 | `0x000007A0` | [0x07AL-language-short-code](value/0x07AL-language-short-code.md) |
| `0x07BL` | UUID | Value | 3 | `0x000007B0` | [0x07BL-uuid](value/0x07BL-uuid.md) |
| `0x07CL` | SHA-256-DIGEST | Value | 3 | `0x000007C0` | [0x07CL-sha-256-digest](value/0x07CL-sha-256-digest.md) |
| `0x07DL` | SHA1-DIGEST | Value | 3 | `0x000007D0` | [0x07DL-sha1-digest](value/0x07DL-sha1-digest.md) |
| `0x07EL` | OPAQUE-BYTES-EVEN | Value | 3 | `0x000007E0` | [0x07EL-opaque-bytes](value/0x07EL-opaque-bytes.md) |
| `0x07FL` | OPAQUE-BYTES-ODD | Value | 3 | `0x000007F0` | [0x07EL-opaque-bytes](value/0x07EL-opaque-bytes.md) |
| `0x080L` | BIT-VECTOR | Value | 4 | `0x00000800` | [0x080L-bit-vector](value/0x080L-bit-vector.md) |
| `0x081L` | DURATION-NANOSECONDS | Value | 4 | `0x00000810` | [0x081L-duration-nanoseconds](value/0x081L-duration-nanoseconds.md) |
| `0x09DL` | VALUE-ISSUER-2WORD | Value | 4 | `0x000009D0` | [0x09DL-value-issuer-2word](value/0x09DL-value-issuer-2word.md) |
| `0x09EL` | VALUE-ISSUER-4WORD | Value | 4 | `0x000009E0` | [0x09EL-value-issuer-4word](value/0x09EL-value-issuer-4word.md) |
| `0x09FL` | VALUE-ISSUER-16WORD | Value | 4 | `0x000009F0` | [0x09FL-value-issuer-16word](value/0x09FL-value-issuer-16word.md) |
| `0x0A0L` | REFERENCE-NODE | Edge | 5 | `0x00000A00` | [0x0A0L-reference-node](edge/0x0A0L-reference-node.md) |
| `0x0A1L` | SAME-NODE | Edge | 5 | `0x00000A10` | [0x0A1L-same-node](edge/0x0A1L-same-node.md) |
| `0x0A2L` | DIFFERENT-NODE | Edge | 5 | `0x00000A20` | [0x0A2L-different-node](edge/0x0A2L-different-node.md) |
| `0x0A3L` | BIND | Edge | 5 | `0x00000A30` | [0x0A3L-bind](edge/0x0A3L-bind.md) |
| `0x0A4L` | LABEL | Edge | 5 | `0x00000A40` | [0x0A4L-label](edge/0x0A4L-label.md) |
| `0x0A5L` | ALIAS | Edge | 5 | `0x00000A50` | [0x0A5L-alias](edge/0x0A5L-alias.md) |
| `0x0A6L` | DESCRIPTION | Edge | 5 | `0x00000A60` | [0x0A6L-description](edge/0x0A6L-description.md) |
| `0x0A8L` | VERB-SHORT | Edge | 5 | `0x00000A80` | [0x0A8L-verb-short](edge/0x0A8L-verb-short.md) |
| `0x0A9L` | VERB | Edge | 5 | `0x00000A90` | [0x0A9L-verb](edge/0x0A9L-verb.md) |
| `0x0AAL` | TRIPLE | Edge | 5 | `0x00000AA0` | [0x0AAL-triple](edge/0x0AAL-triple.md) |
| `0x0ABL` | QUALIFIER | Edge | 5 | `0x00000AB0` | [0x0ABL-qualifier](edge/0x0ABL-qualifier.md) |
| `0x0B0L` | WORLD | Edge | 5 | `0x00000B00` | [0x0B0L-world](edge/0x0B0L-world.md) |
| `0x0B1L` | TIMELINE | Edge | 5 | `0x00000B10` | [0x0B1L-timeline](edge/0x0B1L-timeline.md) |
| `0x0B2L` | SCENE | Edge | 5 | `0x00000B20` | [0x0B2L-scene](edge/0x0B2L-scene.md) |
| `0x0B8L` | PUBLICATION | Edge | 5 | `0x00000B80` | [0x0B8L-publication](edge/0x0B8L-publication.md) |
| `0x0B9L` | DEPRECATION | Edge | 5 | `0x00000B90` | [0x0B9L-deprecation](edge/0x0B9L-deprecation.md) |
| `0x0BAL` | TOMBSTONE | Edge | 5 | `0x00000BA0` | [0x0BAL-tombstone](edge/0x0BAL-tombstone.md) |
| `0x0BBL` | DECLARE | Edge | 5 | `0x00000BB0` | [0x0BBL-declare](edge/0x0BBL-declare.md) |
| `0x0BCL` | FIELD | Edge | 5 | `0x00000BC0` | [0x0BCL-field](edge/0x0BCL-field.md) |
| `0x0BDL` | ENUM | Edge | 5 | `0x00000BD0` | [0x0BDL-enum](edge/0x0BDL-enum.md) |
| `0x0BEL` | CODEC | Edge | 5 | `0x00000BE0` | [0x0BEL-codec](edge/0x0BEL-codec.md) |
| `0x0C0L` | SOURCE | Edge | 6 | `0x00000C00` | [0x0C0L-source](edge/0x0C0L-source.md) |
| `0x0E1L` | FUNCTION-DECLARE | Edge | 7 | `0x00000E10` | [0x0E1L-function-declare](edge/0x0E1L-function-declare.md) |
| `0x0E2L` | TYPE-DECLARE | Edge | 7 | `0x00000E20` | [0x0E2L-type-declare](edge/0x0E2L-type-declare.md) |
| `0x0E8L` | CONST | Edge | 7 | `0x00000E80` | [0x0E8L-const](edge/0x0E8L-const.md) |
| `0x0E9L` | UNARY | Edge | 7 | `0x00000E90` | [0x0E9L-unary](edge/0x0E9L-unary.md) |
| `0x0EAL` | BINARY | Edge | 7 | `0x00000EA0` | [0x0EAL-binary](edge/0x0EAL-binary.md) |
| `0x0EBL` | CALL | Edge | 7 | `0x00000EB0` | [0x0EBL-call](edge/0x0EBL-call.md) |
| `0x0ECL` | MEMBER | Edge | 7 | `0x00000EC0` | [0x0ECL-member](edge/0x0ECL-member.md) |
| `0x0EDL` | INDEX | Edge | 7 | `0x00000ED0` | [0x0EDL-index](edge/0x0EDL-index.md) |
| `0x0EEL` | CONSTRUCT | Edge | 7 | `0x00000EE0` | [0x0EEL-construct](edge/0x0EEL-construct.md) |
| `0x0EFL` | CONDITIONAL | Edge | 7 | `0x00000EF0` | [0x0EFL-conditional](edge/0x0EFL-conditional.md) |
| `0x0F0L` | BLOCK | Edge | 7 | `0x00000F00` | [0x0F0L-block](edge/0x0F0L-block.md) |
| `0x0F1L` | ASSIGN | Edge | 7 | `0x00000F10` | [0x0F1L-assign](edge/0x0F1L-assign.md) |
| `0x0F2L` | IF | Edge | 7 | `0x00000F20` | [0x0F2L-if](edge/0x0F2L-if.md) |
| `0x0F3L` | SWITCH | Edge | 7 | `0x00000F30` | [0x0F3L-switch](edge/0x0F3L-switch.md) |
| `0x0F4L` | WHILE | Edge | 7 | `0x00000F40` | [0x0F4L-while](edge/0x0F4L-while.md) |
| `0x0F5L` | FOREACH | Edge | 7 | `0x00000F50` | [0x0F5L-foreach](edge/0x0F5L-foreach.md) |
| `0x0F6L` | JUMP | Edge | 7 | `0x00000F60` | [0x0F6L-jump](edge/0x0F6L-jump.md) |
| `0x0F7L` | RETURN | Edge | 7 | `0x00000F70` | [0x0F7L-return](edge/0x0F7L-return.md) |
| `0x0F8L` | RAISE | Edge | 7 | `0x00000F80` | [0x0F8L-raise](edge/0x0F8L-raise.md) |
| `0x0F9L` | TRY | Edge | 7 | `0x00000F90` | [0x0F9L-try](edge/0x0F9L-try.md) |
| `0x100L` | CASE-DECLARE | Edge | 8 | `0x00001000` | [0x100L-case-declare](toulmin/0x100L-case-declare.md) |
| `0x101L` | PREDICATE-DECLARE | Edge | 8 | `0x00001010` | [0x101L-predicate-declare](toulmin/0x101L-predicate-declare.md) |
| `0x102L` | SPEC-DECLARE | Edge | 8 | `0x00001020` | [0x102L-spec-declare](toulmin/0x102L-spec-declare.md) |
| `0x103L` | RULE-DECLARE | Edge | 8 | `0x00001030` | [0x103L-rule-declare](toulmin/0x103L-rule-declare.md) |
| `0x104L` | COUNTER-DECLARE | Edge | 8 | `0x00001040` | [0x104L-counter-declare](toulmin/0x104L-counter-declare.md) |
| `0x105L` | EXCEPT-DECLARE | Edge | 8 | `0x00001050` | [0x105L-except-declare](toulmin/0x105L-except-declare.md) |
| `0x108L` | ATTACKS | Edge | 8 | `0x00001080` | [0x108L-attacks](toulmin/0x108L-attacks.md) |
| `0x109L` | SUPERSEDES | Edge | 8 | `0x00001090` | [0x109L-supersedes](toulmin/0x109L-supersedes.md) |
| `0x10AL` | SUPERSEDE-CHAIN | Edge | 8 | `0x000010A0` | [0x10AL-supersede-chain](toulmin/0x10AL-supersede-chain.md) |
| `0x110L` | RUN | Edge | 8 | `0x00001100` | [0x110L-run](toulmin/0x110L-run.md) |
| `0x111L` | DO | Edge | 8 | `0x00001110` | [0x111L-do](toulmin/0x111L-do.md) |
| `0x112L` | DO-ONCE | Edge | 8 | `0x00001120` | [0x112L-do-once](toulmin/0x112L-do-once.md) |
| `0x113L` | UNDO | Edge | 8 | `0x00001130` | [0x113L-undo](toulmin/0x113L-undo.md) |
| `0x114L` | CHECKING | Edge | 8 | `0x00001140` | [0x114L-checking](toulmin/0x114L-checking.md) |
| `0x115L` | ENTRY | Edge | 8 | `0x00001150` | [0x115L-entry](toulmin/0x115L-entry.md) |
| `0x116L` | TRIGGER | Edge | 8 | `0x00001160` | [0x116L-trigger](toulmin/0x116L-trigger.md) |
| `0x118L` | VERDICT | Edge | 8 | `0x00001180` | [0x118L-verdict](toulmin/0x118L-verdict.md) |
| `0x119L` | EVIDENCE | Edge | 8 | `0x00001190` | [0x119L-evidence](toulmin/0x119L-evidence.md) |
| `0x11CL` | Reserved | Edge | 8 |  |  |
| `0x11DL` | Reserved | Edge | 8 |  |  |
| `0x11EL` | Reserved | Edge | 8 |  |  |
| `0x11FL` | Reserved | Edge | 8 |  |  |
| `0x120L` | SOURCE | Edge | 9 | `0x00001200` | [0x120L-source](toulmin/0x120L-source.md) |
| `0x121L` | TEXT | Edge | 9 | `0x00001210` | [0x121L-text](toulmin/0x121L-text.md) |
| `0x122L` | SECTION | Edge | 9 | `0x00001220` | [0x122L-section](toulmin/0x122L-section.md) |
| `0x123L` | CASE-BEGIN | Edge | 9 | `0x00001230` | [0x123L-case-begin](toulmin/0x123L-case-begin.md) |
| `0x124L` | CASE-END | Edge | 9 | `0x00001240` | [0x124L-case-end](toulmin/0x124L-case-end.md) |
| `0x125L` | PROSE | Edge | 9 | `0x00001250` | [0x125L-prose](toulmin/0x125L-prose.md) |
| `0x126L` | NAMESPACE | Edge | 9 | `0x00001260` | [0x126L-namespace](toulmin/0x126L-namespace.md) |
| `0x127L` | FUNC | Edge | 9 | `0x00001270` | [0x127L-func](toulmin/0x127L-func.md) |
| `0x128L` | FIELD | Edge | 9 | `0x00001280` | [0x128L-field](toulmin/0x128L-field.md) |
| `0x129L` | ALIAS | Edge | 9 | `0x00001290` | [0x129L-alias](toulmin/0x129L-alias.md) |
| `0x12AL` | GROUP | Edge | 9 | `0x000012A0` | [0x12AL-group](toulmin/0x12AL-group.md) |
| `0x12BL` | REQUIRES | Edge | 9 | `0x000012B0` | [0x12BL-requires](toulmin/0x12BL-requires.md) |
| `0x12CL` | MEANS | Edge | 9 | `0x000012C0` | [0x12CL-means](toulmin/0x12CL-means.md) |
| `0x12DL` | HAS | Edge | 9 | `0x000012D0` | [0x12DL-has](toulmin/0x12DL-has.md) |
| `0x12EL` | RUNS | Edge | 9 | `0x000012E0` | [0x12EL-runs](toulmin/0x12EL-runs.md) |
| `0x12FL` | EVALUATES | Edge | 9 | `0x000012F0` | [0x12FL-evaluates](toulmin/0x12FL-evaluates.md) |
| `0x130L` | TRIGGERS | Edge | 9 | `0x00001300` | [0x130L-triggers](toulmin/0x130L-triggers.md) |
| `0x131L` | UNTIL | Edge | 9 | `0x00001310` | [0x131L-until](toulmin/0x131L-until.md) |
| `0x132L` | SAME-AS | Edge | 9 | `0x00001320` | [0x132L-same-as](toulmin/0x132L-same-as.md) |
| `0x133L` | IMPORTED-FROM | Edge | 9 | `0x00001330` | [0x133L-imported-from](toulmin/0x133L-imported-from.md) |
| `0x134L` | LABEL | Edge | 9 | `0x00001340` | [0x134L-label](toulmin/0x134L-label.md) |
| `0x1BDL` | EDGE-ISSUER-2WORD | Edge | 13 | `0x00001BD0` | [0x1BDL-edge-issuer-2word](edge/0x1BDL-edge-issuer-2word.md) |
| `0x1BEL` | EDGE-ISSUER-4WORD | Edge | 13 | `0x00001BE0` | [0x1BEL-edge-issuer-4word](edge/0x1BEL-edge-issuer-4word.md) |
| `0x1BFL` | EDGE-ISSUER-16WORD | Edge | 13 | `0x00001BF0` | [0x1BFL-edge-issuer-16word](edge/0x1BFL-edge-issuer-16word.md) |
| `0x1C0L` | DOC-1WORD | Meta | 14 | `0x00001C00` | [0x1C0L-doc-1word](meta/0x1C0L-doc-1word.md) |
| `0x1C1L` | DOC-2WORD | Meta | 14 | `0x00001C10` | [0x1C1L-doc-2word](meta/0x1C1L-doc-2word.md) |
| `0x1C2L` | DOC-4WORD | Meta | 14 | `0x00001C20` | [0x1C2L-doc-4word](meta/0x1C2L-doc-4word.md) |
| `0x1C3L` | BODY | Meta | 14 | `0x00001C30` | [0x1C3L-body](meta/0x1C3L-body.md) |
| `0x1C4L` | END | Meta | 14 | `0x00001C40` | [0x1C4L-end](meta/0x1C4L-end.md) |
| `0x1C5L` | SPEC-VERSION | Meta | 14 | `0x00001C50` | [0x1C5L-spec-version](meta/0x1C5L-spec-version.md) |
| `0x1C6L` | PROFILE | Meta | 14 | `0x00001C60` | [0x1C6L-profile](meta/0x1C6L-profile.md) |
| `0x1C7L` | DOC-ID | Meta | 14 | `0x00001C70` | [0x1C7L-doc-id](meta/0x1C7L-doc-id.md) |
| `0x1C8L` | EFFECTIVE-FROM | Meta | 14 | `0x00001C80` | [0x1C8L-effective-from](meta/0x1C8L-effective-from.md) |
| `0x1C9L` | EFFECTIVE-UNTIL | Meta | 14 | `0x00001C90` | [0x1C9L-effective-until](meta/0x1C9L-effective-until.md) |
| `0x1CAL` | DEFAULT-LANGUAGE | Meta | 14 | `0x00001CA0` | [0x1CAL-default-language](meta/0x1CAL-default-language.md) |
| `0x1CBL` | AUTHOR | Meta | 14 | `0x00001CB0` | [0x1CBL-author](meta/0x1CBL-author.md) |
| `0x1CCL` | CO-AUTHOR | Meta | 14 | `0x00001CC0` | [0x1CCL-co-author](meta/0x1CCL-co-author.md) |
| `0x1CDL` | CREATED-AT | Meta | 14 | `0x00001CD0` | [0x1CDL-created-at](meta/0x1CDL-created-at.md) |
| `0x1CEL` | MODIFIED-AT | Meta | 14 | `0x00001CE0` | [0x1CEL-modified-at](meta/0x1CEL-modified-at.md) |
| `0x1CFL` | RECORDED-BY | Meta | 14 | `0x00001CF0` | [0x1CFL-recorded-by](meta/0x1CFL-recorded-by.md) |
| `0x1D0L` | RECORDED-AT | Meta | 14 | `0x00001D00` | [0x1D0L-recorded-at](meta/0x1D0L-recorded-at.md) |
| `0x1D1L` | PARENT | Meta | 14 | `0x00001D10` | [0x1D1L-parent](meta/0x1D1L-parent.md) |
| `0x1D2L` | DERIVED-FROM | Meta | 14 | `0x00001D20` | [0x1D2L-derived-from](meta/0x1D2L-derived-from.md) |
| `0x1D3L` | GENERATED-BY | Meta | 14 | `0x00001D30` | [0x1D3L-generated-by](meta/0x1D3L-generated-by.md) |
| `0x1D4L` | TRANSFORMED-BY | Meta | 14 | `0x00001D40` | [0x1D4L-transformed-by](meta/0x1D4L-transformed-by.md) |
| `0x1D5L` | CHERRY-PICKED-FROM | Meta | 14 | `0x00001D50` | [0x1D5L-cherry-picked-from](meta/0x1D5L-cherry-picked-from.md) |
| `0x1D6L` | REVERTS | Meta | 14 | `0x00001D60` | [0x1D6L-reverts](meta/0x1D6L-reverts.md) |
| `0x1D7L` | REPLACES | Meta | 14 | `0x00001D70` | [0x1D7L-replaces](meta/0x1D7L-replaces.md) |
| `0x1D8L` | SQUASHED-FROM | Meta | 14 | `0x00001D80` | [0x1D8L-squashed-from](meta/0x1D8L-squashed-from.md) |
| `0x1D9L` | MESSAGE | Meta | 14 | `0x00001D90` | [0x1D9L-message](meta/0x1D9L-message.md) |
| `0x1DAL` | TAG | Meta | 14 | `0x00001DA0` | [0x1DAL-tag](meta/0x1DAL-tag.md) |
| `0x1DBL` | DELTA-BASE | Meta | 14 | `0x00001DB0` | [0x1DBL-delta-base](meta/0x1DBL-delta-base.md) |
| `0x1DCL` | DELTA-REMOVE | Meta | 14 | `0x00001DC0` | [0x1DCL-delta-remove](meta/0x1DCL-delta-remove.md) |
| `0x1DDL` | NEXT-LOCAL-ID | Meta | 14 | `0x00001DD0` | [0x1DDL-next-local-id](meta/0x1DDL-next-local-id.md) |
| `0x1DEL` | LICENSE | Meta | 14 | `0x00001DE0` | [0x1DEL-license](meta/0x1DEL-license.md) |
| `0x1DFL` | ACCESS | Meta | 14 | `0x00001DF0` | [0x1DFL-access](meta/0x1DFL-access.md) |
| `0x1E0L` | PRIVACY | Meta | 15 | `0x00001E00` | [0x1E0L-privacy](meta/0x1E0L-privacy.md) |
| `0x1E1L` | RETENTION | Meta | 15 | `0x00001E10` | [0x1E1L-retention](meta/0x1E1L-retention.md) |
| `0x1E2L` | CONSENT | Meta | 15 | `0x00001E20` | [0x1E2L-consent](meta/0x1E2L-consent.md) |
| `0x1E3L` | USAGE | Meta | 15 | `0x00001E30` | [0x1E3L-usage](meta/0x1E3L-usage.md) |
| `0x1E4L` | IMPORT-DOC | Meta | 15 | `0x00001E40` | [0x1E4L-import-doc](meta/0x1E4L-import-doc.md) |
| `0x1E5L` | ISSUER-KEY | Meta | 15 | `0x00001E50` | [0x1E5L-issuer-key](meta/0x1E5L-issuer-key.md) |
| `0x1E6L` | SIGNATURE | Meta | 15 | `0x00001E60` | [0x1E6L-signature](meta/0x1E6L-signature.md) |
| `0x1E7L` | SIGNED-OFF | Meta | 15 | `0x00001E70` | [0x1E7L-signed-off](meta/0x1E7L-signed-off.md) |
| `0x1E8L` | CONFIDENCE | Meta | 15 | `0x00001E80` | [0x1E8L-confidence](meta/0x1E8L-confidence.md) |
| `0x1E9L` | VERDICT | Meta | 15 | `0x00001E90` | [0x1E9L-verdict](meta/0x1E9L-verdict.md) |
