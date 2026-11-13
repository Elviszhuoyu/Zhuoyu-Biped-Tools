-- 仅更新自有工具目录，不覆盖 LB Tools/BsKeyTools 或工程文件。
(
 if (maxVersion())[1]<22000 do throw "Zhuoyu Biped Tools requires Max 2020 or newer."
 global g_ZYLB_BH,ZYTrailUI,ZYBipedLauncher,ZYMapUI,ZYDiagUI,ZYDiagStop
 try(ZYSideSuspend())catch();try(ZYDiagStop())catch();try(destroyDialog ZYDiagUI)catch();try(destroyDialog ZYMapUI)catch()
 try(destroyDialog ZYBuiltinMapUI)catch()
 try(destroyDialog ZYTrailUI)catch();try(destroyDialog g_ZYLB_BH.BipedPicker_Rollout)catch()
 try(closeRolloutFloater g_ZYLB_BH.bipedUI_Floater)catch();try(destroyDialog ZYBipedLauncher)catch()
 -- 关闭旧窗口后回收其图标资源，避免反复重装累计 GDI 对象。
 gc()
 local sourceRoot=getFilenamePath(getSourceFileName())
 local targetRoot=(getDir #userScripts)+@"\ZhuoyuBipedTools\"
 local io=dotNetClass "System.IO.File";local dirs=dotNetClass "System.IO.Directory"
 dirs.CreateDirectory targetRoot;dirs.CreateDirectory (targetRoot+"ZYLB");dirs.CreateDirectory (targetRoot+"Macros")
 for relative in #(@"Guide.html",@"GuideImages\picker.png",@"GuideImages\drag.png",@"GuideImages\hover_main.png",@"GuideImages\side.png",@"Macros\Zhuoyu Biped-ZYBiped_Diagnostics.mcr",@"Macros\Zhuoyu Biped-ZYBiped_Groups.mcr",@"Macros\Zhuoyu Biped-ZYBiped_Tools.mcr",@"Macros\Zhuoyu Biped-ZYLB_bipedHelper.mcr",@"Macros\Zhuoyu Biped-ZYLB_bipedHelperPicker.mcr",@"Watch-Max.ps1",@"ZYBiped_Launcher.ms",@"ZYDiagnostics.ms",@"ZYGroupButtons.ms",@"ZYIntegration.ms",@"ZYKeyActions.ms",@"ZYLB\LBTools_BipedHelper_16i.bmp",@"ZYLB\LBTools_BipedHelper_24i.bmp",@"ZYLB\LBTools_BipedHelper_ApplyTransform1.png",@"ZYLB\LBTools_BipedHelper_ApplyTransform1_Mask.png",@"ZYLB\LBTools_BipedHelper_ApplyTransform2.png",@"ZYLB\LBTools_BipedHelper_ApplyTransform2_Mask.png",@"ZYLB\LBTools_BipedHelper_Picker_16i.bmp",@"ZYLB\LBTools_BipedHelper_Picker_24i.bmp",@"ZYLB\LBTools_BipedHelper_Picker_AT_FC.png",@"ZYLB\LBTools_BipedHelper_Picker_AT_FC_Mask.png",@"ZYLB\LBTools_BipedHelper_Picker_AT_XYZ.png",@"ZYLB\LBTools_BipedHelper_Picker_AT_XYZ_Mask.png",@"ZYLB\LBTools_BipedHelper_Picker_Display.png",@"ZYLB\LBTools_BipedHelper_Picker_Display_Mask.png",@"ZYLB\LBTools_BipedHelper_Picker_GeometrySnapshot.png",@"ZYLB\LBTools_BipedHelper_Picker_GeometrySnapshot_Mask.png",@"ZYLB\LBTools_BipedHelper_Picker_Keys.png",@"ZYLB\LBTools_BipedHelper_Picker_Keys_Mask.png",@"ZYLB\LBTools_BipedHelper_Picker_LimbSpaces.png",@"ZYLB\LBTools_BipedHelper_Picker_LimbSpaces_Mask.png",@"ZYLB\LBTools_BipedHelper_Picker_PoseBuffer.png",@"ZYLB\LBTools_BipedHelper_Picker_PoseBuffer_Mask.png",@"ZYLB\LBTools_BipedHelper_Picker_TrajectoryHelpers.png",@"ZYLB\LBTools_BipedHelper_Picker_TrajectoryHelpers_Mask.png",@"ZYLB\LBTools_Guide_Image.bmp",@"ZYLB\ZYLB_Biped_Helper.ms",@"ZYLB\ZYLB_Core_en.ms",@"ZYLB\ZYLB_Core_zh.ms",@"ZYMappings.ms",@"ZYBuiltinBindings.ms",@"ZYBindingStorage.ms",@"ZYNativeGroups.netfx.dll",@"ZYNativeGroups.net8.dll",@"ZYRigCatalog.ms",@"ZYRigGroups.ms") do (dirs.CreateDirectory (getFilenamePath (targetRoot+relative));io.Copy (sourceRoot+"payload\\"+relative) (targetRoot+relative) true)
 local startupFile=(getDir #userStartupScripts)+@"\ZhuoyuBipedTools_Startup.ms"
 dirs.CreateDirectory (getDir #userStartupScripts);dirs.CreateDirectory (getDir #userIcons)
 io.Copy (sourceRoot+"payload\\ZhuoyuBipedTools_Startup.ms") startupFile true
 for name in #("LBTools_BipedHelper_16i.bmp","LBTools_BipedHelper_24i.bmp","LBTools_BipedHelper_Picker_16i.bmp","LBTools_BipedHelper_Picker_24i.bmp") do io.Copy (targetRoot+"ZYLB\\"+name) ((getDir #userIcons)+"\\"+substituteString name "LBTools" "ZYLB") true
 local ini=(getDir #plugcfg)+@"\ZYLB_BipedHelper.ini"
 -- 首次安装与旧版留下的半成品配置均补齐；已有设置保留。
 if getIniSetting ini "Picker" "Height" == "" do setIniSetting ini "Picker" "Height" "1"
 if getIniSetting ini "BipedPanel" "CurrentBip" == "" do setIniSetting ini "BipedPanel" "CurrentBip" "1"
 setIniSetting ini "LocalVersion" "Layout" "1.9.8"
 -- 退役本工具旧轨迹宏，保留文件备份；不修改 BsKeyTools。
 local retiredMacro=(getDir #userMacros)+@"\Zhuoyu Biped-ZYBiped_Trail.mcr"
 if doesFileExist retiredMacro do
 (
  local backupMacro=retiredMacro+".disabled"
  if not doesFileExist backupMacro do io.Copy retiredMacro backupMacro false
  deleteFile retiredMacro
 )
 -- 当前 Max 会话可能仍保留旧宏；旧入口只提示，不再调用轨迹脚本。
 global ZYOpenBsTrail
 fn ZYOpenBsTrail = (messageBox "请直接在 BsKeyTools 工具箱中打开轨迹工具。" title:"轨迹入口已移除")
 fileIn startupFile
 colorMan.reInitIcons()
 fileIn (targetRoot+"ZYBiped_Launcher.ms")
 format "Zhuoyu Biped Tools 1.9.8 installed: %\n" targetRoot
 targetRoot
)
