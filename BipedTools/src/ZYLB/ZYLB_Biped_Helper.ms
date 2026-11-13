-- Shared build for Max 2020-2027.
if (maxVersion())[1]<22000 do throw "Zhuoyu Biped Tools requires Max 2020 or newer."
-- 本地语言分支 1.9.8，基于 Lorne Brooks Biped Helper 3.5（2024-06-18）。
-- 作者已在原源码声明允许修改及分发；原作者署名与版本记录完整保留。
-- 沿用原 Biped 关键帧 API；本地选择记录单独存储，不修改节点名称、父级或 Skin。
global g_ZYLB_BH, ZYLB_CN, ZYLB_IconDir, ZYLB_StateSpecs
global ZYLB_Ini = (getDir #plugcfg) + @"\ZYLB_BipedHelper.ini"
ZYLB_IconDir = getFilenamePath (getSourceFileName())
global ZYBipedRoot = (dotNetClass "System.IO.Path").GetFullPath (ZYLB_IconDir + @"..\")
fileIn (ZYBipedRoot+"ZYDiagnostics.ms")
ZYLB_CN = (getIniSetting ZYLB_Ini "Language" "UI") != "en"
fileIn (ZYBipedRoot+"ZYBindingStorage.ms")
fileIn (ZYBipedRoot+"ZYRigGroups.ms")
fileIn (ZYBipedRoot+"ZYRigCatalog.ms")
fileIn (ZYBipedRoot+"ZYGroupButtons.ms")
fileIn (ZYBipedRoot+"ZYMappings.ms")
fileIn (ZYBipedRoot+"ZYBuiltinBindings.ms")
fileIn (ZYBipedRoot+"ZYIntegration.ms")
fileIn (ZYBipedRoot+"ZYKeyActions.ms")
fn ZYLB_T en cn = (if ZYLB_CN then cn else en)
ZYLB_StateSpecs = #(#(#leftHandPivots_Rollout,#chkbtn_pinkyTip,#state),#(#leftHandPivots_Rollout,#chkbtn_ringTip,#state),#(#leftHandPivots_Rollout,#chkbtn_middleTip,#state),#(#leftHandPivots_Rollout,#chkbtn_indexTip,#state),#(#leftHandPivots_Rollout,#chkbtn_pinky2,#state),#(#leftHandPivots_Rollout,#chkbtn_ring2,#state),#(#leftHandPivots_Rollout,#chkbtn_middle2,#state),#(#leftHandPivots_Rollout,#chkbtn_index2,#state),#(#leftHandPivots_Rollout,#chkbtn_pinky1,#state),#(#leftHandPivots_Rollout,#chkbtn_ring1,#state),#(#leftHandPivots_Rollout,#chkbtn_middle1,#state),#(#leftHandPivots_Rollout,#chkbtn_index1,#state),#(#leftHandPivots_Rollout,#chkbtn_palmBack,#state),#(#leftHandPivots_Rollout,#chkbtn_palmMiddle,#state),#(#leftHandPivots_Rollout,#chkbtn_palmFront,#state),#(#leftHandPivots_Rollout,#chkbtn_wristBack,#state),#(#leftHandPivots_Rollout,#chkbtn_wristMiddle,#state),#(#leftHandPivots_Rollout,#chkbtn_wristFront,#state),#(#leftHandPivots_Rollout,#chkbtn_wristCenter,#state),#(#leftHandPivots_Rollout,#chkbtn_thumbTip,#state),#(#leftHandPivots_Rollout,#chkbtn_thumb2,#state),#(#leftHandPivots_Rollout,#chkbtn_thumb1,#state),#(#rightHandPivots_Rollout,#chkbtn_indexTip,#state),#(#rightHandPivots_Rollout,#chkbtn_middleTip,#state),#(#rightHandPivots_Rollout,#chkbtn_ringTip,#state),#(#rightHandPivots_Rollout,#chkbtn_pinkyTip,#state),#(#rightHandPivots_Rollout,#chkbtn_index2,#state),#(#rightHandPivots_Rollout,#chkbtn_middle2,#state),#(#rightHandPivots_Rollout,#chkbtn_ring2,#state),#(#rightHandPivots_Rollout,#chkbtn_pinky2,#state),#(#rightHandPivots_Rollout,#chkbtn_index1,#state),#(#rightHandPivots_Rollout,#chkbtn_middle1,#state),#(#rightHandPivots_Rollout,#chkbtn_ring1,#state),#(#rightHandPivots_Rollout,#chkbtn_pinky1,#state),#(#rightHandPivots_Rollout,#chkbtn_palmFront,#state),#(#rightHandPivots_Rollout,#chkbtn_palmMiddle,#state),#(#rightHandPivots_Rollout,#chkbtn_palmBack,#state),#(#rightHandPivots_Rollout,#chkbtn_wristFront,#state),#(#rightHandPivots_Rollout,#chkbtn_wristMiddle,#state),#(#rightHandPivots_Rollout,#chkbtn_wristBack,#state),#(#rightHandPivots_Rollout,#chkbtn_wristCenter,#state),#(#rightHandPivots_Rollout,#chkbtn_thumbTip,#state),#(#rightHandPivots_Rollout,#chkbtn_thumb2,#state),#(#rightHandPivots_Rollout,#chkbtn_thumb1,#state),#(#leftFootPivots_Rollout,#chkbtn_frontLeft,#state),#(#leftFootPivots_Rollout,#chkbtn_frontMiddle,#state),#(#leftFootPivots_Rollout,#chkbtn_frontRight,#state),#(#leftFootPivots_Rollout,#chkbtn_ankle,#state),#(#leftFootPivots_Rollout,#chkbtn_backLeft,#state),#(#leftFootPivots_Rollout,#chkbtn_backMiddle,#state),#(#leftFootPivots_Rollout,#chkbtn_backRight,#state),#(#rightFootPivots_Rollout,#chkbtn_frontLeft,#state),#(#rightFootPivots_Rollout,#chkbtn_frontMiddle,#state),#(#rightFootPivots_Rollout,#chkbtn_frontRight,#state),#(#rightFootPivots_Rollout,#chkbtn_ankle,#state),#(#rightFootPivots_Rollout,#chkbtn_backLeft,#state),#(#rightFootPivots_Rollout,#chkbtn_backMiddle,#state),#(#rightFootPivots_Rollout,#chkbtn_backRight,#state),#(#SelectionDisplayTime_Rollout,#ddl_bips,#selection),#(#SelectionDisplayTime_Rollout,#chkbtn_bendLinks,#state),#(#SelectionDisplayTime_Rollout,#chkbtn_pivotsLHand,#state),#(#SelectionDisplayTime_Rollout,#chkbtn_pivotsRHand,#state),#(#SelectionDisplayTime_Rollout,#chkbtn_pivotsLFoot,#state),#(#SelectionDisplayTime_Rollout,#chkbtn_pivotsRFoot,#state),#(#SelectionDisplayTime_Rollout,#chkbtn_trajectories,#state),#(#SelectionDisplayTime_Rollout,#rdobtns_timeRange,#state),#(#SelectionDisplayTime_Rollout,#spn_TRstartTime,#value),#(#SelectionDisplayTime_Rollout,#spn_TRendTime,#value),#(#SelectionDisplayTime_Rollout,#spn_TRstepSize,#value),#(#Reference_Rollout,#chkbtn_ghosting,#state),#(#Reference_Rollout,#rdobtns_ghostType,#state),#(#Reference_Rollout,#spn_ghostTotalFrames,#value),#(#Reference_Rollout,#spn_ghostNthFrame,#value),#(#Reference_Rollout,#chkbx_ghostWireframe,#checked),#(#Reference_Rollout,#chkbx_ghostFrameNumbers,#checked),#(#Reference_Rollout,#chkbx_keySwapPB,#checked),#(#Reference_Rollout,#chkbtn_visiblePB,#state),#(#Reference_Rollout,#spn_PBopacity,#value),#(#Reference_Rollout,#edtxt_snapshotSceneLayer,#text),#(#Reference_Rollout,#chkbtn_visibleSnapshots,#state),#(#Reference_Rollout,#spn_snapshotOpacity,#value),#(#Reference_Rollout,#chkbtn_addTrajHelper,#state),#(#Reference_Rollout,#chkbx_limitTrajDisplay,#checked),#(#Reference_Rollout,#spn_limitStart,#value),#(#Reference_Rollout,#spn_limitEnd,#value),#(#Reference_Rollout,#chkbtn_visibleTrajHelpers,#state),#(#Keys_Rollout,#spn_keepStep,#value),#(#Keys_Rollout,#chkbtn_horizontal,#state),#(#Keys_Rollout,#chkbtn_vertical,#state),#(#Keys_Rollout,#chkbtn_rotation,#state),#(#Keys_Rollout,#rdobtns_tcbType,#state),#(#Keys_Rollout,#spn_TCB,#value),#(#Keys_Rollout,#chkbtn_posX,#state),#(#Keys_Rollout,#chkbtn_posY,#state),#(#Keys_Rollout,#chkbtn_posZ,#state),#(#Keys_Rollout,#chkbtn_rotXYZ,#state),#(#Keys_Rollout,#rdobtns_applyTo,#state),#(#Keys_Rollout,#rdobtns_PRY,#state),#(#Keys_Rollout,#chkbx_onlySnapBelow,#checked),#(#LayersRetargeting_Rollout,#rdobtns_base,#state),#(#LayersRetargeting_Rollout,#rdobtns_ref,#state),#(#LayersRetargeting_Rollout,#chkbtn_leftArm,#state),#(#LayersRetargeting_Rollout,#chkbtn_rightArm,#state),#(#LayersRetargeting_Rollout,#chkbtn_leftLeg,#state),#(#LayersRetargeting_Rollout,#chkbtn_rightLeg,#state),#(#LayersRetargeting_Rollout,#chkbx_IKonly,#checked),#(#Layers_Rollout,#chkbx_active,#checked),#(#Layers_Rollout,#chkbtn_solo,#state),#(#Layers_Rollout,#edtxt_index,#text),#(#Layers_Rollout,#ddl_layers,#selection),#(#Layers_Rollout,#edtxt_LayerName,#text),#(#Layers_Rollout,#chkbtn_retargeting,#state),#(#PosePosture_Rollout,#chkbx_pasteOpposite,#checked),#(#PosePosture_Rollout,#chkbtn_horizontal,#state),#(#PosePosture_Rollout,#chkbtn_vertical,#state),#(#PosePosture_Rollout,#chkbtn_rotation,#state),#(#PosePosture_Rollout,#chkbx_velocity,#checked),#(#PosePosture_Rollout,#rdobtns_tcb,#state),#(#AlignBake_Rollout,#rbtns_head,#state),#(#AlignBake_Rollout,#rbtns_rootLimbsBoth,#state),#(#AlignBake_Rollout,#rbtns_selLimbs,#state),#(#AlignBake_Rollout,#chkbtn_leftHand,#state),#(#AlignBake_Rollout,#chkbtn_rightHand,#state),#(#AlignBake_Rollout,#chkbtn_leftFoot,#state),#(#AlignBake_Rollout,#chkbtn_rightFoot,#state),#(#AlignBake_Rollout,#rbtns_nextSlideKey,#state),#(#AlignBake_Rollout,#rbtns_lastSlideKey,#state),#(#AlignBake_Rollout,#chkbx_propBake,#checked),#(#BipedPicker_Rollout,#ddl_bips,#selection),#(#BipedPicker_Rollout,#chkbtn_bendLinks,#state),#(#BipedPicker_Rollout,#chkbtn_pivotsLHand,#state),#(#BipedPicker_Rollout,#chkbtn_pivotsRHand,#state),#(#BipedPicker_Rollout,#chkbtn_pivotsLFoot,#state),#(#BipedPicker_Rollout,#chkbtn_pivotsRFoot,#state),#(#BipedPicker_Rollout,#chkbtn_collapsePickerTools,#state),#(#BipedPicker_Rollout,#rdobtns_timeRange,#state),#(#BipedPicker_Rollout,#spn_TRstartTime,#value),#(#BipedPicker_Rollout,#spn_TRendTime,#value),#(#BipedPicker_Rollout,#spn_TRstepSize,#value),#(#BipedPicker_Rollout,#spn_keepStep,#value),#(#BipedPicker_Rollout,#chkbtn_trajectories,#state),#(#BipedPicker_Rollout,#chkbtn_posX,#state),#(#BipedPicker_Rollout,#chkbtn_posY,#state),#(#BipedPicker_Rollout,#chkbtn_posZ,#state),#(#BipedPicker_Rollout,#chkbtn_rotXYZ,#state),#(#BipedPicker_Rollout,#rdobtns_applyTo,#state),#(#BipedPicker_Rollout,#rdobtns_PRY,#state),#(#BipedPicker_Rollout,#chkbx_onlySnapBelow,#checked),#(#BipedPicker_Rollout,#chkbtn_ghosting,#state),#(#BipedPicker_Rollout,#rdobtns_ghostType,#state),#(#BipedPicker_Rollout,#spn_ghostTotalFrames,#value),#(#BipedPicker_Rollout,#spn_ghostNthFrame,#value),#(#BipedPicker_Rollout,#chkbx_ghostWireframe,#checked),#(#BipedPicker_Rollout,#chkbx_ghostFrameNumbers,#checked),#(#BipedPicker_Rollout,#chkbtn_visiblePB,#state),#(#BipedPicker_Rollout,#chkbx_keySwapPB,#checked),#(#BipedPicker_Rollout,#spn_PBopacity,#value),#(#BipedPicker_Rollout,#chkbtn_visibleSnapshots,#state),#(#BipedPicker_Rollout,#edtxt_snapshotSceneLayer,#text),#(#BipedPicker_Rollout,#spn_snapshotOpacity,#value),#(#BipedPicker_Rollout,#chkbtn_visibleTrajHelpers,#state),#(#BipedPicker_Rollout,#chkbtn_addTrajHelper,#state),#(#BipedPicker_Rollout,#spn_limitStart,#value),#(#BipedPicker_Rollout,#spn_limitEnd,#value),#(#BipedPicker_Rollout,#chkbx_limitTrajDisplay,#checked))
fn ZYLB_SwitchLanguage =
(
 local saved = #()
 local folded = #()
 local mainRolls = #(#SelectionDisplayTime_Rollout,#Keys_Rollout,#LimbSpaces_Rollout,#PosePosture_Rollout,#Reference_Rollout,#Layers_Rollout,#BipFiles_Rollout,#AlignBake_Rollout,#About_Rollout)
 local sel = selection as array
 local mainOpen = g_ZYLB_BH.bipedUI_Floater != undefined and g_ZYLB_BH.bipedUI_Floater.open
 local pickerOpen = g_ZYLB_BH.BipedPicker_Rollout != undefined and g_ZYLB_BH.BipedPicker_Rollout.open
 if mainOpen do for name in mainRolls do append folded #(name,(getProperty g_ZYLB_BH name).open)
 for spec in ZYLB_StateSpecs do
 (
  local r = getProperty g_ZYLB_BH spec[1]
  if r != undefined and (r.open or (mainOpen and (findItem mainRolls spec[1]) > 0)) do
  (
   local c = getProperty r spec[2]
   append saved #(spec[1],spec[2],spec[3],getProperty c spec[3])
  )
 )
 ZYLB_CN = not ZYLB_CN
 setIniSetting ZYLB_Ini "Language" "UI" (if ZYLB_CN then "zh" else "en")
 local oldTool = g_ZYLB_BH
 if mainOpen do closeRolloutFloater oldTool.bipedUI_Floater
 if pickerOpen do destroyDialog oldTool.BipedPicker_Rollout
 -- 语言切换会重建窗口；先回收已销毁窗口的图标资源。
 gc()
 fileIn (ZYLB_IconDir + (if ZYLB_CN then "ZYLB_Core_zh.ms" else "ZYLB_Core_en.ms"))
 ZYPersistToolbarMacros()
 for prop in #(#TRstart,#TRend,#TRstep,#copiedTransform,#a_ATtoggles,#a_storedSpaces) do setProperty g_ZYLB_BH prop (getProperty oldTool prop)
 if mainOpen do g_ZYLB_BH.f_bipedHelperUI()
 if pickerOpen do g_ZYLB_BH.f_bipedPickerUI()
 for item in saved do
 (
  local r = getProperty g_ZYLB_BH item[1]
  if r != undefined and (r.open or (mainOpen and (findItem mainRolls item[1]) > 0)) do setProperty (getProperty r item[2]) item[3] item[4]
 )
 for state in folded do (getProperty g_ZYLB_BH state[1]).open = state[2]
 select (for n in sel where isValidNode n collect n)
)

fileIn (ZYLB_IconDir + (if ZYLB_CN then "ZYLB_Core_zh.ms" else "ZYLB_Core_en.ms"))

ZYPersistToolbarMacros()
