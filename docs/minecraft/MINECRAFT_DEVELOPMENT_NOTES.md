# Dev Notes for 1.12+ modding

## Version Maintenance Strategy
See `.github/project-context.md` in the wendall911 repo for the full branching and version maintenance strategy.

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
Bump version in gradle.properties or project.settings or whatever.
Bump available versions in files/updates.json
git commit -a -m "Release x.x.x"
git tag x.x.x
git push origin
git push --tags
./gradlew build
./gradlew publishMods
Profit!!!

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
