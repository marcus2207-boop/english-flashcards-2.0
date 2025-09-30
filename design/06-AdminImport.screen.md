# Admin Import Screen Specification

**Route:** `/admin/import`  
**Related Stories:** ST-003  
**User Personas:** P-002 (Admin/Teacher - Maria, 35 years old)

## Overview

The Admin Import screen allows administrators to bulk import flashcard vocabulary from CSV or JSON files. It features drag-and-drop file upload, automatic field mapping, validation with preview, inline error correction, and transactional commit with rollback rules.

## Layout

### Container
- **Type:** Single column layout with sections
- **Max Width:** 1400px
- **Background:** `color-background` (#F8FAFC)
- **Padding:** `spacing-xl` (32px)

### Upload Section (Top)
- **Background:** `color-surface` (#FFFFFF)
- **Border:** 2px dashed `color-neutral-300`
- **Border Radius:** `radius-lg` (14px)
- **Padding:** `spacing-xxl` (48px)
- **Min Height:** 200px

### Mapping Section (Middle)
- **Background:** `color-surface` (#FFFFFF)
- **Border Radius:** `radius-lg` (14px)
- **Padding:** `spacing-xl` (32px)
- **Margin Top:** `spacing-lg` (24px)
- **Visible:** After file upload

### Preview Section (Bottom)
- **Background:** `color-surface` (#FFFFFF)
- **Border Radius:** `radius-lg` (14px)
- **Padding:** `spacing-xl` (32px)
- **Margin Top:** `spacing-lg` (24px)
- **Visible:** After mapping confirmed

## Visual Hierarchy

```
┌────────────────────────────────────────────────────────────┐
│  Import Vocabulary                [Sample CSV] [Template]   │
├────────────────────────────────────────────────────────────┤
│                                                             │
│             📁  Drag & drop your CSV or JSON file here      │
│                 or [Browse files]                           │
│                                                             │
│             Supported: .csv, .json (max 10MB)              │
└────────────────────────────────────────────────────────────┘

                   ↓ After file upload ↓

┌────────────────────────────────────────────────────────────┐
│  Field Mapping                         vocabulary_2024.csv  │
├────────────────────────────────────────────────────────────┤
│  CSV Column          →    Target Field                     │
│  ───────────────────────────────────────────────────────  │
│  english             →    [English ▼] ✓                   │
│  polish              →    [Polish ▼] ✓                    │
│  phonetic (optional) →    [Phonetic ▼] ✓                  │
│  tags (optional)     →    [Tags ▼] ✓                      │
│                                                             │
│  [Cancel Import]  [Continue to Preview] →                 │
└────────────────────────────────────────────────────────────┘

                   ↓ After mapping ↓

┌────────────────────────────────────────────────────────────┐
│  Preview (120 rows)      [Filter: All ▼] [Errors only]    │
│                          □ Transactional (>50% rule: ON)   │
├────────────────────────────────────────────────────────────┤
│  #  │ Status │ English  │ Polish   │ Phonetic │ Actions   │
│ ────┼────────┼──────────┼──────────┼──────────┼──────────│
│  1  │   ✓    │ cat      │ kot      │ /kæt/    │ [Edit]   │
│  2  │   ⚠    │ dog      │          │ /dɒɡ/    │ [Fix]    │
│  3  │   ✓    │ house    │ dom      │ /haʊs/   │ [Edit]   │
│  4  │   ✗    │          │ pies     │          │ [Fix]    │
│                           ...                              │
│                                                             │
│  Summary: 118 OK · 2 Warnings · 0 Errors                  │
│                                                             │
│  [Cancel]  [Fix All Errors]  [Start Import] →             │
└────────────────────────────────────────────────────────────┘

                   ↓ On Start Import ↓

┌─────────────────────────────────────────────────────────┐
│  Import Preview                                      [×] │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Ready to import 118 rows                               │
│                                                          │
│  ✓ 118 rows will be imported                            │
│  ⚠ 2 rows have warnings (will import with defaults)     │
│  ✗ 0 rows have errors                                   │
│                                                          │
│  Transactional mode: ON                                 │
│  If >50% fail, all changes will be rolled back.         │
│                                                          │
│  ⏰ Estimated time: 30 seconds                          │
│                                                          │
│  [Cancel]              [Confirm Import] →               │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

## Components Used

### From Component Library
- **Button** - Primary for actions, Secondary for cancel
- **Modal** - Import preview and confirmation
- **Table** - Preview table with pagination
- **Badge** - Status indicators (OK, Warning, Error)
- **Toast** - Success/error notifications
- **Toggle** - Transactional mode switch

### New/Screen-Specific Components
- **File Upload Dropzone** - Drag and drop area with file browser
- **Field Mapper** - Dropdown mapping from CSV columns to DB fields
- **Inline Row Editor** - Edit form replacing table row
- **Progress Indicator** - Import progress with percentage

## Element Specifications

### Upload Dropzone
- **Border:** 2px dashed `color-neutral-300` (#D4D4D8)
- **Border Radius:** `radius-lg` (14px)
- **Padding:** `spacing-xxl` (48px)
- **Background:** `color-surface` (#FFFFFF)
- **Hover Background:** `color-neutral-50` (#FAFAFA)
- **Active (dragging):** Border color `color-primary`, background `color-primary-50`

#### Dropzone Icon
- **Size:** 64px
- **Icon:** 📁 or SVG folder icon
- **Color:** `color-neutral-400` (#A1A1AA)

#### Dropzone Text
- **Primary:** "Drag & drop your CSV or JSON file here"
- **Secondary:** "or [Browse files]"
- **File Types:** "Supported: .csv, .json (max 10MB)"
- **Font Size:** `font-size-body` (16px)
- **Color:** `color-neutral-700` (#3F3F46)

### Field Mapping Row
- **Display:** Flex (space-between)
- **Padding:** `spacing-md` (16px)
- **Border Bottom:** 1px solid `color-neutral-200` (#E4E4E7)

#### Source Column Label
- **Font Weight:** `font-weight-semibold` (600)
- **Color:** `color-neutral-900` (#18181B)
- **Width:** 40%

#### Mapping Dropdown
- **Width:** 50%
- **Options:** English, Polish, Phonetic, Tags, Ignore
- **Auto-detect:** Highlight auto-mapped fields in green

#### Validation Icon
- **OK:** ✓ green
- **Warning:** ⚠ amber
- **Error:** ✗ red

### Preview Table
- **Pagination:** 20 rows per page
- **Columns:** Row #, Status, English, Polish, Phonetic, Actions
- **Row Height:** 48px
- **Striped:** Alternate row background `color-neutral-50`

#### Status Cell
- **OK:** ✓ badge with green background
- **Warning:** ⚠ badge with amber background
- **Error:** ✗ badge with red background
- **Tooltip:** Hover to see error message

#### Action Buttons
- **Edit:** Opens inline editor
- **Fix:** Opens inline editor with focus on error field
- **Size:** Small
- **Variant:** Ghost/Text

### Inline Editor
- **Replace:** Table row with form inputs
- **Fields:** English input, Polish input, Phonetic input
- **Actions:** Save (✓), Cancel (✗)
- **Validation:** Real-time, show errors below field

### Transactional Mode Toggle
- **Label:** "Transactional (>50% rule)"
- **Tooltip:** "If more than 50% of rows fail, all changes will be rolled back"
- **Default:** ON
- **Color:** Primary when ON

### Import Preview Modal
- **Size:** Medium (600px)
- **Title:** "Import Preview"
- **Content:** Summary stats and confirmation
- **Actions:** Cancel, Confirm Import

#### Summary Stats
- **Format:** "{X} rows will be imported"
- **Breakdown:** OK count, Warning count, Error count with icons
- **Transactional Note:** Visible if mode is ON

### Progress Indicator (During Import)
- **Type:** Linear progress bar
- **Show:** Percentage and row count
- **Update:** Real-time via polling
- **Cancel:** Button to abort import

## States

### Initial State
- Upload dropzone ready
- No file selected
- Mapping and preview sections hidden

### File Selected State
- File name displayed
- File size shown
- Mapping section visible
- Auto-mapping attempted

### Mapping State
- Dropdowns populated with CSV columns
- Validation indicators shown
- Continue button enabled if valid

### Preview State
- Table populated with data
- Status indicators for each row
- Summary stats calculated
- Import button enabled if no errors (or warnings only)

### Inline Edit State
- Selected row replaced with form
- Other rows disabled (dim)
- Focus on first input field

### Importing State
- Progress bar visible
- Table rows grayed out
- Cancel button available
- Poll for progress updates

### Import Complete State
- Success toast: "Import zakończony! {X} rows imported"
- Navigate back to dashboard or imports list
- Clear form

### Import Failed State
- Error toast with details
- Show which rows failed
- Option to retry or download error report

### Import Rolled Back State (Transactional)
- Warning toast: "Import wycofany - za dużo błędów (>50%)"
- Error report available
- All changes reverted

## Interactions

### Dropzone
- **Drag Over:** Highlight border, change background
- **Drop:** Accept file if valid format and size
- **Click:** Open file browser
- **File Select:** Validate and upload

### Field Mapping Dropdown
- **Change:** Update mapping, re-validate
- **Auto-detect:** Suggest mapping based on column names

### Filter Dropdown
- **Options:** All, Errors only, Warnings only
- **Change:** Filter table rows

### Transactional Toggle
- **Click:** Toggle mode ON/OFF
- **Tooltip:** Explain rule on hover

### Preview Table Row
- **Hover:** Highlight row
- **Click Status:** Show tooltip with error details
- **Edit Click:** Enter inline edit mode
- **Fix Click:** Enter inline edit mode with focus on error

### Inline Editor
- **Save Click:** Validate, update row, exit edit mode
- **Cancel Click:** Discard changes, exit edit mode
- **Enter Key:** Save
- **Escape Key:** Cancel

### Start Import Button
- **Click:** Show Import Preview Modal
- **Disabled:** If errors exist and not force mode

### Import Preview Modal
- **Confirm:** Start import, show progress
- **Cancel:** Close modal
- **Escape:** Close modal

### During Import
- **Progress:** Auto-update every 500ms
- **Cancel:** Abort import (if possible)

## Accessibility

### Semantic HTML
- `<main>` for import content
- `<form>` for upload and mapping
- `<table>` for preview
- `<dialog>` for modal
- Proper labels for all inputs

### ARIA Attributes
- Dropzone: `role="button" aria-label="Upload file" tabindex="0"`
- File input: Hidden but accessible
- Mapping dropdowns: Proper labels
- Table: `role="table"`, headers with `scope`
- Status badges: `aria-label="Status: {status}, {message}"`
- Progress bar: `role="progressbar" aria-valuenow aria-valuemin aria-valuemax`
- Modal: `role="dialog" aria-modal="true"`

### Keyboard Navigation
- Tab: Through all interactive elements
- Enter/Space: Activate dropzone, buttons
- Arrow keys: Navigate table cells
- Enter: Edit row in table
- Escape: Cancel inline edit, close modal
- Alt+F: Focus on filter dropdown
- Alt+T: Toggle transactional mode

### Screen Reader Announcements
- File selected: "File {name} selected, {size}, {rows} rows detected"
- Mapping validated: "{X} fields mapped correctly"
- Preview loaded: "{X} rows ready, {Y} errors, {Z} warnings"
- Row edited: "Row {num} updated"
- Import started: "Import started, {X} rows"
- Import progress: Announce every 25%
- Import complete: "Import complete, {X} rows imported successfully"

## Responsive Behavior

### Desktop (>1024px)
- Full table width with all columns
- Inline editing in table
- Side-by-side layout for sections

### Tablet (768px - 1024px)
- Scrollable table horizontally
- Smaller dropzone
- Reduced padding

### Mobile (<768px)
- Card layout instead of table
- One row per card
- Edit opens full-screen modal instead of inline
- Stack sections vertically
- Simplified preview (show errors first)

## Backend Integration

### API Endpoints

#### POST /api/imports/upload
**Description:** Upload file and validate

**Request:** multipart/form-data with file

**Response (200 OK):**
```json
{
  "importId": "import-uuid",
  "fileName": "vocabulary_2024.csv",
  "rowCount": 120,
  "columns": ["english", "polish", "phonetic"],
  "suggestedMapping": {
    "english": "english",
    "polish": "polish",
    "phonetic": "phonetic"
  }
}
```

#### POST /api/imports/:id/validate
**Description:** Validate with mapping

**Request Body:**
```json
{
  "mapping": {
    "english": "english",
    "polish": "polish",
    "phonetic": "phonetic"
  }
}
```

**Response (200 OK):**
```json
{
  "rows": [
    {
      "rowNum": 1,
      "status": "ok",
      "data": {
        "english": "cat",
        "polish": "kot",
        "phonetic": "/kæt/"
      }
    },
    {
      "rowNum": 2,
      "status": "warning",
      "data": {
        "english": "dog",
        "polish": "",
        "phonetic": "/dɒɡ/"
      },
      "warnings": ["Polish field empty, will use default"]
    },
    {
      "rowNum": 4,
      "status": "error",
      "data": {
        "english": "",
        "polish": "pies"
      },
      "errors": ["English field required"]
    }
  ],
  "summary": {
    "total": 120,
    "ok": 118,
    "warnings": 2,
    "errors": 0
  }
}
```

#### PUT /api/imports/:id/row/:rowNum
**Description:** Update specific row

**Request Body:**
```json
{
  "english": "dog",
  "polish": "pies",
  "phonetic": "/dɒɡ/"
}
```

**Response (200 OK):**
```json
{
  "status": "ok",
  "data": {...}
}
```

#### POST /api/imports/:id/commit
**Description:** Start import

**Request Body:**
```json
{
  "transactional": true
}
```

**Response (202 Accepted):**
```json
{
  "jobId": "job-uuid",
  "status": "processing"
}
```

#### GET /api/imports/:id/progress/:jobId
**Description:** Check import progress

**Response (200 OK):**
```json
{
  "status": "processing",
  "progress": 45,
  "processedRows": 54,
  "totalRows": 120,
  "errors": []
}
```

**Response (200 OK - Complete):**
```json
{
  "status": "completed",
  "progress": 100,
  "processedRows": 118,
  "totalRows": 120,
  "imported": 118,
  "skipped": 2,
  "errors": []
}
```

**Response (200 OK - Rolled Back):**
```json
{
  "status": "rolled_back",
  "reason": "Error rate >50%",
  "processedRows": 60,
  "failedRows": 35,
  "errors": [...]
}
```

### Transaction Rules
- If transactional mode ON and errors >50%: Rollback all changes
- If transactional mode OFF: Import all valid rows, skip errors
- Warnings don't count toward error threshold

## Design Tokens Used

### Colors
- `color-background`: #F8FAFC
- `color-surface`: #FFFFFF
- `color-primary`: #4F46E5
- `color-success`: #16A34A
- `color-warning`: #F59E0B
- `color-error`: #DC2626
- `color-neutral-900`: #18181B
- `color-neutral-700`: #3F3F46
- `color-neutral-400`: #A1A1AA
- `color-neutral-300`: #D4D4D8
- `color-neutral-200`: #E4E4E7
- `color-neutral-50`: #FAFAFA

### Spacing
- `spacing-sm`: 8px
- `spacing-md`: 16px
- `spacing-lg`: 24px
- `spacing-xl`: 32px
- `spacing-xxl`: 48px

### Typography
- `font-size-h1`: 28px
- `font-size-body`: 16px
- `font-weight-semibold`: 600

### Shadows
- `shadow-md`: 0 4px 6px rgba(0,0,0,0.1)

### Border Radius
- `radius-md`: 10px
- `radius-lg`: 14px

## Content Strings

### Polish UI Text
- **Page Title:** "Import słówek"
- **Dropzone:** "Przeciągnij i upuść plik CSV lub JSON tutaj"
- **Browse:** "Przeglądaj pliki"
- **Supported:** "Obsługiwane: .csv, .json (max 10MB)"
- **Field Mapping:** "Mapowanie pól"
- **Preview:** "Podgląd"
- **Transactional:** "Transakcyjny (reguła >50%)"
- **Status:**
  - "OK" / "✓"
  - "Warning" / "Ostrzeżenie" / "⚠"
  - "Error" / "Błąd" / "✗"
- **Actions:**
  - "Edit" / "Edytuj"
  - "Fix" / "Napraw"
  - "Save" / "Zapisz"
  - "Cancel" / "Anuluj"
  - "Continue to Preview" / "Kontynuuj do podglądu"
  - "Start Import" / "Rozpocznij import"
  - "Confirm Import" / "Potwierdź import"
- **Summary:** "{X} OK · {Y} Warnings · {Z} Errors"
- **Import Messages:**
  - "Import zakończony! {X} rows imported"
  - "Import wycofany - za dużo błędów (>50%)"
  - "Import w toku... {X}%"
- **Errors:**
  - "English field required" / "Pole angielskie wymagane"
  - "File too large" / "Plik za duży"
  - "Invalid format" / "Nieprawidłowy format"

## Testing Checklist

- [ ] File upload works (drag and drop)
- [ ] File upload works (browse button)
- [ ] File size validation (max 10MB)
- [ ] File format validation (CSV, JSON only)
- [ ] Auto-mapping suggests correct fields
- [ ] Manual mapping updates validation
- [ ] Preview table displays all rows
- [ ] Pagination works correctly
- [ ] Filter (Errors only) works
- [ ] Status badges display correctly
- [ ] Inline edit opens and saves
- [ ] Inline edit cancels without saving
- [ ] Transactional toggle works
- [ ] Import preview modal shows correct summary
- [ ] Import starts and shows progress
- [ ] Import completes successfully
- [ ] Import handles errors correctly
- [ ] Rollback works when >50% errors
- [ ] Cancel import works
- [ ] Success toast displays
- [ ] Error toast displays
- [ ] Keyboard navigation works
- [ ] Screen reader announces states
- [ ] Mobile responsive works
- [ ] All text in Polish
- [ ] WCAG AA contrast met
