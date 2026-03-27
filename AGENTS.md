# AGENTS.md

## Project Overview

iCal feed generator for venue events. Scrapes event information from venue websites that don't provide native iCal feeds and generates JSON + ICS (iCalendar) files. Deployed hourly to GitHub Pages via GitHub Actions.

## Architecture

- **`app/parser.rb`** — Base parser class with `uri_open_headers`, `normalize_time` (Dutch→English months), and `cutoff` (14 days in the past).
- **`app/{venue}/parser.rb`** — Venue-specific scrapers inheriting from `Parser`. Each implements `#call` returning an array of event hashes.
- **`app/calendar_builder.rb`** — Converts event hashes to iCal format (Europe/Amsterdam timezone).
- **`bin/reader.rbx`** — Main script that runs all parsers and writes `build/{venue}/events.json` + `events.ics`.

## Event Hash Format

```ruby
{ datum: "DD-MM-YYYY", geopend: "HH:MM uur", eindtijd: "HH:MM uur", title: "...", url: "...", description: "...", locatie: "..." }
```

Only `datum`, `title`, `url`, `locatie` are required. Without `geopend`/`eindtijd`, CalendarBuilder creates all-day events.

## Venues

| Venue | Source | Notes |
|-------|--------|-------|
| BWH | HTML scrape (2-level: list → detail pages) | `burgerweeshuis.nl/programma` |
| Walhalla | HTML scrape (WordPress "The Events Calendar" plugin) | upcoming + past pages |
| Burnside | HTML scrape (microdata/schema.org) | estimated times |
| Buitenpost | **WP REST API** (`/wp-json/wp/v2/pages/19524`) | Divi shortcodes, not rendered HTML |
| GregOrIan | Generated (no scraping) | Fun calendar |

## Buitenpost Parser Details

The `bijbuitenpost.nl/agenda/` page uses Divi page builder. The WP REST API returns **raw Divi shortcodes** (not rendered HTML) in `content.rendered`. Key implementation details:

- Fetches JSON from `/wp-json/wp/v2/pages/19524`
- Decodes HTML entities (`&#8221;` → `"`, `&#8243;` → `″`) via Nokogiri
- Splits content by `[et_pb_row ` shortcodes, filters blocks containing `#09a0a9` (event background color) and `<h2>`
- Extracts `h2` (title), `h3` (date), `p` (description) as real HTML tags within shortcode blocks
- Parses `button_url` from `[et_pb_button]` shortcodes using regex (handles Unicode quote variants)
- Strips Divi shortcode text from descriptions via `/\[\/?\w+/` pattern
- Multi-day dates use `+` or `en` separator (e.g. "5 + 6 april 2026")

## Testing

- **Framework**: RSpec with WebMock (no real HTTP), Timecop (frozen time)
- **Fixtures**: `spec/fixtures/{venue}/` — HTML or JSON files from actual venue responses
- **Pattern**: Parsers accept local file paths for testing (via `URI.open`)
- **Run tests**: `bundle exec rspec` (or direct path to rspec executable)

## Deployment

- **GitHub Actions** (`.github/workflows/publish.yml`): Runs hourly, builds all feeds, deploys to GitHub Pages (main branch only), commits JSON back to repo.
- **Output**: `build/{venue}/events.json` + `events.ics`, plus `build/index.html` from README.

## Adding a New Venue

1. Create `app/{venue}/parser.rb` inheriting from `Parser`, implement `#call`
2. Create fixture files in `spec/fixtures/{venue}/`
3. Create `spec/{venue}/parser_spec.rb`
4. Add venue block to `bin/reader.rbx`
5. Update `README.md` with feed URLs
