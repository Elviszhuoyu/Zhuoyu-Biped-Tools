-- 选择器自身菜单与日志；轨迹由用户直接在 外部工具 中打开。
global ZYBipedMenu
fn ZYLogFolder = ((getDir #plugcfg)+@"\ZhuoyuBipedLogs\")
fn ZYOpenLogFolder =
(
 (dotNetClass "System.IO.Directory").CreateDirectory (ZYLogFolder())
 shellLaunch (ZYLogFolder()) ""
)
fn ZYOpenMaxLog = (shellLaunch "notepad.exe" ("\""+logsystem.getNetLogFileName()+"\""))
fn ZYBipedClose =
(
 ZYSideWanted=false;ZYSideSuspend();ZYDiagStop();callbacks.removeScripts id:#ZYPickerSelection
 try(destroyDialog ZYDiagUI)catch();try(destroyDialog ZYMapUI)catch()
 try(destroyDialog g_ZYLB_BH.BipedPicker_Rollout)catch()
 try(closeRolloutFloater g_ZYLB_BH.bipedUI_Floater)catch()
)
rcmenu ZYBipedMenu
(
 menuItem helper "完整 Biped 助手"
 menuItem groups "角色控制器绑定…"
 separator sep1
 menuItem diagnostics "操作记录…"
 menuItem logFolder "打开日志文件夹"
 menuItem maxLog "打开 Max.log"
 separator sep2
 menuItem closeTools "关闭本套工具"
 on helper picked do g_ZYLB_BH.f_bipedHelperUI()
 on groups picked do ZYMapOpen()
 on diagnostics picked do ZYDiagOpen()
 on logFolder picked do ZYOpenLogFolder()
 on maxLog picked do ZYOpenMaxLog()
 on closeTools picked do ZYBipedClose()
)
fn ZYBipedMore = (popUpMenu ZYBipedMenu)

-- Max 自动生成的宏文件可能采用系统 ANSI；用安装包内的 UTF-8 副本保留中文命令名。
fn ZYPersistToolbarMacros =
(
 local io=dotNetClass "System.IO.File"
 (dotNetClass "System.IO.Directory").CreateDirectory (getDir #userMacros)
 for source in getFiles (ZYBipedRoot+@"Macros\*.mcr") do
  io.Copy source ((getDir #userMacros)+"\\"+getFilenameFile source+getFilenameType source) true
)
