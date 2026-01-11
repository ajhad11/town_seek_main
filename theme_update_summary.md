# App Theme Unification Plan

## Objective
Align the entire application's color scheme with the Home Screen branding to ensure a consistent and premium user experience.

## Selected Brand Color
**Royal Blue**: `Color(0xFF2962FF)`
*Source: Home Screen Promo Banner & Custom Header*

## Changes Implemented

### 1. Global Theme (`lib/main.dart`)
- Updated `primaryColor` to `0xFF2962FF`.
- Updated `AppBarTheme` background and status bar color to `0xFF2962FF`.
- Updated `ColorScheme` seed to `0xFF2962FF`.

### 2. Business Admin Dashboard (`business_admin_dashboard.dart`)
- **Header**: Replaced Purple/Blue gradient with a dedicated Blue gradient (`0xFF2962FF` to `0xFF82B1FF`).
- **Icons**: Changed Purple icons to Blue.
- **Buttons**: Changed Purple buttons to Blue.
- **Shadows**: Updated Purple shadows to Blue shadows.

### 3. Super Admin Dashboard (`super_admin_dashboard.dart`)
- **Header**: Replaced Red/Orange gradient with the standard App Blue gradient.
- **Shadows**: Updated Red shadows to Blue shadows.
- **Icons**: Ensured indicators align with the new theme where appropriate (some functional status colors like Green/Red preserved for metrics).

### 4. Authentication Screens
- **Sign Up** (`signup_screen.dart`): Updated `primaryBlue` constant to exact `0xFF2962FF`.
- **Login** (`login_screen.dart`): Updated `primaryBlue` constant to exact `0xFF2962FF`.
- **Account Type** (`account_type_screen.dart`): Updated `_brandBlue` to `0xFF2962FF`.

## Result
The application now features a unified, professional Blue theme consistent with the Home Screen.
