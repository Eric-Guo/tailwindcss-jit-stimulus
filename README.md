# README

天华材料库前端

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
