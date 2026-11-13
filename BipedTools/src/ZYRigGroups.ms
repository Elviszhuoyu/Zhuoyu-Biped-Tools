-- 节点身份通过弱引用随场景保存；不执行节点名回退，不读取旧全局 INI。
-- 用户确认/清空组时写入；旧工程由 ZYBindingStorage 迁移，自动候选只缓存在本次会话。
global ZYRigIsBlocked,ZYGroupDeleting
global g_ZYLB_BH,ZYRigDataDef,ZYRigCandidates=#(),ZYRigCacheRoot=undefined,ZYRigSceneStamp=undefined,ZYRigAutoNodes=#(),ZYRigCandidateRevision=0
global ZYRigRoot,ZYRigIsControl,ZYRigSlotId,ZYRigData,ZYRigOwners,ZYRigControllerTargets,ZYRigHasBinding,ZYRigRead,ZYRigWrite,ZYRigWeaponName,ZYRigAddCandidate,ZYRigScan,ZYRigEnsure,ZYRigNodes,ZYRigInvalid,ZYRigSceneChanged,ZYRigPostureStore,ZYRigPostureRead,ZYRigDirectControl
fn ZYRigRoot = (if g_ZYLB_BH!=undefined and isValidNode g_ZYLB_BH.bRoot then g_ZYLB_BH.bRoot else undefined)
fn ZYRigIsControl n = (isValidNode n and (classOf n==BoneGeometry or classOf n==Biped_Object or superClassOf n==Helper or superClassOf n==Shape))
fn ZYRigSlotId slot = (findItem #("Hair","Ribbon","Weapon1","Weapon2","Custom1","Custom2","PostureParts") slot)
fn ZYRigData create:false = (ZYBindingData #zySchema "Zhuoyu.RigSelection.v3" ZYRigDataDef create:create)
fn ZYRigControllerTargets ctrl =
(
 local nodes=#()
 if ctrl!=undefined do
 (
  if classOf ctrl==Link_Constraint then
   (for i=1 to ctrl.getNumTargets() where isValidNode (ctrl.getNode i) do appendIfUnique nodes (ctrl.getNode i))
  else
   try(for i=1 to ctrl.constraints.getNumTargets() where isValidNode (ctrl.constraints.getNode i) do appendIfUnique nodes (ctrl.constraints.getNode i))catch()
  if classOf ctrl==PRS do for sub in #(ctrl.position.controller,ctrl.rotation.controller) do
   for n in ZYRigControllerTargets sub do appendIfUnique nodes n
 )
 nodes
)
fn ZYRigOwners node seen:#() =
(
 local roots=#()
 if not isValidNode node or findItem seen node>0 do return roots
 if globalVars.isGlobal #ZYRigIsBlocked and ZYRigIsBlocked node do return roots
 append seen node
 if classOf node.controller==Vertical_Horizontal_Turn then append roots node
 else
 (
  if isValidNode node.parent do for r in ZYRigOwners node.parent seen:seen do appendIfUnique roots r
  for n in ZYRigControllerTargets node.controller do for r in ZYRigOwners n seen:seen do appendIfUnique roots r
 )
 roots
)
fn ZYRigHasBinding slot =
(
 local data=ZYRigData();local owner=ZYRigRoot();local id=ZYRigSlotId slot
 if data!=undefined and owner!=undefined do for i=1 to data.owners.count do
  if (ZYBindingNode data.owners[i])==owner and data.slotIds[i]==id do return true
 false
)
fn ZYRigInvalid slot =
(
 local data=ZYRigData();local owner=ZYRigRoot();local id=ZYRigSlotId slot
 if data!=undefined and owner!=undefined do for i=1 to data.owners.count where (ZYBindingNode data.owners[i])==owner and data.slotIds[i]==id do
 (
  local n=(ZYBindingNode data.targets[i])
  if not ZYRigIsControl n do return true
  local roots=ZYRigOwners n
  if roots.count>0 and (roots.count!=1 or roots[1]!=owner) do return true
 )
 false
)
fn ZYRigRead slot =
(
 local data=ZYRigData();local owner=ZYRigRoot();local id=ZYRigSlotId slot;local nodes=#()
 if ZYRigInvalid slot do return nodes
 if data!=undefined and owner!=undefined do for i=1 to data.owners.count where (ZYBindingNode data.owners[i])==owner and data.slotIds[i]==id do appendIfUnique nodes (ZYBindingNode data.targets[i])
 nodes
)
fn ZYRigWrite slot nodes =
(
 local owner=ZYRigRoot();local id=ZYRigSlotId slot
 if owner==undefined or id==0 do return false
 for n in nodes do
 (
  if not ZYRigIsControl n do return false
  local roots=ZYRigOwners n
  if roots.count>0 and (roots.count!=1 or roots[1]!=owner) do return false
 )
 undo "Zhuoyu Rig Selection Binding" on
 (
  local data=ZYRigData create:true;local owners=#();local targets=#();local ids=#()
  for i=1 to data.owners.count where (ZYBindingNode data.owners[i])!=owner or data.slotIds[i]!=id do
   (append owners (ZYBindingNode data.owners[i]);append targets (ZYBindingNode data.targets[i]);append ids data.slotIds[i])
  -- 空条目阻止自动候选重新接管用户已清空/已失效的插槽。
  if nodes.count==0 then (append owners owner;append targets undefined;append ids id)
  else for n in nodes do (append owners owner;append targets n;append ids id)
  data.owners=ZYBindingRefs owners;data.targets=ZYBindingRefs targets;data.slotIds=ids
 )
 true
)
fn ZYRigWeaponName name =
(
 local text=toLower name
 for key in #("weapon","sword","blade","katana","gun","rifle","pistol","dagger","spear","刀","剑","枪","斧","弓") where findString text key!=undefined do return true
 false
)
-- 自动匹配只接受直接挂在 Biped 上的普通控制器，或直接 Link 到 Biped 的控制器。
-- 列表、脚本、表达式、间接控制链等仍可列为候选，但交给用户确认主控制器。
fn ZYRigDirectControl n =
(
 local ctrl=n.controller
 if classOf ctrl==Link_Constraint do
 (
  local links=ZYRigControllerTargets ctrl
  return links.count==1 and classOf links[1]==Biped_Object
 )
 if classOf ctrl!=PRS or not isValidNode n.parent or classOf n.parent!=Biped_Object do return false
 local pc=ctrl.position.controller;local rc=ctrl.rotation.controller
 if classOf pc==Position_XYZ then
 (
  for axis in #(pc.x_position.controller,pc.y_position.controller,pc.z_position.controller) do
   if findItem #(Bezier_Float,Linear_Float,TCB_Float) (classOf axis)==0 do return false
 )
 else if findItem #(Bezier_Position,Linear_Position,TCB_Position) (classOf pc)==0 do return false
 if classOf rc==Euler_XYZ then
 (
  for axis in #(rc.x_rotation.controller,rc.y_rotation.controller,rc.z_rotation.controller) do
   if findItem #(Bezier_Float,Linear_Float,TCB_Float) (classOf axis)==0 do return false
  true
 )
 else findItem #(TCB_Rotation,Linear_Rotation) (classOf rc)>0
)
fn ZYRigAddCandidate n source reason certain =
(
 if not ZYRigIsControl n or classOf n==Biped_Object do return false
 local owner=ZYRigRoot();local roots=ZYRigOwners n
 -- 可列出归属未知的候选供用户确认；其他角色/跨角色约束一律排除。
 if roots.count>0 and (roots.count!=1 or roots[1]!=owner) do return false
 certain=certain and roots.count==1 and roots[1]==owner and ZYRigDirectControl n
 for entry in ZYRigCandidates where entry[1]==n do
  (entry[4]=entry[4] or certain;return true)
 append ZYRigCandidates #(n,source,reason,certain)
 true
)
fn ZYRigScan =
(
 ZYRigCandidates=#();ZYRigAutoNodes=#();ZYRigCacheRoot=ZYRigRoot();ZYRigSceneStamp=rootNode
 ZYRigCandidateRevision+=1
 if ZYRigCacheRoot==undefined do return ZYRigCandidates
 for source in objects where ZYRigWeaponName source.name and (not globalVars.isGlobal #ZYRigIsBlocked or not ZYRigIsBlocked source) do
 (
  local bones=#();local skinned=false
  for modifier in source.modifiers where classOf modifier==Skin do
  (
   skinned=true
   -- 使用实际 INode；不经 GetBoneName / getNodeByName 转换。
   for n in skinOps.GetBoneNodes modifier where isValidNode n do appendIfUnique bones n
  )
  if skinned then
  (
   for n in bones where not globalVars.isGlobal #ZYRigIsBlocked or not ZYRigIsBlocked n do
   (
    local drivers=ZYRigControllerTargets n.controller
    local customDrivers=for d in drivers where ZYRigIsControl d and classOf d!=Biped_Object collect d
    local parentControl=if ZYRigIsControl n.parent and classOf n.parent!=Biped_Object then n.parent else undefined
    ZYRigAddCandidate n source "武器网格的 Skin 骨骼" (bones.count==1 and customDrivers.count==0 and parentControl==undefined)
    if parentControl!=undefined do ZYRigAddCandidate parentControl source "Skin 骨骼的父控制器；需确认" false
    for d in customDrivers do ZYRigAddCandidate d source "Skin 骨骼的约束驱动控制器；需确认" false
   )
  )
  else
  (
   if ZYRigIsControl source and classOf source!=Biped_Object do
   (
    local links=ZYRigControllerTargets source.controller
    ZYRigAddCandidate source source "名称为武器控制器；核对层级/约束" (links.count==1 and classOf links[1]==Biped_Object)
   )
   if superClassOf source==GeometryClass and not ZYRigIsControl source do
   (
    if ZYRigIsControl source.parent do ZYRigAddCandidate source.parent source "武器网格的直接父控制器" true
    local targets=ZYRigControllerTargets source.controller
    for n in targets do ZYRigAddCandidate n source "武器网格的 Link / 约束目标" (targets.count==1)
   )
  )
 )
 if ZYRigCandidates.count==1 and ZYRigCandidates[1][4] and not ZYRigHasBinding "Weapon1" do ZYRigAutoNodes=#(ZYRigCandidates[1][1])
 ZYRigCandidates
)
fn ZYRigEnsure =
(
 if ZYRigCacheRoot!=ZYRigRoot() or ZYRigSceneStamp!=rootNode do ZYRigScan()
 true
)
fn ZYRigNodes slot =
(
 ZYRigEnsure()
 if ZYRigHasBinding slot then ZYRigRead slot else #()
)
fn ZYRigSceneChanged =
(
 ZYGroupDeleting=false
 ZYRigCacheRoot=undefined;ZYRigSceneStamp=undefined;ZYRigCandidates=#();ZYRigAutoNodes=#();ZYRigCandidateRevision+=1
 if globalVars.isGlobal #ZYPickerSync do try(ZYPickerSync())catch()
)
fn ZYRigPostureStore nodes =
(
 local valid=for n in nodes where isValidNode n and findItem g_ZYLB_BH.a_bipedAllParts n>0 collect n
 ZYRigWrite "PostureParts" valid
)
fn ZYRigPostureRead = ZYRigRead "PostureParts"
callbacks.removeScripts id:#ZYRigContext
callbacks.addScript #filePostOpen "ZYRigSceneChanged()" id:#ZYRigContext
callbacks.addScript #systemPostReset "ZYRigSceneChanged()" id:#ZYRigContext
callbacks.addScript #systemPostNew "ZYRigSceneChanged()" id:#ZYRigContext
