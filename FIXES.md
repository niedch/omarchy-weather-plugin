# nic.omarchy-weather — What Needs to Be Fixed

## Symptom

The `nic.omarchy-weather` bar widget does not load. The bar renders, but the
weather icon is missing and the plugin never appears.

Quickshell log (`/run/user/1000/quickshell/by-id/*/log.qslog`) reports:

```
Plugin widget nic.omarchy-weather failed:
  file:///home/nic/.config/omarchy/plugins/nic.omarchy-weather/BarWidget.qml:4:1:
  module "qs" is not installed
```

## Root Cause

The plugin was written against an **older Omarchy/Quickshell API** and has not
been updated. After the upgrade to the current Omarchy release (the
`icons.omarchy-upgrade-to-quattro.*.bak` backup folder confirms a recent
upgrade), two things it depends on no longer exist:

1. **`import qs` (plain `qs` module)** — `BarWidget.qml:4` and most of the
   scene QML files import the bare `qs` module. The current shell only ships
   `qs.Ui` and `qs.Commons` (each a directory with its own `qmldir`). There is
   no bare `qs` module anymore.
2. **The `Constants` and `Colors` singletons** — the old bare `qs` module
   exposed these. Neither exists in the current API:
   - Current `qs.Commons` provides `Color`, `Style`, `Util`, and `Border` only.
   - `Color` only has `foreground`, `background`, `accent`, `urgent`, `muted`.
     There is **no** `Color.color0`–`color8` (ANSI palette) role.

The stock `omarchy.weather` plugin (in
`/usr/share/omarchy/shell/plugins/panels/weather/`) only imports `qs.Commons`
and `qs.Ui` and uses the current `Style`/`Color` tokens — it never touches a
bare `qs` module or `Constants`.

## What Needs to Change

### 1. Fix the `import qs` statements

Files affected (every `import qs` line must be removed/replaced):

| File | Line | Current line |
|------|------|--------------|
| `BarWidget.qml` | 4 | `import qs` |
| `CloudScene.qml` | 2 | `import qs` |
| `FogScene.qml` | 2 | `import qs` |
| `MoonScene.qml` | 2 | `import qs` |
| `OrbitScene.qml` | 2 | `import qs` |
| `RainScene.qml` | 2 | `import qs` |
| `SnowScene.qml` | 2 | `import qs` |
| `SunScene.qml` | 2 | `import qs` |
| `ThunderScene.qml` | 3 | `import qs` |
| `WeatherPopup.qml` | 4 | `import qs` |
| `WeatherScene.qml` | 2 | `import qs` |

Replace with `import qs.Commons` where `Color`/`Style`/`Util` are used, and
`import qs.Ui` where the widget is a `BarWidget` (already imported in
`BarWidget.qml`).

### 2. Replace `Constants.*` with current `Style` tokens

`Constants` came from the old `qs` module. Map to the current API
(`Style` in `qs.Commons` / `BarWidget`):

| Old (missing) | Current replacement |
|---------------|---------------------|
| `Constants.fontFamily` | `Style.font.family` |
| `Constants.fontSize` | `Style.font.body` (12px base) — used for the icon/temp text |
| `Constants.fontSizeSmall` | `Style.font.caption` or `Style.font.bodySmall` — used in the popup |
| `Constants.barHeight` | `Style.bar.sizeHorizontal` (top/bottom bar) or `BarWidget.barSize` |
| `Constants.pollWeather` | A literal interval (e.g. `600000` for 10 min), or make it a `property int` in `BarWidget.qml` |

Occurrences:

| File | Token | Count |
|------|-------|-------|
| `BarWidget.qml` | `Constants.fontFamily` | 1 |
| `BarWidget.qml` | `Constants.fontSize` | 1 |
| `BarWidget.qml` | `Constants.barHeight` | 1 |
| `BarWidget.qml` | `Constants.pollWeather` | 1 |
| `WeatherPopup.qml` | `Constants.fontFamily` | 21 |
| `WeatherPopup.qml` | `Constants.fontSize` | 3 |
| `WeatherPopup.qml` | `Constants.fontSizeSmall` | 10 |

### 3. Replace `Colors.*` with current `Color` / `Style` tokens

The old `Colors` singleton is gone. The current palette is `Color` (in
`qs.Commons`). The `colorN` ANSI roles have no direct equivalent — map them to
foundational/derived roles or explicit hex.

| Old (missing) | Current replacement |
|---------------|---------------------|
| `Colors.foreground` | `Color.foreground` |
| `Colors.background` | `Color.background` |
| `Colors.accent` | `Color.accent` |
| `Colors.color0` | `Color.urgent` / `Color.muted` (dark, low-emphasis) |
| `Colors.color1` | `Color.urgent` (red-ish) |
| `Colors.color3` | `Color.accent` (warm highlight) |
| `Colors.color6` | `Color.accent` |
| `Colors.color7` | `Color.foreground` |
| `Colors.color8` | `Color.muted` (dimmed/disabled) |

Occurrences:

| File | Tokens |
|------|--------|
| `CloudScene.qml` | `Colors.color8` |
| `FogScene.qml` | `Colors.foreground` |
| `MoonScene.qml` | `Colors.background`, `Colors.foreground` |
| `OrbitScene.qml` | `Colors.accent`, `Colors.background`, `Colors.color3`, `Colors.color8`, `Colors.foreground` |
| `RainScene.qml` | `Colors.color8` |
| `SunScene.qml` | `Colors.color3` |
| `WeatherPopup.qml` | `Colors.background`, `Colors.foreground` |
| `WeatherScene.qml` | `Colors.*` |

`Util.alpha` (used in `OrbitScene.qml`) is **already** available in the current
`qs.Commons.Util` — no change needed there.

### 4. Verify against the current stock plugin

`/usr/share/omarchy/shell/plugins/panels/weather/` is the reference
implementation for the current API. Match its import style and token usage.

## After Editing

1. Edit the QML files in `~/.config/omarchy/plugins/nic.omarchy-weather/`.
   The shell hot-reloads user plugin code under `~/.config/omarchy/plugins/`
   on save.
2. If it does not pick up the change, restart the shell:
   ```
   omarchy restart shell
   ```
3. Confirm the widget loads with no error in the quickshell log:
   ```
   omarchy restart shell
   grep -a "omarchy-weather" /run/user/1000/quickshell/by-id/*/log.qslog
   ```

## Optional: Compatibility shim (alternative to porting)

Instead of rewriting every reference, you can recreate the old `qs` module as a
backward-compatible shim:

1. Create `~/.config/omarchy/plugins/nic.omarchy-weather/qs/qmldir` declaring
   singletons `Constants` and `Colors`.
2. Add `Constants.qml` and `Colors.qml` that read from the current
   `Style`/`Color` singletons (e.g. `Constants.fontFamily: Style.font.family`).
3. Ensure the plugin's QML import path includes that directory.

This is more fragile than porting and duplicates the palette, so porting is
recommended.
