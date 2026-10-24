# Gallery (Flutter, Android)

A ColorOS-style photo gallery: **Photos · Albums · Explore**, with a frosted lavender look, floating search bar and bottom navigation.

## Features
- **Photos** – your whole library grouped by date, with the floating **Years / Months / Days / All** switcher (pinch with two fingers to zoom between levels). Pull to refresh; fast-scroll bar.
- **Albums** – device folders (Camera, Screenshots, WhatsApp, Snapchat, Download…) sorted by size; small folders fold into an **Others** collage. **Media types**: Videos, GIF, Screenshots, Favorites, Panoramas, Recently added.
- **Explore**
  - **People & places** – photos with faces (on-device ML Kit face detection, avatar crops centred on the face) and photos grouped by GPS location with reverse-geocoded place names.
  - **Smart tags** – Food, Buildings, Nature, Animals, Vehicles, Documents, Celebrations, Selfies, Babies (on-device ML Kit image labelling).
  - **Memories** – auto "Two weeks in review" cards per half-month plus "On this day", each with a detail page and an auto-play slideshow.
- **Viewer** – swipe between items, pinch/double-tap zoom, video playback with scrubbing, Send (share), Favorite, Delete, Details (date, size, resolution, album, place, tags, path). Tap to hide the bars.
- **Search** – by file name, album, date ("september 2026", "2024", "monday"), place, smart tag, "videos", "favorite". Suggestion chips for recent months, places, things and albums.

Everything runs on the phone; nothing is uploaded. The smart scan analyses the newest 3,000 photos in the background on first launch and caches the results (change `SmartScanner.maxScan` to adjust).

## Build & run
Requires Flutter 3.24+ and Android Studio / Android SDK.

```bash
cd gallery_app
flutter create --platforms=android --org com.coresolutions .   # generates the Android Gradle wrapper; keeps the existing AndroidManifest.xml
flutter pub get
flutter run                 # with a phone connected (USB debugging on)
flutter build apk --release # APK at build/app/outputs/flutter-apk/app-release.apk
```

If Gradle complains about `minSdk`, open `android/app/build.gradle(.kts)` and set `minSdk = 24`.

## Get an APK without installing anything
1. Create an empty repo on GitHub and upload this folder (or `git push` it).
2. Open the repo's **Actions** tab → **Build APK** → **Run workflow** (it also runs on every push).
3. After ~5 minutes, open the finished run and download **gallery-apk** (a zip containing `app-release.apk`).
4. Copy the APK to your phone, tap it, and allow "Install unknown apps" when asked.

## Project layout
```
lib/
  main.dart                  app + permission gate
  theme.dart                 colours, gradient background
  data/
    media_repository.dart    loads assets/albums, media types, favourites, delete, search
    smart_scanner.dart       ML Kit labels + faces, GPS → places, cached in SharedPreferences
    memories.dart            "Two weeks in review" / "On this day"
    grouping.dart            day / month / year grouping helpers
    gallery_scope.dart       InheritedNotifier that exposes the repository
  screens/
    home_shell.dart          search bar, tabs, frosted bottom nav
    photos_screen.dart       timeline + Years/Months/Days/All switcher
    albums_screen.dart       albums grid, Others, media types
    explore_screen.dart      People & places, Smart tags, Memories, Places, Smart tags pages
    memories_screen.dart     memory cards, memory page, slideshow
    viewer_screen.dart       full-screen viewer + video player
    search_screen.dart       search + suggestions
    asset_grid_screen.dart   generic grid page
  widgets/common.dart        Glass, AssetThumb, grouped grid slivers, tiles
android/app/src/main/AndroidManifest.xml   media, media-location and internet permissions
```

## Notes
- "People" shows photos that contain faces; it does not yet group them by person (that needs a face-embedding model).
- Bursts, Time-lapse and Slo-mo are not exposed by Android's MediaStore in a standard way, so they aren't listed as media types.
- Favourites are stored in the app (Android's own favourite flag is only available on Android 11+).
