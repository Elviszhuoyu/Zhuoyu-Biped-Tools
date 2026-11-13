global ZYBuiltinStart,ZYBuiltinRelease,ZYBuiltinSyncControl,ZYBuiltinContextSync,ZYPickerAutoNodes
global ZYGroupDeleting=false,ZYGroupRefreshTimer,ZYGroupQueueRefresh,ZYGroupFinishRefresh
if ZYGroupRefreshTimer!=undefined do try(ZYGroupRefreshTimer.active=false)catch(try(ZYGroupRefreshTimer.Stop();dotNet.removeAllEventHandlers ZYGroupRefreshTimer;ZYGroupRefreshTimer.Dispose())catch())
ZYGroupRefreshTimer=undefined
fn ZYGroupFinishRefresh sender args = (ZYGroupDeleting=false;ZYMapDirtyRefresh())
fn ZYGroupQueueRefresh =
(
 if ZYGroupRefreshTimer!=undefined then (ZYGroupRefreshTimer.active=false;ZYGroupRefreshTimer.active=true)
 else ZYGroupDeleting=false
)
global ZYText,ZYLB_CN
fn ZYText en cn = (if ZYLB_CN then cn else en)
global ZYPickerNodes,ZYPickerReleaseVisuals,ZYPickerBuildVisuals,ZYPickerSyncBody,ZYMapLabel,ZYMapNodeNames,ZYMapNodes,ZYMapStatus,ZYMapContextValid,ZYMapRefreshConfig,ZYPickerSync,ZYPickerPartsRefresh,ZYSelectionPrepare,ZYHierarchySelect,ZYMapSelect,ZYMapSaveNodes,ZYMapConfirmCandidate,ZYMapLookupSkin,ZYMapOpen,ZYMapUIOwner,ZYMapUICandidates=#()
-- 选择组定义和内置快捷选择；只有明确调用 ZYMapOpen 才打开配置窗口。
global ZYMapUI,ZYMapSlots=#("Hair","Ribbon","Weapon1","Weapon2","Custom1","Custom2"),ZYMapLabels=#("头发","飘带","武器1","武器2","自定义1","自定义2"),g_ZYLB_BH
ZYPickerSpecs=#(#(#btn_selectClavicleL,#(#bClavicleL)),#(#btn_selectArmUpperL,#(#bUpperarmL)),#(#btn_selectArmLowerL,#(#bForearmL)),#(#btn_selectHandL,#(#bHandL)),#(#btn_selectFingersAllL,#(#a_fingersLeft)),#(#btn_selectHead,#(#bHead)),#(#btn_selectPonytailL,#(#bPonytail1)),#(#btn_selectPonytailR,#(#bPonytail2)),#(#btn_selectNeck,#(#bNeck)),#(#btn_selectAllSpines,#(#a_spines)),#(#btn_selectSpine4,#(#bSpine4)),#(#btn_selectSpine3,#(#bSpine3)),#(#btn_selectSpine2,#(#bSpine2)),#(#btn_selectSpine1,#(#bSpine1)),#(#btn_selectPelvis,#(#bPelvis)),#(#btn_selectCOM,#(#bRoot)),#(#btn_selectClavicleR,#(#bClavicleR)),#(#btn_selectArmUpperR,#(#bUpperarmR)),#(#btn_selectArmLowerR,#(#bForearmR)),#(#btn_selectHandR,#(#bHandR)),#(#btn_selectFingersAllR,#(#a_fingersRight)),#(#btn_selectLegUpperL,#(#bThighL)),#(#btn_selectLegLowerL,#(#bCalfL)),#(#btn_selectToeL,#(#bToeL)),#(#btn_selectFootL,#(#bFootL)),#(#btn_selectLegUpperR,#(#bThighR)),#(#btn_selectLegLowerR,#(#bCalfR)),#(#btn_selectFootR,#(#bFootR)),#(#btn_selectToeR,#(#bToeR)),#(#btn_selectPinky3L,#(#bPinky3L)),#(#btn_selectPinky2L,#(#bPinky2L)),#(#btn_selectPinky1L,#(#bPinky1L)),#(#btn_selectRing3L,#(#bRing3L)),#(#btn_selectRing2L,#(#bRing2L)),#(#btn_selectRing1L,#(#bRing1L)),#(#btn_selectMiddle3L,#(#bMiddle3L)),#(#btn_selectMiddle2L,#(#bMiddle2L)),#(#btn_selectMiddle1L,#(#bMiddle1L)),#(#btn_selectIndex3L,#(#bIndex3L)),#(#btn_selectIndex2L,#(#bIndex2L)),#(#btn_selectIndex1L,#(#bIndex1L)),#(#btn_selectThumb3L,#(#bThumb3L)),#(#btn_selectThumb2L,#(#bThumb2L)),#(#btn_selectThumb1L,#(#bThumb1L)),#(#btn_selectFingersL,#(#a_fingersOnlyLeft)),#(#btn_selectThumbL,#(#a_thumbLeft)),#(#btn_selectHandLrgL,#(#bHandL)),#(#btn_selectThumb3R,#(#bThumb3R)),#(#btn_selectThumb2R,#(#bThumb2R)),#(#btn_selectThumb1R,#(#bThumb1R)),#(#btn_selectIndex3R,#(#bIndex3R)),#(#btn_selectIndex2R,#(#bIndex2R)),#(#btn_selectIndex1R,#(#bIndex1R)),#(#btn_selectMiddle3R,#(#bMiddle3R)),#(#btn_selectMiddle2R,#(#bMiddle2R)),#(#btn_selectMiddle1R,#(#bMiddle1R)),#(#btn_selectRing3R,#(#bRing3R)),#(#btn_selectRing2R,#(#bRing2R)),#(#btn_selectRing1R,#(#bRing1R)),#(#btn_selectPinky3R,#(#bPinky3R)),#(#btn_selectPinky2R,#(#bPinky2R)),#(#btn_selectPinky1R,#(#bPinky1R)),#(#btn_selectFingersR,#(#a_fingersOnlyRight)),#(#btn_selectThumbR,#(#a_thumbRight)),#(#btn_selectHandLrgR,#(#bHandR)),#(#btn_LArm,#(#a_armLeft,#a_fingersOnlyLeft,#a_thumbLeft)),#(#btn_LLeg,#(#a_legLeft,#bToeL)),#(#btn_RArm,#(#a_armRight,#a_fingersOnlyRight,#a_thumbRight)),#(#btn_RLeg,#(#a_legRight,#bToeR)),#(#btn_tailBase,#(#bTail)),#(#btn_selectProp1,#(#bProp1)),#(#btn_selectProp2,#(#bProp2)),#(#btn_selectProp3,#(#bProp3)),#(#btn_selectHands,#(#bHandL,#bHandR)),#(#btn_selectFeet,#(#bFootL,#bFootR)),#(#btn_selectAll,#(#a_bipedAllParts)))
-- 色块位图每次打开缓存一次；选择变化仅切换已有位图，避免累计 GDI 资源。
global ZYPickerVisualOwner=undefined,ZYPickerVisualCache=#(),ZYPickerColorSpecs,ZYPickerSelecting=false
ZYPickerColorSpecs=#(#(#btn_selectClavicleL,30,12,#clr_blue),#(#btn_selectArmUpperL,12,26,#clr_blue),#(#btn_selectArmLowerL,12,26,#clr_blue),#(#btn_selectHandL,16,16,#clr_blue),#(#btn_selectFingersAllL,16,16,#clr_purple),#(#btn_selectHead,30,34,#clr_orange),#(#btn_selectNeck,13,17,#clr_cyan),#(#btn_selectAllSpines,14,76,#clr_cyan),#(#btn_selectSpine4,31,14,#clr_cyan),#(#btn_selectSpine3,26,14,#clr_cyan),#(#btn_selectSpine2,21,14,#clr_cyan),#(#btn_selectSpine1,16,14,#clr_cyan),#(#btn_selectPelvis,35,13,#clr_yellow),#(#btn_selectCOM,51,13,#clr_lightblue),#(#btn_selectClavicleR,30,12,#clr_green),#(#btn_selectArmUpperR,12,26,#clr_green),#(#btn_selectArmLowerR,12,26,#clr_green),#(#btn_selectHandR,16,16,#clr_green),#(#btn_selectFingersAllR,16,16,#clr_chartroose),#(#btn_selectLegUpperL,20,28,#clr_blue),#(#btn_selectLegLowerL,14,28,#clr_blue),#(#btn_selectToeL,14,14,#clr_purple),#(#btn_selectFootL,28,14,#clr_blue),#(#btn_selectLegUpperR,20,28,#clr_green),#(#btn_selectLegLowerR,14,28,#clr_green),#(#btn_selectFootR,28,14,#clr_green),#(#btn_selectToeR,14,14,#clr_chartroose),#(#btn_selectPinky3L,8,12,#clr_purple),#(#btn_selectPinky2L,8,12,#clr_purple),#(#btn_selectPinky1L,8,12,#clr_purple),#(#btn_selectRing3L,8,12,#clr_purple),#(#btn_selectRing2L,8,12,#clr_purple),#(#btn_selectRing1L,8,12,#clr_purple),#(#btn_selectMiddle3L,8,12,#clr_purple),#(#btn_selectMiddle2L,8,12,#clr_purple),#(#btn_selectMiddle1L,8,12,#clr_purple),#(#btn_selectIndex3L,8,12,#clr_purple),#(#btn_selectIndex2L,8,12,#clr_purple),#(#btn_selectIndex1L,8,12,#clr_purple),#(#btn_selectThumb3L,8,12,#clr_red),#(#btn_selectThumb2L,8,12,#clr_red),#(#btn_selectThumb1L,8,12,#clr_red),#(#btn_selectFingersL,52,8,#clr_purple),#(#btn_selectThumbL,8,34,#clr_red),#(#btn_selectHandLrgL,36,36,#clr_blue),#(#btn_selectThumb3R,8,12,#clr_yellow),#(#btn_selectThumb2R,8,12,#clr_yellow),#(#btn_selectThumb1R,8,12,#clr_yellow),#(#btn_selectIndex3R,8,12,#clr_chartroose),#(#btn_selectIndex2R,8,12,#clr_chartroose),#(#btn_selectIndex1R,8,12,#clr_chartroose),#(#btn_selectMiddle3R,8,12,#clr_chartroose),#(#btn_selectMiddle2R,8,12,#clr_chartroose),#(#btn_selectMiddle1R,8,12,#clr_chartroose),#(#btn_selectRing3R,8,12,#clr_chartroose),#(#btn_selectRing2R,8,12,#clr_chartroose),#(#btn_selectRing1R,8,12,#clr_chartroose),#(#btn_selectPinky3R,8,12,#clr_chartroose),#(#btn_selectPinky2R,8,12,#clr_chartroose),#(#btn_selectPinky1R,8,12,#clr_chartroose),#(#btn_selectFingersR,52,8,#clr_chartroose),#(#btn_selectThumbR,8,36,#clr_yellow),#(#btn_selectHandLrgR,36,36,#clr_green),#(#btn_copiedTM,12,18,#clr_darkgrey))
fn ZYPickerAutoNodes spec =
(
 local nodes=#()
 if ZYRigRoot()==undefined do return nodes
 for prop in spec[2] do
 (
  local value=getProperty g_ZYLB_BH prop
  if matchPattern (prop as string) pattern:"a_*" then (for n in value where isValidNode n do appendIfUnique nodes n)
  else if isValidNode value do appendIfUnique nodes value
 )
 nodes
)
fn ZYPickerReleaseVisuals = (if ZYBuiltinRelease!=undefined do ZYBuiltinRelease();ZYGroupQuickRelease();ZYPickerVisualCache=#();ZYPickerVisualOwner=undefined;ZYPickerSelecting=false)
fn ZYPickerBuildVisuals ui =
(
 ZYPickerReleaseVisuals();ZYPickerVisualOwner=ui
 for spec in ZYPickerSpecs do
 (
  local control=getProperty ui spec[1]
  local colorIndex=0
  for i=1 to ZYPickerColorSpecs.count where ZYPickerColorSpecs[i][1]==spec[1] do colorIndex=i
  local maps=#()
  if colorIndex>0 do
  (
   local cs=ZYPickerColorSpecs[colorIndex];local w=cs[2];local h=cs[3]
   local fill=getProperty g_ZYLB_BH cs[4]
   for state=0 to 3 do
   (
    local bm=bitmap w h color:(if state==3 then (color 24 24 24) else fill) gamma:1.0
    if state>0 and state<3 do for y=0 to h-1 do
    (
     local row=for x=0 to w-1 collect
     (
      if x<2 or x>=w-2 or y<2 or y>=h-2 then
       (if state==2 then (color 255 255 230) else (if mod (x+y) 4<2 then (color 255 190 50) else fill))
      else fill
     )
     setPixels bm [0,y] row
    )
    append maps bm
   )
  )
  append ZYPickerVisualCache #(spec[1],maps,-1,control.text,control.tooltip,-1,-1,undefined,0,false,false)
 )
 ZYBuiltinStart ui
)
fn ZYPickerSyncBody ui selected =
(
 if ZYPickerVisualOwner!=ui do ZYPickerBuildVisuals ui
 for i=1 to ZYPickerSpecs.count do
 (
  local spec=ZYPickerSpecs[i];local cache=ZYPickerVisualCache[i]
  local nodes=ZYPickerNodes spec;local chosen=0
  for n in nodes where findItem selected n>0 do chosen+=1
  local state=if nodes.count==0 then 3 else if chosen==0 then 0 else if chosen==nodes.count then 2 else 1
  local control=getProperty ui spec[1]
  if cache[3]!=state do
  (
   ZYNativeInput.BeginUpdate (control.hwnd[1] as integer64)
   control.enabled=nodes.count>0
  )
  if cache[3]!=state do
  (
   if cache[2].count>0 then control.images=#(cache[2][state+1],undefined,1,1,1,1,1,false)
   else (control.state=state==2;control.text=cache[4]+(if state==1 then "·" else ""))
  )
  if cache[3]!=state or cache[6]!=chosen or cache[7]!=nodes.count do
  (
  local status="该按钮对应节点尚未选中。"
  if state==3 do status="当前 Biped 缺少对应控制器；暗灰色按钮不可用。"
  if state==2 do status="该按钮对应的 "+(nodes.count as string)+" 个节点已全部选中。"
  if state==1 do status="该组合已选 "+(chosen as string)+" / "+(nodes.count as string)+" 个节点；橙色虚线表示部分选中。"
  control.tooltip=cache[5]+"\n"+status
  )
  ZYBuiltinSyncControl control spec i cache nodes chosen
  cache[3]=state;cache[6]=chosen;cache[7]=nodes.count
 )
)


global ZYMapEditSlot="Hair",ZYMapLabel,ZYMapGroupChanged,ZYMapNew,ZYMapRename,ZYMapDelete,ZYMapDirtyRefresh
global ZYSideUI,ZYSideRefresh,ZYSideToggle,ZYSideSuspend,ZYSideResume,ZYSideClick,ZYSideTurn,ZYSideSave
global ZYSidePage=1,ZYSidePos=undefined,ZYSideWanted=false,ZYSidePlacing=false,ZYSideSlots=#()
fn ZYMapLabel slot = ZYCatalogName slot
fn ZYMapNodeNames nodes =
(
 local names=""
 for n in nodes where isValidNode n do (if names!="" do names+="、";names+=n.name)
 names
)
fn ZYMapNodes slot = ZYRigNodes slot
fn ZYMapStatus value =
(
 if ZYMapUI!=undefined and ZYMapUI.open do ZYMapUI.status.text=value
 if g_ZYLB_BH!=undefined and g_ZYLB_BH.BipedPicker_Rollout!=undefined and g_ZYLB_BH.BipedPicker_Rollout.open do g_ZYLB_BH.BipedPicker_Rollout.lbl_ZYSelection.text=value
)
fn ZYMapContextValid =
(
 if ZYRigRoot()==undefined then (ZYMapStatus "先在选择器顶部选择当前 Biped。";false)
 else if ZYMapUIOwner!=ZYRigRoot() then (ZYMapRefreshConfig();ZYMapStatus "角色已变化，请核对当前编辑组。";false)
 else true
)
fn ZYMapRefreshConfig =
(
 if ZYGroupDeleting do return false
 if ZYMapUI==undefined or not ZYMapUI.open do return false
 ZYRigEnsure()
 if ZYMapUIOwner!=ZYRigRoot() do ZYMapEditSlot="Hair"
 ZYMapUIOwner=ZYRigRoot()
 local rows=ZYCatalogRows();ZYMapSlots=for row in rows collect row[1];ZYMapLabels=for row in rows collect row[2]
 local index=findItem ZYMapSlots ZYMapEditSlot
 if index==0 and rows.count>0 do (index=1;ZYMapEditSlot=rows[1][1])
 ZYMapUI.context.text=if ZYMapUIOwner==undefined then "当前角色：未选择 Biped" else "当前角色："+ZYMapUIOwner.name
 ZYMapUI.context.tooltip=ZYMapUI.context.text
 ZYMapUI.groupList.items=ZYMapLabels;ZYMapUI.groupList.selection=index
 local editable=index>0 and ZYMapUIOwner!=undefined
 for control in #(ZYMapUI.renameGroup,ZYMapUI.deleteGroup,ZYMapUI.save,ZYMapUI.pick,ZYMapUI.confirm,ZYMapUI.clear) do control.enabled=editable
 ZYMapUI.newGroup.enabled=ZYMapUIOwner!=undefined
 ZYMapUI.groupName.text=if editable then ZYMapLabel ZYMapEditSlot else ""
 local nodes=if editable then ZYMapNodes ZYMapEditSlot else #()
 local counts=if editable then ZYRigCounts ZYMapEditSlot else #(0,0)
 local lines=""
 for n in nodes do lines+=n.name+"\r\n"
 if counts[2]>0 do lines+="[失效 / 归属已变化："+(counts[2] as string)+" 个]\r\n"
 ZYMapUI.nodes.text=if lines=="" then "空组：从下面三种来源选择控制器。" else lines
 ZYMapUI.summary.text="当前编辑："+(if editable then ZYMapLabel ZYMapEditSlot else "无")+"    有效 "+(nodes.count as string)+" / 失效 "+(counts[2] as string)
 ZYMapUI.summary.tooltip=ZYMapUI.summary.text
 -- 候选按角色证据生成，与用户给组起的名字无关。
 ZYMapUICandidates=for entry in ZYRigCandidates where isValidNode entry[1] and isValidNode entry[2] collect entry
 ZYMapUI.candidates.items=for entry in ZYMapUICandidates collect (entry[1].name+" ← "+entry[2].name)
 ZYMapUI.candidates.selection=0
 ZYMapUI.reason.text="候选来自武器网格 / 层级 / 约束线索，可绑定到任意组。\n列表为空时，也可直接拾取或使用视口所选。"
 ZYMapUI.status.text="下面三种绑定都会覆盖当前组。配置在保存 .max 后持久化。"
 true
)
fn ZYPickerSync selectedOverride:undefined =
(
 if ZYGroupDeleting do return false
 local selected=if selectedOverride==undefined then (selection as array) else selectedOverride
 if g_ZYLB_BH!=undefined and g_ZYLB_BH.BipedPicker_Rollout!=undefined and g_ZYLB_BH.BipedPicker_Rollout.open do
 (
  local ui=g_ZYLB_BH.BipedPicker_Rollout
  ZYPickerSyncBody ui selected
  for spec in #(#("Hair",#btn_ZYHair),#("Ribbon",#btn_ZYRibbon),#("Weapon1",#btn_ZYWeapon1),#("Weapon2",#btn_ZYWeapon2)) do
   ZYGroupButtonSync (getProperty ui spec[2]) spec[1] selected quick:true
  local names=""
  for i=1 to amin selected.count 2 do (if i>1 do names+=", ";names+=selected[i].name)
  if selected.count>2 do names+=" …"
  ui.lbl_ZYSelection.text=if selected.count==0 then "未选择对象；空组点击配置。" else "已选 "+(selected.count as string)+" 个："+names
  ui.lbl_ZYSelection.tooltip="实际选择："+(ZYMapNodeNames selected)
 )
 ZYBuiltinContextSync()
 ZYSideRefresh selected:selected
 if ZYMapUI!=undefined and ZYMapUI.open and ZYMapUIOwner!=ZYRigRoot() do ZYMapRefreshConfig()
)
fn ZYPickerPartsRefresh = ZYPickerSync()
fn ZYSelectionPrepare = (if getCommandPanelTaskMode()==#motion do setCommandPanelTaskMode #modify)
fn ZYHierarchySelect nodes clearSel:true =
(
 ZYSelectionPrepare();ZYPickerSelecting=true
 try(if clearSel then (if nodes.count==0 then clearSelection() else select nodes) else if nodes.count>0 do selectMore nodes)catch(ZYPickerSelecting=false;ZYPickerSync();throw())
 ZYPickerSelecting=false;ZYPickerSync();true
)
fn ZYMapSelect slot modifiers:undefined =
(
 local nodes=ZYMapNodes slot
 if nodes.count==0 then (ZYPickerSync();ZYMapOpen slot:slot;return false)
 ZYSelectionPrepare();ZYPickerSelecting=true
 if modifiers==undefined do modifiers=#(keyboard.shiftPressed,keyboard.controlPressed,keyboard.altPressed)
 if modifiers[3] then deselect nodes
 else
 (
  for n in nodes do (if n.isHidden do unhide n;n.boxMode=false)
  if modifiers[1] or modifiers[2] then selectMore nodes else select nodes
 )
 ZYPickerSelecting=false;ZYPickerSync();redrawViews();true
)
fn ZYMapSaveNodes nodes =
(
 if not ZYMapContextValid() do return false
 if nodes.count==0 then (ZYMapStatus "视口没有选择控制器；当前绑定保持不变。";return false)
 local unique=#();for n in nodes do appendIfUnique unique n
 if not ZYRigWrite ZYMapEditSlot unique then (ZYMapStatus "绑定未改变：包含网格、其他角色节点或跨角色约束。";return false)
 ZYMapRefreshConfig();ZYPickerSync();ZYMapStatus "已覆盖当前组。请保存 .max，之后打开才会保留。";true
)
fn ZYMapConfirmCandidate =
(
 if not ZYMapContextValid() do return false
 local i=ZYMapUI.candidates.selection
 if i<1 or i>ZYMapUICandidates.count then (ZYMapStatus "先选一个候选，或使用视口拾取 / 当前所选。";return false)
 ZYMapSaveNodes #(ZYMapUICandidates[i][1])
)
fn ZYMapLookupSkin =
(
 if not ZYMapContextValid() do return false
 local nodes=#()
 for source in selection do for modifier in source.modifiers where classOf modifier==Skin do
  for bone in skinOps.GetBoneNodes modifier where ZYRigIsControl bone do
  (
   local roots=ZYRigOwners bone
   if roots.count==1 and roots[1]==ZYRigRoot() do appendIfUnique nodes bone
  )
 if nodes.count==0 then ZYMapStatus "所选网格没有归属当前角色的 Skin 控制骨骼。"
 else (ZYSelectionPrepare();select nodes;ZYMapStatus "已在视口选出 Skin 骨骼；核对后点「使用视口所选」。")
)
fn ZYMapNew =
(
 if not ZYMapContextValid() do return false
 local slot=ZYCatalogCreate ZYMapUI.groupName.text
 if slot==undefined then (ZYMapStatus "输入组名称后点「新建组」。";false)
 else (ZYMapEditSlot=slot;ZYMapRefreshConfig();ZYPickerSync();ZYMapStatus "已新建空组，接着选择绑定来源。";true)
)
fn ZYMapRename =
(
 if ZYMapContextValid() and ZYCatalogRename ZYMapEditSlot ZYMapUI.groupName.text do (ZYMapRefreshConfig();ZYPickerSync();ZYMapStatus "已改名；控制器绑定不变。保存 .max 后保留。")
)
fn ZYMapDelete =
(
 if ZYMapContextValid() do
 (
  ZYCatalogDelete ZYMapEditSlot;ZYMapEditSlot=undefined;ZYMapRefreshConfig();ZYPickerSync()
  ZYMapStatus "已删除本组配置；场景节点保留。Ctrl+Z 可撤销。"
 )
)
fn ZYMapDirtyRefresh = (ZYMapRefreshConfig();ZYPickerSync())
rollout ZYMapUI "角色控制器绑定 · 1.9.8" width:484 height:600
(
 label context "当前角色：" pos:[14,12] width:456 height:20
 dropdownlist groupList "编辑组" pos:[14,38] width:456 height:42
 edittext groupName "名称" pos:[14,92] width:456 height:24
 button newGroup "新建组" pos:[14,124] width:146 height:28 tooltip:"用上方名称创建新空组；不会复制旧绑定。"
 button renameGroup "保存改名" pos:[169,124] width:146 height:28
 button deleteGroup "删除组" pos:[324,124] width:146 height:28 tooltip:"只删除本组配置，保留控制器。Ctrl+Z 可撤销。"
 label summary "当前编辑：" pos:[14,166] width:456 height:20
 edittext nodes "" pos:[14,190] width:456 height:72 readOnly:true
 listbox candidates "控制器候选（任意组可用）" pos:[14,274] width:456 height:5
 label reason "" pos:[14,376] width:456 height:38
 button scan "刷新候选" pos:[14,420] width:146 height:26
 button preview "在视口预览候选" pos:[169,420] width:146 height:26
 button lookup "查所选网格的 Skin" pos:[324,420] width:146 height:26
 label replaceHint "绑定来源 · 以下三项均覆盖当前组" pos:[14,458] width:456 height:18
 button confirm "使用列表候选（一个）" pos:[14,484] width:146 height:30 tooltip:"用列表选中的一个控制器覆盖当前组。"
 pickbutton pick "到视口拾取一个" pos:[169,484] width:146 height:30 filter:ZYRigIsControl autoDisplay:false tooltip:"点击后到视口点一个控制器，覆盖当前组。"
 button save "使用视口所选（多个）" pos:[324,484] width:146 height:30 tooltip:"用视口当前所选控制器覆盖当前组，支持多个。不会追加。"
 button clear "清空绑定" pos:[14,524] width:146 height:26
 button guide "使用指南" pos:[324,524] width:146 height:26
 label status "保存 .max 后保留配置。" pos:[14,564] width:456 height:32
 on groupList selected i do if i>0 and i<=ZYMapSlots.count do (ZYMapEditSlot=ZYMapSlots[i];ZYMapRefreshConfig())
 on candidates selected i do if i>0 and i<=ZYMapUICandidates.count do (reason.text=ZYMapUICandidates[i][3]+(if ZYMapUICandidates[i][4] then "；归属明确。" else "；需核对控制器。"))
 on newGroup pressed do ZYMapNew()
 on renameGroup pressed do ZYMapRename()
 on deleteGroup pressed do ZYMapDelete()
 on scan pressed do (ZYRigScan();ZYMapRefreshConfig();ZYPickerSync())
 on preview pressed do if ZYMapContextValid() do
 (
  local i=candidates.selection
  if i>0 and i<=ZYMapUICandidates.count and isValidNode ZYMapUICandidates[i][1] do (ZYSelectionPrepare();unhide ZYMapUICandidates[i][1];select ZYMapUICandidates[i][1])
 )
 on confirm pressed do ZYMapConfirmCandidate()
 on save pressed do ZYMapSaveNodes (selection as array)
 on pick picked node do if isValidNode node do ZYMapSaveNodes #(node)
 on clear pressed do if ZYMapContextValid() do (ZYRigWrite ZYMapEditSlot #();ZYMapRefreshConfig();ZYPickerSync();ZYMapStatus "本组已清空。保存 .max 后保留；不会自动补回。")
 on lookup pressed do ZYMapLookupSkin()
 on guide pressed do shellLaunch (ZYBipedRoot+"Guide.html") ""
 on ZYMapUI open do ZYMapRefreshConfig()
)
fn ZYMapOpen slot:undefined =
(
 if slot!=undefined and ZYRigRoot()!=undefined do ZYCatalogRestore slot
 if not ZYMapUI.open do createDialog ZYMapUI
 if slot!=undefined do ZYMapEditSlot=slot
 ZYMapRefreshConfig()
)
fn ZYSideSave =
(
 local ini=(getDir #plugcfg)+@"\ZYLB_BipedHelper.ini"
 setIniSetting ini "Groups" "Page" (ZYSidePage as string)
 if ZYSidePos!=undefined do setIniSetting ini "Groups" "Position" (ZYSidePos as string)
)
fn ZYSideRefresh selected:undefined =
(
 if ZYSideUI==undefined or not ZYSideUI.open or ZYSideCells.count!=12 do return false
 if ZYDragControl!=undefined and ZYDragOwner!=ZYRigRoot() do ZYSideCancelDrag()
 if selected==undefined do selected=selection as array
 local rows=ZYCatalogRows();local pages=amax 1 (ceil (rows.count/12.0) as integer)
 ZYSidePage=amin pages (amax 1 ZYSidePage);ZYSideSlots=#()
 ZYSideUI.context.text=if ZYRigRoot()==undefined then "未选择 Biped" else (ZYRigRoot()).name
 ZYSideUI.context.tooltip=ZYSideUI.context.text
 for i=1 to 12 do
 (
  local index=(ZYSidePage-1)*12+i
  local slot=if index<=rows.count then rows[index][1] else undefined
  append ZYSideSlots slot
  ZYGroupButtonSync ZYSideCells[i] slot selected
 )
 ZYSidePager.Text=(ZYSidePage as string)+" / "+(pages as string)+" 页 · "+(rows.count as string)+" 组"
 ZYSidePrevious.Enabled=ZYSidePage>1;ZYSideNext.Enabled=ZYSidePage<pages
 ZYSideUI.newGroup.enabled=ZYRigRoot()!=undefined
 true
)
fn ZYSideClick i edit:false modifiers:undefined =
(
 if i>ZYSideSlots.count do return false
 local slot=ZYSideSlots[i]
 if slot==undefined then (ZYMapOpen();ZYMapUI.groupName.text="";ZYMapStatus "输入名称，然后点击「新建组」。")
 else if edit then ZYMapOpen slot:slot else ZYMapSelect slot modifiers:modifiers
 true
)
fn ZYSideTurn delta = (ZYSidePage+=delta;ZYSideRefresh();ZYSideSave())
rollout ZYSideUI "自定义按钮 · 1.9.8" width:300 height:264
(
 label context "当前角色" pos:[12,10] width:276 height:18
 checkbutton cell1 "+ 新建组" pos:[12,38] width:62 height:40
 checkbutton cell2 "+ 新建组" pos:[82,38] width:62 height:40
 checkbutton cell3 "+ 新建组" pos:[152,38] width:62 height:40
 checkbutton cell4 "+ 新建组" pos:[222,38] width:62 height:40
 checkbutton cell5 "+ 新建组" pos:[12,86] width:62 height:40
 checkbutton cell6 "+ 新建组" pos:[82,86] width:62 height:40
 checkbutton cell7 "+ 新建组" pos:[152,86] width:62 height:40
 checkbutton cell8 "+ 新建组" pos:[222,86] width:62 height:40
 checkbutton cell9 "+ 新建组" pos:[12,134] width:62 height:40
 checkbutton cell10 "+ 新建组" pos:[82,134] width:62 height:40
 checkbutton cell11 "+ 新建组" pos:[152,134] width:62 height:40
 checkbutton cell12 "+ 新建组" pos:[222,134] width:62 height:40
 bitmap marker "" pos:[12,38] width:3 height:40 bitmap:(bitmap 3 40 color:(color 235 183 74)) visible:false
 button previous "上一页" pos:[12,188] width:72 height:26 tooltip:"上一页；拖动时悬停可翻页。"
 label pager "" pos:[90,194] width:120 height:20 align:#center
 button next "下一页" pos:[216,188] width:72 height:26 tooltip:"下一页；拖动时悬停可翻页。"
 on previous pressed do ZYSideTurn -1
 on next pressed do ZYSideTurn 1
 button newGroup "+ 新建组" pos:[12,226] width:132 height:26
 button manage "管理绑定" pos:[156,226] width:132 height:26
 imgTag hit1 "" pos:[12,38] width:62 height:40 opacity:0.0
 on hit1 lbuttondown p flags do ZYGroupDown 1
 on hit1 lbuttonup p flags do ZYDragReleased=true
 on hit1 lbuttondblclk p flags do ZYGroupDown 1

 on hit1 mousemove p flags do ZYGroupMove()
 on hit1 rbuttonup p flags do ZYGroupRight 1
 on cell1 changed state do ZYSideClick 1
 imgTag hit2 "" pos:[82,38] width:62 height:40 opacity:0.0
 on hit2 lbuttondown p flags do ZYGroupDown 2
 on hit2 lbuttonup p flags do ZYDragReleased=true
 on hit2 lbuttondblclk p flags do ZYGroupDown 2

 on hit2 mousemove p flags do ZYGroupMove()
 on hit2 rbuttonup p flags do ZYGroupRight 2
 on cell2 changed state do ZYSideClick 2
 imgTag hit3 "" pos:[152,38] width:62 height:40 opacity:0.0
 on hit3 lbuttondown p flags do ZYGroupDown 3
 on hit3 lbuttonup p flags do ZYDragReleased=true
 on hit3 lbuttondblclk p flags do ZYGroupDown 3

 on hit3 mousemove p flags do ZYGroupMove()
 on hit3 rbuttonup p flags do ZYGroupRight 3
 on cell3 changed state do ZYSideClick 3
 imgTag hit4 "" pos:[222,38] width:62 height:40 opacity:0.0
 on hit4 lbuttondown p flags do ZYGroupDown 4
 on hit4 lbuttonup p flags do ZYDragReleased=true
 on hit4 lbuttondblclk p flags do ZYGroupDown 4

 on hit4 mousemove p flags do ZYGroupMove()
 on hit4 rbuttonup p flags do ZYGroupRight 4
 on cell4 changed state do ZYSideClick 4
 imgTag hit5 "" pos:[12,86] width:62 height:40 opacity:0.0
 on hit5 lbuttondown p flags do ZYGroupDown 5
 on hit5 lbuttonup p flags do ZYDragReleased=true
 on hit5 lbuttondblclk p flags do ZYGroupDown 5

 on hit5 mousemove p flags do ZYGroupMove()
 on hit5 rbuttonup p flags do ZYGroupRight 5
 on cell5 changed state do ZYSideClick 5
 imgTag hit6 "" pos:[82,86] width:62 height:40 opacity:0.0
 on hit6 lbuttondown p flags do ZYGroupDown 6
 on hit6 lbuttonup p flags do ZYDragReleased=true
 on hit6 lbuttondblclk p flags do ZYGroupDown 6

 on hit6 mousemove p flags do ZYGroupMove()
 on hit6 rbuttonup p flags do ZYGroupRight 6
 on cell6 changed state do ZYSideClick 6
 imgTag hit7 "" pos:[152,86] width:62 height:40 opacity:0.0
 on hit7 lbuttondown p flags do ZYGroupDown 7
 on hit7 lbuttonup p flags do ZYDragReleased=true
 on hit7 lbuttondblclk p flags do ZYGroupDown 7

 on hit7 mousemove p flags do ZYGroupMove()
 on hit7 rbuttonup p flags do ZYGroupRight 7
 on cell7 changed state do ZYSideClick 7
 imgTag hit8 "" pos:[222,86] width:62 height:40 opacity:0.0
 on hit8 lbuttondown p flags do ZYGroupDown 8
 on hit8 lbuttonup p flags do ZYDragReleased=true
 on hit8 lbuttondblclk p flags do ZYGroupDown 8

 on hit8 mousemove p flags do ZYGroupMove()
 on hit8 rbuttonup p flags do ZYGroupRight 8
 on cell8 changed state do ZYSideClick 8
 imgTag hit9 "" pos:[12,134] width:62 height:40 opacity:0.0
 on hit9 lbuttondown p flags do ZYGroupDown 9
 on hit9 lbuttonup p flags do ZYDragReleased=true
 on hit9 lbuttondblclk p flags do ZYGroupDown 9

 on hit9 mousemove p flags do ZYGroupMove()
 on hit9 rbuttonup p flags do ZYGroupRight 9
 on cell9 changed state do ZYSideClick 9
 imgTag hit10 "" pos:[82,134] width:62 height:40 opacity:0.0
 on hit10 lbuttondown p flags do ZYGroupDown 10
 on hit10 lbuttonup p flags do ZYDragReleased=true
 on hit10 lbuttondblclk p flags do ZYGroupDown 10

 on hit10 mousemove p flags do ZYGroupMove()
 on hit10 rbuttonup p flags do ZYGroupRight 10
 on cell10 changed state do ZYSideClick 10
 imgTag hit11 "" pos:[152,134] width:62 height:40 opacity:0.0
 on hit11 lbuttondown p flags do ZYGroupDown 11
 on hit11 lbuttonup p flags do ZYDragReleased=true
 on hit11 lbuttondblclk p flags do ZYGroupDown 11

 on hit11 mousemove p flags do ZYGroupMove()
 on hit11 rbuttonup p flags do ZYGroupRight 11
 on cell11 changed state do ZYSideClick 11
 imgTag hit12 "" pos:[222,134] width:62 height:40 opacity:0.0
 on hit12 lbuttondown p flags do ZYGroupDown 12
 on hit12 lbuttonup p flags do ZYDragReleased=true
 on hit12 lbuttondblclk p flags do ZYGroupDown 12

 on hit12 mousemove p flags do ZYGroupMove()
 on hit12 rbuttonup p flags do ZYGroupRight 12
 on cell12 changed state do ZYSideClick 12
 on manage pressed do ZYMapOpen()
 on newGroup pressed do (ZYMapOpen();ZYMapUI.groupName.text="";ZYMapStatus "输入名称后点击「新建组」，然后绑定控制器。")
 on ZYSideUI moved pos do if not ZYSidePlacing do (ZYSidePos=pos;ZYSideSave())
 on ZYSideUI close do (ZYSideRelease();ZYSideSave())
 on ZYSideUI open do (ZYSideBuild();ZYSideRefresh())
)
fn ZYSideSuspend =
(
 if ZYSideUI!=undefined and ZYSideUI.open do (ZYSidePos=getDialogPos ZYSideUI;destroyDialog ZYSideUI)
 if ZYMapUI!=undefined and ZYMapUI.open do destroyDialog ZYMapUI
)
fn ZYSideResume =
(
 if not ZYSideWanted or ZYSideUI.open do return false
 ZYSidePlacing=true
 createDialog ZYSideUI escapeEnable:true
 if ZYSidePos==undefined and g_ZYLB_BH.BipedPicker_Rollout.open do
  (local picker=g_ZYLB_BH.BipedPicker_Rollout;ZYSidePos=(getDialogPos picker)+[(getDialogSize picker).x+24,0])
 if ZYSidePos!=undefined do setDialogPos ZYSideUI ZYSidePos
 ZYSidePlacing=false
 ZYSideRefresh();true
)
fn ZYSideToggle =
(
 if ZYSideUI.open then (ZYSideWanted=false;ZYSidePos=getDialogPos ZYSideUI;destroyDialog ZYSideUI)
 else (ZYSideWanted=true;ZYSideResume())
)
callbacks.removeScripts id:#ZYGroupChanges
callbacks.addScript #sceneUndo "ZYMapDirtyRefresh()" id:#ZYGroupChanges
callbacks.addScript #sceneRedo "ZYMapDirtyRefresh()" id:#ZYGroupChanges
-- 删除通知发生在原生引用更新期间；仅安排一次空闲刷新，不轮询组/场景。
callbacks.addScript #nodePreDelete "ZYRigGuardDelete (callbacks.notificationParam())" id:#ZYGroupChanges
callbacks.addScript #nodePostDelete "ZYGroupQueueRefresh()" id:#ZYGroupChanges
callbacks.addScript #nodeLinked "ZYRigGuardRepair (callbacks.notificationParam())" id:#ZYGroupChanges

-- 只读本工具窗口偏好；不读取节点名或旧全局绑定 INI。
(
 local ini=(getDir #plugcfg)+@"\ZYLB_BipedHelper.ini"
 local v=getIniSetting ini "Groups" "Page"
 if v!="" do try(ZYSidePage=amax 1 (v as integer))catch()
 v=filterString (getIniSetting ini "Groups" "Position") "[], "
 if v.count==2 do try(ZYSidePos=[v[1] as float,v[2] as float])catch()
)

