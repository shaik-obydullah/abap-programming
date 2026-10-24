# Hello World in ABAP - Tutorial

## 1. Theory

### What is ABAP?
ABAP (Advanced Business Application Programming) is SAP's own programming language. It is used to build business applications that run on SAP systems, such as ERP, S/4HANA, and BTP (Business Technology Platform).

### Key Concepts of an ABAP Report

1. **REPORT Statement**
   - Every executable ABAP program (called a *report*) begins with the `REPORT` keyword.
   - Syntax: `REPORT <name>`.
   - The name **must start with a letter** and is conventionally prefixed with `Z` to mark it as a *customer development* (SAP reserves names starting with `A`–`Y` for standard objects, so user programs use `Z`).

2. **WRITE Statement**
   - `WRITE` is the ABAP command used to **output text to the screen** (the output list).
   - It is similar to `PRINT` in Python or `console.log` in JavaScript.
   - Text is enclosed in single quotes `'...'`.

3. **Statements & Periods**
   - Every ABAP statement **ends with a period** `.` — this is essential.
   - ABAP is not case-sensitive: `REPORT zhello_world.` and `report ZHELLO_WORLD.` are identical.

4. **Why "Z" in the Name?**
   - SAP guarantees that all standard objects live in the `A`–`Y` name range.
   - Names beginning with `Z` are reserved for customer programs, so your code never clashes with SAP's.

### Output List (ALV / Basic List)
In older ABAP, `WRITE` sends output to a simple list. Every `WRITE` adds another line/column to this list:
- `WRITE: 'Hello, World!'.` prints the literal text.
- Add a `/` at the start to force a **new line**: `WRITE: / 'Hello, World!'.`

## 2. Code

The simplest possible ABAP program:

```abap
REPORT zhello_world.

WRITE: 'Hello, World!'.
```

### Line-by-line breakdown

| Line | Meaning |
|------|---------|
| `REPORT zhello_world.` | Declares an executable report named `zhello_world`. |
| `WRITE: 'Hello, World!'.` | Writes the text `Hello, World!` to the output screen. |

### How to run it
1. Log in to SAP GUI (or access BTP ABAP environment).
2. Go to transaction **SE38** (ABAP Editor).
3. Enter `ZHELLO_WORLD` as the program name and click **Create**.
4. Paste the code and **Save** (Ctrl+S) — choose a package or the `$TMP` local package.
5. Click **Activate** (Ctrl+F3) to make the program executable.
6. Click **Execute** (F8) to run it and see `Hello, World!` on the screen.

## 3. Practice
Try changing the output:
```abap
REPORT zhello_world.

WRITE: 'Welcome to ABAP!'.
WRITE: / 'Line 1'.
WRITE: / 'Line 2'.
```