[![CircleCI](https://circleci.com/gh/Eric-Guo/tailwindcss-jit-stimulus/tree/main.svg?style=svg)](https://circleci.com/gh/Eric-Guo/tailwindcss-jit-stimulus/tree/main)

# README

This is a template with Rails 7.0, Webpacker 6.0.0, TailwindCSS 3 and Stimulus 3.0.1.

Need using Chrome to make JIT mode works, Safari 14.1.2 will failed to loading `application.css`.

## JavaScript dependencies

Use Node.js 22.13 or newer and pnpm 12.3.4. Install pnpm following the
[official installation instructions](https://pnpm.io/installation), selecting version 12.3.4.

```sh
pnpm --version # 12.3.4
bin/pnpm install --frozen-lockfile
bin/shakapacker
```

`bin/setup` installs JavaScript dependencies with pnpm. Commit `pnpm-lock.yaml`
when dependencies change; use `bin/pnpm install` to update it.
