Upgrade Summary: What Changed and What Broke

Context
- This file summarizes concrete upgrade changes and regressions encountered in this repository.
- It is intentionally different from the reusable migration plan.

pnpm: Changes and Issues
- Scripts and docs were moved to pnpm usage (`pnpm install`, `pnpm run ...`) instead of npm command examples.
- Project lockfile direction switched to pnpm.
- The repository policy has been updated to track `pnpm-lock.yaml` in git for reproducible installs.
- `.gitignore` no longer excludes `pnpm-lock.yaml`.

pnpm-specific issues encountered
- Some migration notes assumed pnpm installation instructions were needed, but pnpm was already installed on this workstation.
- Resulting rule for this environment: do not add global pnpm install instructions unless target machines actually need them.
- Lockfile policy decision: commit `pnpm-lock.yaml` as part of the migration changeset.

SvelteKit/Svelte 5: Changes and Issues
- State API migration from `$app/stores` to `$app/state` in migrated files.
- Template usages moved from store syntax (`$page`, `$navigating`) to state objects (`page`, `navigating`) where applicable.
- Event syntax and reactive syntax updates were applied in migrated components (for example `on:click` to `onclick`, and selected reactive updates).
- Deprecated config key migration: `kit.csrf.checkOrigin` was replaced with the current `csrf.trustedOrigins` shape.

SvelteKit-specific regressions encountered and fixes
- Regression: navigation progress bar (green bar) became visible at idle.
  - Cause: with `$app/state`, `navigating` is an object shape even when idle, so truthiness checks always pass.
  - Fix: check `navigating.to` instead of `navigating` object truthiness.
- Regression risk: routes still using `$app/stores` after partial migration.
  - Fix: migrate remaining files (notably `+error.svelte`) to `$app/state` usage.

Tailwind v4: Changes and Issues
- PostCSS plugin moved from `tailwindcss` to `@tailwindcss/postcss`.
- autoprefixer and postcss-import are no longer needed in v4 (handled automatically); removed from postcss config.
- CSS import updated to `@import 'tailwindcss';` (single import). The split `tailwindcss/preflight` + `tailwindcss/theme` + `tailwindcss/utilities` form does NOT correctly generate theme variables and breaks `@layer base` font-size overrides.
- `tailwind.config.ts` removed — v4 does not auto-detect JS/TS config files. File had no meaningful content (empty theme extension, no plugins).
- `components.json` Tailwind config reference cleared to match v4 usage.

Tailwind/theme-specific regressions encountered and fixes
- Regression: logo image appearance in light/dark themes became inconsistent during migration attempts.
  - Cause: theme-dependent class toggling for inversion became fragile during the upgrade.
  - Fix: centralized CSS approach with `.logo-img` filter defaults and `.dark .logo-img` override; simplified markup class usage.
- Regression: h1/h2/h3 headings all rendered at the same size after Tailwind v4 migration.
  - Cause: using split imports (`tailwindcss/preflight` + `tailwindcss/theme` + `tailwindcss/utilities`) instead of the correct single import. The split form does not generate theme CSS variables, so `@apply text-5xl` in `@layer base` silently produces no output.
  - Fix: replace all three split imports with a single `@import 'tailwindcss';` in app.css.

Svelte 5 / eslint-plugin-svelte v3: Additional regressions and fixes
- Regression: `$:` reactive declarations on constant values flagged as `svelte/no-immutable-reactive-statements`.
  - Fix: replaced `$: x = CONSTANT` with `const x = CONSTANT`.
- Regression: `{#each}` blocks without keys flagged as `svelte/require-each-key`.
  - Fix: added unique key expressions to all each blocks (e.g. `{#each items as item (item.name)}`).
- Regression: invalid HTML attributes (`variant`, `size` on `<a>`; `alt` on `<svg>`) became errors under stricter Svelte 5 type checking.
  - Fix: removed non-standard attributes; used `aria-label` on SVG elements.
- Regression: mode-watcher ≥1.x dropped Svelte store interface; `$mode` store access broke.
  - Fix: switched to `mode.current` throughout (e.g. `{#if mode.current === 'light'}`).

Playwright: Changes and Issues
- Integration tests required system Chromium instead of a downloaded browser.
  - Fix: added `use.launchOptions.executablePath` in `playwright.config.ts` pointing to `/usr/bin/chromium-browser`, with `process.env.CHROMIUM_PATH` override for portability.
  - Do not run `playwright install` in this environment — system browser is available and repo-local downloads are undesired.
- `test-results/` directory added to both `.gitignore` and `.prettierignore` to prevent generated Playwright output from appearing in diffs or lint.

Documentation and Workflow Updates
- README restructured to reflect modern development workflow.
- Added `Pre-publishing` section consolidating pre-release validation and build steps as separate commands.
- `preflight:release` script added to package.json: runs validation only (`pnpm install --frozen-lockfile`, `pnpm audit`, `pnpm outdated`, `pnpm run check`, `pnpm run lint`, `pnpm run test`).
- Static site build handled separately via `pnpm run build` (not part of preflight validation).
- README commands presented in concise format with inline comments for easy reference during releases.
- "Dev Notes" section renamed to "Development" for clarity.

Validation outcome for this repository
- Framework/type checks reached clean state (`svelte-check` with 0 errors and 0 warnings after fixes).
- Lint reached clean state (Prettier + ESLint 0 errors after all fixes).
- Unit tests: 1 passed.
- Integration tests: 1 passed (Playwright using system Chromium).
- All primary upgrade regressions identified in-session were corrected.

Post-migration issues found during new project setup

lucide-svelte deprecation
- `lucide-svelte` was carried forward from the migration without addressing its upstream deprecation warning.
- Fix: replace `lucide-svelte` with `@lucide/svelte` in dependencies and update all import paths. Straight rename — no API changes.
- Affected files: `package.json`, any component importing from `lucide-svelte`.

@eslint/js explicit dependency (pnpm strict isolation)
- `@eslint/js` is imported directly in `eslint.config.js` but was not listed as an explicit devDependency.
- Under npm this resolves transitively; under pnpm strict isolation it fails with `ERR_MODULE_NOT_FOUND`.
- Fix: add `@eslint/js` as an explicit direct devDependency.

.prettierignore gaps
- `pnpm-lock.yaml` and `.claude/` were not excluded from prettier.
- After `pnpm install` regenerates the lockfile, lint fails because prettier wants to reformat it.
- Fix: add `pnpm-lock.yaml` and `.claude/` to `.prettierignore`.

Related file
- Reusable process document: `sveltekit-tailwind-migration-plan.md`
