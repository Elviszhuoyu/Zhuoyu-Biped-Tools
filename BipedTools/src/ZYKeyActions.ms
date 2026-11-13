-- 补帧仅改变关键帧密度；使用原 Biped.addNewKey API，不提交未记录的新姿势。
global ZYKeyMenu,ZYKeyAllParts=false,ZYKeyLastResult,ZYKeyMenuSource
fn ZYKeyReport text detail:"" =
(
 ZYKeyLastResult=text
 for rollName in #(#BipedPicker_Rollout,#Keys_Rollout) do
 (
  local ui=getProperty g_ZYLB_BH rollName
  if ui!=undefined and ui.open and isProperty ui #lbl_ZYKeyStatus do
  (
   ui.lbl_ZYKeyStatus.text=text
   ui.lbl_ZYKeyStatus.tooltip=text+"\n"+detail
  )
 )
 format "%\n" text
 ZYDiagEvent "key_result" (text+";"+detail)
 false
)
fn ZYKeyApply allParts rangeMode =
(
 local g=g_ZYLB_BH
 if g==undefined or not isValidNode g.bRoot do return ZYKeyReport "未执行：先选择当前 Biped。"
 if g.bRoot.controller.figureMode do return ZYKeyReport "未执行：请退出形体模式。"
 local nodes=#()
 if allParts then
 (
  -- 与原全身补帧相同的主要轨道；缺少尾巴等节点时跳过。
  for prop in #(#bRoot,#bPelvis,#bSpine1,#bHead,#bHandL,#bHandR,#bFootL,#bFootR,#bTail) do
  (
   local n=getProperty g prop
   if isValidNode n do appendIfUnique nodes n
  )
 )
 else
 (
  if selection.count==0 do return ZYKeyReport "未执行：先选择 Biped 部件。"
  local invalid=for n in selection where classOf n!=Biped_Object or findItem g.a_bipedAllParts n==0 collect n
  if invalid.count>0 do return ZYKeyReport "未执行：所选须为当前 Biped 部件。" detail:"网格、自定义武器 Bone 和其他角色不支持此补帧按钮；请使用它们自己的动画控制器。"
  nodes=selection as array
 )
 local first=sliderTime;local last=sliderTime;local stepSize=1
 if rangeMode do
 (
  local ui=if ZYKeyMenuSource==#helper then g.SelectionDisplayTime_Rollout else g.BipedPicker_Rollout
  if ui.open and ui.rdobtns_timeRange.state==1 then
  (first=animationRange.start;last=animationRange.end)
  else (first=g.TRstart;last=g.TRend)
  stepSize=g.TRstep
 )
 if first>last do return ZYKeyReport "未执行：开始帧不能大于结束帧。"
 local frames=0;local failures=#();local cancelled=false
 ZYDiagEvent "tool_begin" ("add_keys;all="+(allParts as string)+";range="+(rangeMode as string))
 undo "Zhuoyu Biped Add Keys" on
 (
  for t=first to last by stepSize while not cancelled do
  (
   if keyboard.escPressed then cancelled=true else
   (
    for n in nodes do
     try(g.f_addKeysToSelectedParts n atTime:t)catch(appendIfUnique failures (n.name+": "+getCurrentException()))
    frames+=1
   )
  )
 )
 local desc=(nodes.count as string)+" 部件 × "+(frames as string)+" 时刻"
 local detail="范围 "+(first as string)+" ～ "+(last as string)+"，步长 "+(stepSize as string)+"。已有键不重复新增；动作通常不变。请在摄影表 / 轨迹视图检查键，Ctrl+Z 可撤销。"
 if failures.count>0 then ZYKeyReport ("部分失败："+desc) detail:(detail+"\n"+(failures as string))
 else if cancelled then ZYKeyReport ("已停止："+desc) detail:detail
 else (ZYKeyReport ("补帧完成："+desc) detail:detail;ZYDiagEvent "tool_end" "add_keys";return true)
 false
)
rcmenu ZYKeyMenu
(
 menuItem atCurrent "当前帧补帧"
 menuItem inRange "按范围补帧（时间轴 / 自定）"
 on atCurrent picked do ZYKeyApply ZYKeyAllParts false
 on inRange picked do ZYKeyApply ZYKeyAllParts true
)
fn ZYKeyOpenMenu allParts source:#picker = (ZYKeyAllParts=allParts;ZYKeyMenuSource=source;popUpMenu ZYKeyMenu)
