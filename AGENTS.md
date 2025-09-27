# Repository Guidelines

## Project Structure & Module Organization
- `app/` contains the Rails MVC layers; Stimulus controllers, entrypoints, and Tailwind sources live in `app/packs/`.
- Shared Ruby helpers reside in `lib/`, environment defaults in `config/`, and deployment scripts under `bin/`.
- Static assets compiled by Shakapacker land in `public/packs/` after builds, while raw images and stylesheets sit under `app/packs/images` and `app/packs/stylesheets`.
- Tests follow Rails conventions in `test/` (controllers, models, system) with fixtures in `test/fixtures` for deterministic data.
- Custom npm patches applied via `patch-package` are tracked in `patches/`; update these whenever dependencies shift.

## Build, Test, and Development Commands
- `bin/setup` provisions Bundler gems, Yarn packages, database schema, and clears caches for a clean workspace.
- `bin/rails server` boots the Rails app; pair it with `bin/shakapacker-dev-server` for live Tailwind JIT recompilation and hot module reloads.
- `bin/yarn` (or `yarn install`) refreshes JavaScript dependencies; rerun after editing `package.json` or `patches/`.
- `bin/rails db:migrate` applies schema changes locally; run `bin/rails db:seed` whenever new seed data ships.
- `bundle exec rake assets:clobber` clears compiled packs before preparing a production build to avoid stale assets.

## Coding Style & Naming Conventions
- Target Ruby 3.0 defaults with two-space indentation, `snake_case` methods/variables, and `CamelCase` modules/classes.
- Stimulus controllers follow `some_feature_controller.js` naming, exporting a default `Controller` subclass under `app/packs/controllers`.
- Lean on Tailwind utility classes in ERB views; consolidate shared styles in `app/packs/stylesheets/application.css` when utilities fall short.
- Keep view templates concise—extract complex logic into helpers within `app/helpers/` or presenters in `app/` as needed.

## Testing Guidelines
- `bin/rails test` runs the full Minitest suite; narrow scope (e.g., `bin/rails test test/models`) while iterating locally.
- System tests rely on Selenium + ChromeDriver; verify drivers are installed before running `bin/rails test:system`.
- Fixtures in `test/fixtures/*.yml` should stay deterministic; refresh them when schema or seed logic changes.
- Aim for controller/model coverage around Tailwind-driven interactions and Stimulus controllers that trigger backend flows.

## Commit & Pull Request Guidelines
- Follow short, imperative commit messages (e.g., `Update shakapacker config`), mirroring the existing history.
- Reference related issues in PRs, summarize behavioral changes, and include screenshots or GIFs for UI updates.
- Call out dependency upgrades and corresponding `patches/` adjustments; note database migrations in commits and PR descriptions.
- Request review from Rails + Tailwind maintainers, and wait for automated or manual test confirmation before merging.
