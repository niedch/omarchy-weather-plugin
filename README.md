# Weather

Animated weather bar-widget for Omarchy with current conditions, hourly and 3-day forecast.

## Features

- Current temperature, feels-like, humidity, wind speed and description from wttr.in
- Animated scene in the popup (sun, moon, cloud, rain, snow, thunder, fog)
- Hourly and 3-day forecast
- Night/day icon switching
- Click the icon to toggle the popup

## Requirements

- `curl` must be installed
- Network access to `https://wttr.in`

## Install

```sh
omarchy plugin add https://github.com/<you>/omarchy-weather-plugin.git --enable
```

## Remove

```sh
omarchy plugin remove nic.omarchy-weather
```

## License

MIT