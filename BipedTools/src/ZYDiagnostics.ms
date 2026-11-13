-- 诊断默认关闭。只读上下文；不在回调中采样动画、读取 transform 或创建场景节点。
global ZYDiagEvent,DTrajEdit_Rollout,yunTrajedit_rollout
global ZYDiagEnabled,ZYDiagDir,ZYDiagWatcher,ZYDiagUI,ZYDiagLastState,ZYBipedRoot
if ZYDiagEnabled==undefined do ZYDiagEnabled=false
fn ZYDiagQuote value =
(
 local s=value as string
 s=substituteString s "\\" "\\\\";s=substituteString s "\"" "\\\""
 s=substituteString s "\n" "\\n";s=substituteString s "\r" "\\r";s=substituteString s "\t" "\\t"
 "\""+s+"\""
)
fn ZYDiagMessageBox text title:"MAXScript" =
(
 ZYDiagEvent "message_box" (title+": "+text)
 messageBox text title:title
)
fn ZYDiagQueryBox text title:"MAXScript" =
(
 ZYDiagEvent "confirmation_shown" (title+": "+text)
 local result=queryBox text title:title
 ZYDiagEvent "confirmation_result" (result as string)
 result
)
fn ZYDiagState =
(
 local names="["
 for i=1 to selection.count do (if i>1 do names+=",";names+=ZYDiagQuote selection[i].name)
 names+="]"
 "\"frame\":"+(sliderTime.frame as string)+",\"autoKey\":"+(if animButtonState then "true" else "false")+",\"scene\":"+(ZYDiagQuote (maxFilePath+maxFileName))+",\"selection\":"+names
)
fn ZYDiagSaveError detail =
(
 try
 (
  local folder=(getDir #plugcfg)+@"\ZhuoyuBipedLogs\"
  (dotNetClass "System.IO.Directory").CreateDirectory folder
  local stamp=(dotNetClass "System.DateTime").Now.ToString "o"
  (dotNetClass "System.IO.File").AppendAllText (folder+"Tool-errors.log") (stamp+" | "+detail+" | "+maxFilePath+maxFileName+"\n") (dotNetObject "System.Text.UTF8Encoding" false)
 )catch()
)
fn ZYDiagEvent kind detail =
(
 if kind=="script_error" do ZYDiagSaveError detail
 if ZYDiagEnabled do
 (
  try
  (
   local stamp=(dotNetClass "System.DateTime").UtcNow.ToString "o"
   local line="{\"utc\":"+(ZYDiagQuote stamp)+",\"kind\":"+(ZYDiagQuote kind)+",\"detail\":"+(ZYDiagQuote detail)+","+(ZYDiagState())+"}\n"
   (dotNetClass "System.IO.File").AppendAllText (ZYDiagDir+"maxscript.jsonl") line (dotNetObject "System.Text.UTF8Encoding" false)
  )catch(format "ZY 诊断写入失败：%\n" (getCurrentException()))
 )
 true
)
fn ZYDiagSnapshot =
(
 ZYDiagEvent "snapshot" ("Max="+(maxVersion() as string)+"; range="+(animationRange as string))
 -- 用户明确点击时才枚举 key；不从编辑/绘制回调读取 Biped 轨道。
 for n in selection where classOf n==Biped_Object do
 (
  local ctrls=if classOf n.controller==Vertical_Horizontal_Turn then #(n.controller.vertical.controller,n.controller.horizontal.controller,n.controller.turning.controller) else #(n.controller)
  for i=1 to ctrls.count do
  (
   local values=""
   for k=1 to numKeys ctrls[i] do values+=((getKeyTime ctrls[i] k).frame as string)+(if isKeySelected ctrls[i] k then "* " else " ")
   ZYDiagEvent "key_snapshot" (n.name+";track="+(i as string)+";frames="+values+" (*=selected)")
  )
 )
)
fn ZYDiagStop =
(
 if ZYDiagEnabled do
 (
  ZYDiagEvent "session_stop" "用户停止诊断"
  (dotNetClass "System.IO.File").WriteAllText (ZYDiagDir+"stop.signal") "stop"
  ZYDiagEnabled=false
 )
 if ZYDiagUI!=undefined do try(ZYDiagUI.idle.active=false;ZYDiagUI.status.text="记录已停止；文件保留在本地。")catch()
)
fn ZYDiagStart =
(
 if ZYDiagEnabled do return false
 local folder=(getDir #plugcfg)+@"\ZhuoyuBipedLogs\"
 local stamp=(dotNetClass "System.DateTime").Now.ToString "yyyyMMdd_HHmmss_fff"
 ZYDiagDir=folder+stamp+"\\"
 (dotNetClass "System.IO.Directory").CreateDirectory ZYDiagDir
 ZYDiagEnabled=true;ZYDiagLastState=""
 ZYDiagEvent "session_start" "本工具操作、Max 前台鼠标/修饰键、选择/帧/Auto Key、可见错误弹窗；不记录输入文字，不承诺完整重放或自动 dump。"
 local currentProcess=(dotNetClass "System.Diagnostics.Process").GetCurrentProcess()
 local pid=currentProcess.Id
 local netLog=logsystem.getNetLogFileName()
 local info=dotNetObject "System.Diagnostics.ProcessStartInfo" "powershell.exe"
 info.Arguments="-NoProfile -ExecutionPolicy Bypass -File \""+ZYBipedRoot+"Watch-Max.ps1\" -MaxPid "+(pid as string)+" -SessionDir \""+(trimRight ZYDiagDir "\\")+"\" -MaxLog \""+netLog+"\""
 info.UseShellExecute=false;info.CreateNoWindow=true;info.WindowStyle=(dotNetClass "System.Diagnostics.ProcessWindowStyle").Hidden
 ZYDiagWatcher=(dotNetClass "System.Diagnostics.Process").Start info
 ZYDiagSnapshot()
 ZYDiagUI.idle.active=true;ZYDiagUI.status.text="正在记录；复现操作后停止并导出。"
 true
)
fn ZYDiagExport =
(
 if ZYDiagDir==undefined do return false
 ZYDiagStop()
 if ZYDiagWatcher!=undefined do ZYDiagWatcher.WaitForExit 4000
 local zip=(trimRight ZYDiagDir "\\")+".zip"
 if doesFileExist zip do zip=(trimRight ZYDiagDir "\\")+"_"+((dotNetClass "System.DateTime").Now.ToString "HHmmss")+".zip"
 dotNet.loadAssembly (if (maxVersion())[1]>=28000 then "System.IO.Compression.ZipFile" else "System.IO.Compression.FileSystem")
 (dotNetClass "System.IO.Compression.ZipFile").CreateFromDirectory ZYDiagDir zip
 ZYDiagUI.status.text="已导出 ZIP；不包含 .max 工程。"
 shellLaunch (getFilenamePath zip) ""
 zip
)
rollout ZYDiagUI "诊断记录 · 默认关闭" width:420 height:292
(
 label info "先开始记录 → 复现一次 → 标记现象 → 停止并导出。" width:400 align:#left
 label scope "记录操作线索；停止后导出 ZIP；更多菜单可直接打开日志。" width:400 align:#left
 button start "开始记录" width:190 height:28 across:2 align:#left tooltip:"启用本地记录；后台观察器独立于 Max。仅记录 Max 前台鼠标、修饰键和错误弹窗，不记录键入文字。"
 button stop "停止记录" width:190 height:28 align:#right
 button snapshot "记录关键帧快照" width:190 height:28 across:2 align:#left tooltip:"选好骨骼和 Track Bar 关键帧后点击。只在此时记录所选 Biped 的 key 时间和选中标记。"
 button btn_openFolder "打开日志文件夹" width:190 height:28 align:#right
 edittext note "现象：" text:"例如：开 Bs 轨迹，Shift 拖复制 0–10 到 50–60" width:394 height:44 align:#left
 button mark "写入现象标记" width:190 height:28 across:2 align:#left
 button export "停止并导出 ZIP" width:190 height:28 align:#right
 label status "尚未开始。关闭本窗口会停止记录。" width:400 align:#left
 timer idle interval:250 active:false
 on start pressed do ZYDiagStart()
 on stop pressed do ZYDiagStop()
 on snapshot pressed do (if ZYDiagEnabled then ZYDiagSnapshot() else status.text="请先开始记录。")
 on btn_openFolder pressed do ZYOpenLogFolder()
 on mark pressed do (ZYDiagEvent "user_marker" note.text;status.text="已写入现象标记。")
 on export pressed do ZYDiagExport()
 on idle tick do
 (
  if ZYDiagEnabled do
  (
   local state=ZYDiagState()
   if state!=ZYDiagLastState do (ZYDiagEvent "state_change" "";ZYDiagLastState=state)
  )
 )
 on ZYDiagUI close do ZYDiagStop()
)
fn ZYDiagOpen =
(
 if ZYDiagUI.open do return true
 createDialog ZYDiagUI style:#(#style_titlebar,#style_sysmenu,#style_toolwindow)
)
