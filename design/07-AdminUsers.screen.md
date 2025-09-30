# Admin Users Screen Specification

**Route:** `/admin/users`  
**Related Stories:** ST-002  
**User Personas:** P-002 (Admin/Teacher - Maria, 35 years old)

## Overview

The Admin Users screen allows administrators to create, view, edit, and delete user accounts. It displays a list of all users with their roles, status, and basic statistics. Includes audit logging for all user management actions.

## Layout

### Container
- **Type:** Single column with header and table
- **Max Width:** 1400px
- **Background:** `color-background` (#F8FAFC)
- **Padding:** `spacing-xl` (32px)

### Header Section
- **Display:** Flex (space-between)
- **Contains:** Title, search field, create button
- **Background:** `color-surface` (#FFFFFF)
- **Border Radius:** `radius-lg` (14px)
- **Padding:** `spacing-lg` (24px)
- **Margin Bottom:** `spacing-lg` (24px)

### Table Section
- **Background:** `color-surface` (#FFFFFF)
- **Border Radius:** `radius-lg` (14px)
- **Shadow:** `shadow-md`
- **Overflow:** Auto (horizontal scroll on mobile)

## Visual Hierarchy

```
┌────────────────────────────────────────────────────────────┐
│  User Management    [Search users...]     [+ Create User]  │
└────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────┐
│ ID  │ Name            │ Email           │ Role    │ Status │
│─────┼─────────────────┼─────────────────┼─────────┼────────│
│ 001 │ Laura Kowalska  │ laura@mail.com  │ Student │ Active │
│     │                 │ Joined: 10.01   │ 45 cards│ [Edit] │
│─────┼─────────────────┼─────────────────┼─────────┼────────│
│ 002 │ Maria Nowak     │ maria@mail.com  │ Admin   │ Active │
│     │                 │ Joined: 05.01   │ 234 cards│[Edit]│
│─────┼─────────────────┼─────────────────┼─────────┼────────│
│ 003 │ Jan Kowalski    │ jan@mail.com    │ Student │Inactive│
│     │                 │ Joined: 08.01   │ 12 cards│ [Edit] │
│─────┴─────────────────┴─────────────────┴─────────┴────────│
│                                                             │
│  Showing 1-10 of 45 users          [Prev] [1][2][3] [Next] │
└────────────────────────────────────────────────────────────┘
```

## Components Used

### From Component Library
- **Button** - Primary for create, Secondary for edit/delete
- **Table** - User list with pagination
- **Badge** - Role and status indicators
- **Input** - Search field and form inputs
- **Modal** - Create/Edit user form

### New/Screen-Specific Components
- **User Table Row** - Extended with stats and actions
- **User Form Modal** - Create/edit user with validation

## Element Specifications

### Search Field
- **Placeholder:** "Szukaj użytkowników..."
- **Type:** text
- **Width:** 400px (desktop), 100% (mobile)
- **Icon:** 🔍 (left)
- **Debounce:** 300ms
- **Clear Button:** X (right, appears when text present)

### Create User Button
- **Text:** "+ Utwórz użytkownika"
- **Variant:** Primary
- **Size:** Medium
- **Icon:** 👤

### User Table
- **Columns:** ID, Name, Email, Role, Status, Actions
- **Row Height:** 72px (two-line layout)
- **Pagination:** 10, 25, 50 per page
- **Sort:** Click column header to sort

#### Name Cell
- **Line 1:** Full name (bold)
- **Line 2:** Join date "Joined: DD.MM"
- **Font Size:** `font-size-body` / `font-size-small`

#### Email Cell
- **Format:** Email address
- **Truncate:** If too long, show ellipsis with tooltip

#### Role Cell
- **Badge:** Student, Admin, Teacher
- **Color:** Primary (Student), Success (Admin), Warning (Teacher)
- **Size:** Small

#### Status Cell
- **Badge:** Active, Inactive, Suspended
- **Color:** Success (Active), Neutral (Inactive), Error (Suspended)
- **Size:** Small

#### Stats Line
- **Format:** "{X} cards mastered"
- **Font Size:** `font-size-small` (14px)
- **Color:** `color-neutral-700` (#3F3F46)

#### Actions Cell
- **Edit Button:** "Edytuj" (Secondary, Small)
- **Delete Button:** 🗑️ icon (Ghost, Small, Red on hover)
- **Display:** Flex with gap

### User Form Modal
- **Size:** Medium (600px)
- **Title:** "Nowy użytkownik" or "Edytuj użytkownika: {name}"
- **Fields:**
  - First Name (text, required)
  - Last Name (text, required)
  - Email (email, required, unique validation)
  - Password (password, required for new, optional for edit, min 10 chars)
  - Confirm Password (password, must match)
  - Role (dropdown: Student, Admin, Teacher)
  - Status (toggle: Active/Inactive)
- **Actions:** Cancel, Save

#### Field Validation
- **Real-time:** Show error on blur
- **Email:** Format validation, uniqueness check
- **Password:** Strength indicator, match validation
- **Submit:** Validate all fields before save

## States

### Default State
- Table loaded with users (first page)
- Search field empty
- Create button enabled
- Sort by name (ascending)

### Loading State
- Skeleton loaders for table rows
- Disable create button
- Disable search field

### Search Results State
- Table filtered by search term
- Show result count: "{X} users found"
- Clear search button visible

### Empty State (No Users)
- Icon: 👤
- Message: "Brak użytkowników w systemie"
- Create button prominent

### Search No Results
- Icon: 🔍
- Message: "Nie znaleziono użytkowników"
- Clear search button

### Creating User State (Modal Open)
- Empty form
- Password fields required
- Focus on first name field

### Editing User State (Modal Open)
- Form pre-filled with user data
- Password fields optional
- Focus on first name field

### Saving State
- Disable all form fields
- Show saving spinner on button
- "Saving..." text

### Delete Confirmation
- Modal: "Czy na pewno chcesz usunąć użytkownika {name}?"
- Warning: "Ta operacja jest nieodwracalna"
- Actions: Cancel, Delete (red)

## Interactions

### Search Field
- **Input:** Filter users by name or email (debounced)
- **Clear:** X button clears search, reloads full list
- **Keyboard:** Enter to search immediately

### Create Button
- **Click:** Open user form modal in create mode
- **Keyboard:** Enter or Space

### Table Sorting
- **Click Column Header:** Toggle sort direction (asc/desc)
- **Visual:** Arrow indicator in header

### Edit Button
- **Click:** Open user form modal with user data
- **Keyboard:** Enter or Space

### Delete Button
- **Click:** Show delete confirmation modal
- **Confirm:** DELETE request to API, remove from table
- **Cancel:** Close modal

### User Form Modal
- **Field Input:** Real-time validation on blur
- **Password Input:** Show/hide toggle, strength indicator
- **Role Dropdown:** Select user role
- **Status Toggle:** Click to toggle active/inactive
- **Save:** Validate, POST/PUT to API, close modal, refresh table
- **Cancel:** Close modal, discard changes (confirm if dirty)
- **Escape:** Close modal

### Pagination
- **Page Number Click:** Navigate to page
- **Prev/Next:** Navigate pages
- **Per Page Dropdown:** Change page size

## Accessibility

### Semantic HTML
- `<main>` for content
- `<table>` with proper `<thead>`, `<tbody>`
- `<th scope="col">` for headers
- `<form>` for user form
- Proper labels for all inputs

### ARIA Attributes
- Search field: `role="searchbox" aria-label="Szukaj użytkowników"`
- Table: `role="table" aria-label="Lista użytkowników"`
- Sort headers: `aria-sort="ascending|descending|none"`
- Status badges: `aria-label="Status: {status}"`
- Modal: `role="dialog" aria-modal="true" aria-labelledby="modal-title"`
- Form fields: `aria-required` for required fields
- Password strength: `aria-live="polite" aria-label="Password strength: {level}"`
- Delete confirmation: `role="alertdialog"`

### Keyboard Navigation
- Tab: Through all interactive elements
- Enter/Space: Activate buttons
- Arrow keys: Navigate table cells (optional)
- Escape: Close modal
- Alt+C: Create user
- Alt+S: Focus search
- Ctrl+Enter: Submit form (in modal)

### Screen Reader Announcements
- Search results: "{X} użytkowników znaleziono"
- User created: "Użytkownik {name} został utworzony"
- User updated: "Użytkownik {name} został zaktualizowany"
- User deleted: "Użytkownik {name} został usunięty"
- Validation errors: "Błąd w polu {field}: {message}"

## Responsive Behavior

### Desktop (>1024px)
- Full table with all columns
- Inline actions in table
- Modal centered on screen

### Tablet (768px - 1024px)
- Table scrollable horizontally
- Reduced column widths
- Smaller modal

### Mobile (<768px)
- Card layout instead of table
- One user per card
- Actions as dropdown menu
- Modal full screen
- Search full width
- Create button as FAB

## Backend Integration

### API Endpoints

#### GET /api/admin/users
**Description:** List all users

**Query Parameters:**
- `search`: string (optional)
- `role`: "student" | "admin" | "teacher" (optional)
- `status`: "active" | "inactive" | "suspended" (optional)
- `page`: number (default 1)
- `perPage`: number (default 10)
- `sort`: "name" | "email" | "created" (default "name")
- `order`: "asc" | "desc" (default "asc")

**Response (200 OK):**
```json
{
  "users": [
    {
      "id": "user-uuid",
      "firstName": "Laura",
      "lastName": "Kowalska",
      "email": "laura@mail.com",
      "role": "student",
      "status": "active",
      "masteredCards": 45,
      "createdAt": "2024-01-10T10:00:00Z",
      "lastLogin": "2024-01-15T14:30:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "perPage": 10,
    "total": 45,
    "totalPages": 5
  }
}
```

#### POST /api/admin/users
**Description:** Create new user

**Request Body:**
```json
{
  "firstName": "Jan",
  "lastName": "Kowalski",
  "email": "jan@mail.com",
  "password": "securepass123",
  "role": "student",
  "status": "active"
}
```

**Response (201 Created):**
```json
{
  "id": "user-uuid",
  "firstName": "Jan",
  "lastName": "Kowalski",
  "email": "jan@mail.com",
  "role": "student",
  "status": "active",
  "createdAt": "2024-01-15T15:00:00Z"
}
```

**Error Response (400):**
```json
{
  "error": "Validation failed",
  "details": {
    "email": "Email already exists"
  }
}
```

#### PUT /api/admin/users/:id
**Description:** Update user

**Request Body:** (same as POST, password optional)

**Response (200 OK):** Updated user object

#### DELETE /api/admin/users/:id
**Description:** Delete user

**Response (204 No Content)**

#### GET /api/admin/users/:id/audit-log
**Description:** Get audit log for user

**Response (200 OK):**
```json
{
  "logs": [
    {
      "id": "log-uuid",
      "action": "user.created",
      "performedBy": "admin-uuid",
      "performedAt": "2024-01-10T10:00:00Z",
      "details": {...}
    }
  ]
}
```

### Audit Logging
- All user management actions logged
- Log includes: action, performer, timestamp, changed fields
- Accessible from user detail view

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

### Spacing
- `spacing-md`: 16px
- `spacing-lg`: 24px
- `spacing-xl`: 32px

### Typography
- `font-size-body`: 16px
- `font-size-small`: 14px
- `font-weight-semibold`: 600

### Shadows
- `shadow-md`: 0 4px 6px rgba(0,0,0,0.1)

### Border Radius
- `radius-lg`: 14px

## Content Strings

### Polish UI Text
- **Page Title:** "Zarządzanie użytkownikami"
- **Create Button:** "+ Utwórz użytkownika"
- **Search Placeholder:** "Szukaj użytkowników..."
- **Table Headers:**
  - "ID"
  - "Nazwa"
  - "Email"
  - "Rola"
  - "Status"
  - "Akcje"
- **Roles:**
  - "Student"
  - "Admin"
  - "Teacher" / "Nauczyciel"
- **Statuses:**
  - "Active" / "Aktywny"
  - "Inactive" / "Nieaktywny"
  - "Suspended" / "Zawieszony"
- **Actions:**
  - "Edit" / "Edytuj"
  - "Delete" / "Usuń"
  - "Save" / "Zapisz"
  - "Cancel" / "Anuluj"
- **Form Labels:**
  - "First Name" / "Imię"
  - "Last Name" / "Nazwisko"
  - "Email"
  - "Password" / "Hasło"
  - "Confirm Password" / "Potwierdź hasło"
  - "Role" / "Rola"
  - "Status"
- **Modal Titles:**
  - "New User" / "Nowy użytkownik"
  - "Edit User" / "Edytuj użytkownika"
- **Delete Confirmation:** "Czy na pewno chcesz usunąć użytkownika {name}?"
- **Empty State:** "Brak użytkowników w systemie"
- **No Results:** "Nie znaleziono użytkowników"
- **Stats:** "{X} cards mastered" / "{X} kart opanowanych"
- **Joined:** "Joined: {date}" / "Dołączył: {date}"

## Testing Checklist

- [ ] Table loads with users
- [ ] Search filters by name and email
- [ ] Create button opens modal
- [ ] User form validates all fields
- [ ] Email uniqueness validated
- [ ] Password strength indicator works
- [ ] Password match validation works
- [ ] Create saves new user
- [ ] Edit loads user data
- [ ] Edit saves changes
- [ ] Delete shows confirmation
- [ ] Delete removes user
- [ ] Pagination works
- [ ] Sort by column works
- [ ] Per page dropdown works
- [ ] Loading state shows skeletons
- [ ] Empty state displays correctly
- [ ] No results state displays
- [ ] Keyboard navigation works
- [ ] Screen reader announces changes
- [ ] Mobile responsive works (cards)
- [ ] Touch targets ≥44x44px
- [ ] All text in Polish
- [ ] WCAG AA contrast met
- [ ] Audit log accessible
