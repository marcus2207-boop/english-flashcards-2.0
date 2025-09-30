# Login Screen Specification

**Route:** `/login`  
**Related Stories:** ST-001  
**User Personas:** P-001 (Student), P-002 (Admin)

## Overview

The login screen provides authentication for both students and administrators. It features a centered card layout with email/password fields and clear error states.

## Layout

### Container
- **Type:** Centered single-column layout
- **Max Width:** 420px
- **Background:** `color-background` (#F8FAFC)
- **Vertical Alignment:** Center of viewport

### Card
- **Background:** `color-surface` (#FFFFFF)
- **Border Radius:** `radius-lg` (14px)
- **Shadow:** `shadow-md`
- **Padding:** `spacing-xl` (32px)

## Visual Hierarchy

```
┌─────────────────────────────────────┐
│                                     │
│            [Logo SVG]               │
│                                     │
│        Zaloguj się                  │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ Email                         │ │
│  │ [email input field]           │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ Hasło                         │ │
│  │ [password input field] [eye]  │ │
│  └───────────────────────────────┘ │
│                                     │
│  □ Zapamiętaj mnie                 │
│                                     │
│  ┌───────────────────────────────┐ │
│  │       Zaloguj się             │ │ ← Primary Button
│  └───────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

## Components Used

1. **Logo** - SVG, centered, 80px height
2. **Heading** - H1 "Zaloguj się" (28px, semibold)
3. **Input Fields** (2)
   - Email input with label
   - Password input with label and show/hide toggle
4. **Checkbox** - "Zapamiętaj mnie" (optional)
5. **Button** - Primary, full-width, large size
6. **Toast** - For error messages

## Element Specifications

### Logo
- **Size:** 80px × 80px
- **Margin Bottom:** `spacing-lg` (24px)
- **Alt Text:** "English Flashcards Logo"

### Heading
- **Text:** "Zaloguj się"
- **Font Size:** `fontSize-h1` (28px)
- **Font Weight:** `fontWeight-semibold` (600)
- **Color:** `color-neutral-900` (#0F172A)
- **Margin Bottom:** `spacing-xl` (32px)
- **Text Align:** Center

### Email Input Field
- **Label:** "Email"
- **Type:** email
- **Placeholder:** "twoj@email.pl"
- **Height:** 40px
- **Border:** 1px solid `color-neutral-400`
- **Border Radius:** `radius-sm` (6px)
- **Padding:** `spacing-sm` `spacing-md`
- **Font Size:** `fontSize-base` (16px)

### Password Input Field
- **Label:** "Hasło"
- **Type:** password (toggleable to text)
- **Placeholder:** "••••••••••"
- **Height:** 40px
- **Show/Hide Toggle:** Eye icon button, 24px, positioned right
- **Border:** 1px solid `color-neutral-400`
- **Border Radius:** `radius-sm` (6px)
- **Padding:** `spacing-sm` `spacing-md` `spacing-sm` `spacing-xl` (extra padding for icon)

### Remember Me Checkbox
- **Label:** "Zapamiętaj mnie"
- **Size:** 20px × 20px
- **Margin Top:** `spacing-md` (16px)
- **Margin Bottom:** `spacing-lg` (24px)

### Login Button
- **Text:** "Zaloguj się"
- **Variant:** Primary
- **Size:** Large
- **Full Width:** true
- **Type:** submit
- **Margin Top:** `spacing-lg` (24px)

## States

### Default State
- All fields empty
- Button enabled
- No error messages

### Validation States

#### Invalid Email
- **Trigger:** Email format invalid or empty on submit
- **Visual:** Red border on email field
- **Error Text:** "Nieprawidłowy email" (below field, red, 13px)
- **ARIA:** `aria-invalid="true"`, `aria-describedby="email-error"`

#### Invalid Password
- **Trigger:** Password less than 10 characters
- **Visual:** Red border on password field
- **Error Text:** "Hasło musi mieć minimum 10 znaków" (below field, red, 13px)
- **ARIA:** `aria-invalid="true"`, `aria-describedby="password-error"`

#### Loading State
- **Trigger:** Form submitted, waiting for server response
- **Visual:** Button shows spinner, text changes to "Logowanie..."
- **Behavior:** Button disabled, form fields disabled
- **ARIA:** `aria-busy="true"` on button

#### Authentication Error
- **Trigger:** Invalid credentials from server (401)
- **Visual:** Toast notification top-right
- **Message:** "Nieprawidłowy email lub hasło"
- **Toast Variant:** Error (red)
- **Duration:** 6 seconds

#### Network Error
- **Trigger:** Network failure or server error (500)
- **Visual:** Toast notification top-right
- **Message:** "Błąd połączenia. Spróbuj ponownie."
- **Toast Variant:** Error (red)
- **Duration:** 6 seconds
- **Action Button:** "Ponów" (retry)

## Interactions

### Show/Hide Password Toggle
- **Default:** Password masked (•••)
- **Click:** Toggles between text and password type
- **Icon:** Eye icon (hidden) / Eye-slash icon (visible)
- **ARIA:** `aria-label="Show password"` / `aria-label="Hide password"`

### Form Submission
1. User fills in email and password
2. User clicks "Zaloguj się" or presses Enter
3. Client-side validation runs
4. If valid, POST to `/api/auth/login`
5. On success, redirect to appropriate dashboard
6. On failure, show error toast

### Remember Me
- **Checked:** Session cookie persists for 30 days
- **Unchecked:** Session cookie expires on browser close

## Accessibility

### Keyboard Navigation
- **Tab Order:** Email → Password → Show/Hide → Remember Me → Login Button
- **Enter Key:** Submits form from any field
- **Escape Key:** Clears current field (optional)

### Screen Reader
- **Form Label:** "Login form"
- **Required Fields:** Announced as "required"
- **Error Announcements:** Via `aria-live="assertive"` region
- **Button State:** Loading state announced

### Focus Management
- **Initial Focus:** Email field on page load
- **Error Focus:** First field with error after validation
- **Success Focus:** Dashboard after successful login

### ARIA Attributes
```html
<form role="form" aria-label="Login form">
  <label for="email">Email</label>
  <input 
    id="email" 
    type="email" 
    required
    aria-required="true"
    aria-invalid="false"
    aria-describedby="email-error" />
  <span id="email-error" role="alert"></span>
  
  <label for="password">Hasło</label>
  <input 
    id="password" 
    type="password" 
    required
    aria-required="true"
    aria-invalid="false"
    aria-describedby="password-error password-hint" />
  <span id="password-hint">Minimum 10 znaków</span>
  <span id="password-error" role="alert"></span>
  
  <button type="submit" aria-busy="false">
    Zaloguj się
  </button>
</form>
```

## Responsive Behavior

### Desktop (>1024px)
- Card centered in viewport
- Max width 420px
- Full specifications as above

### Tablet (768px - 1024px)
- Card max width 480px
- Slightly larger touch targets
- Same layout structure

### Mobile (<768px)
- Card expands to 90% viewport width
- Padding reduced to `spacing-lg`
- Logo size reduced to 64px
- Button height 48px for better touch target

## Backend Integration

### Endpoint
```
POST /api/auth/login
```

### Request Body
```json
{
  "email": "user@example.com",
  "password": "userpassword123",
  "rememberMe": false
}
```

### Success Response (200)
```json
{
  "success": true,
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "role": "student|admin",
    "name": "Laura"
  },
  "redirectTo": "/dashboard"
}
```

### Error Responses
- **401 Unauthorized:** Invalid credentials
- **422 Unprocessable:** Validation errors
- **500 Server Error:** Internal error

### Security
- Password sent over HTTPS only
- Session cookie HttpOnly, Secure, SameSite=Strict
- Argon2id for password hashing on backend
- Rate limiting: 5 attempts per IP per 15 minutes

## Design Tokens Used

### Colors
- `color-primary` (#4F46E5)
- `color-surface` (#FFFFFF)
- `color-background` (#F8FAFC)
- `color-neutral-900` (#0F172A)
- `color-neutral-700` (#374151)
- `color-neutral-400` (#9CA3AF)
- `color-error` (#DC2626)
- `color-focus` (#A78BFA)

### Spacing
- `spacing-sm` (12px)
- `spacing-md` (16px)
- `spacing-lg` (24px)
- `spacing-xl` (32px)

### Typography
- `fontSize-h1` (28px)
- `fontSize-base` (16px)
- `fontSize-caption` (13px)
- `fontWeight-semibold` (600)

### Border Radius
- `radius-sm` (6px)
- `radius-lg` (14px)

### Shadow
- `shadow-md`

## Content Strings

```json
{
  "heading": "Zaloguj się",
  "emailLabel": "Email",
  "emailPlaceholder": "twoj@email.pl",
  "passwordLabel": "Hasło",
  "passwordPlaceholder": "••••••••••",
  "rememberMeLabel": "Zapamiętaj mnie",
  "submitButton": "Zaloguj się",
  "loadingButton": "Logowanie...",
  "showPasswordAria": "Pokaż hasło",
  "hidePasswordAria": "Ukryj hasło",
  "errors": {
    "invalidEmail": "Nieprawidłowy email",
    "invalidPassword": "Hasło musi mieć minimum 10 znaków",
    "authenticationFailed": "Nieprawidłowy email lub hasło",
    "networkError": "Błąd połączenia. Spróbuj ponownie."
  }
}
```

## Testing Checklist

- [ ] Email validation works (format check)
- [ ] Password validation works (min 10 chars)
- [ ] Show/hide password toggle works
- [ ] Remember me checkbox toggles
- [ ] Form submits on Enter key
- [ ] Loading state displays correctly
- [ ] Success redirects to correct dashboard
- [ ] Error messages display correctly
- [ ] Keyboard navigation works (Tab order)
- [ ] Screen reader announces all states
- [ ] Focus indicator visible on all elements
- [ ] Mobile responsive layout works
- [ ] WCAG AA contrast ratios met
