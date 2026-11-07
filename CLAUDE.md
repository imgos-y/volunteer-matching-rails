volunteer_matching
Vanilla Rails 8 app that matches volunteers with events. See README.md for features and setup.

## Commands
- `bin/dev`: start the server. In development, Solid Queue runs inside Puma, so `bin/jobs` is not needed.
- `bin/rails test`: run all tests except system tests.
- `bin/rails test <file>:<line>`: run a single test.
- `bin/rails test:system`: run browser tests (needs Chrome). `bin/ci` does not run these.
- `bin/ci`: run style checks, security audits, tests, and seeds.

## Project rules
- Use what Rails ships with. Do not add Devise, RSpec, Bootstrap, or npm.
- Ask before adding a gem.
- Write tests with Minitest and fixtures.
- Write plain CSS and reuse the variables in `app/assets/stylesheets/tokens.css`.
- Sign-in lives on `User`, linked to a `Volunteer` or `Organizer` profile with `delegated_type`.

## Gotchas
- Action Controller caching is off in development by default. Run `bin/rails dev:cache` to test fragment caching.
- Action Cable uses the `async` adapter in development, which only works within one process. To test a broadcast by hand, use the web console, not `bin/rails console`. Production uses Solid Cable.

## Workflow
- Never commit directly to `main`; use a branch and a pull request.
- Add or update tests when behavior changes.
- Run `bin/ci` before opening a pull request.
