# Repository Guidelines

## Project Structure & Module Organization

This Rails 7.2 application provides the Tianhua materials-library frontend. Controllers live in `app/controllers/`; ERB pages and shared partials are in `app/views/`. Phone-specific templates use the `.html+phone.erb` suffix. Frontend code lives in `app/packs/`: `entrypoints/` loads JavaScript, `controllers/` contains Stimulus controllers, and `stylesheets/` and `images/` hold assets. `public/` contains static files. Rails, database, and Shakapacker configuration lives in `config/`; database schema and seeds are in `db/`. Tests live in `test/`, and CI is defined in `.circleci/config.yml`.

## Build, Test, and Development Commands

Use Ruby 3.3.3 to match CI, Node.js 22.13 or newer, and pnpm 12.3.4. Select a compatible Ruby before setup; the Gemfile requires Ruby 3.1 or newer.

- `bin/setup`: installs dependencies, prepares SQLite databases, clears logs and temporary files, and restarts Rails.
- `bin/rails server`: starts the local application.
- `bin/shakapacker`: compiles frontend assets.
- `bin/shakapacker-dev-server`: runs the frontend development server in a separate terminal.
- `bin/rails test`: runs non-system tests.
- `HEADLESS=1 bin/rails test:system`: runs browser tests with headless Chrome.
- `bin/rails test test/integration/home_test.rb`: runs a single test file.

## Coding Style & Naming Conventions

Use two-space indentation in Ruby and JavaScript. Follow Rails conventions: snake_case filenames and methods, CamelCase classes, and `_name.html.erb` for partials. Name Stimulus files `*_controller.js`. Match surrounding quoting and semicolon usage; no dedicated formatter or linter is configured. Prefer existing Tailwind utilities and shared partials for consistent presentation.

## Testing Guidelines

Tests use Minitest, with Capybara and Selenium for system tests. Name files `*_test.rb`; put request checks in `test/integration/` and browser interactions in `test/system/`. Add regression coverage for behavior changes and check desktop and phone views when modifying layouts. Chrome is required for system tests. CI runs both test suites; no coverage threshold is configured.

## Commit & Pull Request Guidelines

History uses short, descriptive English and Chinese commit subjects, without a mandatory prefix. Keep commits focused. PRs should describe the change, link relevant issues, report validation, and include desktop/phone screenshots for visual changes. Commit `pnpm-lock.yaml` when JavaScript dependencies change; use `bin/pnpm install` to update it.
