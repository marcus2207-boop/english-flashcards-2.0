# Settings Screen Specification

**Route:** `/settings`  
**Related Stories:** ST-005b, ST-012  
**User Personas:** P-001 (Student), P-002 (Admin)

## Overview

The Settings screen allows users to configure their preferences including Text-to-Speech (TTS) settings, audio playback options, notification preferences, and data privacy controls. Admin users have additional system configuration options.

## Layout

### Container
- **Type:** Two-column layout with sidebar (desktop), accordion (mobile)
- **Max Width:** 1200px
- **Background:** `color-background` (#F8FAFC)
- **Padding:** `spacing-xl` (32px)

### Sidebar (Left)
- **Width:** 240px (desktop)
- **Background:** `color-surface` (#FFFFFF)
- **Border Radius:** `radius-lg` (14px)
- **Shadow:** `shadow-sm`
- **Contains:** Category navigation

### Content Area (Right)
- **Flex:** 1
- **Margin Left:** `spacing-lg` (24px) on desktop
- **Contains:** Settings panels based on selection

## Visual Hierarchy

```
┌────────────────────────────────────────────────────────────┐
│  Settings                                                   │
└────────────────────────────────────────────────────────────┘

┌──────────────┐  ┌───────────────────────────────────────┐
│              │  │  TTS & Audio Settings                  │
│  🔊 Audio    │  ├───────────────────────────────────────┤
│  🔔 Notif.   │  │                                        │
│  🔒 Privacy  │  │  Text-to-Speech                       │
│  ⚙️ System   │  │  □ Auto-play audio during sessions    │
│  (Admin)     │  │  □ Enable phonetic fallback           │
│              │  │                                        │
│              │  │  Voice Settings                       │
│              │  │  Voice: [US English (Female) ▼]      │
│              │  │  Speed: [──●────] 1.0x               │
│              │  │  Volume: [────●──] 80%               │
│              │  │                                        │
│              │  │  Test TTS                             │
│              │  │  Text: [Enter English word...]        │
│              │  │  [Generate & Play] 🔊                 │
│              │  │                                        │
│              │  │  ⏳ Generating audio... 2s left       │
│              │  │  or                                   │
│              │  │  ✓ Audio ready! [▶ Play]              │
│              │  │  Phonetic: /haʊs/                     │
│              │  │                                        │
│              │  │  Cache Settings                       │
│              │  │  □ Enable audio cache                 │
│              │  │  Cache size: 45 MB / 100 MB           │
│              │  │  [Clear Cache]                        │
│              │  │                                        │
│              │  │  [Save Changes]                       │
│              │  │                                        │
└──────────────┘  └───────────────────────────────────────┘
```

## Components Used

### From Component Library
- **Button** - Primary for save, Secondary for test actions
- **Toggle/Checkbox** - For boolean settings
- **Dropdown** - For voice selection
- **Slider** - For speed and volume
- **Input** - For test text
- **Audio Control** - For playing test audio
- **Progress Bar** - For TTS generation

### New/Screen-Specific Components
- **Settings Panel** - Container for setting groups
- **Setting Row** - Label, control, description layout

## Element Specifications

### Sidebar Navigation
- **Background:** `color-surface` (#FFFFFF)
- **Padding:** `spacing-md` (16px)
- **Items:** Icon + Label

#### Nav Item
- **Padding:** `spacing-sm` (8px)
- **Border Radius:** `radius-sm` (6px)
- **Hover:** Background `color-neutral-50`
- **Active:** Background `color-primary-50`, Text `color-primary`

### Settings Panel
- **Background:** `color-surface` (#FFFFFF)
- **Border Radius:** `radius-lg` (14px)
- **Shadow:** `shadow-md`
- **Padding:** `spacing-xl` (32px)

### Setting Row
- **Display:** Flex (space-between, align-center)
- **Padding:** `spacing-md` (16px) vertical
- **Border Bottom:** 1px solid `color-neutral-200` (except last)

#### Setting Label
- **Font Size:** `font-size-body` (16px)
- **Font Weight:** `font-weight-semibold` (600)
- **Color:** `color-neutral-900` (#18181B)

#### Setting Description
- **Font Size:** `font-size-small` (14px)
- **Color:** `color-neutral-700` (#3F3F46)
- **Margin Top:** `spacing-xs` (4px)

### TTS Test Section
- **Background:** `color-neutral-50` (#FAFAFA)
- **Border:** 1px solid `color-neutral-200` (#E4E4E7)
- **Border Radius:** `radius-md` (10px)
- **Padding:** `spacing-lg` (24px)
- **Margin:** `spacing-lg` (24px) vertical

#### Test Input
- **Placeholder:** "Enter English word..."
- **Width:** 100%
- **Margin Bottom:** `spacing-md` (16px)

#### Generate Button
- **Text:** "Generate & Play"
- **Variant:** Primary
- **Size:** Medium
- **Icon:** 🔊
- **Full Width:** true (mobile)

#### Status Display
- **Generating:** Progress bar with text "Generating audio... Xs left"
- **Ready:** Success message "✓ Audio ready!" with Play button
- **Error:** Error message with Retry button
- **Phonetic:** Display below status if available

### Voice Dropdown
- **Options:** US English (Female), US English (Male), UK English (Female), UK English (Male)
- **Width:** 100%
- **Height:** 44px

### Speed Slider
- **Range:** 0.5x to 2.0x
- **Step:** 0.1
- **Default:** 1.0x
- **Display:** Current value next to slider

### Volume Slider
- **Range:** 0% to 100%
- **Step:** 5
- **Default:** 80%
- **Display:** Percentage next to slider

### Cache Display
- **Format:** "{X} MB / {Y} MB"
- **Progress Bar:** Visual representation
- **Clear Button:** "Clear Cache" (Secondary, Small)

### Save Button
- **Text:** "Zapisz zmiany"
- **Variant:** Primary
- **Size:** Large
- **Position:** Bottom right of panel
- **Full Width:** true (mobile)

## States

### Default State
- All settings loaded with user preferences
- TTS test section ready
- Save button enabled

### Loading State
- Skeleton loaders for settings
- Disable all controls

### TTS Test States
- **Idle:** Input ready, generate button enabled
- **Generating:** Progress bar, estimated time, disable input
- **Ready:** Play button, phonetic display, audio playable
- **Error:** Error message, retry button, fallback phonetic
- **Playing:** Play button shows pause icon

### Saving State
- Disable all inputs
- Show saving spinner on button
- "Saving..." text

### Saved State
- Success toast: "Ustawienia zapisane"
- Re-enable inputs
- Reset save button

### Cache Cleared State
- Success toast: "Cache wyczyszczony"
- Update cache size display to "0 MB"

## Interactions

### Sidebar Navigation
- **Click Item:** Navigate to settings panel
- **Keyboard:** Arrow keys to navigate, Enter to select
- **Active:** Highlight current panel

### Toggle/Checkbox
- **Click:** Toggle on/off
- **Keyboard:** Space to toggle
- **Label Click:** Toggle control

### Voice Dropdown
- **Click:** Open dropdown
- **Select:** Change voice, close dropdown
- **Keyboard:** Arrow keys to navigate, Enter to select

### Speed Slider
- **Drag:** Change speed value
- **Click Track:** Jump to value
- **Keyboard:** Arrow keys to adjust
- **Display:** Update value text in real-time

### Volume Slider
- **Same as Speed Slider**
- **Test:** Play sample sound at selected volume

### TTS Test
- **Input Text:** Enable generate button when text present
- **Generate Click:** 
  - Check cache for audio
  - If not cached: POST to TTS API, poll for status
  - If cached: Load from cache
  - Show progress or ready state
- **Play Click:** Play audio with Audio Control component
- **Retry Click:** Retry generation if failed

### Clear Cache Button
- **Click:** Show confirmation modal
- **Confirm:** DELETE request to API, show success toast
- **Cancel:** Close modal

### Save Button
- **Click:** 
  - Validate settings
  - PUT to API with all settings
  - Show success toast
  - Reset dirty state
- **Disabled:** If no changes made

## Accessibility

### Semantic HTML
- `<main>` for settings content
- `<nav>` for sidebar
- `<section>` for each settings panel
- `<label>` for all controls
- `<fieldset>` for grouped settings

### ARIA Attributes
- Sidebar: `role="navigation" aria-label="Settings categories"`
- Active nav item: `aria-current="page"`
- Toggles: `role="switch" aria-checked="true|false"`
- Sliders: `role="slider" aria-valuenow aria-valuemin aria-valuemax aria-label`
- TTS progress: `role="progressbar" aria-valuenow aria-label="Generating audio"`
- Audio player: Proper controls with labels

### Keyboard Navigation
- Tab: Through all controls
- Arrow keys: Navigate sidebar, adjust sliders
- Space: Toggle checkboxes/switches
- Enter: Submit forms, activate buttons
- Escape: Close dropdowns

### Screen Reader Announcements
- Setting changed: "Setting {name} changed to {value}"
- TTS generating: "Generating audio for {word}"
- TTS ready: "Audio ready for {word}, phonetic {phonetic}"
- TTS playing: "Playing audio"
- Save success: "Ustawienia zapisane pomyślnie"
- Cache cleared: "Cache wyczyszczony, zwolniono {X} MB"

### Focus Management
- On panel switch: Focus on panel heading
- After save: Focus on success toast
- Modal open: Focus on first control
- Modal close: Return to trigger button

## Responsive Behavior

### Desktop (>1024px)
- Two-column layout with sidebar
- Full-width sliders
- Side-by-side controls

### Tablet (768px - 1024px)
- Sidebar collapsible or as tabs
- Reduced spacing
- Stack some controls

### Mobile (<768px)
- Accordion navigation (no sidebar)
- Stack all controls vertically
- Full-width buttons
- Touch-friendly sliders
- Larger touch targets (44x44px)

## Backend Integration

### API Endpoints

#### GET /api/users/:id/settings
**Description:** Get user settings

**Response (200 OK):**
```json
{
  "audio": {
    "autoPlay": true,
    "phoneticFallback": true,
    "voice": "en-US-female",
    "speed": 1.0,
    "volume": 80,
    "cacheEnabled": true
  },
  "notifications": {
    "sessionReminders": true,
    "achievementAlerts": true
  },
  "privacy": {
    "showProgress": true,
    "allowAnalytics": false
  }
}
```

#### PUT /api/users/:id/settings
**Description:** Update user settings

**Request Body:** Same as GET response

**Response (200 OK):** Updated settings

#### POST /api/tts/test
**Description:** Test TTS generation

**Request Body:**
```json
{
  "text": "house",
  "voice": "en-US-female",
  "speed": 1.0
}
```

**Response (200 OK):**
```json
{
  "taskId": "task-uuid",
  "status": "generating",
  "estimatedTime": 2
}
```

#### GET /api/tts/test/:taskId
**Description:** Check TTS test progress

**Response (200 OK - Ready):**
```json
{
  "status": "ready",
  "audioUrl": "/api/tts/audio/task-uuid",
  "phonetic": "/haʊs/"
}
```

#### GET /api/tts/cache/stats
**Description:** Get cache statistics

**Response (200 OK):**
```json
{
  "usedBytes": 47185920,
  "maxBytes": 104857600,
  "itemCount": 234
}
```

#### DELETE /api/tts/cache
**Description:** Clear TTS cache

**Response (204 No Content)**

### Settings Synchronization
- Auto-save on change (debounced 1 second)
- Sync across devices via cloud
- Local storage backup

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
- `spacing-xs`: 4px
- `spacing-sm`: 8px
- `spacing-md`: 16px
- `spacing-lg`: 24px
- `spacing-xl`: 32px

### Typography
- `font-size-body`: 16px
- `font-size-small`: 14px
- `font-weight-semibold`: 600

### Shadows
- `shadow-sm`: 0 1px 2px rgba(0,0,0,0.05)
- `shadow-md`: 0 4px 6px rgba(0,0,0,0.1)

### Border Radius
- `radius-sm`: 6px
- `radius-md`: 10px
- `radius-lg`: 14px

## Content Strings

### Polish UI Text
- **Page Title:** "Ustawienia"
- **Categories:**
  - "Audio & TTS"
  - "Powiadomienia"
  - "Prywatność"
  - "System" (Admin only)
- **Audio Settings:**
  - "Text-to-Speech"
  - "Auto-play audio during sessions" / "Automatyczne odtwarzanie audio"
  - "Enable phonetic fallback" / "Włącz podpowiedź fonetyczną"
  - "Voice Settings" / "Ustawienia głosu"
  - "Voice" / "Głos"
  - "Speed" / "Prędkość"
  - "Volume" / "Głośność"
  - "Test TTS" / "Testuj TTS"
  - "Cache Settings" / "Ustawienia cache"
  - "Enable audio cache" / "Włącz cache audio"
  - "Cache size" / "Rozmiar cache"
  - "Clear Cache" / "Wyczyść cache"
- **Voice Options:**
  - "US English (Female)" / "Angielski US (Kobieta)"
  - "US English (Male)" / "Angielski US (Mężczyzna)"
  - "UK English (Female)" / "Angielski UK (Kobieta)"
  - "UK English (Male)" / "Angielski UK (Mężczyzna)"
- **TTS Test:**
  - "Enter English word..." / "Wpisz angielskie słowo..."
  - "Generate & Play" / "Generuj i odtwórz"
  - "Generating audio... Xs left" / "Generowanie audio... Pozostało Xs"
  - "Audio ready!" / "Audio gotowe!"
  - "Play" / "Odtwórz"
  - "Phonetic" / "Fonetyka"
- **Actions:**
  - "Save Changes" / "Zapisz zmiany"
  - "Cancel" / "Anuluj"
  - "Retry" / "Powtórz"
- **Messages:**
  - "Settings saved" / "Ustawienia zapisane"
  - "Cache cleared" / "Cache wyczyszczony"
  - "TTS generation failed" / "Generowanie TTS nie powiodło się"
  - "Clear cache confirmation" / "Czy na pewno chcesz wyczyścić cache?"

## Testing Checklist

- [ ] Settings load with user preferences
- [ ] Sidebar navigation works
- [ ] Auto-play toggle works
- [ ] Phonetic fallback toggle works
- [ ] Voice dropdown changes voice
- [ ] Speed slider adjusts speed
- [ ] Volume slider adjusts volume
- [ ] TTS test input accepts text
- [ ] Generate button triggers TTS
- [ ] TTS shows progress bar
- [ ] TTS displays phonetic
- [ ] Play button plays audio
- [ ] Retry works on error
- [ ] Cache stats display correctly
- [ ] Clear cache works with confirmation
- [ ] Save button saves all settings
- [ ] Success toast displays
- [ ] Auto-save works (debounced)
- [ ] Keyboard navigation works
- [ ] Screen reader announces changes
- [ ] Mobile accordion works
- [ ] Touch-friendly sliders
- [ ] All text in Polish
- [ ] WCAG AA contrast met
