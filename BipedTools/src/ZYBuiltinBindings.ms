-- 内置按钮共享解析器；覆盖保存节点弱引用，不修改骨架、控制器或动画。
global ZYBuiltinDataDef,ZYBuiltinMapUI,ZYBuiltinOwner,ZYBuiltinKey,ZYBuiltinDraft=#(),ZYBuiltinAutomatic=true,ZYBuiltinDirty=false
global ZYBuiltinTimer,ZYBuiltinReceiver=undefined,ZYBuiltinControls=#(),ZYBuiltinPrevious=#(),ZYBuiltinPreviousKey,ZYBuiltinPreviousOwner,ZYBuiltinPreviousPressId=0
global ZYBuiltinInitFingers,ZYBuiltinData,ZYBuiltinHasOverride,ZYBuiltinRead,ZYBuiltinWrite,ZYBuiltinSpec,ZYBuiltinSelect,ZYBuiltinLabel,ZYBuiltinOpen,ZYBuiltinRefresh,ZYBuiltinStage,ZYBuiltinPickFilter,ZYBuiltinTick
fn ZYBuiltinInitFingers helper =
(
 -- Biped API 返回展平列表；父子关系决定每根手指边界，兼容短拇指及不同节数。
 for side in #(#(#lFingers,"L","Left"),#(#rFingers,"R","Right")) do
 (
  local nodes=#();local roots=#();local chains=#()
  for i=1 to biped.maxNumLinks helper.bRoot do
  (
   local n=biped.getNode helper.bRoot side[1] link:i
   if isValidNode n do appendIfUnique nodes n
  )
  for n in nodes where findItem nodes n.parent==0 do (append roots n;append chains #())
  for n in nodes do
  (
   local ancestor=n
   while findItem nodes ancestor.parent>0 do ancestor=ancestor.parent
   local index=findItem roots ancestor
   if index>0 do append chains[index] n
  )
  local names=#("Thumb","Index","Middle","Ring","Pinky")
  for finger=1 to 5 do for link=1 to 3 do
  (
   local n=if finger<=chains.count and link<=chains[finger].count then chains[finger][link] else undefined
   setProperty helper (("b"+names[finger]+(link as string)+side[2]) as name) n
  )
  local fingers=#();local thumb=if chains.count>0 then chains[1] else #()
  for i=2 to chains.count do join fingers chains[i]
  setProperty helper (("a_fingersOnly"+side[3]) as name) fingers
  setProperty helper (("a_thumb"+side[3]) as name) thumb
 )
 true
)
fn ZYBuiltinData create:false = (ZYBindingData #zyBuiltinSchema "Zhuoyu.BuiltinSelection.v2" ZYBuiltinDataDef create:create)
fn ZYBuiltinSpec key = (for spec in ZYPickerSpecs where spec[1]==key do return spec;undefined)
fn ZYBuiltinHasOverride key =
(
 local data=ZYBuiltinData();local owner=ZYRigRoot()
 if data!=undefined and owner!=undefined do for i=1 to data.owners.count where (ZYBindingNode data.owners[i])==owner and data.buttonKeys[i]==(key as string) do return true
 false
)
fn ZYBuiltinRead key =
(
 local nodes=#();local data=ZYBuiltinData();local owner=ZYRigRoot()
 if data!=undefined and owner!=undefined do for i=1 to data.owners.count where (ZYBindingNode data.owners[i])==owner and data.buttonKeys[i]==(key as string) and ZYRigNodeValid (ZYBindingNode data.targets[i]) do appendIfUnique nodes (ZYBindingNode data.targets[i])
 nodes
)
fn ZYPickerNodes spec = (if ZYBuiltinHasOverride spec[1] then ZYBuiltinRead spec[1] else ZYPickerAutoNodes spec)
fn ZYBuiltinWrite key nodes automatic:false =
(
 local owner=ZYRigRoot()
 if owner==undefined or ZYBuiltinSpec key==undefined do return false
 if not automatic do for n in nodes where not ZYRigNodeValid n do return false
 if automatic and ZYBuiltinData()==undefined do return true
 undo "Bind Picker Button" on
 (
  local data=ZYBuiltinData create:(not automatic);local owners=#();local keys=#();local targets=#()
  for i=1 to data.owners.count where (ZYBindingNode data.owners[i])!=owner or data.buttonKeys[i]!=(key as string) do
   (append owners (ZYBindingNode data.owners[i]);append keys data.buttonKeys[i];append targets (ZYBindingNode data.targets[i]))
  if not automatic do
  (
   local unique=#();for n in nodes do appendIfUnique unique n
   if unique.count==0 do append unique undefined
   for n in unique do (append owners owner;append keys (key as string);append targets n)
  )
  data.owners=ZYBindingRefs owners;data.buttonKeys=keys;data.targets=ZYBindingRefs targets
 )
 true
)
fn ZYBuiltinSelect key =
(
 local spec=ZYBuiltinSpec key
 if spec==undefined do return false
 ZYBuiltinPrevious=selection as array;ZYBuiltinPreviousKey=key;ZYBuiltinPreviousOwner=ZYRigRoot();ZYBuiltinPreviousPressId=ZYNativeInput.ActiveBuiltinPressId
 g_ZYLB_BH.f_selectBipedParts (ZYPickerNodes spec) picker:true
)
fn ZYBuiltinLabel key =
(
 for cache in ZYPickerVisualCache where cache[1]==key do
 (
  local parts=filterString cache[5] "。\n\r."
  if parts.count>0 do return parts[1]
  return cache[4]
 )
 key as string
)
fn ZYBuiltinSyncControl control spec index cache nodes chosen =
(
 local muted=nodes.count==0;local interactive=ZYRigRoot()!=undefined
 local hint=cache[5]+"\n"+(ZYText "Automatic" "自动识别")
 if ZYBuiltinHasOverride spec[1] do hint=cache[5]+"\n"+(ZYText "Manual binding" "手动绑定")
 hint+=" · "+(nodes.count as string)+(ZYText " valid nodes" " 个有效控制器")
 hint+=" · "+(ZYText "Selected " "已选 ")+(chosen as string)
 for n in nodes do hint+="\n"+n.name
 if muted do hint+="\n"+(ZYText "No valid target. Right-click to bind." "暂无有效目标，可右键重新绑定。")
 hint+="\n"+(ZYText "Right-click / double-click: edit binding. Shift/Ctrl: add; Alt: subtract." "右键 / 双击：修改绑定。Shift/Ctrl 加选；Alt 减选。")
 local changed=cache[8]!=hint
 if changed do (control.tooltip=hint;cache[8]=hint)
 local hwnd=control.hwnd[1] as integer64
 local state=if muted then 3 else if chosen==0 then 0 else if chosen==nodes.count then 2 else 1
 if changed or cache[9]!=hwnd or cache[10]!=muted or cache[11]!=interactive or cache[3]!=state do
 (
  ZYNativeInput.ConfigureBuiltin hwnd ZYBuiltinReceiver index muted interactive
  cache[9]=hwnd;cache[10]=muted;cache[11]=interactive
 )
)
fn ZYBuiltinContextSync =
(
 if ZYBuiltinMapUI!=undefined and ZYBuiltinMapUI.open do
 (
  local valid=isValidNode ZYBuiltinOwner and ZYBuiltinOwner==ZYRigRoot()
  ZYBuiltinMapUI.applyBinding.enabled=valid and ZYBuiltinDirty
  local caption=ZYText "Load viewport selection (multi-select)" "载入视口选择（支持多选）"
  if selection.count>0 do caption=(ZYText "Load viewport selection: " "载入视口选择：")+(selection.count as string)+(ZYText " nodes" " 个")
  if ZYBuiltinMapUI.useSelected.text!=caption do ZYBuiltinMapUI.useSelected.text=caption
  for control in #(ZYBuiltinMapUI.useSelected,ZYBuiltinMapUI.pickNode,ZYBuiltinMapUI.previewBinding,ZYBuiltinMapUI.restoreAuto,ZYBuiltinMapUI.clearBinding) do control.enabled=valid
  if not valid do ZYBuiltinMapUI.status.text=ZYText "Character changed. Reopen this editor for the intended character." "当前角色已改变；请关闭并在目标角色上重新打开绑定窗口。"
 )
)
fn ZYBuiltinTargets =
(
 if ZYBuiltinAutomatic then ZYPickerAutoNodes (ZYBuiltinSpec ZYBuiltinKey) else (for n in ZYBuiltinDraft where isValidNode n collect n)
)
fn ZYBuiltinRefresh =
(
 ZYBuiltinMapUI.title=(ZYText "Controller Binding · " "控制器绑定 · ")+(ZYBuiltinLabel ZYBuiltinKey)
 ZYBuiltinMapUI.owner.text=(ZYText "Character: " "角色：")+ZYBuiltinOwner.name
 local nodes=ZYBuiltinTargets()
 local prefix=if ZYBuiltinDirty then (ZYText "Pending: " "待应用：") else (ZYText "Saved binding: " "当前绑定：")
 local mode=if ZYBuiltinAutomatic then (ZYText "Automatic" "自动识别") else (ZYText "Manual" "手动绑定")
 ZYBuiltinMapUI.mode.text=prefix+mode+" · "+(nodes.count as string)+(ZYText " controllers" " 个控制器")
 ZYBuiltinMapUI.nodes.items=for n in nodes collect n.name
 ZYBuiltinMapUI.nodes.tooltip=if nodes.count>0 then ZYMapNodeNames nodes else (ZYText "No target controllers." "当前没有绑定目标。")
 ZYBuiltinMapUI.applyBinding.text=ZYText "Apply binding" "应用绑定"
 ZYBuiltinContextSync()
)
fn ZYBuiltinStage nodes =
(
 if not isValidNode ZYBuiltinOwner or ZYBuiltinOwner!=ZYRigRoot() do (ZYBuiltinContextSync();return false)
 local invalid=for n in nodes where not ZYRigNodeValid n collect n
 if invalid.count>0 do
 (
  ZYBuiltinMapUI.status.text=(ZYText "Not loaded: " "未载入：")+(invalid.count as string)+(ZYText " invalid/other-character objects. Previous draft kept." " 个对象不属于当前角色的有效控制器；原列表保持不变。")
  return false
 )
 ZYBuiltinDraft=#();for n in nodes do appendIfUnique ZYBuiltinDraft n
 ZYBuiltinAutomatic=false;ZYBuiltinDirty=true;ZYBuiltinRefresh()
 ZYBuiltinMapUI.status.text=(ZYText "Loaded " "已载入 ")+(ZYBuiltinDraft.count as string)+(ZYText " controllers. Review the list, then Apply binding." " 个控制器；核对上方列表后点“应用绑定”。")
 true
)
fn ZYBuiltinPickFilter n = (ZYRigNodeValid n and ZYBuiltinOwner==ZYRigRoot())
fn ZYBuiltinPreview nodes =
(
 -- A single explicit redraw, only on the user's preview/apply action; no idle polling.
 ZYHierarchySelect nodes
 redrawViews()
 true
)
fn ZYBuiltinApply =
(
 if not ZYBuiltinDirty do return false
 if not isValidNode ZYBuiltinOwner or ZYBuiltinOwner!=ZYRigRoot() do (ZYBuiltinContextSync();return false)
 if not ZYBuiltinWrite ZYBuiltinKey ZYBuiltinDraft automatic:ZYBuiltinAutomatic do
 (
  ZYBuiltinMapUI.status.text=ZYText "Not saved. Check the character and controllers." "未保存；请检查当前角色及控制器归属。"
  return false
 )
 ZYBuiltinDirty=false
 local nodes=ZYPickerNodes (ZYBuiltinSpec ZYBuiltinKey)
 ZYBuiltinRefresh()
 -- Keep the editor open so the user can read the result and the actual target names.
 -- Write success stays visible even if a separate viewport selection operation fails.
 local previewed=try(ZYBuiltinPreview nodes)catch(false)
 local result=(ZYText "Bound " "已绑定 ")+(nodes.count as string)+(ZYText " controllers. " " 个控制器。")
 result+=if previewed then (ZYText "Highlighted in the viewport; save your .max." "视口已同步高亮；请保存 .max 场景。") else (ZYText "Viewport preview failed; use the color block to verify, then save .max." "视口预览未完成；请点色块核对，并保存 .max 场景。")
 if nodes.count==0 do result=ZYText "Binding is empty. Restore Automatic to use detected targets. Save your .max." "绑定已清空；需要自动目标时使用“恢复自动识别”。请保存 .max。"
 ZYBuiltinMapUI.status.text=result
 ZYMapStatus ((ZYBuiltinLabel ZYBuiltinKey)+" · "+(ZYText "Bound " "已绑定 ")+(nodes.count as string)+(ZYText " controllers" " 个控制器"))
 true
)
rollout ZYBuiltinMapUI "控制器绑定" width:420 height:408
(
 label owner "" pos:[14,10] width:392 height:18
 button useSelected "载入视口选择（支持多选）" pos:[14,38] width:392 height:30
 label selectionHint "可先在视口多选骨骼，再载入；此时还未修改绑定。" pos:[14,75] width:392 height:18
 pickButton pickNode "拾取单个控制器" pos:[14,102] width:190 height:26 autoDisplay:false filter:ZYBuiltinPickFilter message:"点一个当前角色的控制器；右键取消，原绑定不变。"
 button previewBinding "在视口查看列表目标" pos:[216,102] width:190 height:26
 label mode "" pos:[14,141] width:392 height:18
 listbox nodes "" pos:[14,164] width:392 height:6
 button restoreAuto "恢复自动识别" pos:[14,272] width:190 height:26
 button clearBinding "清空绑定" pos:[216,272] width:190 height:26
 label status "" pos:[14,310] width:392 height:38
 button applyBinding "应用绑定" pos:[14,362] width:190 height:30
 button cancelBinding "关闭" pos:[216,362] width:190 height:30
 on ZYBuiltinMapUI open do
 (
  selectionHint.text=ZYText "Select one or more in the viewport, then load and review." "可先在视口多选骨骼，再载入；此时还未修改绑定。"
  useSelected.tooltip=ZYText "Replace the pending list with the current viewport selection. Multiple controllers are supported. Apply to save." "将当前视口选择载入待绑定列表，支持多选；核对后点“应用绑定”才生效。"
  pickNode.text=ZYText "Pick one controller" "拾取单个控制器"
  pickNode.tooltip=ZYText "Replace the pending list with one picked controller. Right-click in the viewport to cancel without changing the list." "用拾取的一个控制器替换待绑定列表；视口右键取消拾取，原列表保持不变。"
  previewBinding.text=ZYText "Show listed targets" "在视口查看列表目标"
  restoreAuto.text=ZYText "Restore Automatic" "恢复自动识别";clearBinding.text=ZYText "Clear Binding" "清空绑定"
  cancelBinding.text=ZYText "Close" "关闭"
  -- List height is measured in text rows at creation. Position following controls
  -- from the actual native list height so font/DPI differences cannot cover them.
  local bottom=amax 272 (nodes.pos.y+nodes.height+14)
  restoreAuto.pos=[14,bottom];clearBinding.pos=[216,bottom]
  status.pos=[14,bottom+38];applyBinding.pos=[14,bottom+90];cancelBinding.pos=[216,bottom+90]
  ZYBuiltinMapUI.height=bottom+136
  status.text=ZYText "Showing the saved binding. Load viewport selection or pick one; Apply to save." "当前显示已保存绑定。载入视口选择或拾取单个，核对后应用。"
  ZYBuiltinRefresh()
 )
 on useSelected pressed do
 (
  if selection.count==0 then status.text=ZYText "Nothing selected. Select one or more controllers in the viewport; the list is unchanged." "视口未选择控制器；请先单选或多选骨骼。原列表保持不变。"
  else ZYBuiltinStage (selection as array)
 )
 on pickNode picked n do if isValidNode n do ZYBuiltinStage #(n)
 on previewBinding pressed do
 (
  local targets=ZYBuiltinTargets()
  if targets.count>0 then
  (
   ZYBuiltinPreview targets
   status.text=if ZYBuiltinDirty then (ZYText "Pending targets highlighted. Apply binding to save." "已高亮待绑定目标；尚未保存，请点“应用绑定”。") else (ZYText "Saved targets highlighted in the viewport." "已在视口高亮当前绑定目标。")
  )
  else status.text=ZYText "The list is empty. Load selection or restore automatic detection." "列表为空；可载入视口选择或恢复自动识别。"
 )
 on clearBinding pressed do ZYBuiltinStage #()
 on restoreAuto pressed do
 (
  ZYBuiltinAutomatic=true;ZYBuiltinDirty=true;ZYBuiltinRefresh()
  status.text=ZYText "Automatic targets are listed above. Apply binding to restore them." "上方已列出自动识别目标；点“应用绑定”后恢复。"
 )
 on applyBinding pressed do ZYBuiltinApply()
 on ZYBuiltinMapUI close do (ZYBuiltinDirty=false;ZYNativeInput.ClearBuiltinEdits())
 on cancelBinding pressed do destroyDialog ZYBuiltinMapUI
)
fn ZYBuiltinOpen key restoreSelection:false pressId:0 =
(
 if ZYRigRoot()==undefined or ZYBuiltinSpec key==undefined do return false
 -- 双击的第一次单击仍即时选择；打开编辑器前还原第一次点击前的视口选择。
 if restoreSelection and ZYBuiltinPreviousKey==key and ZYBuiltinPreviousOwner==ZYRigRoot() and pressId>0 and ZYBuiltinPreviousPressId==pressId do
 (
  ZYPickerSelecting=true
  select (for n in ZYBuiltinPrevious where isValidNode n collect n)
  ZYPickerSelecting=false;ZYPickerSync()
 )
 try(destroyDialog ZYBuiltinMapUI)catch()
 ZYBuiltinOwner=ZYRigRoot();ZYBuiltinKey=key
 ZYBuiltinAutomatic=not ZYBuiltinHasOverride key;ZYBuiltinDraft=ZYBuiltinRead key;ZYBuiltinDirty=false
 createDialog ZYBuiltinMapUI style:#(#style_titlebar,#style_sysmenu,#style_toolwindow)
 true
)
fn ZYBuiltinTick sender args =
(
 local edit=ZYNativeInput.NextBuiltinEdit
 while edit!=0 do
 (
  local index=abs edit
  if index<=ZYPickerSpecs.count do ZYBuiltinOpen ZYPickerSpecs[index][1] restoreSelection:(edit<0) pressId:ZYNativeInput.EditBuiltinPressId
  edit=ZYNativeInput.NextBuiltinEdit
 )
)
fn ZYBuiltinRelease =
(
 if ZYDragTimer!=undefined do ZYDragTimer.active=false
 if ZYGroupRefreshTimer!=undefined do ZYGroupRefreshTimer.active=false
 ZYSideCancelDrag();ZYDragTimer=undefined;ZYGroupRefreshTimer=undefined;ZYGroupDeleting=false;ZYBuiltinReceiver=undefined
 for control in ZYBuiltinControls where control.hwnd.count>0 do ZYNativeInput.Detach (control.hwnd[1] as integer64)
 ZYBuiltinControls=#();ZYNativeInput.ClearBuiltinEdits()
 try(destroyDialog ZYBuiltinMapUI)catch()
)
fn ZYBuiltinStart ui =
(
 ZYBuiltinControls=for spec in ZYPickerSpecs collect getProperty ui spec[1]
 ZYBuiltinReceiver=ui.hit_ZYBuiltin.hwnd[1] as integer64
 ZYDragTimer=ui.ZYDragPulse;ZYGroupRefreshTimer=ui.ZYRefreshPulse
 ZYNativeInput.ClearBuiltinEdits()
)
-- Retire the old 35 ms polling timer on in-session upgrade. Idle picker now does no polling.
if ZYBuiltinTimer!=undefined do try(ZYBuiltinTimer.Stop();dotNet.removeAllEventHandlers ZYBuiltinTimer;ZYBuiltinTimer.Dispose())catch()
ZYBuiltinTimer=undefined
fn ZYBuiltinHistorySync =
(
 if ZYBuiltinMapUI!=undefined and ZYBuiltinMapUI.open and ZYBuiltinOwner==ZYRigRoot() and isValidNode ZYBuiltinOwner and not ZYBuiltinDirty do
 (
  ZYBuiltinAutomatic=not ZYBuiltinHasOverride ZYBuiltinKey;ZYBuiltinDraft=ZYBuiltinRead ZYBuiltinKey
  ZYBuiltinRefresh()
  ZYBuiltinMapUI.status.text=ZYText "Binding list updated after Undo/Redo." "绑定列表已随撤销 / 重做同步。"
 )
)
callbacks.removeScripts id:#ZYBuiltinUndo
callbacks.addScript #sceneUndo "ZYBuiltinHistorySync();ZYPickerSync()" id:#ZYBuiltinUndo
callbacks.addScript #sceneRedo "ZYBuiltinHistorySync();ZYPickerSync()" id:#ZYBuiltinUndo
