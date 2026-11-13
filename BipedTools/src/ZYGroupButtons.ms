global ZYGroupNativeCache=#()
-- Max 原生按钮直接接收悬停并显示完整提示；按钮下方的 imgTag 只接收转发的点击和拖动消息。
-- 分离灰色外观与可编辑交互，不创建 WinForms 按钮、字体或提示。
global ZYGroupButtonSync,ZYGroupQuickRelease,ZYGroupDown,ZYGroupMove,ZYGroupUp,ZYGroupRight,ZYSideBuild,ZYSideRelease
 global ZYSideClick,ZYMapSelect,ZYMapOpen,ZYMapStatus,ZYPickerSync,ZYMapDirtyRefresh,ZYSideSave,ZYSideRefresh,ZYSideTurn,ZYSideUI,ZYSidePage,ZYSideSlots
 global ZYQuickControls=#(),ZYQuickHits=#(),ZYSideCells=#(),ZYSideHits=#(),ZYSidePrevious,ZYSideNext,ZYSidePager,ZYSideMarker
 global ZYSideCancelDrag,ZYSideUpdateDrop,ZYSidePageTick,ZYGroupBounds
 global ZYDragControl=undefined,ZYDragOwner=undefined,ZYDragSlot=undefined,ZYDragStart,ZYDragActive=false,ZYDragInsert=0,ZYDragDirection=0,ZYDragHoverTime=0,ZYDragTimer,ZYDragQuick=false,ZYDragIndex=0,ZYDragReleased=false,ZYDragModifiers=#(false,false,false)
 global ZYNativeInput197EventsAssembly,ZYNativeInput
if ZYDragTimer!=undefined do try(ZYDragTimer.active=false)catch(try(ZYDragTimer.Stop();dotNet.removeAllEventHandlers ZYDragTimer;ZYDragTimer.Dispose())catch())
ZYDragTimer=undefined
-- Select Framework for Max 2020-2025, or net8 for the .NET 8/10 hosts in 2026/2027;
-- no C# compiler, Autodesk SDK or temporary compilation is required at startup.
if ZYNativeInput197EventsAssembly==undefined do
(
 local library=if (maxVersion())[1]>=28000 then "ZYNativeGroups.net8.dll" else "ZYNativeGroups.netfx.dll"
 local bytes=(dotNetClass "System.IO.File").ReadAllBytes (ZYBipedRoot+library)
 ZYNativeInput197EventsAssembly=(dotNetClass "System.Reflection.Assembly").Load bytes
)
ZYNativeInput=dotNetClass "Zhuoyu.Biped.NativeInput197Events"
fn ZYGroupBounds control = ZYNativeInput.Bounds (control.hwnd[1] as integer64)
fn ZYGroupButtonSync control slot selected quick:false =
(
 if quick and ZYQuickControls.count==0 do
 (
  local ui=g_ZYLB_BH.BipedPicker_Rollout
  ZYQuickControls=#(ui.btn_ZYHair,ui.btn_ZYRibbon,ui.btn_ZYWeapon1,ui.btn_ZYWeapon2)
  ZYQuickHits=#(ui.hit_ZYHair,ui.hit_ZYRibbon,ui.hit_ZYWeapon1,ui.hit_ZYWeapon2)
  for i=1 to 4 do (ZYQuickHits[i].pos=ZYQuickControls[i].pos;ZYQuickHits[i].visible=true)
 )
 local index=findItem (if quick then ZYQuickControls else ZYSideCells) control
 local hit=if quick then ZYQuickHits[index] else ZYSideHits[index]
 local nodes=#();local invalid=0;local chosen=0;local label="+ 新建组";local status="empty"
 local hint="这是空位，点击创建控制器组。";local caption=label
 if slot!=undefined do
 (
  nodes=ZYRigNodes slot;invalid=(ZYRigCounts slot)[2]
  for n in nodes where findItem selected n>0 do chosen+=1
  label=ZYCatalogName slot
  caption=if label.count>5 then (substring label 1 4)+"…" else label
  status=if nodes.count==0 then (if invalid>0 then "invalid" else "unbound") else if chosen==nodes.count then "selected" else if chosen>0 then "partial" else "bound"
  if status=="partial" do caption="◐ "+(if caption.count>3 then (substring caption 1 2)+"…" else caption)
  if invalid>0 do caption="! "+(if caption.count>4 then (substring caption 1 3)+"…" else caption)
  local message=case status of
  (
   "unbound":"未绑定，点击设置。"
   "invalid":"绑定已失效，点击重新设置。"
   "selected":"控制器已全部选中。"
   "partial":"控制器部分选中。"
   default:"已绑定，点击选择控制器。"
  )
  if invalid>0 and nodes.count>0 do message+=" 部分绑定失效，右键检查。"
  hint=label+"\n"+message+"\n有效控制器 "+(nodes.count as string)+"；失效 "+(invalid as string)+"；已选 "+(chosen as string)
  for n in nodes do hint+="\n"+n.name
  hint+="\n左键选择；空组点击设置；右键编辑。\nShift/Ctrl 加选；Alt 减选。"
  if not quick do hint+="\n按住左键拖动排序；悬停翻页；Esc 取消。"
 )
 local muted=status=="unbound" or status=="invalid"
 local hwnd=control.hwnd[1] as integer64
 local current=#(hwnd,caption,status,hint,ZYRigRoot()!=undefined,(hit.hwnd[1] as integer64),muted)
 local previous=undefined
 for entry in ZYGroupNativeCache where entry[1]==hwnd do previous=entry
 local changed=previous==undefined
 if not changed do for i=2 to current.count where current[i]!=previous[i] do changed=true
 if changed do
 (
 ZYNativeInput.BeginUpdate (control.hwnd[1] as integer64)
 control.text=caption;control.state=status=="selected"
 control.enabled=ZYRigRoot()!=undefined and not muted
 hit.enabled=ZYRigRoot()!=undefined
 control.tooltip=hint;hit.tooltip="";hit.visible=true
 ZYNativeInput.Raise (control.hwnd[1] as integer64)
 ZYNativeInput.Configure (control.hwnd[1] as integer64) (hit.hwnd[1] as integer64) muted (ZYRigRoot()!=undefined)
  if previous!=undefined do deleteItem ZYGroupNativeCache (findItem ZYGroupNativeCache previous)
  append ZYGroupNativeCache current
 )
)
fn ZYGroupQuickRelease = (ZYGroupNativeCache=#();if ZYDragQuick do ZYSideCancelDrag();for control in ZYQuickControls where control.hwnd.count>0 do ZYNativeInput.Detach (control.hwnd[1] as integer64);ZYQuickControls=#();ZYQuickHits=#())
fn ZYSideBuild =
(
 ZYSideCells=for i=1 to 12 collect getProperty ZYSideUI (("cell"+(i as string)) as name)
 ZYSideHits=for i=1 to 12 collect getProperty ZYSideUI (("hit"+(i as string)) as name)
 for hit in ZYSideHits do hit.visible=true
 ZYSidePrevious=ZYSideUI.previous;ZYSideNext=ZYSideUI.next;ZYSidePager=ZYSideUI.pager;ZYSideMarker=ZYSideUI.marker
 ZYSideMarker.visible=false
)
fn ZYSideCancelDrag =
(
 local hit=ZYDragControl
 ZYDragControl=undefined;ZYDragOwner=undefined;ZYDragSlot=undefined;ZYDragActive=false;ZYDragInsert=0;ZYDragDirection=0;ZYDragIndex=0
 if ZYDragTimer!=undefined do ZYDragTimer.active=false
 if ZYSideUI!=undefined and ZYSideUI.open do ZYSideMarker.visible=false
 if hit!=undefined and hit.hwnd.count>0 do ZYNativeInput.Release (hit.hwnd[1] as integer64)
)
fn ZYSideRelease = (ZYGroupNativeCache=#();ZYSideCancelDrag();for control in ZYSideCells where control.hwnd.count>0 do ZYNativeInput.Detach (control.hwnd[1] as integer64);ZYSideCells=#();ZYSideHits=#())
fn ZYSideUpdateDrop =
(
 local point=ZYNativeInput.Cursor
 local first=ZYGroupBounds ZYSideCells[1];local last=ZYGroupBounds ZYSideCells[4]
 local scale=(last.Right-first.Left)/272.0
 local px=(point.X-first.Left)/scale;local py=(point.Y-first.Top)/scale
 local rows=ZYCatalogRows();local direction=0
 ZYDragInsert=0;ZYSideMarker.visible=false
 if py>=0 and py<136 and px>=0 and px<276 do
 (
  local col=amin 3 ((px/70) as integer);local row=amin 2 ((py/48) as integer)
  local index=(ZYSidePage-1)*12+row*4+col+1;local after=(mod px 70)>=31
  ZYDragInsert=amin (rows.count+1) (index+(if after then 1 else 0))
  local lineX=amin 273 (amax 0 (col*70+(if after then 63 else -4)))
  ZYSideMarker.pos=[12+lineX,38+row*48];ZYSideMarker.visible=true
  ZYNativeInput.Raise (ZYSideMarker.hwnd[1] as integer64)
 )
 if ZYSidePrevious.enabled and (ZYGroupBounds ZYSidePrevious).Contains point do direction=-1
 if ZYSideNext.enabled and (ZYGroupBounds ZYSideNext).Contains point do direction=1
 if direction!=ZYDragDirection do (ZYDragDirection=direction;ZYDragHoverTime=timestamp())
)
fn ZYGroupDown index quick:false =
(
 if ZYRigRoot()==undefined do return false
 ZYSideCancelDrag()
 ZYDragModifiers=#(keyboard.shiftPressed,keyboard.controlPressed,keyboard.altPressed)
 ZYDragReleased=false;ZYDragQuick=quick;ZYDragIndex=index;ZYDragOwner=ZYRigRoot()
 ZYDragControl=if quick then ZYQuickHits[index] else ZYSideHits[index]
 ZYDragSlot=if quick then #("Hair","Ribbon","Weapon1","Weapon2")[index] else ZYSideSlots[index]
 local point=ZYNativeInput.Cursor;ZYDragStart=[point.X,point.Y]
 ZYNativeInput.Capture (ZYDragControl.hwnd[1] as integer64)
 ZYDragTimer.active=true
)
fn ZYGroupMove =
(
 if ZYDragControl==undefined or ZYDragQuick or ZYDragSlot==undefined do return false
 if ZYDragOwner!=ZYRigRoot() then (ZYSideCancelDrag();return false)
 local point=ZYNativeInput.Cursor
 if not ZYDragActive and (amax (abs (point.X-ZYDragStart.x)) (abs (point.Y-ZYDragStart.y)))>=8 do ZYDragActive=true
 if ZYDragActive do ZYSideUpdateDrop()
)
fn ZYGroupUp =
(
 if ZYDragControl==undefined do return false
 local wasDrag=ZYDragActive;local slot=ZYDragSlot;local owner=ZYDragOwner;local index=ZYDragIndex;local quick=ZYDragQuick;local modifiers=ZYDragModifiers
 local inside=(ZYGroupBounds ZYDragControl).Contains ZYNativeInput.Cursor
 if wasDrag do ZYSideUpdateDrop()
 local gap=ZYDragInsert
 ZYSideCancelDrag()
 if owner!=ZYRigRoot() do return false
 if wasDrag then (if gap>0 do ZYCatalogMove slot gap;ZYMapDirtyRefresh();ZYSideSave())
 else if inside do (if quick then ZYMapSelect slot modifiers:modifiers else ZYSideClick index modifiers:modifiers)
 true
)
fn ZYGroupRight index quick:false =
(
 ZYSideCancelDrag()
 local slot=if quick then #("Hair","Ribbon","Weapon1","Weapon2")[index] else ZYSideSlots[index]
 if slot!=undefined do ZYMapOpen slot:slot
)
fn ZYSidePageTick sender args =
(
 if ZYDragControl==undefined or ZYDragOwner!=ZYRigRoot() then (ZYSideCancelDrag();return false)
 if keyboard.escPressed then (ZYSideCancelDrag();ZYSideRefresh();return false)
 -- 鼠标消息处理结束后再提交操作，点击与拖动都只提交一次。
 if not ZYNativeInput.LeftDown then
 (
  if ZYDragReleased then ZYGroupUp() else ZYDragReleased=true
  return true
 )
 ZYGroupMove()
 if ZYDragActive and ZYDragDirection!=0 and (timestamp()-ZYDragHoverTime)>=650 do
 (
  ZYDragHoverTime=timestamp();ZYSideTurn ZYDragDirection;ZYSideUpdateDrop()
 )
)
-- 只在鼠标按住期间计时；没有常驻轮询。
-- ZYDragTimer is a Max native rollout timer owned by the open picker.


