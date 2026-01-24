# Lumia Launcher Feature Guide

This document tracks the development progress and feature set of the Lumia Launcher (Windows Phone style) for Android.

## ✅ Implemented Features

### User Interface (UI)
- **Metro Design Language**: Authentic tile-based interface inspired by Windows Phone.
- **Staggered Grid Layout**: Supports different tile sizes (Small, Wide) using `flutter_staggered_grid_view`.
- **Header Dashboard**: Displays current time (HH:mm) and date (dd/MM/yyyy) in large, legible typography.
- **True Black Theme**: Optimized for OLED screens with a pure black background (`Colors.black`).
- **SafeArea Support**: UI respects device notches and system bars.

### Functionality
- **Native App Launching**: Uses Android `MethodChannel` to invoke native `PackageManager` for opening apps.
- **Gesture Support**: Tap tiles to launch corresponding applications.
- **Error Handling**: Graceful handling of missing packages or launch failures (logged to debug console).

### Pre-configured Tiles
The following apps are currently mapped (hardcoded):
- **Phone** (Teal, Small) -> `com.android.dialer`
- **Messages** (Blue, Wide) -> `com.google.android.apps.messaging`
- **Camera** (Deep Purple, Small) -> `com.android.camera`
- **Settings** (Orange, Small) -> `com.android.settings`

---

## 🚧 Planned / In-Progress Features

### Core Experience
- [ ] **App Drawer**: List all installed applications alphabetically.
- [ ] **Dynamic Package Loading**: Fetch real installed apps instead of hardcoded package names.
- [ ] **Status Bar**: Show battery, signal, and notifications in the header.

### Customization
- [ ] **Tile Editing**: Long-press to resize (Small, Medium, Wide, Large) or unpin tiles.
- [ ] **Color Themes**: Allow users to pick accent colors for tiles.
- [ ] **Drag & Drop**: Reorder tiles on the home screen.
- [ ] **Icon Packs**: Support for custom icon packs.

### Advanced
- [ ] **Live Tiles**: Display notifications or updates on tiles (e.g., missed calls count, calendar events).
- [ ] **Animations**: Tilt effect on tap and page transitions.
