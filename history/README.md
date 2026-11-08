# CamptonHillsWeather.com — Historical Weather Data

This directory is the archive of the weather data recorded at my parents' house in
Campton Hills, Illinois, my childhood home. I set up the weather station and the
website camptonshillsweather.com for my father in 2005. After Mom and Dad passed away
and the house was sold, the station and website were shut down. This copy of the data
is what remains.

## Provenance

- **Station:** Davis weather station at the family home in Campton Hills, IL.
- **Software:** Cumulus (Windows), which polled the Davis console, logged the data,
  and generated the reports and realtime files used by the website in this repository.
- **Source:** `C:\cumulus\data` and `C:\cumulus\Reports` on the Cumulus Windows 10 VM
  (192.168.100.170).
- **Copied:** November 8, 2026. Zipped with PowerShell `Compress-Archive`, transferred
  with `scp` to this repository, and committed unmodified.

## Coverage

- **Readings:** May 5, 2010 through July 20, 2026. Earlier records from 2005–2010 were
  not in the Cumulus data directory and are not included here.
- **Monthly log files:** 195 files, one for every month from May 2010 to July 2026.
- **Daily summaries (`dayfile.txt`):** 5,782 days. Notable gaps where the station or
  PC was down: Mar 2021 (23 days), May–mid-June 2021 (46 days), late Aug–Sep 2021
  (36 days), and Nov–Dec 2024 (31 days), plus several shorter ones.
- **NOAA reports:** monthly reports from Aug 2017 to Jul 2026 and yearly reports from
  2017 to 2026.

## Files

### `data/`

| File | Contents |
|------|----------|
| `MmmYYlog.txt` (e.g. `Jun15log.txt`) | Monthly logs, one comma-separated line per logging interval: date, time, temperature, humidity, dew point, wind, rain, pressure, etc. |
| `dayfile.txt` | One line per day with daily highs/lows and the times they occurred, rain, wind run, etc. Later years have more fields than early years. |
| `alltime.ini`, `monthlyalltime.ini` | All-time records, overall and by calendar month. |
| `year.ini`, `month.ini`, `today.ini`, `yesterday.ini` | Records for the current year, month, and day at the time the station stopped. |
| `alltimelog.txt` | Log of when all-time records were set or changed. |
| `log.xml` | Cumulus weather diary (empty). |
| `bck*`, `NOAMO1124.txt010125`, `ftpls.txt` | Cumulus backup/temporary files, kept as found. |

### `Reports/`

| File | Contents |
|------|----------|
| `NOAAMOmmyy.txt` | NOAA-style monthly climate summary. |
| `NOAAYRyyyy.txt` | NOAA-style yearly climate summary. |

The file formats are documented in the Cumulus 1 help and the Cumulus wiki
(https://cumuluswiki.org/), under "dayfile.txt" and "Monthly log files".

## Notes on the data

- **Units:** Fahrenheit, mph, inches of mercury, and inches of rain. The first few
  readings on May 5, 2010 were recorded in Celsius/hPa, before the station was switched
  to US units.
- **Dates** in the log files and `dayfile.txt` use `dd/mm/yy` format.
- **Sensor glitches:** a few readings are clearly bad, for example the 164°F high
  temperature on Jan 19, 2025 in `alltime.ini`. Some records in the `.ini` files
  (e.g. `highmintempvalue=999`) are Cumulus placeholders that were never updated.
- **Real extremes worth remembering:** the -24.7°F low on Jan 31, 2019 (polar vortex)
  and the -45.4°F wind chill on Jan 6, 2014.
