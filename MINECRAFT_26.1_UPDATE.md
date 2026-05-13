Update gradle to latest
./gradlew wrapper --gradle-version latest

Update accesswidener from named to official

Change fabric-loom to net.fabricmc.fabric-loom in Fabric/build.gradle and build.gradle

Fabric/build.gradle
  modImplementation -> implementation
  modLocalRuntime -> runtimeOnly
  modCompileOnly -> compileOnly
  remove Mixin block
  remove mappings function
  
fabric.mod.json
  change "fabric": "*", to "fabric-api": "${fabric_api_min_version}",
  add fabric_api_min_version to multiloader-common.gradle and gradle.properties
  
https://docs.fabricmc.net/26.1/develop/porting/fabric-api
  
GuiGraphics -> GuiGraphicsExtractor
  renderItem -> item
  renderItemDecorations -> itemDecorations
  (Screen) super.render -> extractRenderState
  (Screen) renderBackground -> extractBackground
  (GuiGraphicsExtractor) drawString -> text
  BlockModelWrapper -> CuboidItemModelWrapper
  renderContents -> extractContents
  submitEntityRenderState -> entity
  drawString -> text
  
    private componentHoverEffect(Lnet/minecraft/client/gui/Font;Lnet/minecraft/network/chat/Style;II)V
    
level.get().getDayTime() -> level.get().getDefaultClockTime()
