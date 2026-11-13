-- Shared build for Max 2020-2027.
if (maxVersion())[1]<22000 do throw "Zhuoyu Biped Tools requires Max 2020 or newer."
-- 启动只定义工具和注册入口；不打开窗口、不记录、不读取动画轨道。
global ZYBipedRoot=(getDir #userScripts)+@"\ZhuoyuBipedTools\"
fileIn (ZYBipedRoot+@"ZYLB\ZYLB_Biped_Helper.ms")
macroScript ZYBiped_Tools category:"Zhuoyu Biped" buttontext:"LB Biped 选择器 1.9.8" tooltip:"LB Biped 选择器" icon:#("ZYLB_BipedHelper_Picker",1)
(fileIn ((getDir #userScripts)+@"\ZhuoyuBipedTools\ZYBiped_Launcher.ms"))
macroScript ZYBiped_Groups category:"Zhuoyu Biped" buttontext:"角色控制器绑定" tooltip:"管理当前角色的自定义按钮与控制器绑定"
(ZYMapOpen())
macroScript ZYBiped_Diagnostics category:"Zhuoyu Biped" buttontext:"诊断记录" tooltip:"默认关闭的本地操作线索记录"
(ZYDiagOpen())

ZYPersistToolbarMacros()
