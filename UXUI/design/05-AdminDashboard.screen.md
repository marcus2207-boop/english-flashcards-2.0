# Admin Dashboard Screen Specification

**Route:** `/admin/dashboard`  
**Related Stories:** ST-009  
**User Personas:** P-002 (Admin/Teacher - Maria, 35 years old)

## Overview

The Admin Dashboard provides administrators with an overview of system usage, recent imports, export status, and quick access to admin functions. It features charts, statistics, and action buttons for common administrative tasks.

## Layout

### Container
- **Type:** Two-column grid layout (responsive)
- **Max Width:** 1400px
- **Background:** `color-background` (#F8FAFC)
- **Padding:** `spacing-xl` (32px)

### Header Section
- **Background:** `color-surface` (#FFFFFF)
- **Border Radius:** `radius-lg` (14px)
- **Shadow:** `shadow-md`
- **Padding:** `spacing-xl` (32px)
- **Contains:** Welcome message and quick actions

### Left Column (Main Stats)
- **Width:** 60%
- **Contains:** Usage charts, user stats

### Right Column (Activity & Actions)
- **Width:** 40%
- **Contains:** Recent imports, export queue, quick links

## Visual Hierarchy

```
┌────────────────────────────────────────────────────────────┐
│  Admin Dashboard            [Export] [Import] [Users]      │
├────────────────────────────────────────────────────────────┤
│                                                             │
│  Witaj, Maria! 👋                                          │
│  Panel administratora                                       │
│                                                             │
└────────────────────────────────────────────────────────────┘

┌────────────────────────┐  ┌──────────────────────────────┐
│                        │  │                               │
│  Aktywni użytkownicy   │  │  Ostatnie importy             │
│                        │  │                               │
│  [Bar Chart]           │  │  ✓ vocabulary_2024.csv        │
│  This week: 45         │  │    15.01, 14:30 · 120 wierszy│
│  Last week: 38         │  │                               │
│  Growth: +18%          │  │  ✓ animals.json               │
│                        │  │    14.01, 10:15 · 85 wierszy │
│  Sesje dziennie        │  │                               │
│                        │  │  [Zobacz wszystkie]           │
│  [Line Chart]          │  │                               │
│  Avg: 127 / day        │  ├──────────────────────────────┤
│                        │  │  Eksporty                     │
│  Słówka w bazie        │  │                               │
│  Total: 1,245          │  │  ⏳ export_2024-01-15.zip    │
│  Mastered: 423 (34%)   │  │     Generating... 45%        │
│  Learning: 822 (66%)   │  │                               │
│                        │  │  ✓ export_2024-01-14.zip     │
└────────────────────────┘  │     Ready [Download]          │
                            │                               │
                            │  [New Export]                 │
                            └──────────────────────────────┘
```

## Components Used

### From Component Library
- **Button** - Primary for quick actions, Secondary for list actions
- **Card** - For stat cards and activity lists
- **Badge** - For status indicators
- **Chart** - Bar and line charts (using chart library)
- **Table** - For detailed stats

### New/Screen-Specific Components
- **Stat Card** - Displays metric with trend indicator
- **Import List Item** - Shows import summary
- **Export Job Item** - Shows export status with progress

## Element Specifications

### Header Title
- **Text:** "Witaj, {firstName}! 👋"
- **Font Size:** `font-size-h1` (28px)
- **Font Weight:** `font-weight-bold` (700)
- **Color:** `color-neutral-900` (#18181B)

### Quick Action Buttons
- **Export:** "Eksport danych"
- **Import:** "Import słówek"
- **Users:** "Zarządzaj użytkownikami"
- **Variant:** Primary / Secondary
- **Size:** Medium
- **Icons:** 📤 📥 👥

### Stat Cards
- **Background:** `color-surface` (#FFFFFF)
- **Border:** 1px solid `color-neutral-200` (#E4E4E7)
- **Border Radius:** `radius-md` (10px)
- **Padding:** `spacing-lg` (24px)
- **Shadow:** `shadow-sm`

#### Active Users Card
- **Metric:** Number of active users this week
- **Trend:** Percentage change vs last week
- **Color:** Green (positive), Red (negative)
- **Chart:** Bar chart showing last 7 days

#### Sessions Per Day Card
- **Metric:** Average sessions per day
- **Chart:** Line chart showing last 30 days
- **Color:** `color-primary` (#4F46E5)

#### Vocabulary Stats Card
- **Total Words:** Total cards in database
- **Mastered:** Count and percentage
- **Learning:** Count and percentage
- **Progress Bar:** Visual representation

### Import List Item
- **Status Icon:** ✓ (success), ⚠ (warning), ✗ (error)
- **File Name:** Truncate with ellipsis
- **Timestamp:** Format "DD.MM, HH:MM"
- **Row Count:** "{X} wierszy"
- **Click:** Navigate to import detail

### Export Job Item
- **Status Icon:** ✓ (complete), ⏳ (generating), ✗ (failed)
- **File Name:** Full name with extension
- **Progress Bar:** If generating, show percentage
- **Download Button:** Only if complete
- **Click:** Open export detail or download

## States

### Default State
- All stats and charts loaded
- Recent imports list (last 5)
- Export queue visible
- Quick actions enabled

### Loading State
- Skeleton loaders for charts
- Skeleton loaders for lists
- Disable quick action buttons

### Error State
- Toast notification for API errors
- Show "Retry" button
- Keep previously loaded data visible

### No Recent Imports
- Message: "Brak ostatnich importów"
- Call to action: "Rozpocznij pierwszy import"

### Export Queue Empty
- Message: "Brak aktywnych eksportów"
- Call to action: "Utwórz nowy eksport"

## Interactions

### Quick Action Buttons
- **Export Click:** Navigate to `/admin/exports`
- **Import Click:** Navigate to `/admin/import`
- **Users Click:** Navigate to `/admin/users`
- **Hover:** Lift shadow

### Chart Hover
- **Tooltip:** Show exact value for data point
- **Cursor:** Crosshair

### Import List Item Click
- **Action:** Navigate to `/admin/imports/:id`
- **Hover:** Background highlight

### Export Job Item
- **Download Click:** Download file via API
- **Progress:** Auto-refresh every 2 seconds while generating
- **Complete:** Stop polling, show download button

### View All Links
- **Imports:** Navigate to `/admin/imports`
- **Exports:** Navigate to `/admin/exports`

## Accessibility

### Semantic HTML
- `<main>` for dashboard content
- `<section>` for each major area
- `<article>` for stat cards
- `<h1>` for page title
- `<h2>` for section titles

### ARIA Attributes
- Charts: `role="img" aria-label="Chart description"`
- Stat cards: `aria-label="Metric name: value, trend"`
- Import list: `role="list"`
- Each import: `role="listitem"`
- Export progress: `aria-valuenow aria-valuemin aria-valuemax aria-label`
- Quick actions: Descriptive `aria-label` attributes

### Keyboard Navigation
- Tab order: Quick actions → Charts → Import list → Export queue
- Enter/Space: Activate buttons and list items
- Arrow keys: Navigate charts (optional, library-dependent)

### Screen Reader Announcements
- On load: "Dashboard załadowany. {X} aktywnych użytkowników."
- After export starts: "Eksport rozpoczęty"
- Export complete: "Eksport gotowy do pobrania"
- Import complete: "Import zakończony pomyślnie"

## Responsive Behavior

### Desktop (>1024px)
- Two-column layout (60/40 split)
- Full charts with hover tooltips
- All stats visible

### Tablet (768px - 1024px)
- Two-column layout (equal split)
- Smaller charts
- Compact stat cards

### Mobile (<768px)
- Single column stack
- Charts simplified or scrollable
- Quick actions as FAB or bottom bar
- Reduced padding

## Backend Integration

### API Endpoints

#### GET /api/admin/dashboard/stats
**Description:** Fetch dashboard statistics

**Response (200 OK):**
```json
{
  "activeUsers": {
    "thisWeek": 45,
    "lastWeek": 38,
    "trend": 18.4
  },
  "sessions": {
    "avgPerDay": 127,
    "last30Days": [...]
  },
  "vocabulary": {
    "total": 1245,
    "mastered": 423,
    "learning": 822
  }
}
```

#### GET /api/admin/imports/recent
**Description:** List recent imports

**Query Parameters:**
- `limit`: number (default 5)

**Response (200 OK):**
```json
{
  "imports": [
    {
      "id": "import-uuid",
      "fileName": "vocabulary_2024.csv",
      "status": "completed",
      "rowCount": 120,
      "successCount": 118,
      "errorCount": 2,
      "createdAt": "2024-01-15T14:30:00Z"
    }
  ]
}
```

#### GET /api/admin/exports
**Description:** List export jobs

**Query Parameters:**
- `status`: "generating" | "completed" | "failed"
- `limit`: number

**Response (200 OK):**
```json
{
  "exports": [
    {
      "id": "export-uuid",
      "fileName": "export_2024-01-15.zip",
      "status": "generating",
      "progress": 45,
      "createdAt": "2024-01-15T15:00:00Z",
      "downloadUrl": null
    },
    {
      "id": "export-uuid-2",
      "fileName": "export_2024-01-14.zip",
      "status": "completed",
      "progress": 100,
      "createdAt": "2024-01-14T16:00:00Z",
      "downloadUrl": "/api/admin/exports/export-uuid-2/download"
    }
  ]
}
```

#### POST /api/admin/exports/new
**Description:** Create new export job

**Request Body:**
```json
{
  "format": "csv" | "json",
  "includeStats": boolean
}
```

**Response (201 Created):**
```json
{
  "id": "export-uuid",
  "status": "queued",
  "estimatedTime": 120
}
```

### Polling Strategy
- Export progress: Poll every 2 seconds while status is "generating"
- Stop polling when status changes to "completed" or "failed"
- Dashboard stats: Auto-refresh every 5 minutes

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
- `color-neutral-200`: #E4E4E7

### Spacing
- `spacing-sm`: 8px
- `spacing-md`: 16px
- `spacing-lg`: 24px
- `spacing-xl`: 32px

### Typography
- `font-size-h1`: 28px
- `font-size-h2`: 24px
- `font-size-body`: 16px
- `font-weight-bold`: 700
- `font-weight-semibold`: 600

### Shadows
- `shadow-sm`: 0 1px 2px rgba(0,0,0,0.05)
- `shadow-md`: 0 4px 6px rgba(0,0,0,0.1)

### Border Radius
- `radius-md`: 10px
- `radius-lg`: 14px

## Content Strings

### Polish UI Text
- **Page Title:** "Panel administratora"
- **Welcome:** "Witaj, {firstName}! 👋"
- **Quick Actions:**
  - "Eksport danych"
  - "Import słówek"
  - "Zarządzaj użytkownikami"
- **Stats Labels:**
  - "Aktywni użytkownicy"
  - "Sesje dziennie"
  - "Słówka w bazie"
  - "Opanowane"
  - "W nauce"
- **Recent Imports:** "Ostatnie importy"
- **Exports:** "Eksporty"
- **Status:**
  - "Generating..." / "Generowanie..."
  - "Ready" / "Gotowy"
  - "Failed" / "Błąd"
- **Actions:**
  - "Download" / "Pobierz"
  - "View All" / "Zobacz wszystkie"
  - "New Export" / "Nowy eksport"
- **Empty States:**
  - "Brak ostatnich importów"
  - "Brak aktywnych eksportów"

## Testing Checklist

- [ ] Dashboard loads with correct stats
- [ ] Charts display data correctly
- [ ] Active users trend calculates correctly
- [ ] Recent imports list shows last 5 imports
- [ ] Export queue displays current jobs
- [ ] Export progress updates automatically
- [ ] Download button works for completed exports
- [ ] Quick action buttons navigate correctly
- [ ] View all links navigate correctly
- [ ] Loading state displays skeletons
- [ ] Error state shows toast and retry
- [ ] Empty states display correctly
- [ ] Keyboard navigation works
- [ ] Screen reader announces stats
- [ ] Charts have accessible descriptions
- [ ] Mobile responsive layout works
- [ ] Charts adapt to mobile screen
- [ ] All text in Polish
- [ ] WCAG AA contrast met
