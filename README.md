# Fire Inspection (draft)

A Ruby on Rails app for managing fire-safety equipment inspections across client sites (addresses). Tracks a masterlist of addresses, recurring inspection schedules (annual / 6-monthly / monthly), and a digital equipment sheet (extinguishers, hydrants, hose reels, exit/emergency lights, fire doors, smoke alarms) with photos and defect history per asset.

This is an early draft, set up for local development only.

## Requirements

- Ruby 3.4.10 (see `.tool-versions` — managed via [asdf](https://asdf-vm.com/))
- Rails 8.1.3
- PostgreSQL 16 (running locally)

## Setup

```bash
bundle install
bin/rails db:create db:migrate
bin/rails db:seed   # optional — loads sample NSW addresses, assets, and a past visit
```

## Running it

```bash
bin/dev
```

This starts Puma plus the Tailwind CSS watcher. Visit **http://localhost:3000**.

If port 3000 is already in use by something else, run on a different port:

```bash
bin/dev -p 3001
```

## Running tests

```bash
bundle exec rspec
```

## Re-seeding sample data

`db/seeds.rb` wipes and recreates sample data (addresses, buildings, schedules, assets, and one completed visit per address) — safe to re-run any time with `bin/rails db:seed`.

## Key concepts

- **Address** — the client site (masterlist), NSW AU format (street, suburb, state, postcode).
- **Schedule** — a recurring inspection definition (frequency: monthly / six_monthly / annual) per address, optionally scoped to a building or equipment category. Status (`upcoming` / `due_soon` / `overdue`) is computed live from `next_due_on`.
- **InspectionVisit** — one inspection visit to an address on a given date; can satisfy one or more schedules (via `ScheduleCompletion`).
- **Asset** — a physical piece of equipment (asset no., building, level, category). Category-specific fields (size/type, brand, length, type code) live in a `details` JSONB column so new equipment types don't need new tables.
- **AssetInspectionRecord** — the finding recorded for an asset during a specific visit (defect status, defect found, action required, photos). Append-only per visit, so inspection history is never overwritten.

## Not yet implemented

- Authorization / roles (every logged-in user can read and write everything)
- Cloud photo storage (currently local disk via ActiveStorage)

## Logins

Dev login credentials are created by `db/seeds.rb` — run `bin/rails db:seed` and see that file for the account.