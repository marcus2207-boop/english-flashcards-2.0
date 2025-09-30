# Admin Exports Screen Specification

**Route:** `/admin/exports`  
**Related Stories:** ST-009  
**User Personas:** P-002 (Admin/Teacher - Maria, 35 years old)

## Overview

The Admin Exports screen allows administrators to create and manage data exports. Users can export vocabulary data in CSV or JSON format, track export job status, download completed exports, and view export history with audit log entries.

## Layout

### Container
- **Type:** Single column with header and content sections
- **Max Width:** 1200px
- **Background:** `color-background` (#F8FAFC)
- **Padding:** `spacing-xl` (32px)

### Header Section
- **Display:** Flex (space-between)
- **Contains:** Title and "New Export" button
- **Background:** `color-surface` (#FFFFFF)
- **Border Radius:** `radius-lg` (14px)
- **Padding:** `spacing-lg` (24px)
- **Margin Bottom:** `spacing-lg` (24px)

### Active Exports Section
- **Background:** `color-surface` (#FFFFFF)
- **Border Radius:** `radius-lg` (14px)
- **Padding:** `spacing-xl` (32px)
- **Shadow:** `shadow-md`
- **Margin Bottom:** `spacing-lg` (24px)

### Export History Section
- **Background:** `color-surface` (#FFFFFF)
- **Border Radius:** `radius-lg` (14px)
- **Padding:** `spacing-xl` (32px)
- **Shadow:** `shadow-md`

## Visual Hierarchy

```
┌────────────────────────────────────────────────────────────┐
│  Data Exports                            [+ New Export]     │
└────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────┐
│  Active Exports                                             │
├────────────────────────────────────────────────────────────┤
│                                                             │
│  ⏳ export_vocabulary_2024-01-15.csv                       │
│     Generating... 45%                                       │
│     [████████████░░░░░░░░░░░░░░░]                          │
│     Started: 15:00 · Est. time left: 30s                   │
│                                                             │
└────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────┐
│  Export History                    [Filter: All ▼]          │
├────────────────────────────────────────────────────────────┤
│                                                             │
│  ✓ export_vocabulary_2024-01-14.csv                        │
│    Created: 14.01, 16:00 · Size: 2.4 MB · 1,245 records    │
│    [Download] [Delete] [View Log]                          │
│                                                             │
│  ✓ export_vocabulary_2024-01-10.json                       │
│    Created: 10.01, 10:30 · Size: 3.8 MB · 1,180 records    │
│    [Download] [Delete] [View Log]                          │
│                                                             │
│  ✗ export_vocabulary_2024-01-05.csv                        │
│    Failed: 05.01, 14:20 · Error: Database timeout          │
│    [Retry] [View Log]                                      │
│                                                             │
│  [Load More]                                                │
└────────────────────────────────────────────────────────────┘
```

## Components Used

### From Component Library
- **Button** - Primary for create, Secondary for actions
- **Badge** - Status indicators
- **Progress Bar** - Export generation progress
- **Modal** - New export configuration

### New/Screen-Specific Components
- **Export Job Card** - Shows job status with progress
- **Export History Item** - Shows completed/failed export

## Element Specifications

### New Export Button
- **Text:** "+ Nowy eksport"
- **Variant:** Primary
- **Size:** Medium
- **Icon:** 📤

### Active Export Card
- **Background:** `color-neutral-50` (#FAFAFA)
- **Border:** 1px solid `color-neutral-200` (#E4E4E7)
- **Border Radius:** `radius-md` (10px)
- **Padding:** `spacing-lg` (24px)
- **Margin Bottom:** `spacing-md` (16px)

#### Status Icon
- **Generating:** ⏳ (animated)
- **Completed:** ✓ (green)
- **Failed:** ✗ (red)
- **Size:** 24px

#### File Name
- **Font Size:** `font-size-h3` (20px)
- **Font Weight:** `font-weight-semibold` (600)
- **Color:** `color-neutral-900` (#18181B)

#### Progress Bar
- **Height:** 8px
- **Background:** `color-neutral-200` (#E4E4E7)
- **Fill:** `color-primary` (#4F46E5)
- **Border Radius:** `radius-sm` (4px)
- **Animated:** Smooth transition

#### Progress Text
- **Format:** "Generating... XX%"
- **Font Size:** `font-size-small` (14px)
- **Color:** `color-neutral-700` (#3F3F46)

#### Metadata
- **Format:** "Started: HH:MM · Est. time left: XXs"
- **Font Size:** `font-size-small` (14px)
- **Color:** `color-neutral-700` (#3F3F46)

### History Item Card
- **Background:** `color-surface` (#FFFFFF)
- **Border:** 1px solid `color-neutral-200` (#E4E4E7)
- **Border Radius:** `radius-md` (10px)
- **Padding:** `spacing-md` (16px)
- **Margin Bottom:** `spacing-sm` (8px)
- **Hover:** Lift shadow

#### File Info
- **Line 1:** File name with status icon
- **Line 2:** Created date, size, record count
- **Font Size:** `font-size-body` / `font-size-small`

#### Action Buttons
- **Download:** "Pobierz" (Primary, Small)
- **Delete:** "Usuń" (Ghost, Small, Red on hover)
- **View Log:** "Zobacz log" (Ghost, Small)
- **Retry:** "Powtórz" (Secondary, Small) - only for failed

### New Export Modal
- **Size:** Medium (600px)
- **Title:** "Nowy eksport danych"
- **Fields:**
  - Format (radio: CSV, JSON)
  - Include Stats (checkbox: Include usage statistics)
  - Date Range (date picker: optional, all data by default)
- **Actions:** Cancel, Create Export

## States

### Default State
- Active exports section (if any jobs running)
- History list loaded with recent exports
- New Export button enabled

### No Active Exports
- Message: "Brak aktywnych eksportów"
- Only show history section

### Generating State
- Progress bar animated
- Progress text updates every second
- Estimated time updates
- Cancel button available

### Export Complete State
- Success toast: "Export gotowy!"
- Move from active to history
- Download button enabled
- Auto-refresh list

### Export Failed State
- Error toast with message
- Show error in history item
- Retry button available
- View Log button to see error details

### Empty History State
- Icon: 📦
- Message: "Brak historii eksportów"
- Subtitle: "Utwórz pierwszy eksport, aby zacząć"
- New Export button prominent

### Creating Export State (Modal Open)
- Format selection (CSV default)
- Include stats checkbox
- Create button enabled

## Interactions

### New Export Button
- **Click:** Open New Export modal
- **Keyboard:** Enter or Space

### New Export Modal
- **Format Select:** Choose CSV or JSON
- **Include Stats Toggle:** Check/uncheck
- **Date Range Pick:** Select start and end dates (optional)
- **Create:** POST to API, close modal, show in active exports
- **Cancel:** Close modal
- **Escape:** Close modal

### Active Export
- **Auto-refresh:** Poll every 2 seconds for progress
- **Cancel Button:** Abort export job (if supported)
- **Complete:** Move to history, show download button

### Download Button
- **Click:** Download file via API
- **Keyboard:** Enter or Space
- **Success:** Show toast "Pobieranie rozpoczęte"

### Delete Button
- **Click:** Show confirmation modal
- **Confirm:** DELETE request to API, remove from list
- **Cancel:** Close modal

### Retry Button (Failed Exports)
- **Click:** Create new export with same settings
- **Navigate:** To new active export

### View Log Button
- **Click:** Open modal with audit log entries
- **Show:** Timestamp, action, details, error messages

### Filter Dropdown
- **Options:** All, Completed, Failed
- **Change:** Filter history list

## Accessibility

### Semantic HTML
- `<main>` for content
- `<section>` for active and history areas
- `<article>` for each export item
- `<progress>` for progress bar
- `<dialog>` for modals

### ARIA Attributes
- Progress bar: `role="progressbar" aria-valuenow aria-valuemin="0" aria-valuemax="100" aria-label="Export progress"`
- Status icons: `aria-label="Status: {status}"`
- Export items: `role="article" aria-label="Export {filename}"`
- Modal: `role="dialog" aria-modal="true" aria-labelledby="modal-title"`
- Download button: `aria-label="Pobierz {filename}"`
- Delete button: `aria-label="Usuń {filename}"`

### Keyboard Navigation
- Tab: Through all interactive elements
- Enter/Space: Activate buttons
- Escape: Close modal
- Alt+N: New export

### Screen Reader Announcements
- Export started: "Export rozpoczęty, {filename}"
- Progress update: Announce every 25% (25%, 50%, 75%, 100%)
- Export complete: "Export gotowy, {filename}, kliknij pobierz"
- Export failed: "Export nieudany, {filename}, {error}"
- Download started: "Pobieranie {filename}"

### Focus Management
- Modal open: Focus on first field
- Modal close: Return to trigger button
- After action: Focus on relevant element (toast, new item)

## Responsive Behavior

### Desktop (>1024px)
- Full layout with all metadata
- Multiple action buttons visible
- Progress bar full width

### Tablet (768px - 1024px)
- Compact layout
- Action buttons smaller
- Metadata may wrap

### Mobile (<768px)
- Stack export info vertically
- Action buttons as dropdown menu or bottom sheet
- Progress bar full width
- Reduced padding
- Modal full screen

## Backend Integration

### API Endpoints

#### GET /api/admin/exports
**Description:** List all export jobs

**Query Parameters:**
- `status`: "generating" | "completed" | "failed" | "all" (default all)
- `limit`: number (default 10)
- `page`: number (default 1)

**Response (200 OK):**
```json
{
  "exports": [
    {
      "id": "export-uuid",
      "fileName": "export_vocabulary_2024-01-15.csv",
      "status": "generating",
      "progress": 45,
      "format": "csv",
      "recordCount": 0,
      "fileSizeBytes": 0,
      "createdAt": "2024-01-15T15:00:00Z",
      "estimatedCompletion": "2024-01-15T15:01:00Z",
      "downloadUrl": null,
      "errorMessage": null
    },
    {
      "id": "export-uuid-2",
      "fileName": "export_vocabulary_2024-01-14.csv",
      "status": "completed",
      "progress": 100,
      "format": "csv",
      "recordCount": 1245,
      "fileSizeBytes": 2516582,
      "createdAt": "2024-01-14T16:00:00Z",
      "completedAt": "2024-01-14T16:02:00Z",
      "downloadUrl": "/api/admin/exports/export-uuid-2/download",
      "errorMessage": null
    }
  ],
  "pagination": {
    "page": 1,
    "perPage": 10,
    "total": 15
  }
}
```

#### POST /api/admin/exports/new
**Description:** Create new export job

**Request Body:**
```json
{
  "format": "csv",
  "includeStats": true,
  "dateRange": {
    "start": "2024-01-01T00:00:00Z",
    "end": "2024-01-15T23:59:59Z"
  }
}
```

**Response (201 Created):**
```json
{
  "id": "export-uuid",
  "fileName": "export_vocabulary_2024-01-15.csv",
  "status": "queued",
  "estimatedTime": 60
}
```

#### GET /api/admin/exports/:id/progress
**Description:** Get export progress

**Response (200 OK):**
```json
{
  "status": "generating",
  "progress": 45,
  "processedRecords": 560,
  "totalRecords": 1245,
  "estimatedCompletion": "2024-01-15T15:01:00Z"
}
```

#### GET /api/admin/exports/:id/download
**Description:** Download completed export

**Response (200 OK):** File download (Content-Disposition: attachment)

#### DELETE /api/admin/exports/:id
**Description:** Delete export

**Response (204 No Content)**

#### GET /api/admin/exports/:id/audit-log
**Description:** Get audit log for export

**Response (200 OK):**
```json
{
  "logs": [
    {
      "timestamp": "2024-01-14T16:00:00Z",
      "action": "export.created",
      "userId": "admin-uuid",
      "details": {
        "format": "csv",
        "includeStats": true
      }
    },
    {
      "timestamp": "2024-01-14T16:02:00Z",
      "action": "export.completed",
      "details": {
        "recordCount": 1245,
        "fileSize": 2516582
      }
    }
  ]
}
```

### Polling Strategy
- Poll every 2 seconds while status is "generating"
- Stop polling when status is "completed" or "failed"
- Exponential backoff if polling fails

## Design Tokens Used

### Colors
- `color-background`: #F8FAFC
- `color-surface`: #FFFFFF
- `color-primary`: #4F46E5
- `color-success`: #16A34A
- `color-error`: #DC2626
- `color-neutral-900`: #18181B
- `color-neutral-700`: #3F3F46
- `color-neutral-200`: #E4E4E7
- `color-neutral-50`: #FAFAFA

### Spacing
- `spacing-sm`: 8px
- `spacing-md`: 16px
- `spacing-lg`: 24px
- `spacing-xl`: 32px

### Typography
- `font-size-h3`: 20px
- `font-size-body`: 16px
- `font-size-small`: 14px
- `font-weight-semibold`: 600

### Shadows
- `shadow-md`: 0 4px 6px rgba(0,0,0,0.1)

### Border Radius
- `radius-sm`: 4px
- `radius-md`: 10px
- `radius-lg`: 14px

## Content Strings

### Polish UI Text
- **Page Title:** "Eksporty danych"
- **New Export:** "+ Nowy eksport"
- **Active Exports:** "Aktywne eksporty"
- **Export History:** "Historia eksportów"
- **Status:**
  - "Generating..." / "Generowanie..."
  - "Completed" / "Zakończony"
  - "Failed" / "Niepowodzenie"
- **Progress:** "Generating... {X}%"
- **Metadata:**
  - "Started: {time}" / "Rozpoczęto: {time}"
  - "Created: {date}" / "Utworzono: {date}"
  - "Size: {size} MB"
  - "Est. time left: {X}s" / "Pozostało: {X}s"
  - "{X} records" / "{X} rekordów"
- **Actions:**
  - "Download" / "Pobierz"
  - "Delete" / "Usuń"
  - "View Log" / "Zobacz log"
  - "Retry" / "Powtórz"
  - "Cancel" / "Anuluj"
  - "Create Export" / "Utwórz eksport"
- **Modal:**
  - "New Export" / "Nowy eksport danych"
  - "Format" / "Format"
  - "Include Stats" / "Uwzględnij statystyki"
  - "Date Range" / "Zakres dat"
- **Empty State:** "Brak historii eksportów"
- **No Active:** "Brak aktywnych eksportów"
- **Filter:** "Filter: {option}"
- **Delete Confirm:** "Czy na pewno chcesz usunąć ten eksport?"

## Testing Checklist

- [ ] Page loads with active and history sections
- [ ] New Export button opens modal
- [ ] Modal validates format selection
- [ ] Create starts export job
- [ ] Active export shows progress bar
- [ ] Progress updates automatically
- [ ] Progress bar animates smoothly
- [ ] Export completes and moves to history
- [ ] Download button downloads file
- [ ] Delete shows confirmation
- [ ] Delete removes export
- [ ] Retry creates new export
- [ ] View Log shows audit log
- [ ] Filter dropdown filters history
- [ ] Empty state displays correctly
- [ ] Loading state shows skeletons
- [ ] Keyboard navigation works
- [ ] Screen reader announces progress
- [ ] Mobile responsive works
- [ ] Touch targets ≥44x44px
- [ ] All text in Polish
- [ ] WCAG AA contrast met
