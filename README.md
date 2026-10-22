# Volunteer Match

A Ruby on Rails app that matches volunteers with events based on their skills and interests.
Organizers create events and confirm attendance; volunteers join events, earn points and unlock badges.
Built as an internship project with **vanilla Rails 8**: no Devise, no RSpec, no Bootstrap,
no npm — only the tools Rails ships with.

## Features

- **Two roles:** volunteers and organizers, each with their own sign-in and sign-up pages
- **Smart matching:** events are ranked by how well they fit a volunteer's skill and interest ("Best Match")
- **Registrations:** join or cancel, capacity limits, organizers confirm attendance or mark no-shows
- **Points and badges:** confirmed attendance earns points; badges unlock at point thresholds
- **Feedback:** volunteers rate events they attended
- **Live notifications:** organizers see new registrations instantly, without reloading the page

  ## Tech stack

| Area                  | Tool 
|-----------------------|-----------------------------------------------------------
| Framework             | Ruby 4.0.2, Rails 8.1.4 
| Database              | SQLite 
| Authentication        | Rails 8 authentication generator (`has_secure_password`) 
| Front end             | Hotwire (Turbo + Stimulus), importmap, Propshaft 
| CSS                   | Plain CSS with design tokens and `@layer` 
| Real time             | Action Cable with Solid Cable 
| Tests                 | Minitest, fixtures, Capybara (system tests) 

## Getting started

Requirements: Ruby 4.0.2 (see `.ruby-version`).

```bash
bin/setup
```

This installs the gems, prepares the database, loads the seed data and starts the server.
Open http://localhost:3000.

To start the server again later:

```bash
bin/dev
```
### Demo accounts

All seed accounts use the password `password123`.

| Role              | Email |
-----------------------------------------
| Organizer (TEMA)  | `john@example.com` |
| Organizer (LOSEV) | `dostluk@example.com` |
| Volunteer         | `aksoy@example.com` |
| Volunteer         | `imge@example.com` |
| Volunteer         | `deniz@example.com` |

## Running the tests

```bash
bin/rails test          # model and integration tests
bin/rails test:system   # browser tests (needs Google Chrome)
bin/ci                  # style, security checks, tests and seeds
```
GitHub Actions runs the same checks on every push and pull request.

## Project structure highlights
- `app/models/user.rb` – one `User` for sign-in, linked to a `Volunteer` or `Organizer` profile with `delegated_type`
- `app/controllers/concerns/authentication.rb` – sessions, `current_volunteer` / `current_organizer`, role checks
- `app/assets/stylesheets/tokens.css` – colors, spacing and type scale as CSS variables
- `app/javascript/controllers/` – Stimulus controllers for the mobile menu and toast messages
- `app/models/notification.rb` – broadcasts live updates with Turbo Streams

