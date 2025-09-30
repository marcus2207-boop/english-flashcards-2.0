# Student Dashboard Screen Specification

**Route:** `/dashboard`  
**Related Stories:** ST-008, ST-006  
**User Personas:** P-001 (Student - Laura, 13 years old)

## Overview

The Student Dashboard is the primary landing page for students after login. It features a prominent call-to-action to start a learning session, displays key learning statistics, and provides quick access to recent sessions with the ability to repeat mistakes.

## Layout

### Container
- **Type:** Centered single-column layout with hero section
- **Max Width:** 1200px
- **Background:** `color-background` (#F8FAFC)
- **Padding:** `spacing-xl` (32px)

### Hero Section
- **Background:** `color-surface` (#FFFFFF)
- **Border Radius:** `radius-lg` (14px)
- **Shadow:** `shadow-lg`
- **Padding:** `spacing-xxl` (48px)
- **Text Align:** Center

### Stats Cards Section
- **Layout:** Three-column grid (responsive: single column on mobile)
- **Gap:** `spacing-lg` (24px)
- **Margin Top:** `spacing-xl` (32px)

### Recent Sessions Section
- **Background:** `color-surface` (#FFFFFF)
- **Border Radius:** `radius-lg` (14px)
- **Shadow:** `shadow-md`
- **Padding:** `spacing-xl` (32px)
- **Margin Top:** `spacing-xl` (32px)

## Visual Hierarchy

```
┌──────────────────────────────────────────────────────┐
│                    Navigation Bar                     │
│  [Logo]  Dashboard  My Lessons  [User Menu]         │
└──────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────┐
│                                                       │
│              Witaj, Laura! 👋                        │
│                                                       │
│         Gotowa na nową sesję nauki?                  │
│                                                       │
│  ┌─────────────────────────────────────────────┐   │
│  │    Rozpocznij sesję 15-minutową             │   │  ← Primary Button
│  └─────────────────────────────────────────────┘   │
│                                                       │
└──────────────────────────────────────────────────────┘

┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│  Opanowane  │  │ Śr. wynik   │  │ Następna    │
│             │  │             │  │             │
│     45      │  │    87%      │  │  Za 2h      │
│   słówek    │  │   (7 dni)   │  │             │
└─────────────┘  └─────────────┘  └─────────────┘

┌──────────────────────────────────────────────────────┐
│  Ostatnie sesje                                       │
│                                                       │
│  ┌────────────────────────────────────────────────┐ │
│  │ 📅 Dzisiaj, 14:30  │  ⭐ 85%  │  [Powtórz błędy]│ │
│  │ 15 słówek · 10 poprawnych                      │ │
│  └────────────────────────────────────────────────┘ │
│                                                       │
│  ┌────────────────────────────────────────────────┐ │
│  │ 📅 Wczoraj, 16:45  │  ⭐ 92%  │  [Powtórz błędy]│ │
│  │ 12 słówek · 11 poprawnych                      │ │
│  └────────────────────────────────────────────────┘ │
│                                                       │
│  [Zobacz wszystkie sesje]                            │
└──────────────────────────────────────────────────────┘
```

## Components Used

### From Component Library
- **Button** - Primary (large) for CTA, Secondary (small) for "Repeat mistakes"
- **Card** - For stats cards and session items
- **Badge** - For status indicators and scores
- **Navigation** - Top navigation bar

### New/Screen-Specific Components
- **Stats Card** - Displays single metric with icon and label
- **Session List Item** - Shows session summary with metadata

## Element Specifications

### Hero Title
- **Text:** "Witaj, {firstName}! 👋"
- **Font Size:** `font-size-h1` (28px)
- **Font Weight:** `font-weight-bold` (700)
- **Color:** `color-neutral-900` (#18181B)
- **Margin Bottom:** `spacing-md` (16px)

### Hero Subtitle
- **Text:** "Gotowa na nową sesję nauki?"
- **Font Size:** `font-size-body` (16px)
- **Color:** `color-neutral-700` (#3F3F46)
- **Margin Bottom:** `spacing-xl` (32px)

### Start Session Button
- **Text:** "Rozpocznij sesję 15-minutową"
- **Variant:** Primary
- **Size:** Large
- **Full Width:** false
- **Width:** Auto (min 320px)
- **Icon:** 🚀 (optional)

### Stats Card
- **Background:** `color-surface` (#FFFFFF)
- **Border:** 1px solid `color-neutral-200` (#E4E4E7)
- **Border Radius:** `radius-md` (10px)
- **Padding:** `spacing-lg` (24px)
- **Text Align:** Center
- **Shadow:** `shadow-sm` (subtle)

#### Mastered Card
- **Icon:** ⭐ (or SVG star icon)
- **Value:** Number with "słówek" label
- **Color:** `color-success` (#16A34A)

#### Average Score Card
- **Icon:** 📊 (or SVG chart icon)
- **Value:** Percentage with "(7 dni)" label
- **Color:** `color-primary` (#4F46E5)

#### Next Due Card
- **Icon:** ⏰ (or SVG clock icon)
- **Value:** Time string ("Za 2h", "Za 30 min")
- **Color:** `color-warning` (#F59E0B)

### Session List Item
- **Background:** `color-neutral-100` (#F4F4F5)
- **Border Radius:** `radius-md` (10px)
- **Padding:** `spacing-md` (16px)
- **Margin Bottom:** `spacing-sm` (8px)
- **Display:** Flex (space-between)

#### Timestamp
- **Format:** "Dzisiaj, HH:MM" or "Wczoraj, HH:MM" or "DD.MM, HH:MM"
- **Font Size:** `font-size-small` (14px)
- **Color:** `color-neutral-700` (#3F3F46)

#### Score Badge
- **Format:** "XX%"
- **Size:** Small
- **Color:** Success (≥80%), Warning (60-79%), Error (<60%)

#### Repeat Button
- **Text:** "Powtórz błędy"
- **Variant:** Secondary
- **Size:** Small
- **Only shown if:** Session has mistakes (score < 100%)

### View All Button
- **Text:** "Zobacz wszystkie sesje"
- **Variant:** Ghost/Text
- **Size:** Medium
- **Align:** Center

## States

### Default State
- All stats loaded and displayed
- Recent sessions list showing last 3-5 sessions
- Start session button enabled

### Loading State
- Show skeleton loaders for stats cards
- Show skeleton loaders for session list items
- Disable start session button with loading spinner

### Empty State (No Sessions)
- Stats cards show "0" or "—" for no data
- Session list shows:
  - Icon: 📚
  - Message: "Nie masz jeszcze żadnych sesji"
  - Subtitle: "Rozpocznij pierwszą sesję, aby zobaczyć swoje postępy!"

### Error State
- Toast notification: "Nie udało się załadować danych"
- Retry button in stats section
- Keep UI interactive

### No Due Cards State
- Next Due card shows: "Brak słówek do powtórki"
- Start session button shows: "Rozpocznij nową sesję" (no 15-min label)
- Info message: "Świetna robota! Możesz nauczyć się nowych słówek lub powtórzyć dowolną lekcję."

## Interactions

### Start Session Button
- **Click:** 
  - Validate user has cards to review
  - If yes: Navigate to `/session/new` with POST request
  - If no: Show modal "Brak słówek do nauki"
- **Hover:** Lift shadow, slight scale (1.02)
- **Active:** Scale down (0.98)
- **Keyboard:** Enter or Space to activate

### Stats Cards
- **Hover:** Subtle lift shadow
- **Click:** Navigate to detailed view (future feature)
- **Tooltip:** Show additional context on hover

### Repeat Mistakes Button
- **Click:**
  - POST to `/api/sessions/repeat` with session ID
  - Navigate to new session with only mistake cards
- **Hover:** Underline text
- **Disabled State:** Grayed out if no mistakes in session

### View All Button
- **Click:** Navigate to `/sessions/history`
- **Hover:** Underline text

### Session List Item
- **Hover:** Background changes to lighter shade
- **Click:** Navigate to session summary `/sessions/:id`

## Accessibility

### Semantic HTML
- `<main>` for dashboard content
- `<section>` for stats and sessions areas
- `<article>` for each session item
- `<h1>` for "Witaj, {name}"
- `<h2>` for section titles

### ARIA Attributes
- Hero section: `role="region" aria-label="Główna akcja"`
- Stats cards: `role="group" aria-label="Twoje statystyki nauki"`
- Each stat card: `aria-label="{Metric name}: {value}"`
- Session list: `role="list"`
- Each session item: `role="listitem"`
- "Repeat mistakes" button: `aria-label="Powtórz błędy z sesji {date}"`

### Keyboard Navigation
- Tab order: Start button → Stats cards → Session items → View all
- Enter/Space: Activate buttons and links
- Arrow keys: Navigate between stats cards (optional)

### Screen Reader Announcements
- On load: "Dashboard załadowany. Masz {X} słówek opanowanych."
- After starting session: "Rozpoczynanie sesji..."
- Empty state: "Nie masz jeszcze żadnych sesji. Rozpocznij pierwszą sesję, aby zobaczyć swoje postępy."

### Focus Management
- On page load: Focus on main heading
- After action: Focus on relevant element (e.g., toast notification)

## Responsive Behavior

### Desktop (>1024px)
- Full layout as specified
- Stats cards in 3-column grid
- Session list shows 5 items
- Hero section with large padding

### Tablet (768px - 1024px)
- Stats cards in 3-column grid (smaller)
- Session list shows 4 items
- Reduced padding on hero section
- Container max-width: 900px

### Mobile (<768px)
- Stats cards stack vertically (single column)
- Session list shows 3 items
- Start button full width
- Reduced padding: `spacing-md` (16px)
- Session item layout stacks vertically
- Font sizes slightly reduced

## Backend Integration

### API Endpoints

#### GET /api/users/:id/summary
**Description:** Fetch dashboard statistics and recent sessions

**Request Headers:**
```json
{
  "Authorization": "Bearer {token}",
  "Accept": "application/json"
}
```

**Response (200 OK):**
```json
{
  "user": {
    "id": "uuid",
    "firstName": "Laura",
    "lastName": "Kowalska"
  },
  "stats": {
    "mastered": 45,
    "averageScore": 87.5,
    "averageScorePeriodDays": 7,
    "nextDueAt": "2024-01-15T16:30:00Z",
    "totalSessions": 23,
    "totalCards": 120,
    "streakDays": 5
  },
  "recentSessions": [
    {
      "id": "session-uuid",
      "startedAt": "2024-01-15T14:30:00Z",
      "completedAt": "2024-01-15T14:45:00Z",
      "totalCards": 15,
      "correctCards": 10,
      "score": 85,
      "hasMistakes": true
    }
  ]
}
```

**Error Responses:**
- 401: Unauthorized (redirect to login)
- 404: User not found
- 500: Server error (show retry option)

#### POST /api/sessions/new
**Description:** Start a new session with due cards

**Request Body:**
```json
{
  "userId": "uuid",
  "duration": 900,
  "maxCards": 20
}
```

**Response (201 Created):**
```json
{
  "sessionId": "session-uuid",
  "cards": 15,
  "estimatedDuration": 900
}
```

#### POST /api/sessions/repeat
**Description:** Start a session with mistakes from previous session

**Request Body:**
```json
{
  "originalSessionId": "session-uuid"
}
```

**Response (201 Created):**
```json
{
  "sessionId": "new-session-uuid",
  "cards": 5,
  "note": "Repeating mistakes from previous session"
}
```

### Data Refresh Strategy
- On page load: Fetch all data
- Auto-refresh: Every 5 minutes (silent background refresh)
- After session complete: Immediate refresh
- Pull-to-refresh on mobile

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
- `color-neutral-100`: #F4F4F5

### Spacing
- `spacing-sm`: 8px
- `spacing-md`: 16px
- `spacing-lg`: 24px
- `spacing-xl`: 32px
- `spacing-xxl`: 48px

### Typography
- `font-size-h1`: 28px
- `font-size-body`: 16px
- `font-size-small`: 14px
- `font-weight-bold`: 700
- `font-weight-semibold`: 600
- `font-weight-normal`: 400

### Shadows
- `shadow-sm`: 0 1px 2px rgba(0,0,0,0.05)
- `shadow-md`: 0 4px 6px rgba(0,0,0,0.1)
- `shadow-lg`: 0 10px 15px rgba(0,0,0,0.1)

### Border Radius
- `radius-md`: 10px
- `radius-lg`: 14px

## Content Strings

### Polish UI Text
- **Hero Title:** "Witaj, {firstName}! 👋"
- **Hero Subtitle:** "Gotowa na nową sesję nauki?"
- **Start Button:** "Rozpocznij sesję 15-minutową"
- **Stats Labels:**
  - Mastered: "Opanowane słówka"
  - Average: "Średni wynik (7 dni)"
  - Next Due: "Następna powtórka"
- **Session List Title:** "Ostatnie sesje"
- **Repeat Button:** "Powtórz błędy"
- **View All:** "Zobacz wszystkie sesje"
- **Empty State:** "Nie masz jeszcze żadnych sesji"
- **Empty Subtitle:** "Rozpocznij pierwszą sesję, aby zobaczyć swoje postępy!"
- **No Due Cards:** "Brak słówek do powtórki"
- **Error Message:** "Nie udało się załadować danych"
- **Loading:** "Ładowanie..."

### Time Formatting
- Today: "Dzisiaj, {HH:MM}"
- Yesterday: "Wczoraj, {HH:MM}"
- Other: "{DD.MM}, {HH:MM}"
- Next due: "Za {X}h", "Za {X} min", "Teraz"

## Testing Checklist

- [ ] Hero section displays with correct user name
- [ ] Start session button navigates to new session
- [ ] Stats cards display correct values from API
- [ ] Recent sessions list shows last sessions
- [ ] "Repeat mistakes" button only shows for sessions with mistakes
- [ ] "Repeat mistakes" creates new session with mistake cards
- [ ] View all button navigates to session history
- [ ] Empty state displays when no sessions exist
- [ ] No due cards state displays when no cards are due
- [ ] Loading state shows skeleton loaders
- [ ] Error state displays toast notification
- [ ] Auto-refresh works every 5 minutes
- [ ] Session item click navigates to session detail
- [ ] Keyboard navigation works (Tab, Enter, Space)
- [ ] Screen reader announces dashboard content
- [ ] Focus order is logical
- [ ] Mobile responsive layout works
- [ ] Tablet layout adapts correctly
- [ ] Stats cards stack vertically on mobile
- [ ] All text is in Polish
- [ ] WCAG AA contrast ratios met
- [ ] Touch targets are ≥44x44px on mobile

