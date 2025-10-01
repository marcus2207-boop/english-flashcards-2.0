# Lessons Screen Specification

**Route:** `/lessons`  
**Related Stories:** ST-004, ST-010  
**User Personas:** P-001 (Student - Laura, 13 years old)

## Overview

The Lessons screen allows students to view, create, and edit their personal lesson collections. Each lesson is a group of flashcards organized by topic. Students can manage their own lessons and view shared lessons from teachers or admins.

## Layout

### Container
- **Type:** Two-column layout with sidebar (desktop), single column (mobile)
- **Max Width:** 1200px
- **Background:** `color-background` (#F8FAFC)
- **Padding:** `spacing-xl` (32px)

### Sidebar (Left)
- **Width:** 280px (desktop)
- **Background:** `color-surface` (#FFFFFF)
- **Border Radius:** `radius-lg` (14px)
- **Shadow:** `shadow-md`
- **Contains:** Filters, lesson categories, create new button

### Main Content (Right)
- **Flex:** 1
- **Margin Left:** `spacing-lg` (24px) on desktop
- **Contains:** Lesson list/grid and lesson editor

## Visual Hierarchy

```
┌────────────────────────────────────────────────────────────┐
│                    Navigation Bar                           │
└────────────────────────────────────────────────────────────┘

┌──────────────┐  ┌───────────────────────────────────────┐
│              │  │                                        │
│  Moje lekcje │  │   [Search lessons...]   [Grid] [List] │
│              │  │                                        │
│  [+ Nowa]    │  │  ┌──────────┐  ┌──────────┐          │
│              │  │  │ Animals  │  │ Weather  │          │
│  Wszystkie   │  │  │ 15 cards │  │ 10 cards │          │
│  Moje (8)    │  │  │ ⭐ 87%   │  │ ⭐ 92%   │          │
│  Udostępnione│  │  │ [Edit]   │  │ [Edit]   │          │
│  (2)         │  │  └──────────┘  └──────────┘          │
│              │  │                                        │
│  Tagi        │  │  ┌──────────┐  ┌──────────┐          │
│  □ Czasowniki│  │  │ Colors   │  │ Food     │          │
│  □ Rzeczown. │  │  │ 8 cards  │  │ 12 cards │          │
│  □ Przymiotn.│  │  │ ⭐ 75%   │  │ ⭐ 95%   │          │
│              │  │  │ [Edit]   │  │ [Edit]   │          │
└──────────────┘  │  └──────────┘  └──────────┘          │
                  │                                        │
                  │  [Load more...]                       │
                  └───────────────────────────────────────┘
```

## Components Used

### From Component Library
- **Button** - Primary for "Create", Secondary for "Edit"
- **Card** - For lesson tiles
- **Badge** - For card count and score
- **Input** - Search field
- **Modal** - Lesson editor

### New/Screen-Specific Components
- **Lesson Card** - Displays lesson info with thumbnail
- **Lesson Editor Modal** - Full editor with card list and add/remove
- **Filter Sidebar** - Category and tag filters

## Element Specifications

### Create New Button
- **Text:** "+ Nowa lekcja"
- **Variant:** Primary
- **Size:** Medium
- **Full Width:** true (in sidebar)

### Search Input
- **Placeholder:** "Szukaj lekcji..."
- **Type:** text
- **Icon:** 🔍 (left)
- **Width:** 100% of content area
- **Debounce:** 300ms

### Lesson Card
- **Background:** `color-surface` (#FFFFFF)
- **Border:** 1px solid `color-neutral-200` (#E4E4E7)
- **Border Radius:** `radius-md` (10px)
- **Padding:** `spacing-md` (16px)
- **Shadow:** `shadow-sm`
- **Hover:** Lift shadow to `shadow-md`
- **Min Height:** 180px

#### Card Title
- **Font Size:** `font-size-h3` (20px)
- **Font Weight:** `font-weight-semibold` (600)
- **Color:** `color-neutral-900` (#18181B)
- **Truncate:** 2 lines with ellipsis

#### Card Count Badge
- **Format:** "{X} kart" or "{X} karty" (proper Polish plural)
- **Size:** Small
- **Color:** `color-neutral-700` (#3F3F46)

#### Average Score Badge
- **Format:** "⭐ XX%"
- **Size:** Small
- **Color:** Success (≥80%), Warning (60-79%), Error (<60%)

#### Edit Button
- **Text:** "Edytuj"
- **Variant:** Secondary
- **Size:** Small

### Lesson Editor Modal
- **Size:** Extra large (90vw on desktop, full screen on mobile)
- **Title:** "Edytuj lekcję: {name}" or "Nowa lekcja"
- **Contains:** 
  - Lesson name input
  - Tag selector (multi-select)
  - Card list (sortable)
  - Add card button
  - Save/Cancel buttons

## States

### Default State
- Lesson grid/list loaded with user's lessons
- Sidebar filters visible
- Search field empty

### Loading State
- Show skeleton loaders for lesson cards
- Disable create button
- Search field disabled

### Empty State (No Lessons)
- Icon: 📚
- Message: "Nie masz jeszcze żadnych lekcji"
- Subtitle: "Stwórz swoją pierwszą lekcję, aby zacząć naukę!"
- Create button prominent

### Search/Filter Results Empty
- Icon: 🔍
- Message: "Nie znaleziono lekcji"
- Subtitle: "Spróbuj zmienić kryteria wyszukiwania"
- Clear filters button

### Editor Modal States
- **Viewing:** Show card list, allow sorting
- **Adding Card:** Inline form at top of list
- **Editing Card:** Replace card with inline edit form
- **Saving:** Disable all inputs, show saving indicator
- **Error:** Show error toast, keep modal open

## Interactions

### Create New Button
- **Click:** Open lesson editor modal in create mode
- **Keyboard:** Enter or Space

### Lesson Card
- **Click:** Navigate to lesson detail `/lessons/:id`
- **Edit Button Click:** Open lesson editor modal for this lesson
- **Hover:** Lift shadow

### Search Field
- **Input:** Filter lessons by name (debounced 300ms)
- **Clear:** X button appears when text present

### Filter Sidebar
- **Checkbox Click:** Toggle filter, update lesson list
- **Category Click:** Filter by category (My/Shared/All)

### Lesson Editor Modal
- **Add Card:** Show inline form with English/Polish fields and TTS option
- **Edit Card:** Click card row to edit inline
- **Delete Card:** X button with confirmation
- **Drag Card:** Reorder cards in list
- **Save:** POST/PUT to API, close modal, refresh list
- **Cancel:** Close modal without saving, confirm if changes exist

## Accessibility

### Semantic HTML
- `<main>` for lessons content
- `<aside>` for sidebar
- `<nav>` for filters
- `<article>` for each lesson card
- `<h1>` for "Moje lekcje"
- `<h2>` for lesson names

### ARIA Attributes
- Search field: `aria-label="Szukaj lekcji" role="searchbox"`
- Lesson cards: `role="article" aria-label="Lekcja {name}, {X} kart"`
- Filter checkboxes: Proper labels and `aria-checked`
- Modal: `role="dialog" aria-modal="true" aria-labelledby="modal-title"`
- Card list in editor: `role="list"`
- Sortable items: `aria-grabbed` state during drag

### Keyboard Navigation
- Tab: Navigate through cards, buttons, filters
- Enter/Space: Activate buttons and cards
- Esc: Close modal
- Arrow keys: Navigate card list in editor
- Drag handles: Keyboard-accessible reordering (Space to grab, Arrow to move, Space to drop)

### Screen Reader Announcements
- After search: "{X} lekcji znaleziono"
- After filter: "Lista lekcji zaktualizowana"
- After save: "Lekcja zapisana pomyślnie"
- Empty state: "Nie masz jeszcze żadnych lekcji. Stwórz swoją pierwszą lekcję."

## Responsive Behavior

### Desktop (>1024px)
- Two-column layout with sidebar
- Grid view: 3 columns
- List view: Single column with horizontal layout

### Tablet (768px - 1024px)
- Sidebar collapsible (hamburger menu)
- Grid view: 2 columns
- Reduced card size

### Mobile (<768px)
- Sidebar hidden, accessed via bottom sheet
- Grid view: 1 column (card list)
- Full-width cards
- Editor modal full screen
- Search field full width with floating action button for create

## Backend Integration

### API Endpoints

#### GET /api/lessons
**Description:** List all lessons for user

**Query Parameters:**
- `userId`: uuid (required)
- `search`: string (optional)
- `tags`: comma-separated (optional)
- `shared`: boolean (optional, default false)

**Response (200 OK):**
```json
{
  "lessons": [
    {
      "id": "lesson-uuid",
      "name": "Animals",
      "cardCount": 15,
      "tags": ["rzeczowniki", "podstawowe"],
      "averageScore": 87.5,
      "createdAt": "2024-01-10T10:00:00Z",
      "updatedAt": "2024-01-14T15:30:00Z",
      "ownerId": "user-uuid",
      "isShared": false
    }
  ]
}
```

#### POST /api/lessons
**Description:** Create new lesson

**Request Body:**
```json
{
  "name": "Weather",
  "tags": ["rzeczowniki", "pogoda"],
  "cards": []
}
```

**Response (201 Created):**
```json
{
  "id": "lesson-uuid",
  "name": "Weather",
  "cardCount": 0,
  "createdAt": "2024-01-15T14:00:00Z"
}
```

#### PUT /api/lessons/:id
**Description:** Update lesson

**Request Body:**
```json
{
  "name": "Weather vocabulary",
  "tags": ["rzeczowniki", "pogoda", "advanced"],
  "cards": [
    {
      "id": "card-uuid",
      "english": "rain",
      "polish": "deszcz",
      "phonetic": "/reɪn/",
      "order": 0
    }
  ]
}
```

#### DELETE /api/lessons/:id
**Description:** Delete lesson (with confirmation)

**Response (204 No Content)**

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
- `font-size-h3`: 20px
- `font-size-body`: 16px
- `font-weight-semibold`: 600

### Shadows
- `shadow-sm`: 0 1px 2px rgba(0,0,0,0.05)
- `shadow-md`: 0 4px 6px rgba(0,0,0,0.1)

### Border Radius
- `radius-md`: 10px
- `radius-lg`: 14px

## Content Strings

### Polish UI Text
- **Page Title:** "Moje lekcje"
- **Create Button:** "+ Nowa lekcja"
- **Search Placeholder:** "Szukaj lekcji..."
- **Categories:**
  - "Wszystkie"
  - "Moje"
  - "Udostępnione"
- **Tags:** "Tagi"
- **Edit Button:** "Edytuj"
- **Delete Button:** "Usuń"
- **Save Button:** "Zapisz"
- **Cancel Button:** "Anuluj"
- **Empty State:** "Nie masz jeszcze żadnych lekcji"
- **Empty Subtitle:** "Stwórz swoją pierwszą lekcję, aby zacząć naukę!"
- **Card Count:** "{X} kart" / "{X} karty" / "{X} karta"
- **Modal Title New:** "Nowa lekcja"
- **Modal Title Edit:** "Edytuj lekcję: {name}"
- **Add Card:** "+ Dodaj kartę"
- **Confirm Delete:** "Czy na pewno chcesz usunąć tę lekcję?"

## Testing Checklist

- [ ] Lesson grid displays correctly
- [ ] Create button opens modal
- [ ] Modal allows adding/editing cards
- [ ] Search filters lessons correctly
- [ ] Category filters work
- [ ] Tag filters work (multiple selection)
- [ ] Edit button opens lesson in modal
- [ ] Save creates/updates lesson via API
- [ ] Delete removes lesson with confirmation
- [ ] Empty state displays when no lessons
- [ ] Loading state shows skeletons
- [ ] Drag and drop reordering works
- [ ] Keyboard navigation functional
- [ ] Screen reader announces changes
- [ ] Mobile responsive layout works
- [ ] Sidebar collapses on mobile
- [ ] Touch targets ≥44x44px
- [ ] All text in Polish
- [ ] WCAG AA contrast met
