-- 选择记录使用弱引用；不把场景根节点变成骨骼的依赖项。
-- 独立的新定义保留旧文件的读取能力，迁移完成并核对后才移除旧记录。
global ZYBindingNode,ZYBindingRef,ZYBindingRefs,ZYBindingIndex,ZYBindingFind,ZYBindingData,ZYBindingUpgrade
global ZYRigDataDef,ZYCatalogDef,ZYBuiltinDataDef,ZYBindingMigrating=false,ZYBindingLastUpgrade=0
ZYRigDataDef=attributes ZYRigSelectionDataSafe attribID:#(0x604c3281,0x254e1792) version:1
(
 parameters bindings
 (
  zySchema type:#string default:"Zhuoyu.RigSelection.v3"
  owners type:#maxObjectTab tabSizeVariable:true
  targets type:#maxObjectTab tabSizeVariable:true
  slotIds type:#intTab tabSizeVariable:true animatable:false
 )
)
ZYCatalogDef=attributes ZYRigGroupCatalogSafe attribID:#(0x604c3282,0x254e1793) version:1
(
 parameters catalog
 (
  zyCatalogSchema type:#string default:"Zhuoyu.RigGroups.v2"
  initializedOwners type:#maxObjectTab tabSizeVariable:true
  groupOwners type:#maxObjectTab tabSizeVariable:true
  groupIds type:#intTab tabSizeVariable:true animatable:false
  groupNames type:#stringTab tabSizeVariable:true
  groupEmpty type:#intTab tabSizeVariable:true animatable:false
  blockedNodes type:#maxObjectTab tabSizeVariable:true
  nextId type:#integer default:1001 animatable:false
 )
)
ZYBuiltinDataDef=attributes ZYBuiltinSelectionDataSafe attribID:#(0x604c3283,0x254e1794) version:1
(
 parameters bindings
 (
  zyBuiltinSchema type:#string default:"Zhuoyu.BuiltinSelection.v2"
  owners type:#maxObjectTab tabSizeVariable:true
  buttonKeys type:#stringTab tabSizeVariable:true
  targets type:#maxObjectTab tabSizeVariable:true
 )
)
fn ZYBindingNode value =
(
 if value==undefined then undefined
 else if classOf value==NodeTransformMonitor then value.node
 else if isValidNode value then value
 else undefined
)
fn ZYBindingRef value =
(
 if classOf value==NodeTransformMonitor then value
 else if isValidNode value then NodeTransformMonitor node:value forwardTransformChangeMsgs:false
 else undefined
)
fn ZYBindingRefs values = (for value in values collect ZYBindingRef value)
fn ZYBindingIndex values node =
(
 for i=1 to values.count where (ZYBindingNode values[i])==node do return i
 0
)
fn ZYBindingFind prop schema =
(
 for i=1 to custAttributes.count rootNode baseObject:false do
 (
  local ca=custAttributes.get rootNode i baseObject:false
  if isProperty ca prop and getProperty ca prop==schema do return ca
 )
 undefined
)
fn ZYBindingData prop schema definition create:false =
(
 local data=ZYBindingFind prop schema
 if data==undefined and create do
 (
  custAttributes.add rootNode definition baseObject:false
  data=ZYBindingFind prop schema
 )
 data
)
fn ZYBindingRemove data =
(
 for i=custAttributes.count rootNode baseObject:false to 1 by -1 where (custAttributes.get rootNode i baseObject:false)==data do
  custAttributes.delete rootNode i baseObject:false
)
fn ZYBindingPairs data ownerProp keyProp =
(
 local owners=getProperty data ownerProp;local keys=getProperty data keyProp
 if owners.count!=keys.count do throw "Binding table has inconsistent row counts; original records kept."
 for i=1 to owners.count collect #((ZYBindingNode owners[i]),keys[i])
)
fn ZYBindingHasPair pairs item =
(
 -- MAXScript 数组的 == / findItem 比较数组身份，不会逐项比较复合键。
 for pair in pairs where pair[1]==item[1] and pair[2]==item[2] do return true
 false
)
fn ZYBindingMigrate oldData prop schema definition fields nodeFields ownerProp keyProp =
(
 local current=ZYBindingFind prop schema
 local created=current==undefined
 local data=ZYBindingData prop schema definition create:true
 local previous=for field in fields collect (local v=getProperty data field;if field==#nextId then v else v as array)
 local values=for v in previous collect (if classOf v==Array then (for item in v collect item) else v)
 try
 (
  local oldPairs=ZYBindingPairs oldData ownerProp keyProp
  local newPairs=ZYBindingPairs data ownerProp keyProp
  local rowFields=if prop==#zyCatalogSchema then #(#groupOwners,#groupIds,#groupNames,#groupEmpty) else #(#owners,keyProp,#targets)
  for field in rowFields where (getProperty oldData field).count!=oldPairs.count do
   throw "Binding table has inconsistent row counts; original records kept."
  -- 已有新版记录优先；旧多选列表按整组复制，不能丢掉第二个目标。
  for i=1 to oldPairs.count where (if prop==#zyCatalogSchema then ZYBindingIndex data.initializedOwners oldPairs[i][1]==0 else not ZYBindingHasPair newPairs oldPairs[i]) do for field in rowFields do
  (
   local value=(getProperty oldData field)[i]
   if findItem nodeFields field>0 do value=ZYBindingRef value
   append values[findItem fields field] value
  )
  if prop==#zyCatalogSchema do
  (
   for field in #(#initializedOwners,#blockedNodes) where isProperty oldData field do
   (
    local list=values[findItem fields field]
    for value in getProperty oldData field where ZYBindingIndex list (ZYBindingNode value)==0 do append list (ZYBindingRef value)
   )
   values[findItem fields #nextId]=amax data.nextId oldData.nextId
  )
  for i=1 to fields.count do setProperty data fields[i] values[i]
  -- 逐项读回身份和元数据，成功后才删除会阻碍 Link/Unlink 的旧属性。
  for i=1 to fields.count do
  (
   local actual=getProperty data fields[i];local expected=values[i]
   if classOf expected==Array then
   (
    if actual.count!=expected.count do throw "Binding migration count mismatch; original records kept."
    for j=1 to expected.count do
    (
     local a=actual[j];local b=expected[j]
     if findItem nodeFields fields[i]>0 do (a=ZYBindingNode a;b=ZYBindingNode b)
     if a!=b do throw "Binding migration identity mismatch; original records kept."
    )
   )
   else if actual!=expected do throw "Binding migration metadata mismatch; original records kept."
  )
  ZYBindingRemove oldData
 )
 catch
 (
  if created then ZYBindingRemove data else for i=1 to fields.count do setProperty data fields[i] previous[i]
  throw
 )
 true
)
fn ZYBindingUpgrade =
(
 if ZYBindingMigrating do return 0
 ZYBindingMigrating=true
 local count=0
 try
 (
  -- 仅升级插件元数据，不写父级、控制器、Skin 或动画键；不生成持久脚本回调。
  with undo off
  (
   for spec in #(
    #(#zySchema,"Zhuoyu.RigSelection.v2","Zhuoyu.RigSelection.v3",ZYRigDataDef,#(#owners,#targets,#slotIds),#(#owners,#targets),#owners,#slotIds),
    #(#zyCatalogSchema,"Zhuoyu.RigGroups.v1","Zhuoyu.RigGroups.v2",ZYCatalogDef,#(#initializedOwners,#groupOwners,#groupIds,#groupNames,#groupEmpty,#blockedNodes,#nextId),#(#initializedOwners,#groupOwners,#blockedNodes),#groupOwners,#groupIds),
    #(#zyBuiltinSchema,"Zhuoyu.BuiltinSelection.v1","Zhuoyu.BuiltinSelection.v2",ZYBuiltinDataDef,#(#owners,#buttonKeys,#targets),#(#owners,#targets),#owners,#buttonKeys)
   ) do
   (
    local legacy=ZYBindingFind spec[1] spec[2]
    while legacy!=undefined do
    (
     ZYBindingMigrate legacy spec[1] spec[3] spec[4] spec[5] spec[6] spec[7] spec[8]
     count+=1;legacy=ZYBindingFind spec[1] spec[2]
    )
   )
  )
 )
 catch (ZYBindingMigrating=false;throw)
 ZYBindingMigrating=false;ZYBindingLastUpgrade=count
 if count>0 do format "Zhuoyu Biped Tools: upgraded % binding tables. Save a scene copy to retain the upgrade.\n" count
 count
)
callbacks.removeScripts id:#ZYBindingStorage
callbacks.addScript #filePostOpen "ZYBindingUpgrade()" id:#ZYBindingStorage
callbacks.addScript #filePostMerge "ZYBindingUpgrade()" id:#ZYBindingStorage
-- 会话内升级时，旧撤销记录可能重新挂回旧属性；立即转换，不能重新引入强引用。
callbacks.addScript #sceneUndo "ZYBindingUpgrade()" id:#ZYBindingStorage
callbacks.addScript #sceneRedo "ZYBindingUpgrade()" id:#ZYBindingStorage
ZYBindingUpgrade()
