-- 组目录与选择记录分开保存；1.9.8 使用弱引用，保留历史组 ID 及 PostureParts=7。
-- 目录顺序即按钮顺序；内部 ID 不取决于名称、节点名或页码。
global ZYCatalogDef,ZYCatalog,ZYCatalogMaterialize,ZYCatalogRows,ZYCatalogSlot,ZYCatalogName,ZYCatalogCreate,ZYCatalogRename,ZYCatalogDelete,ZYCatalogRestore,ZYCatalogSetEmpty,ZYRigCounts,ZYRigNodeValid
global ZYRigIsBlocked,ZYRigGuardDelete,ZYRigGuardRepair,ZYGroupDeleting,ZYGroupQueueRefresh
global ZYCatalogMove
global ZYCatalogNextId=1001
fn ZYCatalog create:false = (ZYBindingData #zyCatalogSchema "Zhuoyu.RigGroups.v2" ZYCatalogDef create:create)
fn ZYCatalogSlot id = (if id>=1 and id<=7 then #("Hair","Ribbon","Weapon1","Weapon2","Custom1","Custom2","PostureParts")[id] else "Group"+(id as string))
fn ZYRigSlotId slot =
(
 if classOf slot==Integer do return slot
 local id=findItem #("Hair","Ribbon","Weapon1","Weapon2","Custom1","Custom2","PostureParts") slot
 if id==0 and matchPattern slot pattern:"Group*" do try(id=(substring slot 6 -1) as integer)catch(id=0)
 id
)
fn ZYCatalogMaterialize =
(
 local owner=ZYRigRoot();if owner==undefined do return undefined
 local ca=ZYCatalog create:true
 if ZYBindingIndex ca.initializedOwners owner==0 do
 (
  append ca.initializedOwners (ZYBindingRef owner)
  for i=1 to 6 do (append ca.groupOwners (ZYBindingRef owner);append ca.groupIds i;append ca.groupNames #("头发","飘带","武器1","武器2","自定义1","自定义2")[i];append ca.groupEmpty 0)
 )
 ca
)
fn ZYCatalogRows =
(
 local rows=#();local owner=ZYRigRoot();if owner==undefined do return rows
 local ca=ZYCatalog()
 if ca==undefined or ZYBindingIndex ca.initializedOwners owner==0 then
  (for i=1 to 6 do append rows #(ZYCatalogSlot i,#("头发","飘带","武器1","武器2","自定义1","自定义2")[i]))
 else for i=1 to ca.groupOwners.count where (ZYBindingNode ca.groupOwners[i])==owner do append rows #(ZYCatalogSlot ca.groupIds[i],ca.groupNames[i])
 rows
)
fn ZYCatalogName slot =
(
 for row in ZYCatalogRows() where row[1]==slot do return row[2]
 local id=ZYRigSlotId slot
 if id>=1 and id<=6 then #("头发","飘带","武器1","武器2","自定义1","自定义2")[id] else "自定义组"
)
fn ZYCatalogRestore slot =
(
 if ZYRigRoot()==undefined do return false
 for row in ZYCatalogRows() where row[1]==slot do return true
 undo "Restore Rig Group" on
 (
  local groupLabel=ZYCatalogName slot;local ca=ZYCatalogMaterialize()
  append ca.groupOwners (ZYBindingRef (ZYRigRoot()));append ca.groupIds (ZYRigSlotId slot);append ca.groupNames groupLabel;append ca.groupEmpty 1
 )
 true
)
fn ZYCatalogCreate label =
(
 label=trimLeft (trimRight label)
 if ZYRigRoot()==undefined or label=="" do return undefined
 local slot
 undo "Create Rig Group" on
 (
  local ca=ZYCatalogMaterialize();local id=amax ca.nextId ZYCatalogNextId
  ZYCatalogNextId=id+1;ca.nextId=ZYCatalogNextId;slot=ZYCatalogSlot id
  append ca.groupOwners (ZYBindingRef (ZYRigRoot()));append ca.groupIds id;append ca.groupNames label;append ca.groupEmpty 1
 )
 slot
)
fn ZYCatalogRename slot label =
(
 label=trimLeft (trimRight label);if label=="" do return false
 undo "Rename Rig Group" on
 (
  local ca=ZYCatalogMaterialize();local id=ZYRigSlotId slot
  for i=1 to ca.groupOwners.count where (ZYBindingNode ca.groupOwners[i])==ZYRigRoot() and ca.groupIds[i]==id do ca.groupNames[i]=label
 )
 true
)
fn ZYCatalogSetEmpty slot value =
(
 if slot=="PostureParts" do return true
 local ca=ZYCatalogMaterialize();local id=ZYRigSlotId slot
 for i=1 to ca.groupOwners.count where (ZYBindingNode ca.groupOwners[i])==ZYRigRoot() and ca.groupIds[i]==id do ca.groupEmpty[i]=value
 true
)
fn ZYRigNodeValid n =
(
 if not ZYRigIsControl n do return false
 local roots=ZYRigOwners n
 roots.count==0 or (roots.count==1 and roots[1]==ZYRigRoot())
)
fn ZYRigCounts slot =
(
 local ca=ZYCatalog();local owner=ZYRigRoot();local id=ZYRigSlotId slot
 if ca!=undefined do for i=1 to ca.groupOwners.count where (ZYBindingNode ca.groupOwners[i])==owner and ca.groupIds[i]==id and ca.groupEmpty[i]==1 do return #(0,0)
 local data=ZYRigData();local valid=0;local invalid=0
 if data!=undefined and owner!=undefined do for i=1 to data.owners.count where (ZYBindingNode data.owners[i])==owner and data.slotIds[i]==id do
  (if ZYRigNodeValid (ZYBindingNode data.targets[i]) then valid+=1 else invalid+=1)
 #(valid,invalid)
)
fn ZYRigInvalid slot = ((ZYRigCounts slot)[2]>0)
fn ZYRigRead slot =
(
 local data=ZYRigData();local owner=ZYRigRoot();local id=ZYRigSlotId slot;local nodes=#()
 if data!=undefined and owner!=undefined do for i=1 to data.owners.count where (ZYBindingNode data.owners[i])==owner and data.slotIds[i]==id and ZYRigNodeValid (ZYBindingNode data.targets[i]) do appendIfUnique nodes (ZYBindingNode data.targets[i])
 nodes
)
fn ZYRigWrite slot nodes =
(
 local owner=ZYRigRoot();local id=ZYRigSlotId slot
 if owner==undefined or id==0 do return false
 for n in nodes where not ZYRigNodeValid n do return false
 undo "Bind Rig Group" on
 (
  local data=ZYRigData create:true;local owners=#();local targets=#();local ids=#()
  for i=1 to data.owners.count where (ZYBindingNode data.owners[i])!=owner or data.slotIds[i]!=id do
   (append owners (ZYBindingNode data.owners[i]);append targets (ZYBindingNode data.targets[i]);append ids data.slotIds[i])
  if nodes.count==0 then (append owners owner;append targets undefined;append ids id)
  else (local unique=#();for n in nodes do appendIfUnique unique n;for n in unique do (append owners owner;append targets n;append ids id))
  data.owners=ZYBindingRefs owners;data.targets=ZYBindingRefs targets;data.slotIds=ids
  ZYCatalogSetEmpty slot (if nodes.count==0 then 1 else 0)
 )
 true
)
fn ZYCatalogDelete slot =
(
 if ZYRigRoot()==undefined do return false
 undo "Delete Rig Group Configuration" on
 (
  ZYRigWrite slot #()
  local ca=ZYCatalogMaterialize();local id=ZYRigSlotId slot
  for i=ca.groupOwners.count to 1 by -1 where (ZYBindingNode ca.groupOwners[i])==ZYRigRoot() and ca.groupIds[i]==id do
   (deleteItem ca.groupOwners i;deleteItem ca.groupIds i;deleteItem ca.groupNames i;deleteItem ca.groupEmpty i)
 )
 true
)

-- Max 2023 某些骨骼链删除父节点后，子节点 parent 访问会原生崩溃。
-- 删除前只遍历受影响子树并留下弱引用；不改节点层级或动画。
fn ZYRigIsBlocked n =
(
 local ca=ZYCatalog()
 ca!=undefined and isProperty ca #blockedNodes and ZYBindingIndex ca.blockedNodes n>0
)
fn ZYRigGuardDelete n =
(
 ZYGroupDeleting=true
 local ca=ZYCatalog();if ca==undefined or not isValidNode n do return false
 local queue=for child in n.children collect child
 while queue.count>0 do
 (
  local child=queue[queue.count];deleteItem queue queue.count
  if isValidNode child do
  (
   if ZYBindingIndex ca.blockedNodes child==0 do append ca.blockedNodes (ZYBindingRef child)
   for descendant in child.children do append queue descendant
  )
 )
 true
)
fn ZYRigGuardRepair n =
(
 if ZYGroupDeleting do return false
 local ca=ZYCatalog();if ca==undefined do return false
 -- 用户明确重新链接节点时，可再次按实际父级验证归属。
 local index=ZYBindingIndex ca.blockedNodes n
 if index>0 do deleteItem ca.blockedNodes index
 ZYGroupQueueRefresh();true
)
fn ZYRigIsControl n = (isValidNode n and not ZYRigIsBlocked n and (classOf n==BoneGeometry or classOf n==Biped_Object or superClassOf n==Helper or superClassOf n==Shape))

-- gap 是移动前目录的插入缝（1..count+1）。仅重排当前角色的目录槽；绑定 ID 不变。
fn ZYCatalogMove slot gap =
(
 local rows=ZYCatalogRows();local source=0
 for i=1 to rows.count where rows[i][1]==slot do source=i
 if source==0 do return false
 gap=amin (rows.count+1) (amax 1 gap)
 local destination=if gap>source then gap-1 else gap
 if destination==source do return false
 undo "Reorder Rig Groups" on
 (
  local ca=ZYCatalogMaterialize();local owner=ZYRigRoot();local positions=#();local entries=#()
  for i=1 to ca.groupOwners.count where (ZYBindingNode ca.groupOwners[i])==owner do
   (append positions i;append entries #(ca.groupIds[i],ca.groupNames[i],ca.groupEmpty[i]))
  local entry=entries[source];deleteItem entries source;insertItem entry entries destination
  for i=1 to positions.count do
   (local pos=positions[i];ca.groupIds[pos]=entries[i][1];ca.groupNames[pos]=entries[i][2];ca.groupEmpty[pos]=entries[i][3])
 )
 true
)

