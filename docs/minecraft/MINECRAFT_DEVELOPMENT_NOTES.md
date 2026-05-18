# Dev Notes for 1.12+ modding

## Version Maintenance Strategy
See `.github/project-context.md` in the wendall911 repo for the full branching and version maintenance strategy.

## Session Start

Before beginning any development session:

1. `git status` — confirm clean working tree and verify the current branch
2. `git pull` — pull remote changes; fast-forwards if no local commits diverge
3. If git warns that it cannot automatically rebase, run `git rebase` directly

External contributions via PRs arrive occasionally. Always pull before starting work.

## Show gradlew tasks
./gradlew tasks

Important Build Tasks
-----------
build - Assembles and tests this project.
clean - Deletes the build directory.
runClient - Runs the Minecraft client
runServer - Runs the Minecraft Server
setupDecompWorkspace - DevWorkspace + the deobfuscated Minecraft source linked as a source jar.
setupDevWorkspace - CIWorkspace + natives and assets to run and test Minecraft
publishMods - Uploads all Modrinth and CurseForge projects 

## Steps to release build

**Versioning**

Versions follow semantic versioning in the form `minecraft_version-major.minor.patch` or
`minecraft_version-major.minor.patch.build`. The build segment is used for housekeeping
changes where no features were added or removed. Tagging is required on all public-facing
releases — always tag, no exceptions.

**Bug fixes across branches**

Before starting a bug fix, identify which other branches need the same patch. Plan commits
for cherry-pick compatibility. If upstream Minecraft code has diverged too far for a
cherry-pick to apply cleanly, use a diff strategy instead. Each branch that needs the fix
gets its own release.

**Release sequence**

1. Ensure all code changes are committed and the working tree is clean.
2. Move current version to last version in `files/updates.json`. Bump version in `gradle.properties`.
3. Run `./scripts/release_dryrun` — builds all loaders, dry-publishes to the private Discord `#dryrun` channel.
4. Check Discord: verify the changelog looks correct and covers only the intended range of commits. If the previous version tag is wrong, the entire git history will appear as the changelog — fix the tag before continuing.
5. Run `git diff` to confirm `files/updates.json` and `gradle.properties` look right.
6. `git commit -m "Release minecraft_version-major.minor.patch"`
7. `git tag minecraft_version-major.minor.patch`
8. `git push && git push --tags`
9. Run `./scripts/do_release` — verifies the tag is present, builds all loaders, publishes with `DO_RELEASE=true`.

## Get decomp sources Forge
cd MinecraftForge
checkout branch
./gradlew clean
./gradlew setup
Viola! : projects/forge/src/main/java/

## Get decomp sources NeoForge
cd NeoFormRuntime
git pull
./gradlew build
./gradlew publish

java -jar build/libs/neoform-runtime-1.0.41-all.jar run --dist joined --neoforge net.neoforged:neoforge:21.9.8-beta:userdev --add-repository=https://maven.parchmentmc.org --parchment-data=org.parchmentmc.data:parchment-1.21.8:2025.07.20:checked@zip --parchment-conflict-prefix=p_ --write-result=compiled:build/minecraft-1.21.9.jar --write-result=clientResources:build/client-extra-1.21.9.jar --write-result=sources:build/minecraft-sources-1.21.9.jar

Check build.gradle runConfigurations for more examples of commands. Readme is not very updated.

mkdir ../../sources/1.21.9-21.9.8-beta
cp build/minecraft-sources-1.21.9.jar ../../sources/1.21.9-21.9.8-beta/
cd ../../sources/1.21.9-21.9.8-beta/
unzip minecraft-sources-1.21.9.jar

## Set java version globally while developing
# alternatives --config java

## Update gradlew and gradle-wrapper.jar
./gradlew wrapper --gradle-version latest
