# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview
This is 天华材料库前端 (Tianhua Material Library Frontend), a **Ruby on Rails 7.2.2** application with **Stimulus.js** and **Tailwind CSS 3.4.18** for managing architectural materials, manufacturers, projects, and samples in the construction/architecture industry.

**⚠️ Important**: Use Chrome for JIT mode. Safari 14.1.2 has loading issues with `application.css`.

## Common Development Commands

### Initial Setup
```bash
bin/setup
```
This idempotent script installs dependencies (Bundler, pnpm), prepares the database, and restarts the application server.

### Running the Application
```bash
# Start Rails server
bin/rails server

# In a separate terminal: Start Shakapacker dev server for live Tailwind JIT recompilation
bin/shakapacker-dev-server
```

### Database Operations
```bash
bin/rails db:migrate          # Apply schema changes
bin/rails db:seed             # Load seed data
bin/rails db:prepare          # Create/migrate/seed database
bin/rails db:drop             # Drop database
bin/rails db:reset            # Reset database
```

### Testing
```bash
# Run full test suite
bin/rails test

# Run specific test categories
bin/rails test test/models              # Model tests
bin/rails test test/controllers         # Controller tests
bin/rails test test/integration         # Integration tests
bin/rails test:system                   # System tests (requires Chrome/ChromeDriver)

# Run specific test file
bin/rails test test/models/user_test.rb
```

### Asset Management
```bash
# Clear compiled packs (required before production builds)
bundle exec rake assets:clobber

# Compile assets for production
bundle exec rake assets:precompile

# Install/update JavaScript dependencies
pnpm install

# Apply npm patches (run automatically on postinstall)
patch-package
```

### Code Quality
```bash
bundle exec rubocop                    # Lint Ruby code
bundle exec rubocop -A                 # Auto-fix lint issues
```

### Build Assets for Production
```bash
# Complete production build sequence
bundle exec rake assets:clobber
bin/rails assets:precompile
```

## High-Level Architecture

### Directory Structure
- **app/** - Main application code
  - **controllers/** - Rails controllers (including API and personal_center)
  - **models/** - ActiveRecord models
  - **views/** - ERB templates organized by feature
  - **helpers/** - View helpers
  - **jobs/** - Background jobs
  - **packs/** - Frontend assets
    - **controllers/** - Stimulus controllers
    - **entrypoints/** - Webpack entry points
    - **images/** - Static images
    - **stylesheets/** - Tailwind CSS source files
- **config/** - Configuration files
- **db/** - Database migrations and seeds
- **lib/** - Shared Ruby code
- **test/** - Minitest suite (unit, integration, system)
- **public/packs/** - Compiled assets (Shakapacker output)

### Frontend Architecture

#### Stimulus + Webpack (Shakapacker)
- Entry point: `app/packs/entrypoints/application.js`
  - Registers Tailwind Stimulus components: `alert`, `autosize`, `dropdown`, `modal`, `tabs`, `popover`, `toggle`, `slideover`
  - Auto-loads controllers from `app/packs/controllers/**` via `definitionsFromContext`
- Controllers: Create in `app/packs/controllers/NAME_controller.js` exporting a Stimulus Controller class
- Build tool: Shakapacker (Webpack 5 wrapper) configured via `config/webpack/webpack.config.js`

#### Frontend Dependencies
- **@hotwired/stimulus** - Interactive components
- **@hotwired/turbo** - Fast page navigation
- **mrujs** - Modern Rails JavaScript helpers
- **tailwindcss-stimulus-components** - Pre-built UI components
- **tailwindcss** - Utility-first CSS framework

#### View Conventions
- Use `data-controller`, `data-action`, and `data-*-target` attributes in `.erb` templates
- Prefer declarative actions: `click->controller#method`
- Keep DOM queries scoped using Stimulus targets
- Images via `require.context('../images', true)`
- CSS imported from `app/packs/stylesheets/application.css`

### Backend Architecture

#### API Design
- API routes under `api` namespace in `config/routes/api.rb` with `defaults: { format: :json }`
- JSON responses built with **Jbuilder** templates in `app/views/api/**`
- Template naming convention: `app/views/api/resource/action.json.jbuilder`
- API controllers in `app/controllers/api/**`

#### Authentication
- **Devise** configured for `users` and `visitors` models with limited modules
- SSO/OpenID Connect: `GET /auth/openid_connect/callback` → `OpenidConnectController#callback`
- Development auth: `GET /auth/dev_auth/login` (DevAuthController)
- Use `authenticate_any!` from ApplicationController to guard actions for both users and visitors

#### Key Models
- Materials (with color systems, samples, favorites)
- Manufacturers (with ratings and feedback)
- Projects (with related materials and manufacturers)
- Samples (with related projects)
- Users/Visitors (personalized experiences)

#### Routes Organization
- Main routes: `config/routes.rb`
- API routes: `config/routes/api.rb` (included via `draw(:api)`)
- Use `rails routes` to inspect available endpoints

### Database
- **MySQL** database
- ActiveRecord migrations in `db/migrate/`
- Fixtures in `test/fixtures/` for deterministic test data

### Testing Stack
- **Minitest** - Test framework
- **Capybara + Selenium Webdriver** - System/integration tests
- **Chrome/ChromeDriver** - Required for system tests
- Test types: Unit (models/controllers), Integration, System

### Deployment
- **Capistrano** deployment configuration (Capfile.rb)
- Production server: m-thtri.thape.com.cn
- CI/CD: GitLab CI (`.gitlab-ci.yml`) and CircleCI (`.circleci/config.yml`)

## Development Workflow

1. Run `bin/setup` for initial setup
2. Start both servers:
   - `bin/rails server` (Rails app)
   - `bin/shakapacker-dev-server` (frontend build)
3. Make changes to:
   - Ruby code in `app/` (controllers, models, views, helpers)
   - Stimulus controllers in `app/packs/controllers/`
   - Tailwind classes in views (no custom CSS needed unless utilities fall short)
4. Run tests: `bin/rails test`
5. Check code quality: `bundle exec rubocop`

## Code Style & Conventions

### Ruby
- Ruby 3.0 defaults
- Two-space indentation
- `snake_case` for methods/variables
- `CamelCase` for modules/classes

### Stimulus
- Naming: `some_feature_controller.js`
- Export default `Controller` subclass
- Controllers auto-registered from `app/packs/controllers/`

### Views
- Lean on Tailwind utility classes
- Keep templates concise
- Extract complex logic into helpers or presenters

### API Responses
- Use Jbuilder partials for reusable JSON structures
- Keep controllers thin (fetch records, authorize, let Jbuilder shape JSON)
- Use `includes` and `select` to avoid N+1 queries
- Return consistent keys and nesting

## Configuration Files (Key)

- `Gemfile` / `Gemfile.lock` - Ruby dependencies
- `package.json` - JavaScript dependencies (pnpm)
- `config/routes.rb` - Main routes
- `config/routes/api.rb` - API routes
- `config/webpack/webpack.config.js` - Shakapacker configuration
- `tailwind.config.js` - Tailwind customization
- `.rubocop.yml` - Ruby linting rules
- `.gitlab-ci.yml` - GitLab CI pipeline
- `.circleci/config.yml` - CircleCI configuration

## Important Notes

### npm Patches
- Custom patches in `patches/` directory applied via `patch-package`
- Re-run `pnpm install` after updating dependencies or patches

### Asset Pipeline
- Static assets compiled by Shakapacker land in `public/packs/`
- Use `javascript_packs_with_chunks_tag` and `stylesheet_packs_with_chunks_tag` helpers in layouts

### Browser Support
- Targets: Modern browsers (not IE 11)
- Chrome required for Tailwind JIT mode
- Safari 14.1.2 has compatibility issues

## Dependency Management

- **Ruby**: Managed by Bundler (`bundle` commands)
- **JavaScript**: Managed by pnpm v10.20.0
- Custom npm patches tracked in `patches/` directory
- Package resolutions/overrides in `package.json`

## CI/CD

### GitLab CI
- Stages: test and deploy
- MySQL test database
- Bundle and pnpm caching
- Production deployment via Capistrano

### CircleCI
- Ruby 3.0.2 with Node and browsers
- System tests with Chrome/ChromeDriver
- Full test suite execution
