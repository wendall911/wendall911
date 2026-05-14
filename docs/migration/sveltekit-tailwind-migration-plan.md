SvelteKit + Tailwind Migration Plan (Reusable)

Purpose
- Provide a repeatable process to migrate SvelteKit projects to current SvelteKit and Tailwind versions with minimal regressions.
- Keep package manager, framework APIs, and styling toolchain aligned.

Scope
- Package manager standardization (pnpm preferred)
- All package upgrades (`dependencies` and `devDependencies`)
- SvelteKit state/store API migration
- Tailwind v4 migration
- Regression checks and validation

Phase 1: Baseline and Safety
1. Record current state
   - Save current dependency versions from package.json.
   - Capture build/check/test status before changes.
   - Snapshot git status and last known good commit.
2. Confirm package manager strategy
   - Choose one lockfile and one package manager command set.
   - If using pnpm, ensure scripts and docs use pnpm commands.
   - Define lockfile policy explicitly:
     - Recommended: commit `pnpm-lock.yaml` for reproducible installs.
     - Alternative: if intentionally ignored, document why and accept non-reproducible install risk.
   - Remove or stop updating conflicting lockfiles (`package-lock.json`, `yarn.lock`) during migration.
   - Update `.gitignore` to match the chosen lockfile policy.
   - Update README and developer docs to pnpm commands (`pnpm install`, `pnpm run dev`, `pnpm run build`, etc.).
   - Create a pre-publishing workflow in package.json scripts:
     - Add `preflight:release` script that runs `pnpm install --frozen-lockfile`, audit, outdated check, type/lint checks, tests, and build.
     - Document the pre-publishing workflow in README with clear command examples and inline comments for easy reference during releases.
   - Environment policy: do not add pnpm installation steps when pnpm is already available on target workstations/CI images.
   - CI policy: workflows must use the same package manager/lockfile as local development (for pnpm repos, do not use `npm ci` against `package-lock.json`).
   - GitHub Actions runtime policy: migrate to action versions that support Node 24 (`actions/checkout@v6`, `actions/setup-node@v6`, `pnpm/action-setup@v6`) before Node 20 deprecation deadlines.
   - Keep application runtime explicit in workflow (`node-version: 24`) and pin pnpm major/minor as needed for lockfile compatibility in CI.
3. Create rollback point
   - Tag or note a pre-migration commit SHA.

Phase 2: Dependency Upgrade
0. Upgrade all direct packages in package.json
   - Update both `dependencies` and `devDependencies` to current compatible versions.
   - Do not stop after framework-only packages; include runtime, tooling, test, and lint packages.
1. Upgrade core stack first
   - svelte
   - @sveltejs/kit
   - @sveltejs/vite-plugin-svelte
   - vite
   - typescript
2. Upgrade styling/tooling stack
   - tailwindcss
   - @tailwindcss/postcss (for Tailwind v4)
   - postcss, autoprefixer
   - linting/formatting/test packages
3. Install missing type packages
   - Add @types/node if tsconfig or tooling references Node types.

Phase 3: SvelteKit API Migration
1. Move from old stores API where required
   - Replace imports from $app/stores with $app/state where applicable.
2. Replace store-style template usage
   - Replace $page, $navigating, etc. with page, navigating when using $app/state.
3. Validate condition checks for state objects
   - Do not rely on object truthiness for navigation indicators.
   - Preferred check: navigating.to (or a similarly explicit field) to avoid always-on UI.
4. Update event and reactivity syntax as needed for Svelte 5
   - Migrate on:click to onclick where required by code style/migration goals.
   - Replace legacy reactive patterns with runes where intentionally adopted.

Phase 4: Tailwind v4 Migration
1. Update PostCSS plugin usage
   - tailwindcss plugin key -> @tailwindcss/postcss.
   - autoprefixer and postcss-import are no longer needed; v4 handles them automatically.
2. Move to v4 CSS import style
   - Use a single `@import 'tailwindcss';` — do NOT use the split `tailwindcss/preflight`, `tailwindcss/theme`, `tailwindcss/utilities` form.
   - The split import form omits theme variable generation and breaks @layer base font-size overrides.
   - `@layer base { ... @apply ... }` in the main CSS file remains valid in v4.
   - For custom utilities previously in `@layer utilities {}`, migrate to `@utility name { ... }` syntax.
3. Remove obsolete Tailwind config usage
   - v4 does NOT auto-detect tailwind.config.ts/js — delete the file if it has no meaningful content.
   - If a JS config is still needed, explicitly load it with `@config "./tailwind.config.ts";` in app.css.
   - Update related tool configs (for example component generator settings like components.json) to remove stale config references.
4. Scan and fix v4 renamed/removed utilities in templates
   Run this single command to surface all patterns that need attention:
   ```
   rg -n "shadow-sm|drop-shadow-sm|blur-sm|backdrop-blur-sm|rounded-sm|rounded[^-]|outline-none|\bring\b|bg-opacity-|text-opacity-|border-opacity-|flex-shrink|flex-grow|overflow-ellipsis|\[--[a-zA-Z]|@layer utilities|@layer components|theme\(|@tailwind " src/
   ```
   Rename map (v3 -> v4):
   - shadow-sm -> shadow-xs, shadow (bare) -> shadow-sm
   - blur-sm -> blur-xs, blur (bare) -> blur-sm
   - rounded-sm -> rounded-xs, rounded (bare) -> rounded-sm
   - outline-none -> outline-hidden (new outline-none sets style: none, breaking a11y)
   - ring (bare) -> ring-3 (default width changed 3px -> 1px)
   - bg-opacity-*, text-opacity-*, border-opacity-* -> opacity modifiers (e.g. bg-black/50)
   - flex-shrink-* -> shrink-*, flex-grow-* -> grow-*
   - Arbitrary CSS variable syntax: bg-[--var] -> bg-(--var)
   - Important modifier: !flex -> flex!
   - @layer utilities/components -> @utility name { ... }
   - theme(colors.x.y) -> var(--color-x-y)
   - Stacked variants now apply left-to-right (e.g. *:first: not first:*:)
5. Validate light/dark image rendering
   - If logos/icons are PNG assets, prefer a stable CSS class strategy over reactive class toggles for inversion.
   - Example pattern from migration: apply inversion filter to `.logo-img` by default and disable it in `.dark .logo-img`.
   - Keep image class usage simple in markup and avoid fragile theme-store-dependent class interpolation.
6. Configure editor support for Tailwind directives (VS Code)
   - Install and enable Tailwind CSS IntelliSense (`bradlc.vscode-tailwindcss`).
   - In Tailwind v4 projects, use canonical entry import syntax in the main stylesheet: `@import 'tailwindcss';`.
   - Add workspace settings so CSS files use Tailwind language mode and the extension can resolve the v4 entry file:
     - `"files.associations": { "*.css": "tailwindcss" }`
     - `"tailwindCSS.experimental.configFile": "src/app.css"` (adjust path per project)
   - Use `Tailwind CSS: Show Output` to confirm extension activation before changing build config.

Phase 5: Regression Prevention Checklist
- Navigation/loading indicators are hidden at idle and visible only during transitions.
- Error routes still render correct status/message after state API changes.
- Theme toggles and icon logic still work in light and dark mode.
- PNG/SVG branding images render correctly in both light and dark themes (no washed-out or invisible logo).
- Heading hierarchy (h1/h2/h3) renders at correct distinct sizes after migration.
- Links/buttons do not use invalid native HTML attributes (variant, size, alt on svg).
- Script commands consistently use selected package manager.
- No duplicated or malformed markup introduced during migration edits.
- Playwright integration tests use system browser via executablePath rather than downloading browsers into the repo.

Phase 6: Validation Gates
Run in order; stop and fix on any failure before proceeding:
```
pnpm outdated                          # confirm no direct packages remain outdated
pnpm run check                         # svelte-check: 0 errors, 0 warnings
pnpm run lint                          # prettier + eslint clean
pnpm exec vitest run                   # unit tests pass
pnpm run test:integration              # playwright integration tests pass
```
Manual smoke tests after automated gates:
- Home route, error route, navigation transitions, theme switch, key UI flows.
- Heading hierarchy (h1 > h2 > h3) visually distinct at expected sizes.
- Logo/branding images correct in both light and dark mode.

Final diff review:
- Every changed file has a migration reason.
- No unrelated edits remain.

Deliverables
- Updated package graph (`dependencies` and `devDependencies`) and lockfile strategy
- Migrated app/state usage
- Tailwind v4-compatible CSS/PostCSS setup
- Pre-publishing workflow script and README documentation
- Passing checks/tests
- Short migration notes for other developers

Common Pitfalls and Fixes
- Pitfall: Progress bar always visible after switching to $app/state.
  Fix: Use explicit field checks (example: navigating.to) instead of checking navigating object truthiness.
- Pitfall: TypeScript error for missing Node type definitions.
  Fix: Add @types/node as a dev dependency.
- Pitfall: Old package-manager commands remain in scripts/docs.
  Fix: Normalize scripts/docs to the chosen manager.
- Pitfall: README/docs were not migrated with the package-manager switch.
   Fix: Update README command examples and installation instructions to match chosen package-manager policy.
- Pitfall: Migration upgrades only framework packages and misses other direct packages.
   Fix: Explicitly upgrade all direct packages in `dependencies` and `devDependencies`, then verify with an outdated check.
- Pitfall: pnpm migration done, but lockfile policy is unclear or mixed lockfiles remain.
   Fix: Decide whether `pnpm-lock.yaml` is committed or intentionally ignored, document the rationale, and enforce one-lockfile policy in repo.
- Pitfall: Dark/light logo filter fix regresses during Tailwind migration.
   Fix: Keep theme-dependent image filtering in centralized CSS (for example `.logo-img` + `.dark .logo-img`) and include visual smoke tests.
- Pitfall: Deprecated config keys remain in framework config.
  Fix: Replace deprecated keys with current equivalents and re-run checks.
- Pitfall: Headings (h1/h2/h3) all render at the same size after Tailwind v4 upgrade.
  Fix: Use `@import 'tailwindcss';` (single import) not the split preflight/theme/utilities form. The split form does not generate theme variables needed for `@layer base` font-size `@apply` rules to work.
- Pitfall: tailwind.config.ts left in repo but not loaded, causing confusion.
  Fix: v4 does not auto-detect JS/TS config. Delete the file if empty/unused, or explicitly add `@config "./tailwind.config.ts";` in app.css.
- Pitfall: Invalid HTML attributes on native elements cause svelte-check errors after Svelte 5 upgrade.
  Fix: Remove non-standard attributes such as `variant`, `size` on `<a>` tags and `alt` on `<svg>` elements (use `aria-label` instead).
- Pitfall: Svelte reactive declarations (`$:`) flagged as immutable by eslint-plugin-svelte v3.
  Fix: Replace `$: x = CONSTANT` with `const x = CONSTANT` for values that don't change reactively.
- Pitfall: `each` blocks missing keys flagged by eslint-plugin-svelte v3.
  Fix: Add a unique key to every `{#each items as item (item.id)}` block.
- Pitfall: Playwright integration tests attempt to download their own Chromium, failing in environments with a system browser.
  Fix: Set `use.launchOptions.executablePath` in playwright.config.ts to the system browser path (e.g. `/usr/bin/chromium-browser`). Use `process.env.CHROMIUM_PATH` with a fallback for portability.
- Pitfall: mode-watcher ≥1.x no longer exports Svelte stores; `$mode` store syntax breaks.
  Fix: Switch to `mode.current` (e.g. `{#if mode.current === 'light'}`). Import `mode` from `mode-watcher` unchanged; just drop the `$` prefix and access `.current`.
- Pitfall: GitHub Actions uses `npm ci` in a pnpm-standardized repo and fails with peer-resolution conflicts (for example `ERESOLVE` with stale `package-lock.json` versions).
   Fix: set up pnpm in workflow (`pnpm/action-setup` + `actions/setup-node` with pnpm cache) and run `pnpm install --frozen-lockfile` / `pnpm run build`.
- Pitfall: Tailwind v4 build fails with `[postcss] ENOENT ... /<repo>/tailwindcss` when using `@import 'tailwindcss';` in some Vite 8 + pnpm environments.
   Fix: use explicit CSS entry import `@import 'tailwindcss/index.css';` while keeping Tailwind v4 PostCSS plugin configuration.
- Pitfall: GitHub Actions emits Node 20 deprecation warnings because workflow actions still use old majors (`actions/checkout@v4`, `actions/setup-node@v4`, `pnpm/action-setup@v4`).
   Fix: upgrade to Node 24-capable action majors (`@v6`) and keep workflow runtime on `node-version: 24`.
- Pitfall: VS Code reports `Unknown at rule @apply` in valid Tailwind v4 stylesheets.
   Fix: install/enable Tailwind CSS IntelliSense, map `*.css` to `tailwindcss` language mode, point `tailwindCSS.experimental.configFile` at the entry stylesheet, and verify server status with `Tailwind CSS: Show Output`.

Reusable Command Sequence (copy-paste template)
```
# 1. Upgrade all deps to latest
pnpm up --latest
pnpm add -D @tailwindcss/postcss @types/node

# 2. Scan for Tailwind v4 breaking patterns
rg -n "shadow-sm|drop-shadow-sm|blur-sm|backdrop-blur-sm|rounded-sm|rounded[^-]|outline-none|\bring\b|bg-opacity-|text-opacity-|border-opacity-|flex-shrink|flex-grow|overflow-ellipsis|\[--[a-zA-Z]|@layer utilities|@layer components|theme\(|@tailwind " src/

# 3. Validation gates
pnpm outdated
pnpm run check
pnpm run lint
pnpm exec vitest run
pnpm run test:integration
```

Note
- Adapt this plan to the project risk profile. For high-traffic apps, stage migration in smaller commits and validate each phase independently.
