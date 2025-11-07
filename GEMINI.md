# GEMINI.md

## Project Overview

This project is the frontend for the "Tianhua Materials Library" (天华材料库). It is a Ruby on Rails application that provides a web interface for browsing and managing a collection of materials, samples, projects, and manufacturers.

The application uses a modern frontend stack, including:

*   **Shakapacker:** For webpack integration with Rails.
*   **Tailwind CSS:** A utility-first CSS framework.
*   **Stimulus:** A modest JavaScript framework for the HTML you already have.
*   **Turbo:** For speed and single-page-application-like navigation.

The backend is a standard Rails application using:

*   **Ruby on Rails:** The core web framework.
*   **Puma:** As the application server.
*   **MySQL:** As the database.
*   **Devise and Omniauth:** For user authentication.
*   **Jbuilder:** For building JSON APIs.

## Codebase Architecture

*   **Core Models:** The central models of the application are `Material`, `Sample`, and `Cases` (representing projects).
    *   `Material` and `Cases` have a many-to-many relationship.
    *   `Sample` belongs to a `Material`.
*   **Authentication:** The application uses the Devise gem for authentication and has two distinct user models:
    *   `User`: For internal employees, authenticated against a separate `user_info` database.
    *   `Visitor`: For external users.
*   **Personal Center:** The `personal_center` namespace provides a dedicated area for authenticated users to manage their content, such as projects, messages, and suppliers.
*   **API:** The `thtri_api` appears to be a key component of the system, likely for integration with other services.

## Building and Running

### Prerequisites

*   Ruby
*   Node.js
*   Yarn or pnpm
*   MySQL

### Development

To run the application in development, you will likely need to follow these steps:

1.  **Install dependencies:**
    ```bash
    bundle install
    pnpm install
    ```

2.  **Set up the database:**
    ```bash
    rails db:create
    rails db:migrate
    rails db:seed
    ```

3.  **Run the application:**
    ```bash
    ./bin/shakapacker-dev-server
    rails s
    ```

### Testing

To run the test suite:

```bash
bundle exec rspec
```

*(TODO: Verify the exact test command. It might be `rails test` or something else.)*

## Development Conventions

*   **Authentication:** User authentication is handled by Devise and Omniauth. Internal users (`User` model) are authenticated against a separate database, while external users (`Visitor` model) are managed by this application.
*   **Frontend:** The frontend is built with Stimulus, Turbo, and Tailwind CSS. JavaScript code is located in `app/packs/entrypoints` and Stimulus controllers are in `app/packs/controllers`.
*   **API:** The application provides a JSON API built with Jbuilder. The `thtri_api` is likely used for integrations.
*   **Styling:** CSS is written using Tailwind CSS. The configuration is in `tailwind.config.js`.
*   **Linting:** The project uses RuboCop for Ruby code linting. The configuration is in `.rubocop.yml`.