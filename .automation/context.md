# wendall911 — Project Context

## What This Is
Meta-repository representing the wendall911 GitHub account. Contains multiple independent Minecraft mod sub-repositories and one mixed web project (ModrinthBadge-Unofficial). This repo is a workspace root and a governance hub — it is not a single deployable project.

## Sub-Repositories
Each subdirectory with a `.git` folder is an independent repository. Active mod projects:
- ActuallyHarvest, BetterDays, BetterWorldgen, ChargedCharms, CreeperFireworks, CroptopiaHandbook
- ExampleMod, Handbook, Homeostatic, HomeostaticSeasons, MagicalPsiRevival, MobChampions
- ModpackUpdater, ModrinthBadge-Unofficial, ReadyPlayerFun, SimpleTextOverlay, SlurpReborn
- SurvivalistEssentials, SurvivalistEssentialsModpack, TCIntegrations, TinkerSurvival
- TinkerSurvivalModpack, TunnelTrench, WhiteNoise

Each sub-repository has its own `.automation/context.md` describing its structure, supported modloaders, and active branches. The context for these should only be read when explicitly asked for.

## ModrinthBadge-Unofficial
Mixed project. The repo root is a Python API. The `modrinth.roughness.technology/` subdirectory is a SvelteKit/Tailwind frontend hosted at modrinth.roughness.technology. These are separate concerns — do not conflate them. See that repo's own `project-context.md`.

## Branch Convention (Minecraft Mods)
- Branch names correspond directly to the targeted Minecraft version (e.g. `26.1`, `1.20.1`)
- There is no canonical `main` branch — all version branches are active, independent release streams
- Active branches per mod vary; each mod's `project-context.md` documents which branches are maintained
- Default to `26.1` when it exists; fall back to `1.20.1` for older projects
- `BetterWorldgen` is an exception — it remains on its own existing branch
- Modloader support (NeoForge, Fabric, or both) varies per mod and per branch — check the mod's context before assuming

## Modloader History and Strategy
- `1.12.2`: Forge only — dominant loader, still widely played
- `1.13`–`1.20.1`: Forge only — Fabric emerged due to Forge's delayed 1.13 support, but these projects stayed on Forge through 1.20.1
- Multiloader adoption began with Architectury — abandoned due to poor maintenance and slow updates
- Switched to MultiLoader-Template pattern, forked as ExampleMod due to the same slow-update problem
- `1.21.1` onward: NeoForge replaces Forge — Forge's maintainer is shadow banned in the community; founding members forked the project to create NeoForge
- Current multiloader target: NeoForge + Fabric for all post-1.20.1 work
- NeoForge and Fabric have increasing API convergence, progressively reducing dependence on WhiteNoise as a cross-loader bridge

Forking slow or stalled upstream dependencies is a recurring pattern across these projects.

## Version Maintenance Strategy
Actively maintained branches: `1.20.1`, `1.21.1`, and the current latest (`26.1`).

Branch lifecycle:
- A branch is cut for the major version when development starts (e.g. `26.1`)
- Patch releases within that major land on the same branch (e.g. 26.1.1, 26.1.2)
- If a patch version becomes a popular long-term target, it gets its own independent branch for maintenance — `1.21.1` is the established example (the 1.21 series ran to 1.21.11, but 1.21.1 is the stable/popular version)
- Popularity as a signal for branching is not time-predictable — it can emerge weeks or months after release; do not assume a version is done being tracked
- When a new major lands (e.g. 26.2), the prior major branch (26.1) is maintained for a period to ensure bugs are fixed before full migration

## Release Process (Minecraft Mods)
See `docs/minecraft/MINECRAFT_DEVELOPMENT_NOTES.md` for the full release sequence:
1. Bump version in `gradle.properties` (or project settings)
2. Bump available versions in `files/updates.json`
3. `git commit -a -m "Release x.x.x"`
4. `git tag x.x.x`
5. `git push origin`
6. `git push --tags`
7. `./gradlew build`
8. `./gradlew publishMods` (publishes to Modrinth and CurseForge)

Deployment is incomplete until both commit and tags are pushed. Do not skip steps or reorder them.

VCS operations are banned for AI tools.

## Modpacks
A modpack is a published collection of mods including configurations, datapack
overrides, and texture pack overrides. Modpacks target a specific modloader and
are distributed via CurseForge and Modrinth.

For wendall911 projects, modpacks are distributed on CurseForge only — not
Modrinth. CurseForge has a larger mod selection which is the primary reason.

Modpacks have separate client-side and server-side mod lists, as mods can be:
- Client-side only
- Server-side only
- Both (most common)

This designation is defined in each mod's build file upload configuration.

## Workspace Governance
- All projects governed by AI_CONDUCT.md

## Reference Docs
- `docs/minecraft/MINECRAFT_DEVELOPMENT_NOTES.md` — Gradle tasks, release steps, decomp source setup
