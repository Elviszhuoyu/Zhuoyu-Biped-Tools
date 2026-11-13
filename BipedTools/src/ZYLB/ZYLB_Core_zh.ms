/**************************************************************************************************************************
// This script was authored by Lorne Brooks, Email: lbtools2k@gmail.com
//
//
// REVISION HISTORY:
// Version 3.5 18/06/24;
//						- Added the Apply Transform and Foot Cleanup functionality to the Picker UI.
// Version 3.4 24/05/24;
//						- Added a new Biped Picker UI which works with the Biped Helper functions. This can be opened in several ways including: From the main Biped Helper UI using a
//						  picker button; By clicking the Biped Helper toolbar icon while holding Shift; By assigning a hotkey to a macro; Or by placing a dedicated toolbar icon. The
//						  picker has been designed to work with a standard human Biped configuration.
//						- Moved pose buffering into the Reference rollout.
//						- Toggle trajectories now behaves as a check button and queries the current Biped state.
//						- Added new ability to toggle ghost on selected objects with all ghost settings in the Reference rollout.
//						- Added the ability to swap to the Pose Buffer when one is available and toggled active. Used after altering a pose to allow swapping between the new pose and
//						  pose buffer while keeping it active.
//						- Prevented pose buffer mesh from using display by layer property which resulted in an opaque rendering and not using opacity setting.
//						- Added new ability to copy the transform of an object (e.g. a hand or foot) then paste or bake to either the current frame or a selected time range. Different
//						  axes for position and rotation can be set when pasting or baking. Can also be applied generically to non-Biped objects. Found in the Keys rollout.
//						- Added new ability to cleanup footsteps by re-orienting a foot in pitch, roll or yaw, as well as snapping the base of the foot to the ground plane. Found in
//						  the Keys rollout.
//						- Added the apply increment functionaily (without displaying the dialog) to the Keys rollout.
//						- Added box mode and bend links toggles.
//						- Added new selection buttons for getting the parent, child, all children, or growing seleection up or down the hierarchy.
//						- Added new ability to add trajectory helpers to the surface of picked Biped parts, with the option to trim using a time range. Found in the Reference rollout.
// Version 3.3 19/04/24;
//						- Added more settings for adjusting TCB values on existing keys. Can now choose tension and bias as well as continuity. Can also choose which COM tracks to
//						  affect if the COM is selected.
//						- Added a new Biped snap buffer for current pose at slidertime to use when posing. Can re-snap a new buffered pose, toggle visibility or remove the buffered pose.
// Version 3.2 13/10/23;
//						- Fixed a crash when attempting to paste a copied posture with an existing empty CopyPosture collection.
//						- Move the Keys section to its own separate rollout.
//						- Added a Time Range section which applies to all functions that operate across the time range.
//						- Key All Parts and Key Selected Parts can now add new keys across the time range by holding either shift or control.
//						- Added a new method to delete keys across the time range for either selected parts, or all parts if shift or control are held.
//						- Added a new method to delete in-between keys across the time range based a step size set by a spinner. Keys that exist between each step will be removed.
//						- Added ability to paste a copied posture across the time range for each frame when holding shift or control.
//						- Added additional options for pasting a posture on the Biped root (COM).
//						- Added a new method to Posture Grabber for straightening fingers with finger selection.
//						- Added left and right hand select all fingers buttons.
//						- Added prop alignment and baking to a target object to the Baking rollout.
//						- Added new methods to Layers rollout for adding, deleting, collapsing and renaming Biped layers.
//						- Added support for tail bones when setting or deleting keys.
//						- Added selection of props if available.
//						- Added checks for invalid biped to all UI functions.
//						- Mirroring limb postures now includes fingers and toes.
//						- Script now handles finding Biped objects with modifiers in the stack.
//						- Various UI and layout adjustments.
// Version 3.1 24/09/22;
//						- Changed PDF guide button to link to an online guide.
//						- Added ability to hold shift to set planted keys for limbs. Store and load spaces now account for planted keys.
//						- IK pivot UI's and layers retargeting UI now follow main UI if moved.
// Version 3.0 23/02/21;
//						- Renamed previous method "Align & Bake To Target" to "Align To Offset".
//						- Added new alignment method "Align To Match" which re-aligns a Biped for all root keys to match a target object's animation (can be another Biped root).
// Version 2.9 21/02/21;
//						- Added a new rollout "Alignment" which contains a method for aligning and baking to a target object for any keys found on the root and limbs.
// Version 2.8 09/11/20;
//						- Added to layers rollout a Snap & Set Key button and a separate dialog for Retargeting.
// Version 2.7 02/11/20;
//						- Added a new rollout for layers navigation. Includes: move up and down layer buttons, a drop-down list of available layers,
//						  and active layer toggles.
// Version 2.6 06/10/20;
//						- Added ability to open a new window to set IK pivots for each hand & foot where planted or sliding keys are assigned.
// Version 2.5 25/09/20;
//						- Added ability to save and load BIP animation files via both dialog and quick modes.
// Version 2.4 10/05/20;
//						- Added a new baking option for keying a Biped head in order to track an active Look At Target if assigned.
// Version 2.3 28/06/17;
//						- Fixed a bug where paste posture would crash due to missing posture in the collection. It now filters the selection for
//						    biped only parts during the copy posture phase, so that the collection is created properly for pasting.
//						- UI now remembers it's last location, even after Max restart.
// Version 2.2 23/11/16;
//						- Added the ability to copy and paste (with optional opposite) a posture based on a selection of biped parts. The copied
//						  posture is saved as a file for later retrieval. You can also quickly select the copied biped parts if available.
// Version 2.1 19/11/16;
//						- Added a new rollout called Quick Posture, with options to mirror limbs, and straighten or untwist spine links.
// Version 2.0 06/02/16;
//						- Added a new button "Key Selected Biped Parts". Adds keys to all selected biped parts at the current slider time.
// Version 1.9 08/11/15;
//						- Bake Animation Keys now refreshes the UI in the case of the root being a <deleted scene node>.
//						- Trajectories Toggle now force switches to the motion panel before toggling the trajectories mode.
//						- Baking up to next and last modes now allows any part of a limb to be selected, not just the hands or feet.
//						- Added options to enable a single pose to be grabbed then applied without using the Biped collections panel. It saves the pose to a file for storage.
//						- Delete Frame Keys can now remove keys on all Biped parts at the current slider time, by holding Shift or Control when clicking the button.
//						- Added a select Both Hands & Feet button to the Selection/Display/Keys rollout.
//						- Updated PDF guide.
// Version 1.8 06/11/15;
//						- Fixed global variable usage which caused the functions key all and delete all keys to not work (finally).
//						- Changed interface references of IK to be Body/Object space instead, to more accurately reflect their purpose.
//						- Added a Delete Frame Keys button, which deletes all keys on selected Biped parts based on the slider time.
//						- Added new button images, tooltips and rearranged some UI elements.
//						- Improved code for baking animation keys.
//						- Added a PDF guide and button link to the UI (in the About rollout).
//						- The previous dialog version of this tool is no longer supported. "Compact" reference removed.
// Version 1.7 01/07/15;
//						- Converted the dialog interface into a more compact floater with collaspable rollouts.
//						- Added functionality to enable user specified snapshots scene layer.
// Version 1.6 17/12/14;
//						- Fixed global variable usage which caused the functions key all and delete all keys to not work.
// Version 1.5 09/12/14;
//						- While using the Shift or Control method for setting TCB linear or smooth values across the time range, if the
//							Escape key is pressed the operation will now stop.
// Version 1.4 27/10/14;
//						- Email change for help contact.
// Version 1.3 13/10/14;
//						- When selecting from the dropdown list of multiple Bipeds, you can now hold Shift to also select the Biped root
//							or hold Control to select the whole rig.
// Version 1.2 22/09/14;
//						- Fixed the snapshot functionality. Do longer selects anything which means it works for frozen objects in Max 2015.
//							Also, now handles multiple skin meshes in the Mesh Character layer. Only Skin meshes are snapshot.
// Version 1.1 17/09/14;
//						- Added a dropdown list to enable selection of a Biped for the panel to operate on in the case of multiple Bipeds.
// Version 1.0 15/09/14;
//						- First public release.
//
//
// This script is not copyrighted, please feel free to modify or distribute.
//
**************************************************************************************************************************/


global g_ZYLB_BH

struct s_ZYLB_bipedHelper
(

/*==================================================================================
// Structure variables
====================================================================================*/

BH_pos, --// biped helper UI position
BP_pos, --// biped picker UI position
BP_height = #(557,874), --// toggle height of picker UI to show or hide tools stored as #(min,max)
BP_state, --// index for BP_height based on stored INI value
defaultPos = [150,150], --mouse.screenpos + [-75,-15],
bhINIfile = (getDir #plugcfg) + @"\ZYLB_BipedHelper.ini",
quickBipFile = (getDir #plugcfg) + @"\ZYLB_BipedHelper_QuickSave.bip",
poseBufferSnap = (getDir #plugcfg) + @"\ZYLB_BipedHelper_PoseBufferSnap.cpy",
copiedPose = (getDir #plugcfg) + @"\ZYLB_BipedHelper_CopiedPose.cpy",
copiedPosture = (getDir #plugcfg) + @"\ZYLB_BipedHelper_CopiedPosture.cpy",
postureObjsTextFile = (getDir #plugcfg) + @"\ZYLB_BipedHelper_PostureObjs.txt",
imageGuide = ZYLB_IconDir + @"\LBTools_Guide_Image.bmp",
defaultPBopacity = 40,
defaultSnapshotsOpacity = 20,
f_openBipedUI,
f_openBipedPickerUI,
bipedUI_Floater,
AlignBake_Rollout,
SelectionDisplayTime_Rollout,
leftHandPivots_Rollout,
rightHandPivots_Rollout,
leftFootPivots_Rollout,
rightFootPivots_Rollout,
Reference_Rollout,
Keys_Rollout,
BipFiles_Rollout,
PosePosture_Rollout,
LayersRetargeting_Rollout,
Layers_Rollout,
LimbSpaces_Rollout,
BipedPicker_Rollout,
About_Rollout,
a_storedSpaces = #(),
a_bips = #(),
bRoot, bPelvis,
bSpine1, bSpine2, bSpine3, bSpine4,
bNeck, bHead, bPonytail1, bPonytail2,
bClavicleL, bUpperarmL, bForearmL, bHandL,
bClavicleR, bUpperarmR, bForearmR, bHandR,
bThumb1L, bThumb2L, bThumb3L,
bIndex1L, bIndex2L, bIndex3L,
bMiddle1L, bMiddle2L, bMiddle3L,
bRing1L, bRing2L, bRing3L,
bPinky1L, bPinky2L, bPinky3L,
bThumb1R, bThumb2R, bThumb3R,
bIndex1R, bIndex2R, bIndex3R,
bMiddle1R, bMiddle2R, bMiddle3R,
bRing1R, bRing2R, bRing3R,
bPinky1R, bPinky2R, bPinky3R,
bThighL, bCalfL, bFootL, bToeL,
bThighR, bCalfR, bFootR, bToeR,
bTail,
bProp1, bProp2, bProp3,
a_armLeft = #(),
a_armRight = #(),
a_legLeft = #(),
a_legRight = #(),
a_fingersLeft = #(),
a_fingersRight = #(),
a_fingersOnlyLeft = #(), --// excludes thumb
a_fingersOnlyRight = #(), --// excludes thumb
a_thumbLeft = #(),
a_thumbRight = #(),
a_toesLeft = #(),
a_toesRight = #(),
a_spines = #(),
a_bipedHandsFeet = #(),
a_bipedLimbs = #(),
a_bipedAllParts = #(),
TRstart = animationRange.start,
TRend = animationRange.end,
TRstep = 1,
retargetingOption = 1,
leftHandUIoffset = [-95,120],
rightHandUIoffset = [215,120],
leftFootUIoffset = [-95,280],
rightFootUIoffset = [215,280],
picker_leftHandUIoffset = [-95,160],
picker_rightHandUIoffset = [305,160],
picker_leftFootUIoffset = [-95,340],
picker_rightFootUIoffset = [305,340],
layersRetargetingUIoffset = [220,300],
poseBuffStr = "#_BIPED_POSE_#",
a_ATtoggles = #(false,false,false,false), --// (PosX,PosY,PosZ,RotXYZ) - used by the Apply Transform operations
copiedTransform, --// used by the Apply Transform operations
copiedMsg = "已复制世界变换", --// used by the Apply Transform operations for the Biped Helper UI
dumYawCalf, --// used by Foot Cleanup
dumYawFoot, --// used by Foot Cleanup
clr_lightblue = (color 166 202 240),
clr_blue = (color 28 28 177),
clr_green = (color 6 134 6),
clr_cyan = (color 8 110 134),
clr_yellow = (color 224 198 87),
clr_red = (color 134 6 6),
clr_purple = (color 108 8 136),
clr_chartroose = (color 113 134 6),
clr_darkgrey = (color 10 10 10),
clr_orange = (color 255 60 0),

/*==================================================================================
// Structure functions
/*==================================================================================

f_buttonColor
f_findSkinModifier
f_getAllChildren
f_findHierarchyRoot
f_findHierarchy
f_missingBipedError
f_filterBipedParts
f_findAllParts
f_selectBipedParent
f_getBipedChildren
f_selectBipedChildren
f_selectBipedChild
f_findFingerRoot
f_findAllFingers
f_findAllToes
f_findAllSpines
f_initBipedParts
f_selectBipedParts
f_collectBipRoots
f_processTCBvalues
f_evaluateTCBprocess
f_addKeysToAllParts
f_addKeysToSelectedParts
f_deleteAllFrameKeys
f_deleteBipedPartKeys
f_pasteCopiedTM
f_applyPitchOrient
f_applyRollOrient
f_applyYawOrient
f_applyFootOrientation
f_snapFootToFloor
f_getAllKeyTimesTR
f_storeSpaces
f_loadSpaces
f_limbBody
f_limbObject
f_changePivot
f_getPivotIndex
f_isValidBiped
f_trajectoryHelpersDelete
f_addTrajectoryHelper
f_linearAttach
f_removePoseBuffer
f_cleanupPoseBuffer
f_savePoseBufferFile
f_snapPB
f_swapPB
f_snapshotGeometry
f_snaphotsVisibility
f_snapshotsDelete
f_snapshotsOpacity
f_bipedBakeSlidingKeys
f_bipedBakeSlidingKeyNext
f_bipedBakeSlidingKeyLast
f_bipedBakeRoot
f_bipedBakeHead
f_openPivotsUI_LeftHand
f_openPivotsUI_RightHand
f_openPivotsUI_LeftFoot
f_openPivotsUI_RightFoot
f_bipedHelperUI
f_bipedPickerUI

====================================================================================*/

fn f_buttonColor width height clr =
(
	bitmap width height color:clr gamma:1.0
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_findSkinModifier obj =
(
	local skinFound = false
	for i = 1 to obj.modifiers.count do
	(
		if classof obj.modifiers[i] == Skin then
		(
			skinFound = true
			exit
		)
	)
	skinFound
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_getAllChildren obj &a_nodes:#() = --// Recursive function
(
	for c in obj.children do
	(
		append a_nodes c
		f_getAllChildren c a_nodes:a_nodes
	)
	a_nodes
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_findHierarchyRoot obj = --// Recursive function
(
	if obj != undefined then
	(
		if isValidnode obj.parent then
		(
			f_findHierarchyRoot obj.parent
		)
		else
		(
			obj
		)
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_findHierarchy obj =
(
	if obj != undefined then 
	(
		local parentNode = g_ZYLB_BH.f_findHierarchyRoot obj
		g_ZYLB_BH.f_getAllChildren parentNode a_nodes:#(parentNode)
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_missingBipedError picker:false =
(
	ZYDiagMessageBox "之前选择的 Biped 已不在场景中，界面已刷新。" title:"Biped 助手"
	setIniSetting g_ZYLB_BH.bhINIfile "BipedPanel" "CurrentBip" "1"
	if picker then g_ZYLB_BH.f_openBipedPickerUI()
	else g_ZYLB_BH.f_openBipedUI()
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_filterBipedParts a_objs =
(
	local a_bipedObjs = #()
	for obj in a_objs where (classof obj.baseObject == Biped_Object) do
	(
		append a_bipedObjs obj
	)
	a_bipedObjs
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_findAllParts =
(
	g_ZYLB_BH.a_bipedAllParts = #()
	local a_bipedObjs = g_ZYLB_BH.f_findHierarchy g_ZYLB_BH.bRoot
	a_bipedObjs = g_ZYLB_BH.f_filterBipedParts a_bipedObjs
	for obj in a_bipedObjs do
	(
		if NOT (matchpattern obj.name pattern:"*Footsteps") AND NOT (matchpattern obj.name pattern:"*Twist*") AND NOT (matchpattern obj.name pattern:"*Nub") do
		(
			append g_ZYLB_BH.a_bipedAllParts obj
		)
	)
	g_ZYLB_BH.a_bipedAllParts
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
	
fn f_selectBipedParent a_objs clearSel:true =
(
 local nodes=#()
 for obj in a_objs where isValidNode obj and findItem g_ZYLB_BH.a_bipedAllParts obj>0 do
  if isValidNode obj.parent and findItem g_ZYLB_BH.a_bipedAllParts obj.parent>0 do appendIfUnique nodes obj.parent
 ZYHierarchySelect nodes clearSel:clearSel
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_getBipedChildren obj &a_nodes:#() = --// Recursive function
(
	if obj != undefined then
	(
		for c in obj.children where classof c.baseObject == Biped_Object do
		(
			append a_nodes c
			f_getBipedChildren c a_nodes:a_nodes
		)
	)
	a_nodes
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_selectBipedChildren a_objs =
(
 local nodes=#()
 for obj in a_objs where isValidNode obj and findItem g_ZYLB_BH.a_bipedAllParts obj>0 do
  for child in f_getBipedChildren obj where findItem g_ZYLB_BH.a_bipedAllParts child>0 do appendIfUnique nodes child
 ZYHierarchySelect nodes clearSel:false
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_selectBipedChild a_objs clearSel:true =
(
 local nodes=#()
 for obj in a_objs where isValidNode obj and findItem g_ZYLB_BH.a_bipedAllParts obj>0 do
  for child in obj.children where findItem g_ZYLB_BH.a_bipedAllParts child>0 do appendIfUnique nodes child
 ZYHierarchySelect nodes clearSel:clearSel
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_findFingerRoot obj = --// Recursive function
(
	if obj != undefined then
	(
		if isValidnode obj.parent AND obj.parent != g_ZYLB_BH.bHandL AND obj.parent != g_ZYLB_BH.bHandR then
		(
			f_findFingerRoot obj.parent
		)
		else
		(
			obj
		)
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_findAllFingers =
(
	g_ZYLB_BH.a_fingersLeft = #()
	g_ZYLB_BH.a_fingersRight = #()
	local handChildren = #()
	g_ZYLB_BH.f_getAllChildren g_ZYLB_BH.bHandL a_nodes:handChildren
	for obj in handChildren where classof obj.baseObject == Biped_Object do
	(
		append g_ZYLB_BH.a_fingersLeft obj
	)
	handChildren = #()
	g_ZYLB_BH.f_getAllChildren g_ZYLB_BH.bHandR a_nodes:handChildren
	for obj in handChildren where classof obj.baseObject == Biped_Object do
	(
		append g_ZYLB_BH.a_fingersRight obj
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_findAllToes =
(
	g_ZYLB_BH.a_toesLeft = #()
	g_ZYLB_BH.a_toesRight = #()
	local footChildren = #()
	g_ZYLB_BH.f_getAllChildren g_ZYLB_BH.bFootL a_nodes:footChildren
	for obj in footChildren where classof obj.baseObject == Biped_Object do
	(
		append g_ZYLB_BH.a_toesLeft obj
	)
	footChildren = #()
	g_ZYLB_BH.f_getAllChildren g_ZYLB_BH.bFootR a_nodes:footChildren
	for obj in footChildren where classof obj.baseObject == Biped_Object do
	(
		append g_ZYLB_BH.a_toesRight obj
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_findAllSpines =
(
	g_ZYLB_BH.a_spines = for obj in $objects where classof obj.baseObject == Biped_Object AND findstring obj.name g_ZYLB_BH.bRoot.name != undefined AND findstring obj.name "spine" != undefined collect obj
	g_ZYLB_BH.a_spines as array
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_initBipedParts picker:false =
(
	if isValidNode g_ZYLB_BH.bRoot then
	(
		g_ZYLB_BH.bPelvis = biped.getNode g_ZYLB_BH.bRoot #Pelvis
		g_ZYLB_BH.bSpine1 = biped.getNode g_ZYLB_BH.bRoot #Spine link:1
		g_ZYLB_BH.bSpine2 = biped.getNode g_ZYLB_BH.bRoot #Spine link:2
		g_ZYLB_BH.bSpine3 = biped.getNode g_ZYLB_BH.bRoot #Spine link:3
		g_ZYLB_BH.bSpine4 = biped.getNode g_ZYLB_BH.bRoot #Spine link:4
		g_ZYLB_BH.bNeck = biped.getNode g_ZYLB_BH.bRoot #Neck
		g_ZYLB_BH.bHead = biped.getNode g_ZYLB_BH.bRoot #Head
		g_ZYLB_BH.bPonytail1 = biped.getNode g_ZYLB_BH.bRoot #pony1
		g_ZYLB_BH.bPonytail2 = biped.getNode g_ZYLB_BH.bRoot #pony2
		
		g_ZYLB_BH.bClavicleL = biped.getNode g_ZYLB_BH.bRoot #lArm link:1
		g_ZYLB_BH.bUpperarmL = biped.getNode g_ZYLB_BH.bRoot #lArm link:2
		g_ZYLB_BH.bForearmL = biped.getNode g_ZYLB_BH.bRoot #lArm link:3
		g_ZYLB_BH.bHandL = biped.getNode g_ZYLB_BH.bRoot #lArm link:4
		
		g_ZYLB_BH.bClavicleR = biped.getNode g_ZYLB_BH.bRoot #rArm link:1
		g_ZYLB_BH.bUpperarmR = biped.getNode g_ZYLB_BH.bRoot #rArm link:2
		g_ZYLB_BH.bForearmR = biped.getNode g_ZYLB_BH.bRoot #rArm link:3
		g_ZYLB_BH.bHandR = biped.getNode g_ZYLB_BH.bRoot #rArm link:4






























		g_ZYLB_BH.bThighL = biped.getNode g_ZYLB_BH.bRoot #lLeg link:1
		g_ZYLB_BH.bCalfL = biped.getNode g_ZYLB_BH.bRoot #lLeg link:2
		g_ZYLB_BH.bFootL = biped.getNode g_ZYLB_BH.bRoot #lLeg link:3
		g_ZYLB_BH.bToeL = biped.getNode g_ZYLB_BH.bRoot #lToes link:1
		
		g_ZYLB_BH.bThighR = biped.getNode g_ZYLB_BH.bRoot #rLeg link:1
		g_ZYLB_BH.bCalfR = biped.getNode g_ZYLB_BH.bRoot #rLeg link:2
		g_ZYLB_BH.bFootR = biped.getNode g_ZYLB_BH.bRoot #rLeg link:3
		g_ZYLB_BH.bToeR = biped.getNode g_ZYLB_BH.bRoot #rToes link:1
		
		g_ZYLB_BH.bTail = biped.getNode g_ZYLB_BH.bRoot #tail
		
		g_ZYLB_BH.bProp1 = biped.getNode g_ZYLB_BH.bRoot #prop1
		g_ZYLB_BH.bProp2 = biped.getNode g_ZYLB_BH.bRoot #prop2
		g_ZYLB_BH.bProp3 = biped.getNode g_ZYLB_BH.bRoot #prop3
		
		g_ZYLB_BH.a_armLeft = #(g_ZYLB_BH.bClavicleL, g_ZYLB_BH.bUpperarmL, g_ZYLB_BH.bForearmL, g_ZYLB_BH.bHandL)
		g_ZYLB_BH.a_armRight = #(g_ZYLB_BH.bClavicleR, g_ZYLB_BH.bUpperarmR, g_ZYLB_BH.bForearmR, g_ZYLB_BH.bHandR)
		g_ZYLB_BH.a_legLeft = #(g_ZYLB_BH.bThighL, g_ZYLB_BH.bCalfL, g_ZYLB_BH.bFootL)
		g_ZYLB_BH.a_legRight = #(g_ZYLB_BH.bThighR, g_ZYLB_BH.bCalfR, g_ZYLB_BH.bFootR)




		
        ZYBuiltinInitFingers g_ZYLB_BH

		g_ZYLB_BH.a_bipedLimbs = #(g_ZYLB_BH.bClavicleL, g_ZYLB_BH.bUpperarmL, g_ZYLB_BH.bForearmL, g_ZYLB_BH.bHandL,
														g_ZYLB_BH.bClavicleR, g_ZYLB_BH.bUpperarmR, g_ZYLB_BH.bForearmR, g_ZYLB_BH.bHandR,
														g_ZYLB_BH.bThighL, g_ZYLB_BH.bCalfL, g_ZYLB_BH.bFootL,
														g_ZYLB_BH.bThighR, g_ZYLB_BH.bCalfR, g_ZYLB_BH.bFootR
													)
		
		g_ZYLB_BH.f_findAllFingers()
		g_ZYLB_BH.f_findAllToes()
		g_ZYLB_BH.f_findAllSpines()
		g_ZYLB_BH.a_bipedHandsFeet = #(g_ZYLB_BH.bHandL, g_ZYLB_BH.bHandR, g_ZYLB_BH.bFootL, g_ZYLB_BH.bFootR)
		g_ZYLB_BH.f_findAllParts()
        if picker and g_ZYLB_BH.BipedPicker_Rollout!=undefined do
        (
            g_ZYLB_BH.BipedPicker_Rollout.btn_selectPonytailL.enabled=isValidNode g_ZYLB_BH.bPonytail1
            g_ZYLB_BH.BipedPicker_Rollout.btn_selectPonytailR.enabled=isValidNode g_ZYLB_BH.bPonytail2
            g_ZYLB_BH.BipedPicker_Rollout.btn_selectProp1.enabled=isValidNode g_ZYLB_BH.bProp1
            g_ZYLB_BH.BipedPicker_Rollout.btn_selectProp2.enabled=isValidNode g_ZYLB_BH.bProp2
            g_ZYLB_BH.BipedPicker_Rollout.btn_selectProp3.enabled=isValidNode g_ZYLB_BH.bProp3
            ZYPickerPartsRefresh()
        )
	)
	else
	(
		if picker then g_ZYLB_BH.f_missingBipedError picker:true
		else g_ZYLB_BH.f_missingBipedError()
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_selectBipedParts parts picker:false =
(
 if NOT isValidNode g_ZYLB_BH.bRoot then
 (
  if picker then g_ZYLB_BH.f_initBipedParts picker:true else g_ZYLB_BH.f_initBipedParts()
  return false
 )
 local nodes=if classOf parts==Array then (for n in parts where isValidNode n collect n) else (if isValidNode parts then #(parts) else #())
 if nodes.count==0 do return false
 ZYSelectionPrepare()
 -- 原子选择后立即同步真实状态，避免重复重绘和处理中间消息。
 local mode=if keyboard.altPressed then 3 else if keyboard.shiftPressed or keyboard.controlPressed then 2 else 1
 ZYPickerSelecting=true
 try
 (
  if mode==3 then deselect nodes else if mode==2 then selectMore nodes else select nodes
 )catch(ZYPickerSelecting=false;ZYPickerSync();throw())
 ZYPickerSelecting=false
 ZYPickerSync()
 redrawViews()
 true
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_collectBipRoots =
(
	for b in geometry where (classof b.controller == Vertical_Horizontal_Turn) do
	(
		append g_ZYLB_BH.a_bips b
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

mapped fn f_processTCBvalues obj a_tcbCOM type val atTime:sliderTime =
(
	try
	(
		if obj == g_ZYLB_BH.bRoot then
		(
			if type == 1 then --// Tension
			(
				--// Vertical
				if a_tcbCOM[1] then (biped.getKey obj.controller[1].controller (getkeyindex obj.controller[1].controller atTime)).tension = val
				--// Horizontal
				if a_tcbCOM[2] then (biped.getKey obj.controller[2].controller (getkeyindex obj.controller[2].controller atTime)).tension = val
				--// Turning
				if a_tcbCOM[3] then (biped.getKey obj.controller[3].controller (getkeyindex obj.controller[3].controller atTime)).tension = val
			)
			else if type == 2 then --// Continuity
			(
				--// Vertical
				if a_tcbCOM[1] then (biped.getKey obj.controller[1].controller (getkeyindex obj.controller[1].controller atTime)).continuity = val
				--// Horizontal
				if a_tcbCOM[2] then (biped.getKey obj.controller[2].controller (getkeyindex obj.controller[2].controller atTime)).continuity = val
				--// Turning
				if a_tcbCOM[3] then (biped.getKey obj.controller[3].controller (getkeyindex obj.controller[3].controller atTime)).continuity = val
			)
			else if type == 3 then --// Bias
			(
				--// Vertical
				if a_tcbCOM[1] then (biped.getKey obj.controller[1].controller (getkeyindex obj.controller[1].controller atTime)).bias = val
				--// Horizontal
				if a_tcbCOM[2] then (biped.getKey obj.controller[2].controller (getkeyindex obj.controller[2].controller atTime)).bias = val
				--// Turning	
				if a_tcbCOM[3] then (biped.getKey obj.controller[3].controller (getkeyindex obj.controller[3].controller atTime)).bias = val
			)
		)
		else
		(
			if type == 1 then
			(
				(biped.getKey obj.controller (getkeyindex obj.controller atTime)).tension = val
			)
			else if type == 2 then
			(
				(biped.getKey obj.controller (getkeyindex obj.controller atTime)).continuity = val
			)
			else if type == 3 then
			(
				(biped.getKey obj.controller (getkeyindex obj.controller atTime)).bias = val
			)
		)
	)catch(g_ZYLB_BH.f_initBipedParts())
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/**
	a_tcbCOM - is the store of the COM track selection from the UI toggles
	type - is the mode to use for setting TCB (i.e. tension, continuity or bias)
	val - the value to apply using either the spinner or a preset
*/
fn f_evaluateTCBprocess a_tcbCOM type val =
(
	undo "TCBProcess" on
	(
		if selection.count > 0 then
		(
			if keyboard.shiftPressed OR keyboard.controlPressed then
			(
				for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
				(
					g_ZYLB_BH.f_processTCBvalues (selection as array) a_tcbCOM type val atTIme:t
				)
			)
			else
			(
				g_ZYLB_BH.f_processTCBvalues (selection as array) a_tcbCOM type val
			)
		)
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_addKeysToAllParts atTime:sliderTime =
(
	try
	(
		biped.addNewKey g_ZYLB_BH.bRoot.controller.vertical atTime
		biped.addNewKey g_ZYLB_BH.bRoot.controller.horizontal atTime
		biped.addNewKey g_ZYLB_BH.bRoot.controller.turning atTime
		biped.addNewKey g_ZYLB_BH.bPelvis.controller atTime
		biped.addNewKey g_ZYLB_BH.bSpine1.controller atTime
		biped.addNewKey g_ZYLB_BH.bHead.controller atTime
		biped.addNewKey g_ZYLB_BH.bHandL.controller atTime
		biped.addNewKey g_ZYLB_BH.bHandR.controller atTime
		biped.addNewKey g_ZYLB_BH.bFootL.controller atTime
		biped.addNewKey g_ZYLB_BH.bFootR.controller atTime
		biped.addNewKey g_ZYLB_BH.bTail.controller atTime
	)catch()
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_addKeysToSelectedParts part atTime:sliderTime =
(
	if part == g_ZYLB_BH.bRoot then
	(
		biped.addNewKey part.controller.vertical atTime
		biped.addNewKey part.controller.horizontal atTime
		biped.addNewKey part.controller.turning atTime
	)
	else
	(
		biped.addNewKey part.controller atTime
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_deleteAllFrameKeys atTime:sliderTime =
(
	try(deleteKey g_ZYLB_BH.bRoot.controller.vertical.controller (getKeyIndex g_ZYLB_BH.bRoot.controller.vertical.controller atTime))catch()
	try(deleteKey g_ZYLB_BH.bRoot.controller.horizontal.controller (getKeyIndex g_ZYLB_BH.bRoot.controller.horizontal.controller atTime))catch()
	try(deleteKey g_ZYLB_BH.bRoot.controller.turning.controller (getKeyIndex g_ZYLB_BH.bRoot.controller.turning.controller atTime))catch()
	try(deleteKey g_ZYLB_BH.bPelvis.controller (getKeyIndex g_ZYLB_BH.bPelvis.controller atTime))catch()
	try(deleteKey g_ZYLB_BH.bSpine1.controller (getKeyIndex g_ZYLB_BH.bSpine1.controller atTime))catch()
	try(deleteKey g_ZYLB_BH.bHead.controller (getKeyIndex g_ZYLB_BH.bHead.controller atTime))catch()
	try(deleteKey g_ZYLB_BH.bPonytail1.controller (getKeyIndex g_ZYLB_BH.bPonytail1.controller atTime))catch()
	try(deleteKey g_ZYLB_BH.bPonytail2.controller (getKeyIndex g_ZYLB_BH.bPonytail2.controller atTime))catch()
	try(deleteKey g_ZYLB_BH.bHandL.controller (getKeyIndex g_ZYLB_BH.bHandL.controller atTime))catch()
	try(deleteKey g_ZYLB_BH.bHandR.controller (getKeyIndex g_ZYLB_BH.bHandR.controller atTime))catch()
	try(deleteKey g_ZYLB_BH.bFootL.controller (getKeyIndex g_ZYLB_BH.bFootL.controller atTime))catch()
	try(deleteKey g_ZYLB_BH.bFootR.controller (getKeyIndex g_ZYLB_BH.bFootR.controller atTime))catch()
	try(deleteKey g_ZYLB_BH.bTail.controller (getKeyIndex g_ZYLB_BH.bTail.controller atTime))catch()
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_deleteBipedPartKeys part atTime:sliderTime =
(
	deselectKeys part.controller
	selectKeys part.controller atTime
	if part == g_ZYLB_BH.bRoot then
	(
		deleteKeys part.controller.vertical.controller.keys #selection
		deleteKeys part.controller.horizontal.controller.keys #selection
		deleteKeys part.controller.turning.controller.keys #selection
	)
	else
	(
		deleteKeys part.controller.keys #selection
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_pasteCopiedTM obj =
(
	local pt = Point wirecolor:green
	hide pt
	with animate off
	(
		pt.transform = obj.transform

		if g_ZYLB_BH.a_ATtoggles[4] then --// rotation XYZ
		(
			pt.transform = g_ZYLB_BH.copiedTransform
			pt.position = obj.transform.position
		)
		if g_ZYLB_BH.a_ATtoggles[1] then
		(
			pt.position.x = g_ZYLB_BH.copiedTransform.position.x
		)
		if g_ZYLB_BH.a_ATtoggles[2] then
		(
			pt.position.y = g_ZYLB_BH.copiedTransform.position.y
		)
		if g_ZYLB_BH.a_ATtoggles[3] then
		(
			pt.position.z = g_ZYLB_BH.copiedTransform.position.z
		)
		if g_ZYLB_BH.a_ATtoggles[1] == false AND g_ZYLB_BH.a_ATtoggles[2] == false AND g_ZYLB_BH.a_ATtoggles[3] == false then
		(
			pt.position = obj.transform.position
		)
	)
	--// Two pastes are required to properly plant IK limbs
	obj.transform = pt.transform
	obj.transform = pt.transform
	delete pt
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_applyPitchOrient foot =
(
	local pt = point()
	pt.transform = foot.transform
	local hlpAlign = point wirecolor:(color 14 255 2) size:10
	local hlpUp = point wirecolor:(color 196 88 225) size:10
	hlpAlign.transform = pt.transform
	hlpUp.transform = pt.transform	
		
	in coordsys local move hlpAlign [0, 10, 0]
	in coordsys local move hlpUp [10, 0, 0]

	pt.rotation.controller = LookAt_Constraint()
	pt.rotation.controller.appendTarget hlpAlign 50.0
	pt.rotation.controller.upnode_world = off
	pt.rotation.controller.pickUpNode = hlpUp
	pt.rotation.controller.StoUP_axis = 0
	pt.rotation.controller.upnode_axis = 0
	pt.rotation.controller.target_axis = 1
	pt.rotation.controller.upnode_axis = 0
	pt.rotation.controller.StoUP_axis = 0

	if hlpAlign.position.z < pt.position.z then
	(
		while hlpAlign.position.z < pt.position.z AND NOT keyboard.escPressed do
		(
			in coordsys local move hlpAlign [-0.01, 0, 0]
		)
	)
	else
	(
		while hlpAlign.position.z > pt.position.z AND NOT keyboard.escPressed do
		(
			in coordsys local move hlpAlign [0.01, 0, 0]
		)	
	)
	foot.transform = pt.transform
			
	delete hlpAlign
	delete hlpUp
	delete pt
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_applyRollOrient foot =
(
	local pt = point()
	pt.transform = foot.transform
	local hlpAlign = point wirecolor:(color 14 255 2) size:10
	local hlpUp = point wirecolor:(color 196 88 225) size:10
	hlpAlign.transform = pt.transform
	hlpUp.transform = pt.transform	
		
	in coordsys local move hlpAlign [0, 0, 10]
	in coordsys local move hlpUp [10, 0, 0]

	pt.rotation.controller = LookAt_Constraint()
	pt.rotation.controller.appendTarget hlpAlign 50.0
	pt.rotation.controller.upnode_world = off
	pt.rotation.controller.pickUpNode = hlpUp
	pt.rotation.controller.StoUP_axis = 0
	pt.rotation.controller.upnode_axis = 0
	pt.rotation.controller.target_axis = 2
	pt.rotation.controller.upnode_axis = 1
	pt.rotation.controller.StoUP_axis = 1

	if hlpAlign.position.z < pt.position.z then
	(
		while hlpAlign.position.z < pt.position.z AND NOT keyboard.escPressed do
		(
			in coordsys local move hlpAlign [-0.01, 0, 0]
		)
	)
	else
	(
		while hlpAlign.position.z > pt.position.z AND NOT keyboard.escPressed do
		(
			in coordsys local move hlpAlign [0.01, 0, 0]
		)	
	)
	foot.transform = pt.transform
		
	delete hlpAlign
	delete hlpUp
	delete pt
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_applyYawOrient foot =
(
	if NOT isValidNode g_ZYLB_BH.dumYawCalf AND NOT isValidNode g_ZYLB_BH.dumYawFoot then
	(
		g_ZYLB_BH.dumYawCalf = dummy boxsize:[10,10,10]
		g_ZYLB_BH.dumYawCalf.transform = foot.transform
		g_ZYLB_BH.dumYawCalf.parent = foot.parent
		in coordsys local move g_ZYLB_BH.dumYawCalf [0, 10, 0]
		
		g_ZYLB_BH.dumYawFoot = dummy boxsize:[8,8,8]
		g_ZYLB_BH.dumYawFoot.transform = foot.transform
		g_ZYLB_BH.dumYawFoot.parent = foot
		in coordsys local move g_ZYLB_BH.dumYawFoot [0, 10, 0]
	)
	
	local pt = point()
	pt.transform = foot.transform
	local hlpAlign = point wirecolor:(color 14 255 2) size:10
	local hlpUp = point wirecolor:(color 196 88 225) size:10
	hlpAlign.transform = pt.transform
	hlpUp.transform = pt.transform	
		
	in coordsys local move hlpAlign [0, 10, 0]
	in coordsys local move hlpUp [0, 0, 10]

	pt.rotation.controller = LookAt_Constraint()
	pt.rotation.controller.appendTarget hlpAlign 50.0
	pt.rotation.controller.upnode_world = off
	pt.rotation.controller.pickUpNode = hlpUp
	pt.rotation.controller.StoUP_axis = 0
	pt.rotation.controller.upnode_axis = 0
	pt.rotation.controller.target_axis = 1
	pt.rotation.controller.upnode_axis = 0
	pt.rotation.controller.StoUP_axis = 0

	hlpAlign.position = g_ZYLB_BH.dumYawCalf.position
	hlpAlign.position.z = g_ZYLB_BH.dumYawFoot.position.z
	
	foot.transform = pt.transform
	
	delete hlpAlign
	delete hlpUp
	delete pt
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_applyFootOrientation foot PRYstate =
(
	case PRYstate of
	(
		1: g_ZYLB_BH.f_applyPitchOrient foot
		2: g_ZYLB_BH.f_applyRollOrient foot
		3: g_ZYLB_BH.f_applyYawOrient foot
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/**
	Move the Biped foot up so the bottom-most edge touches the ground plane.
*/
fn f_snapFootToFloor foot onlySnapBelowFloor =
(
	local pt = point()
	pt.transform = foot.transform
	if onlySnapBelowFloor then
	(
		if foot.min.z < 0 then
		(
			pt.position.z = pt.position.z - foot.min.z
			foot.transform = pt.transform
		)
	)
	else
	(
		pt.position.z = pt.position.z - foot.min.z
		foot.transform = pt.transform
	)
	delete pt
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/**
	Return the times for all keys in the range, or optionally selected only.
*/
fn f_getAllKeyTimesTR obj rangeStart rangeEnd selectedOnly:false =
(
	local a_TRtimes = #()
	local a_allKeys = obj.controller.keys
	for i = 1 to a_allKeys.count do
	(
		local t = getKeyTime obj.controller i
		if t >= rangeStart AND t <= rangeEnd then
		(
			if selectedOnly then
			(
				if isKeySelected obj.controller i then
				(
					append a_TRtimes a_allKeys[i].time
				)
			)
			else
			(
				append a_TRtimes a_allKeys[i].time
			)
		)
	)
	a_TRtimes
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_storeSpaces =
(
	local a_limb_nodes = #(g_ZYLB_BH.bHandL,g_ZYLB_BH.bHandR,g_ZYLB_BH.bFootL,g_ZYLB_BH.bFootR)
	local a_limb_ctrls = #(g_ZYLB_BH.bHandL.controller,g_ZYLB_BH.bHandR.controller,g_ZYLB_BH.bFootL.controller,g_ZYLB_BH.bFootR.controller)
	local a_allKeys = #()
	local a_spaces = #(#(), #(), #(), #())

	select a_limb_nodes
	for n = 1 to a_limb_nodes.count while NOT keyboard.escPressed do
	(
		local keyCount = numKeys a_limb_ctrls[n]
		for i = 1 to keyCount while NOT keyboard.escPressed do
		(
			a_allKeys[i] = biped.getkey a_limb_ctrls[n] i
			if a_allKeys[i].ikspace == 1 then --// object space
			(
				if a_allKeys[i].ikJoinedPivot then a_spaces[n][i] = 2 --// planted key
				else a_spaces[n][i] = 1 --// sliding key
			)
			else --// body space
			(
				a_spaces[n][i] = 0 --// free key
			)
		)
		for j = 1 to keyCount while NOT keyboard.escPressed do
		(
			t = getKeyTime a_limb_ctrls[n] j
			sliderTime = t
			biped.setFreeKey a_limb_nodes[n]
		)
	)
	sliderTime = animationRange.start
	a_spaces
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_loadSpaces a_spaces =
(
	local a_limb_nodes = #(g_ZYLB_BH.bHandL,g_ZYLB_BH.bHandR,g_ZYLB_BH.bFootL,g_ZYLB_BH.bFootR)
	local a_limb_ctrls = #(g_ZYLB_BH.bHandL.controller,g_ZYLB_BH.bHandR.controller,g_ZYLB_BH.bFootL.controller,g_ZYLB_BH.bFootR.controller)
	
	select a_limb_nodes
	for n = 1 to a_limb_ctrls.count while NOT keyboard.escPressed do
	(
		for i = 1 to a_spaces[n].count while NOT keyboard.escPressed do
		(
			t = getKeyTime a_limb_ctrls[n] i
			sliderTime = t
			if a_spaces[n][i] == 2 then
			(
				biped.setPlantedKey a_limb_nodes[n]
			)
			if a_spaces[n][i] == 1 then
			(
				biped.setSlidingKey a_limb_nodes[n]
			)
		)
	)
	sliderTime = animationRange.start
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_limbBody =
(
	if selection.count > 0 do
	(
		for obj in (selection as array) do
		(
			try
			(			
				local keyCount = numKeys obj.controller
				for i = 1 to keyCount while NOT keyboard.escPressed do
				(
					t = getKeyTime obj.controller i
					sliderTime = t
					biped.setFreeKey obj
				)
				sliderTime = animationRange.start
			) catch()
		)
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_limbObject =
(
	if selection.count > 0 do
	(
		for obj in (selection as array) do
		(
			try
			(
				local keyCount = numKeys obj.controller
				for i = 1 to keyCount while NOT keyboard.escPressed do
				(
					t = getKeyTime obj.controller i
					sliderTime = t
					biped.setSlidingKey obj
				)
				sliderTime = animationRange.start
			) catch()
		)
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_changePivot ctrl index =
(
	if ctrl.keys.count > 0 then
	(
		local keyIndex = getKeyIndex ctrl slidertime
		if keyIndex > 0 then
		(
			local key = biped.getKey ctrl keyIndex
			if key.ikSpace > 0 then
			(
				key.ikPivotIndex = index
				return true
			)
			else
			(
				ZYDiagMessageBox "当前帧必须是固定或滑动 IK 关键帧，即对象空间。" title:"IK 接触轴心选择"
			)
		)
		else
		(
			ZYDiagMessageBox "当前帧没有关键帧。" title:"IK 接触轴心选择"
		)
	)
	else
	(
		ZYDiagMessageBox "未找到关键帧。请先设置固定或滑动 IK 帧。" title:"IK 接触轴心选择"
	)
	
	return false
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_getPivotIndex ctrl =
(
	if ctrl.keys.count > 0 then
	(
		local keyIndex = getKeyIndex ctrl slidertime
		if keyIndex > 0 then
		(
			local key = biped.getKey ctrl keyIndex
			if key.ikSpace > 0 then
			(
				return (biped.getKey ctrl keyIndex).ikPivotIndex
			)
		)
	)
	return 0	
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_isValidBiped =
(
	if isValidNode g_ZYLB_BH.bRoot then
	(
		return true
	)
	return false
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/**
	Function to detect objects near [0,0,0] within a tolerance
*/
fn f_trajectoryHelpersDelete query:true =
(
	local deleteConfirmed = false
	local layerTrajectories = layerManager.getLayerFromName "BIPED_TRAJECTORIES"
	if layerTrajectories != undefined then
	(
		if query then
		(
			if (ZYDiagQueryBox "确认删除 Biped 轨迹辅助对象？" title:"Biped 轨迹辅助") then
			(
				layerTrajectories.nodes &nodesInLayer
				delete nodesInLayer
				layerManager.deleteLayerByName "BIPED_TRAJECTORIES"
				deleteConfirmed = true
			)
		)
		else
		(
			layerTrajectories.nodes &nodesInLayer
			delete nodesInLayer
			layerManager.deleteLayerByName "BIPED_TRAJECTORIES"
			deleteConfirmed = true
		)
	)
	deleteConfirmed
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_addTrajectoryHelper &pt =
(
    fn isBipedSurface node = isValidNode node and classOf node.baseObject == Biped_Object
    fn surfaceClick event hit node face shift ctrl alt =
    (
        case event of
        (
            #mousePoint: (if hit != undefined then hit else #continue)
            #mouseAbort: undefined
            default: #continue
        )
    )
    local target = pickObject message:"选择一个 Biped 部件" forceListenerFocus:false filter:isBipedSurface
    if not isValidNode target do return false
    local hit = mouseTrack on:target prompt:"点击 Biped 部件表面放置轨迹辅助点" trackCallback:surfaceClick
    if classOf hit != Ray or not isValidNode target do return false
    undo "Place Biped trajectory helper" on
    (
        pt = point name:(uniqueName ("TRAJ_" + target.name)) size:0.1 box:false cross:true
        pt.parent = target
        pt.pos = hit.pos
        pt.dir = hit.dir
        local trajectoryLayer = layerManager.getLayerFromName "BIPED_TRAJECTORIES"
        if trajectoryLayer == undefined do trajectoryLayer = layerManager.newLayerFromName "BIPED_TRAJECTORIES"
        trajectoryLayer.addNode pt
        setTrajectoryOn pt true
        freeze pt
        setTransformLockFlags pt #{1..9}
    )
    true
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/		

fn f_linearAttach a_objs =
(
	convertToPoly a_objs[1]
	for obj in 2 to a_objs.count do
	(
		polyop.attach a_objs[1] a_objs[obj]
	)
	return a_objs[1]
),
		
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/		
		
fn f_removePoseBuffer =
(
	if selectionSets[g_ZYLB_BH.poseBuffStr] != undefined then
	(
		local a_objs = #()
		for obj in selectionSets[g_ZYLB_BH.poseBuffStr] do
		(
			append a_objs obj
		)
		delete a_objs
		deleteItem selectionSets g_ZYLB_BH.poseBuffStr
	)
	
	local layerPoseBuffer = layerManager.getLayerFromName g_ZYLB_BH.poseBuffStr
	if layerPoseBuffer != undefined then
	(
		layerPoseBuffer.nodes &nodesInLayer
		delete nodesInLayer
		layerManager.deleteLayerByName g_ZYLB_BH.poseBuffStr
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
		
fn f_cleanupPoseBuffer showMsg:true =
(
	if showMsg then ZYDiagMessageBox "未找到姿势缓存网格，缓存状态已重置。" title:"Biped 助手"
	g_ZYLB_BH.f_removePoseBuffer()
),
		
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/		
		
fn f_savePoseBufferFile =
(
	local bRootCtrl = g_ZYLB_BH.bRoot.controller
	biped.createCopyCollection bRootCtrl "PoseBufferSnap"
	local colIndex = biped.numCopyCollections bRootCtrl
	local copyCol = biped.getCopyCollection bRootCtrl colIndex
	biped.copyBipPose bRootCtrl copyCol #snapAuto
	biped.saveCopyPasteFile bRootCtrl g_ZYLB_BH.poseBufferSnap
	biped.deleteCopyCollection bRootCtrl colIndex
),
		
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/		
		
fn f_snapPB opacity =
(
	with animate off
	(
		g_ZYLB_BH.f_removePoseBuffer()

		--// clone the full biped
		local a_clones = #()
		local a_originals=for n in g_ZYLB_BH.a_bipedAllParts collect n
		maxops.clonenodes a_originals actualNodeList:&a_originals newNodes:&a_clones
		local a_poseBufferObjs=#()

		--// convert the cloned biped to meshes by extracting faces
		for i = 1 to a_clones.count where findstring a_clones[i].name "footsteps" == undefined AND findstring a_clones[i].name "nub" == undefined AND findstring a_clones[i].name "twist" == undefined do
		(
			convertToPoly a_clones[i]
			local n = polyop.getNumFaces a_clones[i]
			local beforeDetach=objects as array
			polyOp.detachFaces a_clones[i] #{1..n} asNode:true name:(a_originals[i].name + "_POSEBUFFER")
			for detached in objects where findItem beforeDetach detached==0 do
			(append a_poseBufferObjs detached;detached.transform=a_originals[i].transform)
		)
		delete a_clones
		
		--// Reinitialize Biped parts due to cloning to avoid selecting footsteps, twists and nubs
		g_ZYLB_BH.f_initBipedParts()
		
		--// Attach all the pose buffer meshes into one mesh
		local poseBuffer = g_ZYLB_BH.f_linearAttach a_poseBufferObjs
		poseBuffer.name = g_ZYLB_BH.poseBuffStr		
		poseBuffer.boxmode = off
		freeze poseBuffer
		poseBuffer.showFrozenInGray = off
		poseBuffer.displayByLayer = false
		
		--// Apply material
		local bufferMat = meditMaterials[24] = standard()
		bufferMat.Diffuse = color 0 0 0
		bufferMat.Opacity = opacity
		bufferMat.name = "Pose Buffer Mat"
		poseBuffer.material = bufferMat
		
		--// Add the pose buffer mesh to a selection set and scene layer
		selectionSets[g_ZYLB_BH.poseBuffStr] = poseBuffer
		if LayerManager.getLayerFromName g_ZYLB_BH.poseBuffStr == undefined then
		(
			LayerManager.newLayerFromName g_ZYLB_BH.poseBuffStr
		)
		local layerPoseBuffer = LayerManager.getLayerFromName g_ZYLB_BH.poseBuffStr
		layerPoseBuffer.addNodes poseBuffer
		layerPoseBuffer.boxmode = off
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_swapPB isKeyed =
(
	--// Snap the Biped to the stored pose that matches the pose buffer
	if doesFileExist g_ZYLB_BH.poseBufferSnap then
	(
		local bRootCtrl = g_ZYLB_BH.bRoot.controller
		biped.loadCopyPasteFile bRootCtrl g_ZYLB_BH.poseBufferSnap
		local colIndex = biped.numCopyCollections bRootCtrl
		local copyCol = biped.getCopyCollection bRootCtrl colIndex

		--// Use the previously stored pose to change the Biped
		local copyBH_pose = getCopy copyCol #pose 1
		
		--// Store the current pose in the collection to swap back to later on
		biped.copyBipPose bRootCtrl copyCol #snapAuto

		if isKeyed then
		(
			with animate on
			(
				undo "SwapPoseBuffer" on
				(
					biped.pasteBipPose bRootCtrl copyBH_pose false #pstdefault true true true false
					biped.pasteBipPose bRootCtrl copyBH_pose false #pstdefault true true true false
				)
			)
		)
		else
		(
			undo "SwapPoseBuffer" on
			(
				biped.pasteBipPose bRootCtrl copyBH_pose false #pstdefault true true true false
				biped.pasteBipPose bRootCtrl copyBH_pose false #pstdefault true true true false
			)
		)
		
		--// Remove the old pose, rename the copied one (so incrementing works properly), and resave the file
		deleteCopy copyCol #pose 1
		biped.setCopyName bRootCtrl #pose 1 "Pose01"
		biped.saveCopyPasteFile bRootCtrl g_ZYLB_BH.poseBufferSnap
		
		--// Cleanup
		biped.deleteCopyCollection bRootCtrl colIndex
	)
	else
	(
		ZYDiagMessageBox "还没有姿势文件，请先缓存当前姿势。" title:"Biped 助手"
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_snapshotGeometry opacity =
(
	local success = false
	local snapshotLayerName = getIniSetting g_ZYLB_BH.bhINIfile "SnapshotLayer" "LayerName"
			if snapshotLayerName == "*** BLANK ***" and (layerManager.getLayerFromName snapshotLayerName)==undefined do snapshotLayerName="" 
	local layerMeshChar = layerManager.getLayerFromName snapshotLayerName
	-- // First make sure the scene layer exists
	if layerMeshChar != undefined then
	(
		--// Collect all nodes from the scene layer
		local a_nodes = #()
		layerMeshChar.nodes &a_nodes
		if a_nodes.count > 0 then
		(
			--// Collect only the skinned meshes from the scene layer nodes array
			local a_skinNodes = #()
			for n in a_nodes do
			(
				if (g_ZYLB_BH.f_findSkinModifier n) then
				(
					append a_skinNodes n
				)
			)
			if a_skinNodes.count > 0 then
			(
				with Animate off
				(
					--// Snapshot the first skinned mesh and assign a material which has a low opacity and grey colour
					local snapMesh = snapShot a_skinNodes[1]
					local geoSnapshotMat = meditMaterials[24] = standard()
					geoSnapshotMat.Diffuse = color 126 126 126
					geoSnapshotMat.Opacity = opacity
					geoSnapshotMat.name = "Geo Snapshot Mat"
					snapMesh.material = geoSnapshotMat
					
					--// Continue snapping remaining skinned meshes and attach them
					for i = 2 to a_skinNodes.count do
					(
						local newMesh = snapshot a_skinNodes[i]
						newMesh.material = geoSnapshotMat
						attach snapMesh newMesh
					)
					snapMesh.pivot = snapMesh.center
					
					-- // Create a new layer if this is the first snapshot
					if LayerManager.getLayerFromName "SNAPSHOTS" == undefined then
					(
						LayerManager.newLayerFromName "SNAPSHOTS"
					)
					
					-- // Add the new snapshot mesh to the snapshots layer, freeze it and set object properties transparency
					local layerSnapshots = LayerManager.getLayerFromName "SNAPSHOTS"
					layerSnapshots.addNode snapMesh
					layerSnapshots.boxmode = off
					freeze snapMesh
					snapMesh.backfacecull = on
					snapMesh.boxmode = off
					snapMesh.showFrozenInGray = off
					snapMesh.displayByLayer = false
					
					-- // Rename the snapshot mesh and add the slider time frame
					snapMesh.name = ("Snapshot :: " + sliderTime as string)
				)
				success = true
			)
			else
			(
				ZYDiagMessageBox "快照来源图层必须包含带 Skin 的网格。" title:"Biped 快照"
			)
		)
		else
		(
			ZYDiagMessageBox "快照来源图层中没有对象。" title:"Biped 快照"
		)
	)
	else
	(
		ZYDiagMessageBox "未找到指定快照来源图层。" title:"Biped 快照"
	)
	success
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_snaphotsVisibility state =
(
	local layerSnapshots = layerManager.getLayerFromName "SNAPSHOTS"
	if layerSnapshots != undefined then
	(
		layerSnapshots.isHidden = NOT state
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_snapshotsDelete =
(
	local deleteConfirmed = false
	local layerSnapshots = layerManager.getLayerFromName "SNAPSHOTS"
	if layerSnapshots != undefined then
	(
		if (ZYDiagQueryBox "确认删除几何快照及其图层？" title:"Biped 快照") then
		(
			layerSnapshots.nodes &nodesInLayer
			delete nodesInLayer
			layerManager.deleteLayerByName "SNAPSHOTS"
			deleteConfirmed = true
		)
	)
	deleteConfirmed
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_snapshotsOpacity opacity =
(
	local a_snapshots = $'Snapshot::*'
	if a_snapshots.count > 0 then
	(
		with animate off
		(
			for snapMesh in a_snapshots do
			(
				snapMesh.material.opacity = opacity
			)
		)
	)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_bipedBakeSlidingKeys a_limbs =
(
	undo "BipedBakeSlidingKeys" on
	(
		for obj in a_limbs while NOT keyboard.escPressed do 
		(
			select obj
			indexInitial = numKeys obj.controller
			if indexInitial > 1 then
			(
				indexAdded = 0
				for i = 1 to indexInitial while NOT keyboard.escPressed do
				(
					i = i + indexAdded
					local indexCount = indexInitial + indexAdded
					local currentKey = biped.getKey obj.controller i
					if i < indexCount then
					(
						nextKey = biped.getKey obj.controller (i+1)
					)
					if nextKey != undefined then
					(
						if currentKey.ikSpace == 1 and nextKey.ikSpace == 1 then --// Both keys are Object space (sliding)
						(
							t = getKeyTime obj.controller i
							if t < animationRange.start then
							(
								t = animationRange.start - 1
								sliderTime = t
							)
							if i < (indexCount + indexAdded) then --// Set sliding keys until the next sliding key is reached
							(
								nextKeyTime = getKeyTime obj.controller (i+1)
								if nextKeyTime > animationRange.end then
								(
									nextKeyTime = animationRange.end + 1
								)
								for h = (t + 1) to (nextKeyTime - 1) while NOT keyboard.escPressed do
								(
									sliderTime = h
									biped.SetSlidingKey obj
									indexAdded = indexAdded + 1
								)
							)
						)
					)
				)
				bRoot.controller.osObject = undefined
			)
			else
			(
				str_error = "此肢体至少需要两个滑动关键帧：" + obj.name
				format (str_error + "\n")
				ZYDiagMessageBox str_error title:"Biped 烘焙"
			)
		)
	)
	sliderTime = animationRange.start
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_bipedBakeSlidingKeyNext =
(
	local obj = selection[1]

	undo "BipedBakeSlidingKeyNext" on
	(
		while (getKeyIndex obj.controller sliderTime) == 0 do
		(
			if sliderTime == animationRange.end then
			(
				exit()
			)
			else
			(
				sliderTime += 1
			)
		)
		if sliderTime < animationRange.end then
		(
			local index = getKeyIndex obj.controller sliderTime
			local initialKey = biped.getKey obj.controller index
			if index < (numKeys obj.controller) then --// Needs at least two keys to work
			(
				local nextKey = biped.getKey obj.controller (index + 1)
				local nextKeyTime = getKeyTime obj.controller (index + 1)
				if nextKeyTime <= animationRange.end then
				(
					if initialKey.ikSpace == 1 AND nextKey.ikSpace == 1 then
					(
						local t = getKeyTime obj.controller index
						sliderTime = t
						for f = (t + 1) to (nextKeyTime - 1) while NOT keyboard.escPressed do
						(
							sliderTime = f
							biped.SetSlidingKey obj
						)
						sliderTime += 1
					)
					else
					(
						sliderTime += 1
					)
				)
				else
				(
					ZYDiagMessageBox "下一个滑动关键帧必须位于当前可见时间范围内。" title:"Biped 烘焙"
				)
			)
			else
			(
				local str_error = "此肢体至少需要两个滑动关键帧：" + obj.name + "（从当前帧开始）。"
				format (str_error + "\n")
				ZYDiagMessageBox str_error title:"Biped 烘焙"
			)
		)
	)
	sliderTime = animationRange.start
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_bipedBakeSlidingKeyLast =
(
	local bool_done = false
	local obj = selection[1]
	
	undo "BipedBakeSlidingKeyLast" on
	(
		while bool_done == false do
		(
			while (getKeyIndex obj.controller sliderTime) == 0 do
			(
				if sliderTime == animationRange.end then
				(
					exit()
				)
				else
				(
					sliderTime += 1
				)
			)
			if sliderTime < animationRange.end then
			(
				local index = getKeyIndex obj.controller sliderTime
				local currentKey = biped.getKey obj.controller index
				if index < (numKeys obj.controller) then --// Needs at least two keys to work
				(
					local nextKey = biped.getKey obj.controller (index + 1)
					local nextKeyTime = getKeyTime obj.controller (index + 1)
					if nextKeyTime <= animationRange.end then
					(
						if currentKey.ikSpace == 1 and nextKey.ikSpace == 1 then
						(
							local t = getKeyTime obj.controller index
							sliderTime = t
							for f = (t + 1) to (nextKeyTime - 1) while NOT keyboard.escPressed do
							(
								sliderTime = f
								biped.SetSlidingKey obj
							)
							sliderTime += 1
							index = getKeyIndex obj.controller sliderTime
							currentKey = biped.getKey obj.controller index
							if index < (numKeys obj.controller) then
							(
								nextKey = biped.getKey obj.controller (index + 1)
								if nextKey.ikSpace == 0 then
								(
									bool_done = true
								)
							)
							else
							(
								exit()
							)
						)
						else
						(
							sliderTime += 1
						)
					)
					else
					(
						ZYDiagMessageBox "下一个滑动关键帧必须位于当前可见时间范围内。" title:"Biped 烘焙"
						exit()
					)
				)
				else
				(
					local str_error = "此肢体至少需要两个滑动关键帧：" + obj.name + "（从当前帧开始）。"
					format (str_error + "\n")
					ZYDiagMessageBox str_error title:"Biped 烘焙"
					exit()
				)
			)
			else
			(
				bool_done = true
			)
		)
	)
	sliderTime = animationRange.start
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_bipedBakeRoot =
(
	sliderTime = animationRange.start
	local bipObj = g_ZYLB_BH.bRoot
	select bipObj
	linkCtrl = bipObj.parent
	local followHelper = dummy()
	followHelper.name = "FollowHelper"
	followHelper.parent = linkCtrl
	with animate on
	(
		undo "BipedBakeRoot" on
		(
			for t = animationRange.start to animationRange.end while NOT keyboard.escPressed do
			(
				at time t (followHelper.transform = bipObj.transform)
			)
			bipObj.parent = undefined
			if classof linkCtrl.controller == Link_Constraint then
			(
				for i = 1 to linkCtrl.controller.getNumTargets() while NOT keyboard.escPressed do
				(
					if linkCtrl.controller.getNode i != undefined then --// A target object is set (not linked to world space)
					(
						local currentTime = linkCtrl.controller.getFrameNo i --// Current target time
						if i < linkCtrl.controller.getNumTargets() then --// Is not the last target
						(
							local nextTime = linkCtrl.controller.getFrameNo (i+1) --// Get the next target time
							if currentTime >= animationRange.start and nextTime <= animationRange.end then
							(
								for t = currentTime to nextTime while NOT keyboard.escPressed do
								(
									sliderTime = t
									bipObj.transform = followHelper.transform
								)
							)
							else
							(
								for t = animationRange.start to animationRange.end while NOT keyboard.escPressed do
								(
									sliderTime = t
									bipObj.transform = followHelper.transform
								)
							)
						)
						if i == linkCtrl.controller.getNumTargets() and sliderTime != animationRange.end then --// Is the last target
						(
							for t = currentTime to animationRange.end while NOT keyboard.escPressed do
							(
								sliderTime = t
								bipObj.transform = followHelper.transform
							)					
						)
					)
				)
			)
			else
			(
				for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
				(
					sliderTime = t
					bipObj.transform = followHelper.transform
				)
			)
		)
	)
	delete followHelper
	sliderTime = animationRange.start
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_bipedBakeHead =
(
	local pt = Point()
	with animate on
	(
		undo "BipedBakeHead" on
		(
			for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
			(
				at time t (pt.transform = g_ZYLB_BH.bHead.transform)
			)

			g_ZYLB_BH.bRoot.controller.headObject = undefined
			
			for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
			(
				at time t (g_ZYLB_BH.bHead.transform = pt.transform)
			)
		)
	)
	delete pt
	sliderTime = animationRange.start
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_openPivotsUI_LeftHand pos:g_ZYLB_BH.defaultPos =
(
	rollout leftHandPivots_Rollout "左手轴心"
	(
		local lrg = 16
		local sml = 12

		checkbutton chkbtn_pinkyTip "" across:4 width:sml height:sml align:#left offset:[-8,0] tooltip:"小指指尖接触轴心"
		checkbutton chkbtn_ringTip "" width:sml height:sml offset:[-8,0] tooltip:"无名指指尖接触轴心"
		checkbutton chkbtn_middleTip "" width:sml height:sml offset:[-8,0] tooltip:"中指指尖接触轴心"
		checkbutton chkbtn_indexTip "" width:sml height:sml offset:[-8,0] tooltip:"食指指尖接触轴心"
		
		checkbutton chkbtn_pinky2 "" width:sml height:sml across:4 align:#left offset:[-8,0] tooltip:"小指第二节接触轴心"
		checkbutton chkbtn_ring2 "" width:sml height:sml offset:[-8,0] tooltip:"无名指第二节接触轴心"
		checkbutton chkbtn_middle2 "" width:sml height:sml offset:[-8,0] tooltip:"中指第二节接触轴心"
		checkbutton chkbtn_index2 "" width:sml height:sml offset:[-8,0] tooltip:"食指第二节接触轴心"
		
		checkbutton chkbtn_pinky1 "" width:sml height:sml across:4 align:#left offset:[-8,0] tooltip:"小指第一节接触轴心"
		checkbutton chkbtn_ring1 "" width:sml height:sml offset:[-8,0] tooltip:"无名指第一节接触轴心"
		checkbutton chkbtn_middle1 "" width:sml height:sml offset:[-8,0] tooltip:"中指第一节接触轴心"
		checkbutton chkbtn_index1 "" width:sml height:sml offset:[-8,0] tooltip:"食指第一节接触轴心"
		
		checkbutton chkbtn_palmBack "" width:lrg height:lrg across:3 align:#left offset:[-8,0] tooltip:"手掌后接触轴心"
		checkbutton chkbtn_palmMiddle "" width:lrg height:lrg offset:[-9,0] tooltip:"手掌中接触轴心"
		checkbutton chkbtn_palmFront "" width:lrg height:lrg offset:[-8,0] tooltip:"手掌前接触轴心"
		
		checkbutton chkbtn_wristBack "" width:lrg height:lrg across:3 align:#left offset:[-8,0] tooltip:"手腕后接触轴心"
		checkbutton chkbtn_wristMiddle "" width:lrg height:lrg offset:[-9,0] tooltip:"手腕中接触轴心"
		checkbutton chkbtn_wristFront "" width:lrg height:lrg offset:[-8,0] tooltip:"手腕前接触轴心"
		
		checkbutton chkbtn_wristCenter "" width:lrg height:lrg align:#left offset:[14,0] tooltip:"手腕中心接触轴心"
		
		checkbutton chkbtn_thumbTip "" width:sml height:sml align:#right offset:[7,-92] tooltip:"拇指指尖接触轴心"
		checkbutton chkbtn_thumb2 "" width:sml height:sml align:#right offset:[7,0] tooltip:"拇指第二节接触轴心"
		checkbutton chkbtn_thumb1 "" width:sml height:sml align:#right offset:[7,0] tooltip:"拇指第一节接触轴心"
		
		fn f_uncheckAll =
		(
			chkbtn_wristCenter.checked = false
			chkbtn_wristFront.checked = false
			chkbtn_wristMiddle.checked = false
			chkbtn_wristBack.checked = false
			chkbtn_palmFront.checked = false
			chkbtn_palmMiddle.checked = false
			chkbtn_palmBack.checked = false
			chkbtn_thumb1.checked = false
			chkbtn_thumb2.checked = false
			chkbtn_thumbTip.checked = false
			chkbtn_index1.checked = false
			chkbtn_index2.checked = false
			chkbtn_indexTip.checked = false
			chkbtn_middle1.checked = false
			chkbtn_middle2.checked = false
			chkbtn_middleTip.checked = false
			chkbtn_ring1.checked = false
			chkbtn_ring2.checked = false
			chkbtn_ringTip.checked = false
			chkbtn_pinky1.checked = false
			chkbtn_pinky2.checked = false
			chkbtn_pinkyTip.checked = false
		)
		
		fn f_updateButton state chkbtn index =
		(
			f_uncheckAll();
			if state then
			(
				if (g_ZYLB_BH.f_changePivot g_ZYLB_BH.bHandL.controller index) then
				(
					chkbtn.checked = true
				)
			)
			else
			(
				if (g_ZYLB_BH.f_getPivotIndex g_ZYLB_BH.bHandL.controller) > 0 then
				(
					chkbtn.checked = true
				)
			)
		)
		
		on leftHandPivots_Rollout open do
		(
			case (g_ZYLB_BH.f_getPivotIndex g_ZYLB_BH.bHandL.controller) of
			(
				1: chkbtn_wristCenter.checked = true
				2: chkbtn_wristFront.checked = true
				3: chkbtn_wristMiddle.checked = true
				4: chkbtn_wristBack.checked = true
				5: chkbtn_palmFront.checked = true
				6: chkbtn_palmMiddle.checked = true
				7: chkbtn_palmBack.checked = true
				8: chkbtn_thumb1.checked = true
				9: chkbtn_thumb2.checked = true
				10: chkbtn_thumbTip.checked = true
				11: chkbtn_index1.checked = true
				12: chkbtn_index2.checked = true
				13: chkbtn_indexTip.checked = true
				14: chkbtn_middle1.checked = true
				15: chkbtn_middle2.checked = true
				16: chkbtn_middleTip.checked = true
				17: chkbtn_ring1.checked = true
				18: chkbtn_ring2.checked = true
				19: chkbtn_ringTip.checked = true
				20: chkbtn_pinky1.checked = true
				21: chkbtn_pinky2.checked = true
				22: chkbtn_pinkyTip.checked = true
				default: f_uncheckAll()
			)
		)
		
		on leftHandPivots_Rollout close do
		(
			if g_ZYLB_BH.SelectionDisplayTime_Rollout != undefined AND g_ZYLB_BH.SelectionDisplayTime_Rollout.open then
			(
				g_ZYLB_BH.SelectionDisplayTime_Rollout.chkbtn_pivotsLHand.checked = false
			)
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.chkbtn_pivotsLHand.checked = false
			)
		)
		
		on chkbtn_wristCenter changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_wristCenter"
 try
 (
 (f_updateButton state chkbtn_wristCenter 1)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_wristCenter"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_wristFront changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_wristFront"
 try
 (
 (f_updateButton state chkbtn_wristFront 2)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_wristFront"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_wristMiddle changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_wristMiddle"
 try
 (
 (f_updateButton state chkbtn_wristMiddle 3)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_wristMiddle"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_wristBack changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_wristBack"
 try
 (
 (f_updateButton state chkbtn_wristBack 4)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_wristBack"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_palmFront changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_palmFront"
 try
 (
 (f_updateButton state chkbtn_palmFront 5)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_palmFront"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_palmMiddle changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_palmMiddle"
 try
 (
 (f_updateButton state chkbtn_palmMiddle 6)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_palmMiddle"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_palmBack changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_palmBack"
 try
 (
 (f_updateButton state chkbtn_palmBack 7)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_palmBack"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_thumb1 changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_thumb1"
 try
 (
 (f_updateButton state chkbtn_thumb1 8)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_thumb1"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_thumb2 changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_thumb2"
 try
 (
 (f_updateButton state chkbtn_thumb2 9)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_thumb2"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_thumbTip changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_thumbTip"
 try
 (
 (f_updateButton state chkbtn_thumbTip 10)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_thumbTip"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_index1 changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_index1"
 try
 (
 (f_updateButton state chkbtn_index1 11)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_index1"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_index2 changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_index2"
 try
 (
 (f_updateButton state chkbtn_index2 12)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_index2"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_indexTip changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_indexTip"
 try
 (
 (f_updateButton state chkbtn_indexTip 13)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_indexTip"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_middle1 changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_middle1"
 try
 (
 (f_updateButton state chkbtn_middle1 14)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_middle1"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_middle2 changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_middle2"
 try
 (
 (f_updateButton state chkbtn_middle2 15)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_middle2"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_middleTip changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_middleTip"
 try
 (
 (f_updateButton state chkbtn_middleTip 16)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_middleTip"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_ring1 changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_ring1"
 try
 (
 (f_updateButton state chkbtn_ring1 17)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_ring1"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_ring2 changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_ring2"
 try
 (
 (f_updateButton state chkbtn_ring2 18)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_ring2"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_ringTip changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_ringTip"
 try
 (
 (f_updateButton state chkbtn_ringTip 19)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_ringTip"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_pinky1 changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_pinky1"
 try
 (
 (f_updateButton state chkbtn_pinky1 20)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_pinky1"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_pinky2 changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_pinky2"
 try
 (
 (f_updateButton state chkbtn_pinky2 21)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_pinky2"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_pinkyTip changed state do (
 ZYDiagEvent "tool_begin" "leftHandPivots_Rollout.chkbtn_pinkyTip"
 try
 (
 (f_updateButton state chkbtn_pinkyTip 22)
 ZYDiagEvent "tool_end" "leftHandPivots_Rollout.chkbtn_pinkyTip"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	) --// end rollout
	
	try(destroyDialog leftHandPivots_Rollout)catch()
	createDialog leftHandPivots_Rollout width:90 height:120 pos:pos style:#(#style_toolwindow, #style_sysmenu)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_openPivotsUI_RightHand pos:g_ZYLB_BH.defaultPos =
(
	rollout rightHandPivots_Rollout "右手轴心"
	(
		local lrg = 16
		local sml = 12
		
		checkbutton chkbtn_indexTip "" across:4 width:sml height:sml align:#right offset:[8,0] tooltip:"食指指尖接触轴心"
		checkbutton chkbtn_middleTip "" width:sml height:sml offset:[12,0] tooltip:"中指指尖接触轴心"
		checkbutton chkbtn_ringTip "" width:sml height:sml offset:[12,0] tooltip:"无名指指尖接触轴心"
		checkbutton chkbtn_pinkyTip "" width:sml height:sml offset:[12,0] tooltip:"小指指尖接触轴心"

		checkbutton chkbtn_index2 "" width:sml height:sml across:4 align:#right offset:[8,0] tooltip:"食指第二节接触轴心"
		checkbutton chkbtn_middle2 "" width:sml height:sml offset:[12,0] tooltip:"中指第二节接触轴心"
		checkbutton chkbtn_ring2 "" width:sml height:sml offset:[12,0] tooltip:"无名指第二节接触轴心"
		checkbutton chkbtn_pinky2 "" width:sml height:sml offset:[12,0] tooltip:"小指第二节接触轴心"
		
		checkbutton chkbtn_index1 "" width:sml height:sml across:4 align:#right offset:[8,0] tooltip:"食指第一节接触轴心"
		checkbutton chkbtn_middle1 "" width:sml height:sml offset:[12,0] tooltip:"中指第一节接触轴心"
		checkbutton chkbtn_ring1 "" width:sml height:sml offset:[12,0] tooltip:"无名指第一节接触轴心"
		checkbutton chkbtn_pinky1 "" width:sml height:sml offset:[12,0] tooltip:"小指第一节接触轴心"

		checkbutton chkbtn_palmFront "" width:lrg height:lrg across:3 align:#right offset:[7,0] tooltip:"手掌前接触轴心"
		checkbutton chkbtn_palmMiddle "" width:lrg height:lrg offset:[11,0] tooltip:"手掌中接触轴心"
		checkbutton chkbtn_palmBack "" width:lrg height:lrg offset:[12,0] tooltip:"手掌后接触轴心"		

		checkbutton chkbtn_wristFront "" width:lrg height:lrg across:3 align:#right offset:[7,0] tooltip:"手腕前接触轴心"
		checkbutton chkbtn_wristMiddle "" width:lrg height:lrg offset:[11,0] tooltip:"手腕中接触轴心"
		checkbutton chkbtn_wristBack "" width:lrg height:lrg offset:[12,0] tooltip:"手腕后接触轴心"
		
		checkbutton chkbtn_wristCenter "" width:lrg height:lrg align:#right offset:[-14,0] tooltip:"手腕中心接触轴心"
		
		checkbutton chkbtn_thumbTip "" width:sml height:sml align:#right offset:[-58,-92] tooltip:"拇指指尖接触轴心"
		checkbutton chkbtn_thumb2 "" width:sml height:sml align:#right offset:[-58,0] tooltip:"拇指第二节接触轴心"
		checkbutton chkbtn_thumb1 "" width:sml height:sml align:#right offset:[-58,0] tooltip:"拇指第一节接触轴心"
			
		fn f_uncheckAll =
		(
			chkbtn_wristCenter.checked = false
			chkbtn_wristFront.checked = false
			chkbtn_wristMiddle.checked = false
			chkbtn_wristBack.checked = false
			chkbtn_palmFront.checked = false
			chkbtn_palmMiddle.checked = false
			chkbtn_palmBack.checked = false
			chkbtn_thumb1.checked = false
			chkbtn_thumb2.checked = false
			chkbtn_thumbTip.checked = false
			chkbtn_index1.checked = false
			chkbtn_index2.checked = false
			chkbtn_indexTip.checked = false
			chkbtn_middle1.checked = false
			chkbtn_middle2.checked = false
			chkbtn_middleTip.checked = false
			chkbtn_ring1.checked = false
			chkbtn_ring2.checked = false
			chkbtn_ringTip.checked = false
			chkbtn_pinky1.checked = false
			chkbtn_pinky2.checked = false
			chkbtn_pinkyTip.checked = false
		)
		
		fn f_updateButton state chkbtn index =
		(
			f_uncheckAll();
			if state then
			(
				if (g_ZYLB_BH.f_changePivot g_ZYLB_BH.bHandR.controller index) then
				(
					chkbtn.checked = true
				)
			)
			else
			(
				if (g_ZYLB_BH.f_getPivotIndex g_ZYLB_BH.bHandR.controller) > 0 then
				(
					chkbtn.checked = true
				)
			)
		)
	
		on rightHandPivots_Rollout open do
		(
			case (g_ZYLB_BH.f_getPivotIndex g_ZYLB_BH.bHandR.controller) of
			(
				1: chkbtn_wristCenter.checked = true
				2: chkbtn_wristFront.checked = true
				3: chkbtn_wristMiddle.checked = true
				4: chkbtn_wristBack.checked = true
				5: chkbtn_palmFront.checked = true
				6: chkbtn_palmMiddle.checked = true
				7: chkbtn_palmBack.checked = true
				8: chkbtn_thumb1.checked = true
				9: chkbtn_thumb2.checked = true
				10: chkbtn_thumbTip.checked = true
				11: chkbtn_index1.checked = true
				12: chkbtn_index2.checked = true
				13: chkbtn_indexTip.checked = true
				14: chkbtn_middle1.checked = true
				15: chkbtn_middle2.checked = true
				16: chkbtn_middleTip.checked = true
				17: chkbtn_ring1.checked = true
				18: chkbtn_ring2.checked = true
				19: chkbtn_ringTip.checked = true
				20: chkbtn_pinky1.checked = true
				21: chkbtn_pinky2.checked = true
				22: chkbtn_pinkyTip.checked = true
				default: f_uncheckAll()
			)
		)
		
		on rightHandPivots_Rollout close do
		(
			if g_ZYLB_BH.SelectionDisplayTime_Rollout != undefined AND g_ZYLB_BH.SelectionDisplayTime_Rollout.open then
			(
				g_ZYLB_BH.SelectionDisplayTime_Rollout.chkbtn_pivotsRHand.checked = false
			)
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.chkbtn_pivotsRHand.checked = false
			)
		)
		
		on chkbtn_wristCenter changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_wristCenter"
 try
 (
 (f_updateButton state chkbtn_wristCenter 1)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_wristCenter"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_wristFront changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_wristFront"
 try
 (
 (f_updateButton state chkbtn_wristFront 2)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_wristFront"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_wristMiddle changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_wristMiddle"
 try
 (
 (f_updateButton state chkbtn_wristMiddle 3)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_wristMiddle"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_wristBack changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_wristBack"
 try
 (
 (f_updateButton state chkbtn_wristBack 4)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_wristBack"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_palmFront changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_palmFront"
 try
 (
 (f_updateButton state chkbtn_palmFront 5)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_palmFront"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_palmMiddle changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_palmMiddle"
 try
 (
 (f_updateButton state chkbtn_palmMiddle 6)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_palmMiddle"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_palmBack changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_palmBack"
 try
 (
 (f_updateButton state chkbtn_palmBack 7)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_palmBack"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_thumb1 changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_thumb1"
 try
 (
 (f_updateButton state chkbtn_thumb1 8)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_thumb1"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_thumb2 changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_thumb2"
 try
 (
 (f_updateButton state chkbtn_thumb2 9)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_thumb2"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_thumbTip changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_thumbTip"
 try
 (
 (f_updateButton state chkbtn_thumbTip 10)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_thumbTip"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_index1 changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_index1"
 try
 (
 (f_updateButton state chkbtn_index1 11)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_index1"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_index2 changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_index2"
 try
 (
 (f_updateButton state chkbtn_index2 12)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_index2"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_indexTip changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_indexTip"
 try
 (
 (f_updateButton state chkbtn_indexTip 13)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_indexTip"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_middle1 changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_middle1"
 try
 (
 (f_updateButton state chkbtn_middle1 14)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_middle1"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_middle2 changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_middle2"
 try
 (
 (f_updateButton state chkbtn_middle2 15)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_middle2"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_middleTip changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_middleTip"
 try
 (
 (f_updateButton state chkbtn_middleTip 16)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_middleTip"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_ring1 changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_ring1"
 try
 (
 (f_updateButton state chkbtn_ring1 17)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_ring1"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_ring2 changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_ring2"
 try
 (
 (f_updateButton state chkbtn_ring2 18)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_ring2"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_ringTip changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_ringTip"
 try
 (
 (f_updateButton state chkbtn_ringTip 19)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_ringTip"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_pinky1 changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_pinky1"
 try
 (
 (f_updateButton state chkbtn_pinky1 20)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_pinky1"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_pinky2 changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_pinky2"
 try
 (
 (f_updateButton state chkbtn_pinky2 21)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_pinky2"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_pinkyTip changed state do (
 ZYDiagEvent "tool_begin" "rightHandPivots_Rollout.chkbtn_pinkyTip"
 try
 (
 (f_updateButton state chkbtn_pinkyTip 22)
 ZYDiagEvent "tool_end" "rightHandPivots_Rollout.chkbtn_pinkyTip"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	) --// end rollout
	
	try(destroyDialog rightHandPivots_Rollout)catch()
	createDialog rightHandPivots_Rollout width:90 height:120 pos:pos style:#(#style_toolwindow, #style_sysmenu)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_openPivotsUI_LeftFoot pos:g_ZYLB_BH.defaultPos =
(
	rollout leftFootPivots_Rollout "左脚轴心"
	(
		local lrg = 16

		checkbutton chkbtn_frontLeft "" across:3 width:lrg height:lrg align:#left offset:[0,0] tooltip:"前左接触轴心"
		checkbutton chkbtn_frontMiddle "" width:lrg height:lrg offset:[0,0] tooltip:"前中接触轴心"
		checkbutton chkbtn_frontRight "" width:lrg height:lrg offset:[3,0] tooltip:"前右接触轴心"
		checkbutton chkbtn_ankle "" width:lrg height:lrg align:#left offset:[13,0] tooltip:"脚踝接触轴心"
		checkbutton chkbtn_backLeft "" across:3 width:lrg height:lrg align:#left offset:[0,0] tooltip:"后左接触轴心"
		checkbutton chkbtn_backMiddle "" width:lrg height:lrg offset:[0,0] tooltip:"后中接触轴心"
		checkbutton chkbtn_backRight "" width:lrg height:lrg offset:[3,0] tooltip:"后右接触轴心"

		fn f_uncheckAll =
		(
			chkbtn_ankle.checked = false
			chkbtn_backLeft.checked = false
			chkbtn_backMiddle.checked = false
			chkbtn_backRight.checked = false
			chkbtn_frontLeft.checked = false
			chkbtn_frontMiddle.checked = false
			chkbtn_frontRight.checked = false
		)
		
		fn f_updateButton state chkbtn index =
		(
			f_uncheckAll();
			if state then
			(
				if (g_ZYLB_BH.f_changePivot g_ZYLB_BH.bFootL.controller index) then
				(
					chkbtn.checked = true
				)
			)
			else
			(
				if (g_ZYLB_BH.f_getPivotIndex g_ZYLB_BH.bFootL.controller) > 0 then
				(
					chkbtn.checked = true
				)
			)
		)
	
		on leftFootPivots_Rollout open do
		(
			case (g_ZYLB_BH.f_getPivotIndex g_ZYLB_BH.bFootL.controller) of
			(
				1: chkbtn_ankle.checked = true
				2: chkbtn_backLeft.checked = true
				3: chkbtn_backMiddle.checked = true
				4: chkbtn_backRight.checked = true
				5: chkbtn_frontLeft.checked = true
				6: chkbtn_frontMiddle.checked = true
				7: chkbtn_frontRight.checked = true
				default: f_uncheckAll()
			)
		)
		
		on leftFootPivots_Rollout close do
		(
			if g_ZYLB_BH.SelectionDisplayTime_Rollout != undefined AND g_ZYLB_BH.SelectionDisplayTime_Rollout.open then
			(
				g_ZYLB_BH.SelectionDisplayTime_Rollout.chkbtn_pivotsLFoot.checked = false
			)
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.chkbtn_pivotsLFoot.checked = false
			)
		)
		
		on chkbtn_ankle changed state do (
 ZYDiagEvent "tool_begin" "leftFootPivots_Rollout.chkbtn_ankle"
 try
 (
 (f_updateButton state chkbtn_ankle 1)
 ZYDiagEvent "tool_end" "leftFootPivots_Rollout.chkbtn_ankle"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_backLeft changed state do (
 ZYDiagEvent "tool_begin" "leftFootPivots_Rollout.chkbtn_backLeft"
 try
 (
 (f_updateButton state chkbtn_backLeft 2)
 ZYDiagEvent "tool_end" "leftFootPivots_Rollout.chkbtn_backLeft"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_backMiddle changed state do (
 ZYDiagEvent "tool_begin" "leftFootPivots_Rollout.chkbtn_backMiddle"
 try
 (
 (f_updateButton state chkbtn_backMiddle 3)
 ZYDiagEvent "tool_end" "leftFootPivots_Rollout.chkbtn_backMiddle"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_backRight changed state do (
 ZYDiagEvent "tool_begin" "leftFootPivots_Rollout.chkbtn_backRight"
 try
 (
 (f_updateButton state chkbtn_backRight 4)
 ZYDiagEvent "tool_end" "leftFootPivots_Rollout.chkbtn_backRight"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_frontLeft changed state do (
 ZYDiagEvent "tool_begin" "leftFootPivots_Rollout.chkbtn_frontLeft"
 try
 (
 (f_updateButton state chkbtn_frontLeft 5)
 ZYDiagEvent "tool_end" "leftFootPivots_Rollout.chkbtn_frontLeft"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_frontMiddle changed state do (
 ZYDiagEvent "tool_begin" "leftFootPivots_Rollout.chkbtn_frontMiddle"
 try
 (
 (f_updateButton state chkbtn_frontMiddle 6)
 ZYDiagEvent "tool_end" "leftFootPivots_Rollout.chkbtn_frontMiddle"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_frontRight changed state do (
 ZYDiagEvent "tool_begin" "leftFootPivots_Rollout.chkbtn_frontRight"
 try
 (
 (f_updateButton state chkbtn_frontRight 7)
 ZYDiagEvent "tool_end" "leftFootPivots_Rollout.chkbtn_frontRight"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)	
	) --// end rollout
	
	try(destroyDialog leftFootPivots_Rollout)catch()
	createDialog leftFootPivots_Rollout width:90 height:70 pos:pos style:#(#style_toolwindow, #style_sysmenu)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_openPivotsUI_RightFoot pos:g_ZYLB_BH.defaultPos =
(
	rollout rightFootPivots_Rollout "右脚轴心"
	(
		local lrg = 16

		checkbutton chkbtn_frontLeft "" across:3 width:lrg height:lrg align:#left offset:[0,0] tooltip:"前左接触轴心"
		checkbutton chkbtn_frontMiddle "" width:lrg height:lrg offset:[0,0] tooltip:"前中接触轴心"
		checkbutton chkbtn_frontRight "" width:lrg height:lrg offset:[3,0] tooltip:"前右接触轴心"
		checkbutton chkbtn_ankle "" width:lrg height:lrg align:#left offset:[39,0] tooltip:"脚踝接触轴心"
		checkbutton chkbtn_backLeft "" across:3 width:lrg height:lrg align:#left offset:[0,0] tooltip:"后左接触轴心"
		checkbutton chkbtn_backMiddle "" width:lrg height:lrg offset:[0,0] tooltip:"后中接触轴心"
		checkbutton chkbtn_backRight "" width:lrg height:lrg offset:[3,0] tooltip:"后右接触轴心"

		fn f_uncheckAll =
		(
			chkbtn_ankle.checked = false
			chkbtn_backLeft.checked = false
			chkbtn_backMiddle.checked = false
			chkbtn_backRight.checked = false
			chkbtn_frontLeft.checked = false
			chkbtn_frontMiddle.checked = false
			chkbtn_frontRight.checked = false
		)
		
		fn f_updateButton state chkbtn index =
		(
			f_uncheckAll();
			if state then
			(
				if (g_ZYLB_BH.f_changePivot g_ZYLB_BH.bFootR.controller index) then
				(
					chkbtn.checked = true
				)
			)
			else
			(
				if (g_ZYLB_BH.f_getPivotIndex g_ZYLB_BH.bFootR.controller) > 0 then
				(
					chkbtn.checked = true
				)
			)
		)
	
		on rightFootPivots_Rollout open do
		(
			case (g_ZYLB_BH.f_getPivotIndex g_ZYLB_BH.bFootR.controller) of
			(
				1: chkbtn_ankle.checked = true
				2: chkbtn_backLeft.checked = true
				3: chkbtn_backMiddle.checked = true
				4: chkbtn_backRight.checked = true
				5: chkbtn_frontLeft.checked = true
				6: chkbtn_frontMiddle.checked = true
				7: chkbtn_frontRight.checked = true
				default: f_uncheckAll()
			)
		)
		
		on rightFootPivots_Rollout close do
		(
			if g_ZYLB_BH.SelectionDisplayTime_Rollout != undefined AND g_ZYLB_BH.SelectionDisplayTime_Rollout.open then
			(
				g_ZYLB_BH.SelectionDisplayTime_Rollout.chkbtn_pivotsRFoot.checked = false
			)
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.chkbtn_pivotsRFoot.checked = false
			)
		)
		
		on chkbtn_ankle changed state do (
 ZYDiagEvent "tool_begin" "rightFootPivots_Rollout.chkbtn_ankle"
 try
 (
 (f_updateButton state chkbtn_ankle 1)
 ZYDiagEvent "tool_end" "rightFootPivots_Rollout.chkbtn_ankle"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_backLeft changed state do (
 ZYDiagEvent "tool_begin" "rightFootPivots_Rollout.chkbtn_backLeft"
 try
 (
 (f_updateButton state chkbtn_backLeft 2)
 ZYDiagEvent "tool_end" "rightFootPivots_Rollout.chkbtn_backLeft"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_backMiddle changed state do (
 ZYDiagEvent "tool_begin" "rightFootPivots_Rollout.chkbtn_backMiddle"
 try
 (
 (f_updateButton state chkbtn_backMiddle 3)
 ZYDiagEvent "tool_end" "rightFootPivots_Rollout.chkbtn_backMiddle"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_backRight changed state do (
 ZYDiagEvent "tool_begin" "rightFootPivots_Rollout.chkbtn_backRight"
 try
 (
 (f_updateButton state chkbtn_backRight 4)
 ZYDiagEvent "tool_end" "rightFootPivots_Rollout.chkbtn_backRight"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_frontLeft changed state do (
 ZYDiagEvent "tool_begin" "rightFootPivots_Rollout.chkbtn_frontLeft"
 try
 (
 (f_updateButton state chkbtn_frontLeft 5)
 ZYDiagEvent "tool_end" "rightFootPivots_Rollout.chkbtn_frontLeft"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_frontMiddle changed state do (
 ZYDiagEvent "tool_begin" "rightFootPivots_Rollout.chkbtn_frontMiddle"
 try
 (
 (f_updateButton state chkbtn_frontMiddle 6)
 ZYDiagEvent "tool_end" "rightFootPivots_Rollout.chkbtn_frontMiddle"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on chkbtn_frontRight changed state do (
 ZYDiagEvent "tool_begin" "rightFootPivots_Rollout.chkbtn_frontRight"
 try
 (
 (f_updateButton state chkbtn_frontRight 7)
 ZYDiagEvent "tool_end" "rightFootPivots_Rollout.chkbtn_frontRight"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	) --// end rollout
	
	try(destroyDialog rightFootPivots_Rollout)catch()
	createDialog rightFootPivots_Rollout width:90 height:70 pos:pos style:#(#style_toolwindow, #style_sysmenu)
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

-- 配置文件可能由安装器或语言设置提前创建；逐项读取，不能只检查文件存在。
fn f_readIniIndex section key upper defaultValue:1 =
(
    local raw = getIniSetting bhINIfile section key
    local value = try(raw as integer)catch(undefined)
    if value == undefined or value < 1 or value > upper do value = defaultValue
    if raw != (value as string) do setIniSetting bhINIfile section key (value as string)
    value
),

fn f_readIniPosition section fallback =
(
    local raw = getIniSetting bhINIfile section "Position"
    local parts = filterString raw "[], "
    local value = fallback
    if parts.count == 2 do try(value = [(parts[1] as float), (parts[2] as float)])catch()
    if raw != (value as string) do setIniSetting bhINIfile section "Position" (value as string)
    value
),

fn f_bipedHelperUI =
(	
	rollout SelectionDisplayTime_Rollout "选择 / 显示 / 时间"
	(
		button btn_ZYLanguage "中文 / English" width:125 height:24 align:#left tooltip:"切换界面语言并记住选择；保留当前对象和工具参数。"
		on btn_ZYLanguage pressed do (
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_ZYLanguage"
 try
 (
 ZYLB_SwitchLanguage()
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_ZYLanguage"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		dropDownList ddl_bips "" width:150 across:2 align:#left tooltip:"选择当前 Biped 根。Shift 选择根；Ctrl 选择全身。节点名保持原样。"
		button btn_refreshUI "刷" width:20 height:20 align:#right offset:[8,0] tooltip:"重新搜索场景中的 Biped；换工程或改名后使用。"
		group "选择"
		(
			button btn_openPicker "选择器" align:#left width:135 height:18 offset:[3,0] across:2 tooltip:"打开图形选择器，控制已有 Biped。"
			button btn_resetPickerPos "X" align:#right width:20 height:18 offset:[-3,0] tooltip:"关闭选择器并重置窗口位置。"
			label lbl_txt1 "加选 Shift/Ctrl · 减选 Alt" align:#center
			button btn_selectAll "全身" align:#center width:160 height:18 tooltip:"选择当前 Biped 全身部件；不包含自定义头发、飘带或武器骨骼。"
			button btn_selectHead "头部" align:#center width:160 height:18 tooltip:"选择 Biped 头部节点；不会自动选择全部头发骨骼。"
			button btn_selectSpine "脊柱" align:#left width:115 height:18 offset:[3,0] across:2 tooltip:"选择第一节脊柱；同时按 Shift 和 Ctrl 选择全部脊柱。"
			checkbutton chkbtn_bendLinks "弯曲" align:#right width:40 height:18 offset:[-3,0] tooltip:"切换脊柱、手指、尾部和马尾的弯曲链接模式。"
			button btn_selectCOM "根 COM" align:#center width:160 height:18 tooltip:"选择 Biped 根节点，例如 Bip01 或 Bip001。"
			button btn_selectFingersLeft "左手指" align:#left width:78 height:18 across:2 offset:[3,0] tooltip:"选择左手的全部 Biped 手指关节。"
			button btn_selectFingersRight "右手指" align:#right width:78 height:18 offset:[-3,0] tooltip:"选择右手的全部 Biped 手指关节。"
			checkbutton chkbtn_pivotsLHand "P" across:4 width:14 height:18 align:#left offset:[3,0] tooltip:"打开左手 IK 轴心选择；须存在标准 Biped 左手。"
			button btn_selectLHand "左手" width:63 height:18 offset:[-11,0] tooltip:"选择 Biped 左手节点。"
			button btn_selectRHand "右手" width:63 height:18 offset:[17,0] tooltip:"选择 Biped 右手节点。"
			checkbutton chkbtn_pivotsRHand "P" width:14 height:18 offset:[14,0] tooltip:"打开右手 IK 轴心选择；须存在标准 Biped 右手。"
			checkbutton chkbtn_pivotsLFoot "P" across:4 width:14 height:18 align:#left offset:[3,0] tooltip:"打开左脚 IK 轴心选择；须存在标准 Biped 左脚。"
			button btn_selectLFoot "左脚" width:63 height:18 offset:[-11,0] tooltip:"选择 Biped 左脚节点。"
			button btn_selectRFoot "右脚" width:63 height:18 offset:[17,0] tooltip:"选择 Biped 右脚节点。"
			checkbutton chkbtn_pivotsRFoot "P" width:14 height:18 offset:[14,0] tooltip:"打开右脚 IK 轴心选择；须存在标准 Biped 右脚。"
			button btn_selectHandsFeet "双手和双脚" align:#center width:160 height:18 tooltip:"选择 Biped 双手与双脚。"
			button btn_selectProp1 "道1" align:#left width:50 height:18 across:3 offset:[3,0] tooltip:"选择标准 Biped 道具 1 节点（Prop1）。不存在时灰显；不会自动选择枪、刀或剑。自定义武器请用下方「+ 自定义按钮」配置控制骨骼。"
			button btn_selectProp2 "道2" align:#center width:50 height:18 tooltip:"选择标准 Biped 道具 2 节点（Prop2）。不存在时灰显；不会自动选择枪、刀或剑。自定义武器请用下方「+ 自定义按钮」配置控制骨骼。"
			button btn_selectProp3 "道3" align:#right width:50 height:18 offset:[-3,0] tooltip:"选择标准 Biped 道具 3 节点（Prop3）。不存在时灰显；不会自动选择枪、刀或剑。自定义武器请用下方「+ 自定义按钮」配置控制骨骼。"
			button btn_selectBipedParentGrow "+<" width:24 height:18 align:#left offset:[3,0] across:5 tooltip:"所选 Biped 向上加选父级。"
			button btn_selectBipedParentNext "<" width:24 height:18 align:#left offset:[-4,0] tooltip:"选择所选 Biped 的父级。"
			button btn_selectBipedChildren "子级" width:55 height:18 align:#center offset:[0,0] tooltip:"选择所选 Biped 的所有子级。"
			button btn_selectBipedChildNext ">" width:24 height:18 align:#right offset:[4,0] tooltip:"选择所选 Biped 的下一个子级。"
			button btn_selectBipedChildGrow ">+" width:24 height:18 align:#right offset:[-3,0] tooltip:"所选 Biped 向下加选子级。"	
		)
		group "显示"
		(
			button btn_hideBiped "隐藏骨骼" align:#left width:78 height:18 across:2 offset:[3,0] tooltip:"隐藏当前 Biped 的全部部件。"
			button btn_unhideBiped "显示骨骼" align:#right width:78 height:18 offset:[-3,0] tooltip:"显示当前 Biped；末端、扭转与脚步节点仍不显示。"
			button btn_boxMode "方块显示" align:#left width:78 height:18 offset:[3,0] across:2 tooltip:"全部 Biped 改为方块显示；Shift 恢复正常显示。"
			checkbutton chkbtn_trajectories "原生轨迹" align:#right width:78 height:18 offset:[-3,0] tooltip:"切换所选 Biped 的 Max 原生轨迹显示。"
		)
		group "时间范围"
		(
			radiobuttons rdobtns_timeRange labels:#("当前范围", "指定范围") default:1 columns:2 align:#center offset:[5,0] offsets:#([0,0],[5,0]) tooltip:#("使用 Max 当前范围，或使用工具指定的开始、结束与步长。","使用 Max 当前范围，或使用工具指定的开始、结束与步长。")
			spinner spn_TRstartTime "始" range:[0,99999, g_ZYLB_BH.TRstart] type:#integer fieldwidth:40 enabled:false align:#left across:3 tooltip:"范围开始帧；用于批量补帧、删帧与烘焙。"
			spinner spn_TRendTime "末" range:[1,99999, g_ZYLB_BH.TRend] type:#integer fieldwidth:40 align:#center enabled:false offset:[7,0] tooltip:"范围结束帧；用于批量补帧、删帧与烘焙。"
			spinner spn_TRstepSize "步" range:[1,99, g_ZYLB_BH.TRstep] type:#integer fieldwidth:20 align:#right tooltip:"批量处理的帧间隔；1 表示逐帧。"
			button btn_setTRstart "" width:55 height:10 align:#left offset:[0,-3] across:2 enabled:false tooltip:"将开始值设为当前帧；Shift 跳到该值。"
			button btn_setTRend "" width:55 height:10 align:#left offset:[-22,-3] enabled:false tooltip:"将结束值设为当前帧；Shift 跳到该值。"
		)	
		
		fn f_closeAllDialogs =
		(
			if chkbtn_pivotsLHand.state then try(destroyDialog g_ZYLB_BH.leftHandPivots_Rollout)catch()
			if chkbtn_pivotsRHand.state then try(destroyDialog g_ZYLB_BH.rightHandPivots_Rollout)catch()
			if chkbtn_pivotsLFoot.state then try(destroyDialog g_ZYLB_BH.leftFootPivots_Rollout)catch()
			if chkbtn_pivotsRFoot.state then try(destroyDialog g_ZYLB_BH.rightFootPivots_Rollout)catch()
			try(destroyDialog g_ZYLB_BH.LayersRetargeting_Rollout)catch()
		)
		
		on SelectionDisplayTime_Rollout open do
		(
			setCommandPanelTaskMode #motion
			local a_bipNames = #()
			for b in g_ZYLB_BH.a_bips do
			(
				append a_bipNames b.name
			)
			ddl_bips.items = a_bipNames
			ddl_bips.selection = g_ZYLB_BH.f_readIniIndex "BipedPanel" "CurrentBip" g_ZYLB_BH.a_bips.count
			if ddl_bips.selection > 0 then
			(
				g_ZYLB_BH.bRoot = g_ZYLB_BH.a_bips[ddl_bips.selection]
				g_ZYLB_BH.f_initBipedParts()
				ddl_bips.height = (ddl_bips.items.count + 1) * 100
			)
			else
			(
				g_ZYLB_BH.f_missingBipedError()
			)
			
			--// Initialize time range
			spn_TRstartTime.value = g_ZYLB_BH.TRstart = animationRange.start
			spn_TRendTime.value = g_ZYLB_BH.TRend = animationRange.end
			spn_TRstepSize.value = g_ZYLB_BH.TRstep = 1
			--// Sync with picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				rdobtns_timeRange.state = g_ZYLB_BH.BipedPicker_Rollout.rdobtns_timeRange.state
				spn_TRstartTime.enabled = spn_TRendTime.enabled = btn_setTRstart.enabled = btn_setTRend.enabled = rdobtns_timeRange.state - 1
				spn_TRstartTime.value = g_ZYLB_BH.BipedPicker_Rollout.spn_TRstartTime.value
				spn_TRendTime.value = g_ZYLB_BH.BipedPicker_Rollout.spn_TRendTime.value
				spn_TRstepSize.value = g_ZYLB_BH.BipedPicker_Rollout.spn_TRstepSize.value
			)
			
			--// Initialize toggle states
			chkbtn_bendLinks.state = g_ZYLB_BH.bRoot.controller.bendLinksMode
			chkbtn_trajectories.state = g_ZYLB_BH.bRoot.controller.displaytrajectories
		)

		on SelectionDisplayTime_Rollout close do
		(
			f_closeAllDialogs()
		)
		
		on SelectionDisplayTime_Rollout moved pos do
		(
			g_ZYLB_BH.BH_pos = pos
			setIniSetting g_ZYLB_BH.bhINIfile "Floater" "Position" (g_ZYLB_BH.BH_pos as string)

			--// update any external dialog positions (if open)
			if chkbtn_pivotsLHand.state then SetDialogPos g_ZYLB_BH.leftHandPivots_Rollout (g_ZYLB_BH.BH_pos + g_ZYLB_BH.leftHandUIoffset)
			if chkbtn_pivotsRHand.state then SetDialogPos g_ZYLB_BH.rightHandPivots_Rollout (g_ZYLB_BH.BH_pos + g_ZYLB_BH.rightHandUIoffset)
			if chkbtn_pivotsLFoot.state then SetDialogPos g_ZYLB_BH.leftFootPivots_Rollout (g_ZYLB_BH.BH_pos + g_ZYLB_BH.leftFootUIoffset)
			if chkbtn_pivotsRFoot.state then SetDialogPos g_ZYLB_BH.rightFootPivots_Rollout (g_ZYLB_BH.BH_pos + g_ZYLB_BH.rightFootUIoffset)			
			SetDialogPos g_ZYLB_BH.LayersRetargeting_Rollout (g_ZYLB_BH.BH_pos + g_ZYLB_BH.layersRetargetingUIoffset)
		)
		
		on ddl_bips selected val do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.ddl_bips"
 try
 (
 (
			if isValidNode g_ZYLB_BH.a_bips[ddl_bips.selection] then
			(
				if ddl_bips.selected == g_ZYLB_BH.a_bips[ddl_bips.selection].name then
				(
					g_ZYLB_BH.bRoot = g_ZYLB_BH.a_bips[ddl_bips.selection]
					g_ZYLB_BH.f_initBipedParts()
					setIniSetting g_ZYLB_BH.bhINIfile "BipedPanel" "CurrentBip" (ddl_bips.selection as string)
					ZYSelectionPrepare()
					if keyboard.shiftPressed do
					(
						try(select g_ZYLB_BH.bRoot)catch(g_ZYLB_BH.f_initBipedParts())
					)
					if keyboard.controlPressed do
					(
						try(select g_ZYLB_BH.a_bipedAllParts)catch(g_ZYLB_BH.f_initBipedParts())
					)
					f_closeAllDialogs()
					g_ZYLB_BH.Layers_Rollout.f_updateLayers()
					
					--// Update picker if open
					if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
					(
						g_ZYLB_BH.BipedPicker_Rollout.ddl_bips.selection = ddl_bips.selection
					)
				)
				else
				(
					g_ZYLB_BH.f_missingBipedError()
				)
			)
			else
			(
				g_ZYLB_BH.f_missingBipedError()
			)
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.ddl_bips"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_refreshUI pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_refreshUI"
 try
 (
 (
			g_ZYLB_BH.f_openBipedUI()
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_refreshUI"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on btn_openPicker pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_openPicker"
 try
 (
 (
			g_ZYLB_BH.f_bipedPickerUI()
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_openPicker"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_resetPickerPos pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_resetPickerPos"
 try
 (
 (
			if (hasIniSetting g_ZYLB_BH.bhINIfile "Picker" "Position") then
			(
				setIniSetting g_ZYLB_BH.bhINIfile "Picker" "Position" (g_ZYLB_BH.defaultPos as string)
				ZYDiagMessageBox "选择器窗口位置已重置。" title:"Biped 助手"
				try(destroyDialog g_ZYLB_BH.BipedPicker_Rollout)catch()
			)
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_resetPickerPos"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectAll pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectAll"
 try
 (
 (
			setCommandPanelTaskMode #motion
			try
			(
				select g_ZYLB_BH.a_bipedAllParts
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectAll"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectHead pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectHead"
 try
 (
 (
			g_ZYLB_BH.f_selectBipedParts g_ZYLB_BH.bHead
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectHead"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectSpine pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectSpine"
 try
 (
 (
			if keyboard.controlPressed AND keyboard.shiftPressed then
			(
				g_ZYLB_BH.f_selectBipedParts g_ZYLB_BH.a_spines
			)
			else
			(
				g_ZYLB_BH.f_selectBipedParts g_ZYLB_BH.bSpine1
			)
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectSpine"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_bendLinks changed state do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.chkbtn_bendLinks"
 try
 (
 (
			try
			(
				g_ZYLB_BH.bRoot.controller.bendLinksMode = state
				
				--// Update the Picker if open
				if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
				(
					g_ZYLB_BH.BipedPicker_Rollout.chkbtn_bendLinks.state = state
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.chkbtn_bendLinks"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectCOM pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectCOM"
 try
 (
 (
			g_ZYLB_BH.f_selectBipedParts g_ZYLB_BH.bRoot
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectCOM"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectFingersLeft pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectFingersLeft"
 try
 (
 (
			g_ZYLB_BH.f_selectBipedParts g_ZYLB_BH.a_fingersLeft
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectFingersLeft"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectFingersRight pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectFingersRight"
 try
 (
 (
			g_ZYLB_BH.f_selectBipedParts g_ZYLB_BH.a_fingersRight
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectFingersRight"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectLFoot pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectLFoot"
 try
 (
 (
			g_ZYLB_BH.f_selectBipedParts g_ZYLB_BH.bFootL
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectLFoot"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	
		on chkbtn_pivotsLFoot changed state do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.chkbtn_pivotsLFoot"
 try
 (
 (
			try
			(
				if state then
				(
					g_ZYLB_BH.f_openPivotsUI_LeftFoot pos:(g_ZYLB_BH.BH_pos + g_ZYLB_BH.leftFootUIoffset)
					chkbtn_pivotsLFoot.state = true
				)
				else
				(
					try(destroyDialog g_ZYLB_BH.leftFootPivots_Rollout)catch()
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.chkbtn_pivotsLFoot"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectRFoot pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectRFoot"
 try
 (
 (
			g_ZYLB_BH.f_selectBipedParts g_ZYLB_BH.bFootR
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectRFoot"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_pivotsRFoot changed state do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.chkbtn_pivotsRFoot"
 try
 (
 (
			try
			(
				if state then
				(
					g_ZYLB_BH.f_openPivotsUI_RightFoot pos:(g_ZYLB_BH.BH_pos + g_ZYLB_BH.rightFootUIoffset)
					chkbtn_pivotsRFoot.state= true
				)
				else
				(
					try(destroyDialog g_ZYLB_BH.rightFootPivots_Rollout)catch()
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.chkbtn_pivotsRFoot"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectLHand pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectLHand"
 try
 (
 (
			g_ZYLB_BH.f_selectBipedParts g_ZYLB_BH.bHandL
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectLHand"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	
		on chkbtn_pivotsLHand changed state do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.chkbtn_pivotsLHand"
 try
 (
 (
			try
			(
				if state then
				(
					g_ZYLB_BH.f_openPivotsUI_LeftHand pos:(g_ZYLB_BH.BH_pos + g_ZYLB_BH.leftHandUIoffset)
					chkbtn_pivotsLHand.state = true
				)
				else
				(
					try(destroyDialog g_ZYLB_BH.leftHandPivots_Rollout)catch()
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.chkbtn_pivotsLHand"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectRHand pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectRHand"
 try
 (
 (
			g_ZYLB_BH.f_selectBipedParts g_ZYLB_BH.bHandR
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectRHand"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_pivotsRHand changed state do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.chkbtn_pivotsRHand"
 try
 (
 (
			try
			(
				if state then
				(
					g_ZYLB_BH.f_openPivotsUI_RightHand pos:(g_ZYLB_BH.BH_pos + g_ZYLB_BH.rightHandUIoffset)
					chkbtn_pivotsRHand.state = true
				)
				else
				(
					try(destroyDialog g_ZYLB_BH.rightHandPivots_Rollout)catch()
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.chkbtn_pivotsRHand"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectHandsFeet pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectHandsFeet"
 try
 (
 (
			g_ZYLB_BH.f_selectBipedParts g_ZYLB_BH.a_bipedHandsFeet
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectHandsFeet"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectProp1 pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectProp1"
 try
 (
 (
			g_ZYLB_BH.f_selectBipedParts g_ZYLB_BH.bProp1
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectProp1"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectProp2 pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectProp2"
 try
 (
 (
			g_ZYLB_BH.f_selectBipedParts g_ZYLB_BH.bProp2
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectProp2"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectProp3 pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectProp3"
 try
 (
 (
			g_ZYLB_BH.f_selectBipedParts g_ZYLB_BH.bProp3
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectProp3"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectBipedParentGrow pressed do (
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectBipedParentGrow"
 try
 (
 g_ZYLB_BH.f_selectBipedParent (selection as array) clearSel:false
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectBipedParentGrow"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectBipedParentNext pressed do (
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectBipedParentNext"
 try
 (
 g_ZYLB_BH.f_selectBipedParent (selection as array)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectBipedParentNext"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectBipedChildren pressed do (
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectBipedChildren"
 try
 (
 g_ZYLB_BH.f_selectBipedChildren (selection as array)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectBipedChildren"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectBipedChildNext pressed do (
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectBipedChildNext"
 try
 (
 g_ZYLB_BH.f_selectBipedChild (selection as array)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectBipedChildNext"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectBipedChildGrow pressed do (
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_selectBipedChildGrow"
 try
 (
 g_ZYLB_BH.f_selectBipedChild (selection as array) clearSel:false
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_selectBipedChildGrow"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_hideBiped pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_hideBiped"
 try
 (
 (
			try
			(
				local a_bipedObjs = g_ZYLB_BH.f_findHierarchy g_ZYLB_BH.bRoot
				a_bipedObjs = g_ZYLB_BH.f_filterBipedParts a_bipedObjs
				for h in helpers do
				(
					if matchpattern h.name pattern:"*Nub" do
					(
						append a_bipedObjs h
					)
				)
				hide a_bipedObjs
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_hideBiped"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on btn_unhideBiped pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_unhideBiped"
 try
 (
 (
			try
			(
				unhide g_ZYLB_BH.a_bipedAllParts
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_unhideBiped"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_boxMode pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_boxMode"
 try
 (
 (
			try
			(
				g_ZYLB_BH.a_bipedAllParts.displayByLayer = false
				if keyboard.shiftPressed then g_ZYLB_BH.a_bipedAllParts.boxMode = false
				else g_ZYLB_BH.a_bipedAllParts.boxMode = true
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_boxMode"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_trajectories changed state do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.chkbtn_trajectories"
 try
 (
 (
			try
			(
				setCommandPanelTaskMode #motion
				g_ZYLB_BH.bRoot.controller.displaytrajectories = state
				
				--// Update the Picker if open
				if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
				(
					g_ZYLB_BH.BipedPicker_Rollout.chkbtn_trajectories.state = state
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.chkbtn_trajectories"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on rdobtns_timeRange changed state do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.rdobtns_timeRange"
 try
 (
 (
			case rdobtns_timeRange.state of
			(
				1: (
						g_ZYLB_BH.TRstart = animationRange.start
						g_ZYLB_BH.TRend = animationRange.end
						spn_TRstartTime.enabled = false
						spn_TRendTime.enabled = false
						btn_setTRstart.enabled = false
						btn_setTRend.enabled = false
					)
				2: (
						g_ZYLB_BH.TRstart = spn_TRstartTime.value as time
						g_ZYLB_BH.TRend = spn_TRendTime.value as time
						spn_TRstartTime.enabled = true
						spn_TRendTime.enabled = true
						btn_setTRstart.enabled = true
						btn_setTRend.enabled = true
					)
			)
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.rdobtns_timeRange.state = state
				case state of
				(
					1: (
							g_ZYLB_BH.BipedPicker_Rollout.spn_TRstartTime.enabled = false
							g_ZYLB_BH.BipedPicker_Rollout.spn_TRendTime.enabled = false
							g_ZYLB_BH.BipedPicker_Rollout.btn_setTRstart.enabled = false
							g_ZYLB_BH.BipedPicker_Rollout.btn_setTRend.enabled = false
					   )
					2: (
							g_ZYLB_BH.BipedPicker_Rollout.spn_TRstartTime.enabled = true
							g_ZYLB_BH.BipedPicker_Rollout.spn_TRendTime.enabled = true
							g_ZYLB_BH.BipedPicker_Rollout.btn_setTRstart.enabled = true
							g_ZYLB_BH.BipedPicker_Rollout.btn_setTRend.enabled = true
					   )
				)
			)
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.rdobtns_timeRange"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on spn_TRstartTime changed val do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.spn_TRstartTime"
 try
 (
 (
			if val >= spn_TRendTime.value then
			(
				g_ZYLB_BH.TRend = spn_TRendTime.value = val + 1
			)
			g_ZYLB_BH.TRstart = val as time
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				if val >= g_ZYLB_BH.BipedPicker_Rollout.spn_TRendTime.value then
				(
					g_ZYLB_BH.BipedPicker_Rollout.spn_TRendTime.value = val + 1
				)
				g_ZYLB_BH.BipedPicker_Rollout.spn_TRstartTime.value = val
			)
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.spn_TRstartTime"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on spn_TRendTime changed val do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.spn_TRendTime"
 try
 (
 (
			if val <= spn_TRstartTime.value then
			(
				g_ZYLB_BH.TRstart = spn_TRstartTime.value = val - 1
			)
			g_ZYLB_BH.TRend = val as time
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				if val <= g_ZYLB_BH.BipedPicker_Rollout.spn_TRstartTime.value then
				(
					g_ZYLB_BH.BipedPicker_Rollout.spn_TRstartTime.value = val - 1
				)
				g_ZYLB_BH.BipedPicker_Rollout.spn_TRendTime.value = val
			)
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.spn_TRendTime"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on spn_TRstepSize changed val do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.spn_TRstepSize"
 try
 (
 (
			g_ZYLB_BH.TRstep = val
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.spn_TRstepSize.value = val
			)
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.spn_TRstepSize"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
			
		on btn_setTRstart pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_setTRstart"
 try
 (
 (
			if keyboard.shiftPressed then
			(
				sliderTime = spn_TRstartTime.value as time
			)
			else
			(
				spn_TRstartTime.value = sliderTime
				if sliderTime >= spn_TRendTime.value then
				(
					g_ZYLB_BH.TRend = spn_TRendTime.value = sliderTime + 1
				)
				g_ZYLB_BH.TRstart = sliderTime
			)
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.spn_TRstartTime.value = sliderTime
				if sliderTime >= spn_TRendTime.value then
				(
					g_ZYLB_BH.BipedPicker_Rollout.spn_TRendTime.value = sliderTime + 1
				)
			)
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_setTRstart"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_setTRend pressed do
		(
 ZYDiagEvent "tool_begin" "SelectionDisplayTime_Rollout.btn_setTRend"
 try
 (
 (
			if keyboard.shiftPressed then
			(
				sliderTime = spn_TRendTime.value as time
			)
			else
			(
				spn_TRendTime.value = sliderTime
				if sliderTime <= spn_TRstartTime.value then
				(
					g_ZYLB_BH.TRstart = spn_TRstartTime.value = sliderTime - 1
				)
				g_ZYLB_BH.TRend = sliderTime
			)

			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.spn_TRendTime.value = sliderTime
				if sliderTime <= spn_TRstartTime.value then
				(
					g_ZYLB_BH.BipedPicker_Rollout.spn_TRstartTime.value = sliderTime - 1
				)
			)
		)
 ZYDiagEvent "tool_end" "SelectionDisplayTime_Rollout.btn_setTRend"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	) --// end rollout
	
	rollout Reference_Rollout "参考"
	(
		group "残影显示"
		(
			checkbutton chkbtn_ghosting "残影" align:#center width:160 height:20 tooltip:"切换所选 Biped 的残影显示。"
			radiobuttons rdobtns_ghostType "显示范围：" labels:#("之前","之后","前后") align:#center offsets:#([-5,0],[0,0],[5,0]) tooltip:#("选择显示当前帧之前、之后或前后两侧的残影。","选择显示当前帧之前、之后或前后两侧的残影。","选择显示当前帧之前、之后或前后两侧的残影。")
			label lbl_ghostTotalFrames "残影总帧数：" align:#left across:2 offset:[8,0]
			spinner spn_ghostTotalFrames "" range:[1,100,3] type:#integer align:#center offset:[-5,0] tooltip:"残影显示的总帧数。"
			label lbl_ghostNthFrame "每隔 N 帧：" align:#left across:2 offset:[8,0]
			spinner spn_ghostNthFrame "" range:[1,100,1] type:#integer align:#center offset:[-5,0] tooltip:"每隔 N 帧显示一次残影；数值越大越稀疏。"
			checkbox chkbx_ghostWireframe "线框显示" align:#left across:2 offset:[5,0] checked:true tooltip:"将残影显示为线框，便于比较姿势而少遮挡模型。"
			checkbox chkbx_ghostFrameNumbers "显示帧号" align:#right offset:[-5,0] tooltip:"在残影上显示对应帧号。"
		)
		group "姿势缓存"
		(
			button btn_snapPB "缓存当前姿势" width:160 height:20 align:#center tooltip:"在当前帧为当前 Biped 创建姿势缓存；需要蒙皮网格。"
			button btn_swapPB "互换缓存姿势" width:116 height:20 align:#left offset:[4,0] enabled:false across:2 tooltip:"当前姿势与已有缓存互换，并留下新的缓存网格。"
			checkbox chkbx_keySwapPB "打帧" align:#right offset:[0,3] checked:true tooltip:"互换缓存姿势时在当前帧打帧；即使 Auto Key 关闭也会打帧。"			
			checkbutton chkbtn_visiblePB "显示" width:78 height:20 align:#left offset:[3,0] across:2 enabled:false tooltip:"切换已有姿势缓存网格的显示。"
			button btn_removePB "删除" width:78 height:20 align:#right offset:[-3,0] enabled:false tooltip:"移除已有姿势缓存网格。"
			spinner spn_PBopacity "缓存不透明度：" range:[0,100,g_ZYLB_BH.defaultPBopacity] type:#integer fieldwidth:30 align:#left offset:[5,3] tooltip:"调整姿势缓存网格不透明度。" across:2
			button btn_defaultPBopacity "<" width:20 height:20 align:#right offset:[0,0] tooltip:"恢复缓存的默认不透明度。"
		)
		group "几何快照"
		(
			label lbl_snapshotSceneLayer "快照来源图层：" align:#left
			edittext edtxt_snapshotSceneLayer "" align:#center width:162 offset:[-2,0] tooltip:"输入待生成快照的蒙皮网格图层名；须与场景原名一致。"
			button btn_snapshotGeometry "生成当前帧快照" width:160 height:20 align:#center tooltip:"为指定图层中的蒙皮网格生成当前帧合并快照。"
			checkbutton chkbtn_visibleSnapshots "显示" align:#left width:78 height:20 offset:[3,0] across:2 tooltip:"切换已有快照图层的显示。"
			button btn_deleteSnapshots "删除" align:#right width:78 height:20 offset:[-3,0] tooltip:"删除快照图层及其中全部快照。"
			spinner spn_snapshotOpacity "快照不透明度：" range:[0,100,g_ZYLB_BH.defaultSnapshotsOpacity] type:#integer fieldwidth:30 align:#center offset:[30,3] across:2 tooltip:"调整已有快照的不透明度。"
			button btn_defaultSnapshotOpacity "<" width:20 height:20 align:#right offset:[-4,0] tooltip:"恢复快照默认不透明度。"
		)
		group "原生轨迹辅助"
		(
			checkbutton chkbtn_addTrajHelper "添加轨迹辅助" width:160 height:20 align:#center tooltip:"点击后在 Biped 表面拾取位置，添加原生轨迹辅助对象。"
			checkbox chkbx_limitTrajDisplay "裁剪轨迹显示" align:#center checked:false tooltip:"按开始与结束值裁剪原生轨迹显示。"
			spinner spn_limitStart "始" range:[0,1000000,animationRange.start] fieldwidth:50 type:#integer align:#left offset:[5,0] enabled:false across:2 tooltip:"原生轨迹裁剪的开始帧。"
			spinner spn_limitEnd "末" range:[0,1000000,animationRange.end] fieldwidth:50 type:#integer align:#right offset:[-5,0] enabled:false tooltip:"原生轨迹裁剪的结束帧。"
			checkbutton chkbtn_visibleTrajHelpers "显示" width:78 height:20 align:#left offset:[3,0] enabled:false across:2 tooltip:"切换已有 Biped 轨迹辅助对象的显示。"
			button btn_deleteTrajHelpers "删除" width:78 height:20 align:#right offset:[-3,0] enabled:false tooltip:"删除全部 Biped 轨迹辅助对象及其图层。"
		)

		on Reference_Rollout open do
		(
			--// Initialize ghost settings based on preferences
			chkbtn_ghosting.state = GhostingManager.ShowGhosting
			rdobtns_ghostType.state = GhostingManager.GhostType
			spn_ghostTotalFrames.value = GhostingManager.TotalGhostFrames
			spn_ghostNthFrame.value = GhostingManager.GhostFrameIncrement
			chkbx_ghostWireframe.checked = GhostingManager.DisplayGhostInWireframe
			chkbx_ghostFrameNumbers.checked = GhostingManager.ShowGhostFrameNumbers
			
			--// Initialize pose buffer
			local layer = LayerManager.getLayerFromName g_ZYLB_BH.poseBuffStr
			if layer != undefined then
			(
				local a_nodes = #()
				layer.nodes &a_nodes
				if a_nodes.count > 0 then
				(
					btn_removePB.enabled = chkbtn_visiblePB.enabled = true
					chkbtn_visiblePB.state = layer.on
					spn_PBopacity.value = $'#_BIPED_POSE_#'.material.opacity
					btn_swapPB.enabled = true
				)
				else
				(
					layerManager.deleteLayerByName g_ZYLB_BH.poseBuffStr
					btn_removePB.enabled = chkbtn_visiblePB.enabled = false
					chkbtn_visiblePB.state = false
					spn_PBopacity.value = g_ZYLB_BH.defaultPBopacity
					btn_swapPB.enabled = false
				)
			)
			--// Sync with the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				spn_PBopacity.value = g_ZYLB_BH.BipedPicker_Rollout.spn_PBopacity.value
			)
						
			--// Initialize geometry snapshot layer and visibility state
			local snapshotLayerName = getIniSetting g_ZYLB_BH.bhINIfile "SnapshotLayer" "LayerName"
			if snapshotLayerName == "*** BLANK ***" and (layerManager.getLayerFromName snapshotLayerName)==undefined do snapshotLayerName=""
			if snapshotLayerName == "" do
			(
				setIniSetting g_ZYLB_BH.bhINIfile "SnapshotLayer" "LayerName" "*** 空白 ***"
				snapshotLayerName = "*** 空白 ***"
			)
			edtxt_snapshotSceneLayer.text = snapshotLayerName
			local layerSnapshots = layerManager.getLayerFromName "SNAPSHOTS"
			if layerSnapshots != undefined then
			(
				btn_deleteSnapshots.enabled = chkbtn_visibleSnapshots.enabled = true
				if layerSnapshots.isHidden then chkbtn_visibleSnapshots.state = false
				else chkbtn_visibleSnapshots.state = true
			)
			else
			(
				btn_deleteSnapshots.enabled = chkbtn_visibleSnapshots.enabled = chkbtn_visibleSnapshots.state = false
			)
			--// Sync with the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				spn_snapshotOpacity.value = g_ZYLB_BH.BipedPicker_Rollout.spn_snapshotOpacity.value
			)
			
			--// Initialize biped trajectories
			maxOps.fixedTrimRange = true
			maxOps.trimTrajectories = false
			local layerBipedTrajectories = layerManager.getLayerFromName "BIPED_TRAJECTORIES"
			if layerBipedTrajectories != undefined then
			(
				btn_deleteTrajHelpers.enabled = chkbtn_visibleTrajHelpers.enabled = true
				if layerBipedTrajectories.isHidden then chkbtn_visibleTrajHelpers.state = false
				else chkbtn_visibleTrajHelpers.state = true
				
				if layerBipedTrajectories.getNumNodes() == 0 then
				(
					g_ZYLB_BH.f_trajectoryHelpersDelete query:false
					btn_deleteTrajHelpers.enabled = chkbtn_visibleTrajHelpers.enabled = chkbtn_visibleTrajHelpers.state = false
				)
			)
			else
			(
				btn_deleteTrajHelpers.enabled = chkbtn_visibleTrajHelpers.enabled = chkbtn_visibleTrajHelpers.state = false
			)
			--// Sync with the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				spn_limitStart.enabled = g_ZYLB_BH.BipedPicker_Rollout.spn_limitStart.enabled
				spn_limitEnd.enabled = g_ZYLB_BH.BipedPicker_Rollout.spn_limitEnd.enabled
				spn_limitStart.value = g_ZYLB_BH.BipedPicker_Rollout.spn_limitStart.value
				spn_limitEnd.value = g_ZYLB_BH.BipedPicker_Rollout.spn_limitEnd.value
				chkbx_limitTrajDisplay.state = g_ZYLB_BH.BipedPicker_Rollout.chkbx_limitTrajDisplay.state
			)
		)
		
		on chkbtn_visibleTrajHelpers changed state do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.chkbtn_visibleTrajHelpers"
 try
 (
 (
			local layerBipedTrajectories = layerManager.getLayerFromName "BIPED_TRAJECTORIES"
			if layerBipedTrajectories != undefined then
			(
				if state then layerBipedTrajectories.isHidden = false
				else layerBipedTrajectories.isHidden = true
			)
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visibleTrajHelpers.state = state
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.chkbtn_visibleTrajHelpers"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_addTrajHelper changed state do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.chkbtn_addTrajHelper"
 try
 (
 (
			local pt = undefined
			if state then
			(
				g_ZYLB_BH.f_addTrajectoryHelper &pt
			)
			chkbtn_addTrajHelper.state = false
			local layerBipedTrajectories = layerManager.getLayerFromName "BIPED_TRAJECTORIES"
			if layerBipedTrajectories != undefined then
			(
				btn_deleteTrajHelpers.enabled = chkbtn_visibleTrajHelpers.enabled = chkbtn_visibleTrajHelpers.state = true
			)
			else
			(
				btn_deleteTrajHelpers.enabled = chkbtn_visibleTrajHelpers.enabled = chkbtn_visibleTrajHelpers.state = false
			)
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				if layerBipedTrajectories != undefined then
				(
					g_ZYLB_BH.BipedPicker_Rollout.btn_deleteTrajHelpers.enabled = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visibleTrajHelpers.enabled = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visibleTrajHelpers.state = true
				)
				else
				(
					g_ZYLB_BH.BipedPicker_Rollout.btn_deleteTrajHelpers.enabled = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visibleTrajHelpers.enabled = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visibleTrajHelpers.state = false
				)
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.chkbtn_addTrajHelper"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbx_limitTrajDisplay changed state do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.chkbx_limitTrajDisplay"
 try
 (
 (
			maxOps.trimTrajectories = state
			spn_limitStart.enabled = spn_limitEnd.enabled = state
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.chkbx_limitTrajDisplay.state = state
				g_ZYLB_BH.BipedPicker_Rollout.spn_limitStart.enabled = g_ZYLB_BH.BipedPicker_Rollout.spn_limitEnd.enabled = state
				g_ZYLB_BH.BipedPicker_Rollout.spn_limitStart.value = spn_limitStart.value
				g_ZYLB_BH.BipedPicker_Rollout.spn_limitEnd.value = spn_limitEnd.value
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.chkbx_limitTrajDisplay"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on spn_limitStart changed val do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.spn_limitStart"
 try
 (
 (
			maxOps.trimTrajectoriesStart = val
			
			if val >= spn_limitEnd.value then
			(
				spn_limitEnd.value = val + 1
			)
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.spn_limitStart.value = val
				if val >= g_ZYLB_BH.BipedPicker_Rollout.spn_limitEnd.value then
				(
					g_ZYLB_BH.BipedPicker_Rollout.spn_limitEnd.value = val + 1
				)
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.spn_limitStart"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on spn_limitEnd changed val do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.spn_limitEnd"
 try
 (
 (
			maxOps.trimTrajectoriesEnd = val
			
			if val <= spn_limitStart.value then
			(
				spn_limitStart.value = val - 1
			)
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.spn_limitEnd.value = val
				if val <= g_ZYLB_BH.BipedPicker_Rollout.spn_limitStart.value then
				(
					g_ZYLB_BH.BipedPicker_Rollout.spn_limitStart.value = val - 1
				)
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.spn_limitEnd"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_deleteTrajHelpers pressed do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.btn_deleteTrajHelpers"
 try
 (
 (
			g_ZYLB_BH.f_trajectoryHelpersDelete()
			btn_deleteTrajHelpers.enabled = chkbtn_visibleTrajHelpers.enabled = chkbtn_visibleTrajHelpers.state = false
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.btn_deleteTrajHelpers.enabled = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visibleTrajHelpers.enabled = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visibleTrajHelpers.state = false
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.btn_deleteTrajHelpers"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_visiblePB changed state do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.chkbtn_visiblePB"
 try
 (
 (
			try
			(
				local poseNode = $'#_BIPED_POSE_#'
				if poseNode != undefined then
				(
					local layer = LayerManager.getLayerFromName g_ZYLB_BH.poseBuffStr
					if layer != undefined then
					(
						btn_swapPB.enabled = layer.on = state
					)
					else
					(
						btn_swapPB.enabled = chkbtn_visiblePB.state = chkbtn_visiblePB.enabled = false
					)
				)
				else
				(
					g_ZYLB_BH.f_cleanupPoseBuffer()
					btn_swapPB.enabled = chkbtn_visiblePB.state = chkbtn_visiblePB.enabled = false
					btn_removePB.enabled = false
				)
				
				--// Update the Picker if open
				if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
				(
					if poseNode != undefined then
					(
						g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visiblePB.state = state
						g_ZYLB_BH.BipedPicker_Rollout.btn_swapPB.enabled = state
					)
					else
					(
						g_ZYLB_BH.BipedPicker_Rollout.btn_swapPB.enabled = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visiblePB.state = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visiblePB.enabled = false
					)
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.chkbtn_visiblePB"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
				
		on btn_snapPB pressed do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.btn_snapPB"
 try
 (
 (
			try
			(
				g_ZYLB_BH.f_snapPB spn_PBopacity.value
				--// Activate toggle, remove and swap buttons
				btn_removePB.enabled = btn_swapPB.enabled = chkbtn_visiblePB.state = chkbtn_visiblePB.enabled = true
				--// Store a copy of the current pose as a file for use with swap pose buffer
				g_ZYLB_BH.f_savePoseBufferFile()
				
				--// Update the Picker if open
				if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
				(
					g_ZYLB_BH.BipedPicker_Rollout.btn_removePB.enabled = g_ZYLB_BH.BipedPicker_Rollout.btn_swapPB.enabled = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visiblePB.state = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visiblePB.enabled = true
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.btn_snapPB"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_swapPB pressed do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.btn_swapPB"
 try
 (
 (
			try
			(
				local poseNode = $'#_BIPED_POSE_#'
				if poseNode != undefined then
				(
					--// Create a new pose buffer using the current Biped pose
					g_ZYLB_BH.f_snapPB spn_PBopacity.value
					--// Swap the Biped pose with the pose buffer
					g_ZYLB_BH.f_swapPB chkbx_keySwapPB.checked
				)
				else
				(
					g_ZYLB_BH.f_cleanupPoseBuffer()
					btn_swapPB.enabled = chkbtn_visiblePB.state = chkbtn_visiblePB.enabled = false
					btn_removePB.enabled = false
				)
				
				--// Update the Picker if open
				if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
				(
					if poseNode == undefined then
					(
						g_ZYLB_BH.BipedPicker_Rollout.btn_swapPB.enabled = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visiblePB.state = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visiblePB.enabled = false
						g_ZYLB_BH.BipedPicker_Rollout.btn_removePB.enabled = false
					)
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.btn_swapPB"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_removePB pressed do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.btn_removePB"
 try
 (
 (
			try
			(
				local poseNode = $'#_BIPED_POSE_#'
				if poseNode != undefined then
				(
					if (ZYDiagQueryBox "确认删除姿势缓存？" title:"Biped 助手") then
					(
						g_ZYLB_BH.f_cleanupPoseBuffer showMsg:false
						btn_swapPB.enabled = chkbtn_visiblePB.state = chkbtn_visiblePB.enabled = false
						btn_removePB.enabled = false
					)
				)
				else
				(
					g_ZYLB_BH.f_cleanupPoseBuffer()
					btn_swapPB.enabled = chkbtn_visiblePB.state = chkbtn_visiblePB.enabled = false
					btn_removePB.enabled = false
				)
				
				--// Update the Picker if open
				if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
				(
					if poseNode != undefined then
					(
						g_ZYLB_BH.BipedPicker_Rollout.btn_swapPB.enabled = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visiblePB.state = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visiblePB.enabled = false
						g_ZYLB_BH.BipedPicker_Rollout.btn_removePB.enabled = false
					)
					else
					(
						g_ZYLB_BH.BipedPicker_Rollout.btn_swapPB.enabled = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visiblePB.state = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visiblePB.enabled = false
						g_ZYLB_BH.BipedPicker_Rollout.btn_removePB.enabled = false
					)
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.btn_removePB"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on spn_PBopacity changed val do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.spn_PBopacity"
 try
 (
 (
			local poseNode = $'#_BIPED_POSE_#'
			if poseNode != undefined then
			(
				with animate off
				(
					poseNode.material.opacity = val
				)
			)
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.spn_PBopacity.value = val
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.spn_PBopacity"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_defaultPBopacity pressed do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.btn_defaultPBopacity"
 try
 (
 (
			spn_PBopacity.value = g_ZYLB_BH.defaultPBopacity
			local poseNode = $'#_BIPED_POSE_#'
			if poseNode != undefined then
			(
				with animate off
				(
					poseNode.material.opacity = g_ZYLB_BH.defaultPBopacity
				)
			)
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.spn_PBopacity.value = g_ZYLB_BH.defaultPBopacity
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.btn_defaultPBopacity"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_ghosting changed state do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.chkbtn_ghosting"
 try
 (
 (
			GhostingManager.ShowGhosting = state
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.chkbtn_ghosting.state = state
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.chkbtn_ghosting"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on rdobtns_ghostType changed state do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.rdobtns_ghostType"
 try
 (
 (
			GhostingManager.GhostType = state
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.rdobtns_ghostType.state = state
			)
			
			redrawViews()
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.rdobtns_ghostType"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on spn_ghostTotalFrames changed val do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.spn_ghostTotalFrames"
 try
 (
 (
			GhostingManager.TotalGhostFrames = val
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.spn_ghostTotalFrames.value = val
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.spn_ghostTotalFrames"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on spn_ghostNthFrame changed val do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.spn_ghostNthFrame"
 try
 (
 (
			GhostingManager.GhostFrameIncrement = val
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.spn_ghostNthFrame.value = val
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.spn_ghostNthFrame"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbx_ghostWireframe changed state do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.chkbx_ghostWireframe"
 try
 (
 (
			GhostingManager.DisplayGhostInWireframe = state
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.chkbx_ghostWireframe.state = state
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.chkbx_ghostWireframe"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbx_ghostFrameNumbers changed state do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.chkbx_ghostFrameNumbers"
 try
 (
 (
			GhostingManager.ShowGhostFrameNumbers = state
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.chkbx_ghostFrameNumbers.state = state
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.chkbx_ghostFrameNumbers"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on edtxt_snapshotSceneLayer changed val do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.edtxt_snapshotSceneLayer"
 try
 (
 (
			setIniSetting g_ZYLB_BH.bhINIfile "SnapshotLayer" "LayerName" val
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.edtxt_snapshotSceneLayer.text = val
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.edtxt_snapshotSceneLayer"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_snapshotGeometry pressed do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.btn_snapshotGeometry"
 try
 (
 (
			try
			(
				undo "SnapshotGeometry" on
				(
					local successful = g_ZYLB_BH.f_snapshotGeometry spn_snapshotOpacity.value
					if successful then
					(
						btn_deleteSnapshots.enabled = chkbtn_visibleSnapshots.enabled = chkbtn_visibleSnapshots.state = true
					
						--// Update the Picker if open
						if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
						(
							g_ZYLB_BH.BipedPicker_Rollout.btn_deleteSnapshots.enabled = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visibleSnapshots.enabled = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visibleSnapshots.state = true
						)
					)
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.btn_snapshotGeometry"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_visibleSnapshots changed state do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.chkbtn_visibleSnapshots"
 try
 (
 (
			g_ZYLB_BH.f_snaphotsVisibility state
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visibleSnapshots.state = state
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.chkbtn_visibleSnapshots"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)		
		
		on btn_deleteSnapshots pressed do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.btn_deleteSnapshots"
 try
 (
 (
			undo "SnapshotsDelete" on
			(
				local deleteConfirmed = g_ZYLB_BH.f_snapshotsDelete()
				if deleteConfirmed then
				(
					btn_deleteSnapshots.enabled = chkbtn_visibleSnapshots.enabled = chkbtn_visibleSnapshots.state = false
					
					--// Update the Picker if open
					if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
					(
						g_ZYLB_BH.BipedPicker_Rollout.btn_deleteSnapshots.enabled = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visibleSnapshots.enabled = g_ZYLB_BH.BipedPicker_Rollout.chkbtn_visibleSnapshots.state = false
					)
				)
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.btn_deleteSnapshots"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on spn_snapshotOpacity changed val do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.spn_snapshotOpacity"
 try
 (
 (
			undo "SnapshotsOpacity" on
			(
				g_ZYLB_BH.f_snapshotsOpacity val
				
				--// Update the Picker if open
				if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
				(
					g_ZYLB_BH.BipedPicker_Rollout.spn_snapshotOpacity.value = val
				)
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.spn_snapshotOpacity"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_defaultSnapshotOpacity pressed do
		(
 ZYDiagEvent "tool_begin" "Reference_Rollout.btn_defaultSnapshotOpacity"
 try
 (
 (
			undo "SnapshotsDefaultOpacity" on
			(
				spn_snapshotOpacity.value = g_ZYLB_BH.defaultSnapshotsOpacity
				g_ZYLB_BH.f_snapshotsOpacity g_ZYLB_BH.defaultSnapshotsOpacity
				
				--// Update the Picker if open
				if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
				(
					g_ZYLB_BH.BipedPicker_Rollout.spn_snapshotOpacity.value = g_ZYLB_BH.defaultSnapshotsOpacity
				)
			)
		)
 ZYDiagEvent "tool_end" "Reference_Rollout.btn_defaultSnapshotOpacity"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	) --// end rollout
	
	rollout Keys_Rollout "关键帧"
	(
		local a_tcbCOM = #(true,true,true) --// Stores the states of the COM track selection settings from the UI (Horizontal, Vertical, Turning)
		local imageAT1 = ZYLB_IconDir + @"\LBTools_BipedHelper_ApplyTransform1.png"
		local imageAT1mask = ZYLB_IconDir + @"\LBTools_BipedHelper_ApplyTransform1_Mask.png"
		local imageAT2 = ZYLB_IconDir + @"\LBTools_BipedHelper_ApplyTransform2.png"
		local imageAT2mask = ZYLB_IconDir + @"\LBTools_BipedHelper_ApplyTransform2_Mask.png"
		
		group "添加 / 修改 / 删除"
		(
			button btn_keyAllParts "全身补帧" width:160 height:18 align:#center tooltip:"给当前 Biped 各主要轨道的已有值补帧。单击仅当前帧；Shift/Ctrl 按范围；右键选择模式。\n不会提交刚改的新姿势；改姿势请开 Auto Key 或用运动面板 Set Key。"
			button btn_keySelectedParts "所选补帧" width:160 height:18 align:#center tooltip:"给所选 Biped 轨道的已有值补帧。单击仅当前帧；Shift/Ctrl 按范围；右键选择模式。\n不会提交刚改的新姿势；改姿势请开 Auto Key 或用运动面板 Set Key。"
			button btn_deleteAllkeys "清空全部帧" width:160 height:18 align:#center tooltip:"删除当前 Biped 全身的所有动画关键帧；会先要求确认。"
			button btn_deleteFrameKeys "删除当前帧" width:78 height:18 align:#left offset:[3,0] across:2 tooltip:"删除所选 Biped 当前帧的 key；Shift/Ctrl 对全身生效。"
			button btn_deleteRangeKeys "删除范围帧" width:78 height:18 align:#right offset:[-3,0] tooltip:"删除所选 Biped 范围内的 key；Shift/Ctrl 对全身生效。"
			button btn_deleteBetweenKeys "间隔删帧" width:115 height:18 align:#left offset:[3,0] across:2 tooltip:"按间隔保留 key 并删除中间帧；Shift/Ctrl 对全身生效。"
			spinner spn_keepStep "" type:#integer range:[2,100,2] fieldwidth:30 align:#right offset:[-3,2] tooltip:"间隔删帧时每 N 帧保留一个 key。"
			button btn_applyIncrement "应用上次变换增量" width:160 height:18 align:#center tooltip:"将最近一次变换增量应用到所选 Biped 的选中 key。"
		)
		label lbl_ZYKeyStatus "补帧：右键选择当前帧 / 范围" width:170 height:32 align:#center
		group "TCB 插值设置"
		(
			label lbl_COM "根轨道：" align:#left offset:[10,3] across:4
			checkbutton chkbtn_horizontal "横" align:#left width:24 height:18 checked:true tooltip:"选中 Biped 根时，将 TCB 修改应用于水平位移轨道。"
			checkbutton chkbtn_vertical "竖" align:#left offset:[-8,0] width:24 height:18 checked:true tooltip:"选中 Biped 根时，将 TCB 修改应用于垂直位移轨道。"
			checkbutton chkbtn_rotation "转" align:#left offset:[-16,0] width:24 height:18 checked:true tooltip:"选中 Biped 根时，将 TCB 修改应用于朝向旋转轨道。"
			radiobuttons rdobtns_tcbType labels:#("张力","连续性","偏置") align:#left offsets:#([-5,0],[-8,0],[2,0]) columns:3 default:2 tooltip:#("选择要修改的张力、连续性或偏置参数，影响 Biped 关键帧之间的插值。","选择要修改的张力、连续性或偏置参数，影响 Biped 关键帧之间的插值。","选择要修改的张力、连续性或偏置参数，影响 Biped 关键帧之间的插值。")
			spinner spn_TCB "TCB 数值：" range:[0,50,25] align:#left fieldwidth:40 offset:[10,3] across:2 tooltip:"TCB 参数值 0–50；点击「应用」写入当前帧，Shift/Ctrl 按指定范围处理。"
			button btn_applyTCB "应用" align:#center offset:[15,0] tooltip:"把当前所选部件的 TCB 参数设为输入数值；按 Shift/Ctrl 应用于指定范围。"
			button btn_TCB0 "0" align:#center width:24 height:18 across:6 offset:[2,0] tooltip:"把所选部件当前帧的 TCB 参数设为 0；按 Shift/Ctrl 按指定范围应用。"
			button btn_TCB5 "5" align:#center width:24 height:18 offset:[2,0] tooltip:"把所选部件当前帧的 TCB 参数设为 5；按 Shift/Ctrl 按指定范围应用。"
			button btn_TCB10 "10" align:#center width:24 height:18 offset:[2,0] tooltip:"把所选部件当前帧的 TCB 参数设为 10；按 Shift/Ctrl 按指定范围应用。"
			button btn_TCB15 "15" align:#center width:24 height:18 offset:[2,0] tooltip:"把所选部件当前帧的 TCB 参数设为 15；按 Shift/Ctrl 按指定范围应用。"
			button btn_TCB20 "20" align:#center width:24 height:18 offset:[2,0] tooltip:"把所选部件当前帧的 TCB 参数设为 20；按 Shift/Ctrl 按指定范围应用。"
			button btn_TCB25 "25" align:#center width:24 height:18 offset:[2,0] tooltip:"把所选部件当前帧的 TCB 参数设为 25；按 Shift/Ctrl 按指定范围应用。"
		)
		group "应用变换"
		(
			label lbl_copiedTM "尚未复制变换"
			button btn_copyTM "复制世界变换" width:164 height:18 align:#center tooltip:"复制一个所选对象的世界位置与旋转。"
			label lbl_pos "位置：" align:#left offset:[10,3] across:4
			checkbutton chkbtn_posX "X" images:#(imageAT1, imageAT1mask, 6, 1, 2, 1, 1, false) width:30 height:18 align:#center offset:[-4,0] checked:false tooltip:"粘贴或烘焙时应用世界 X 位置。"
			checkbutton chkbtn_posY "Y" images:#(imageAT1, imageAT1mask, 6, 3, 4, 1, 1, false) width:30 height:18 align:#center offset:[0,0] checked:false tooltip:"粘贴或烘焙时应用世界 Y 位置。"
			checkbutton chkbtn_posZ "Z" images:#(imageAT1, imageAT1mask, 6, 5, 6, 1, 1, false) width:30 height:18 align:#center offset:[2,0] checked:false tooltip:"粘贴或烘焙时应用世界 Z 位置。"
			label lbl_rot "旋转：" align:#left offset:[10,3] across:2
			checkbutton chkbtn_rotXYZ "XYZ" images:#(imageAT2, imageAT2mask, 2, 1, 2, 1, 1, false) width:118 height:18 align:#center offset:[-22,0] checked:false tooltip:"粘贴或烘焙时应用全部旋转轴。"
			button btn_pasteTM "粘贴世界变换" width:164 height:18 align:#center enabled:false tooltip:"向所选对象粘贴已复制的世界变换；先复制并选择轴。"
			button btn_bakeTM "烘焙世界变换" width:164 height:18 align:#center enabled:false tooltip:"将已复制的世界变换按开始、结束与步长烘焙到所选对象。"
		)
		group "脚部清理"
		(
			radiobuttons rdobtns_applyTo labels:#("当前帧","逐帧","全部键","选中键") align:#center offsets:#([5,0],[-5,0],[5,5],[-5,5]) columns:2 tooltip:#("只处理当前帧","按指定范围逐帧处理","只处理范围内已有 key","只处理范围内选中 key")
			progressBar pb_cleanup color:orange
			radiobuttons rdobtns_PRY labels:#("俯仰","侧倾","朝向") align:#center offsets:#([-10,0],[0,0],[10,0]) tooltip:#("校正脚部俯仰，使脚底平行世界 XY 平面","校正脚部侧倾，使脚底平行世界 XY 平面","以当前帧朝向为基准校正")
			button btn_orientFoot "校正脚部朝向" width:164 height:18 align:#center tooltip:"选择 Biped 脚，按俯仰/侧倾/朝向校正。俯仰和侧倾对齐世界 XY 平面；朝向以当前帧为准。"
			button btn_snapToFloor "脚底贴到 Z=0" width:164 height:18 align:#center tooltip:"将所选 Biped 脚的底面移动到地平面。"
			checkbox chkbx_onlySnapBelow "仅校正低于 Z=0 的脚底" align:#left checked:true tooltip:"只在脚底低于地平面时执行贴地。"
		)
		
		fn f_evaluateAxesToggles =
		(
			g_ZYLB_BH.a_ATtoggles[1] = chkbtn_posX.state
			g_ZYLB_BH.a_ATtoggles[2] = chkbtn_posY.state
			g_ZYLB_BH.a_ATtoggles[3] = chkbtn_posZ.state
			g_ZYLB_BH.a_ATtoggles[4] = chkbtn_rotXYZ.state
		)
		
		fn f_setAxisToggles =
		(
			chkbtn_posX.state = g_ZYLB_BH.a_ATtoggles[1]
			chkbtn_posY.state = g_ZYLB_BH.a_ATtoggles[2]
			chkbtn_posZ.state = g_ZYLB_BH.a_ATtoggles[3]
			chkbtn_rotXYZ.state = g_ZYLB_BH.a_ATtoggles[4]
		)
		
		on Keys_Rollout open do
		(
			--// Initialize apply transform
			btn_pasteTM.enabled = btn_bakeTM.enabled = false
			if g_ZYLB_BH.copiedTransform != undefined then
			(
				btn_pasteTM.enabled = btn_bakeTM.enabled = true
				lbl_copiedTM.text = g_ZYLB_BH.copiedMsg
			)
			f_setAxisToggles()
			
			--// Sync with the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				--// Initialize delete between
				spn_keepStep.value = g_ZYLB_BH.BipedPicker_Rollout.spn_keepStep.value
				--// Initialize foot cleanup
				rdobtns_applyTo.state = g_ZYLB_BH.BipedPicker_Rollout.rdobtns_applyTo.state
				rdobtns_PRY.state = g_ZYLB_BH.BipedPicker_Rollout.rdobtns_PRY.state
				chkbx_onlySnapBelow.state = g_ZYLB_BH.BipedPicker_Rollout.chkbx_onlySnapBelow.state
			)
		)
		
		on btn_keyAllParts pressed do (ZYKeyMenuSource=#helper;ZYKeyApply true (keyboard.shiftPressed or keyboard.controlPressed))
		on btn_keyAllParts rightclick do ZYKeyOpenMenu true source:#helper
		
		on btn_keySelectedParts pressed do (ZYKeyMenuSource=#helper;ZYKeyApply false (keyboard.shiftPressed or keyboard.controlPressed))
		on btn_keySelectedParts rightclick do ZYKeyOpenMenu false source:#helper
		
		on btn_deleteAllkeys pressed do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.btn_deleteAllkeys"
 try
 (
 (
			try
			(
				if g_ZYLB_BH.bRoot.controller.figureMode == false then
				(
					if (ZYDiagQueryBox "确认删除当前 Biped 的全部动画？此操作会删除所有关键帧。" title:"Biped 助手") do
					(
						biped.clearAllAnimation g_ZYLB_BH.bRoot.controller
						g_ZYLB_BH.bRoot.controller.figureMode = true
						g_ZYLB_BH.bRoot.controller.figureMode = false
					)
				)
				else
				(
					ZYDiagMessageBox "请先退出 Biped 的形体模式。" title:"Biped 助手"
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.btn_deleteAllkeys"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
			
		on btn_deleteFrameKeys pressed do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.btn_deleteFrameKeys"
 try
 (
 (
			try
			(
				if g_ZYLB_BH.bRoot.controller.figureMode == false then
				(
					undo "DeleteFrameKeys" on
					(
						if keyboard.shiftPressed OR keyboard.controlPressed then
						(
							g_ZYLB_BH.f_deleteAllFrameKeys()
						)
						else --// Default method, removes keys only on selected parts
						(
							if selection.count > 0 then
							(
								local a_bipedParts = selection as array
								for b in a_bipedParts do
								(
									g_ZYLB_BH.f_deleteBipedPartKeys b
								)
							)
							else
							(
								ZYDiagMessageBox "请先选择一个或多个 Biped 部件。" title:"Biped 助手"
							)
						)
					)
				)
				else
				(
					ZYDiagMessageBox "请先退出 Biped 的形体模式。" title:"Biped 助手"
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.btn_deleteFrameKeys"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_deleteRangeKeys pressed do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.btn_deleteRangeKeys"
 try
 (
 (
			try
			(
				if g_ZYLB_BH.bRoot.controller.figureMode == false then
				(
					undo "DeleteRangeKeys" on
					(
						if keyboard.shiftPressed OR keyboard.controlPressed then
						(
							for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
							(
								g_ZYLB_BH.f_deleteAllFrameKeys atTime:t
							)
						)
						else --// Default method, removes keys only on selected parts
						(
							if selection.count > 0 then
							(
								local a_bipedParts = selection as array
								for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
								(
									for b in a_bipedParts do
									(
										g_ZYLB_BH.f_deleteBipedPartKeys b atTime:t
									)
								)
							)
							else
							(
								ZYDiagMessageBox "请先选择一个或多个 Biped 部件。" title:"Biped 助手"
							)
						)
					)
				)
				else
				(
					ZYDiagMessageBox "请先退出 Biped 的形体模式。" title:"Biped 助手"
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.btn_deleteRangeKeys"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_deleteBetweenKeys pressed do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.btn_deleteBetweenKeys"
 try
 (
 (
			try
			(
				if g_ZYLB_BH.bRoot.controller.figureMode == false then
				(
					undo "DeleteBetweenKeys" on
					(
						--// Delete Between will ignore the time range step size value, so it uses the keep step value instead.
						if keyboard.shiftPressed OR keyboard.controlPressed then
						(
							for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend while NOT keyboard.escPressed do
							(
								if (mod t.frame spn_keepStep.value) != 0 then
								(
									g_ZYLB_BH.f_deleteAllFrameKeys atTime:t
								)
							)
						)
						else --// Default method, removes keys only on selected parts
						(
							if selection.count > 0 then
							(
								local a_bipedParts = selection as array
								for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend while NOT keyboard.escPressed do
								(
									if (mod t.frame spn_keepStep.value) != 0 then
									(
										for b in a_bipedParts do
										(
											g_ZYLB_BH.f_deleteBipedPartKeys b atTime:t
										)
									)
								)
							)
							else
							(
								ZYDiagMessageBox "请先选择一个或多个 Biped 部件。" title:"Biped 助手"
							)
						)
					)
				)
				else
				(
					ZYDiagMessageBox "请先退出 Biped 的形体模式。" title:"Biped 助手"
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.btn_deleteBetweenKeys"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on spn_keepStep changed val do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.spn_keepStep"
 try
 (
 (
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.spn_keepStep.value = val
			)
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.spn_keepStep"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_applyIncrement pressed do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.btn_applyIncrement"
 try
 (
 (
			try
			(
				biped.setmultiplekeys g_ZYLB_BH.bRoot.controller
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.btn_applyIncrement"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_vertical changed state do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.chkbtn_vertical"
 try
 (
 (
			a_tcbCOM[1] = state
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.chkbtn_vertical"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_horizontal changed state do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.chkbtn_horizontal"
 try
 (
 (
			a_tcbCOM[2] = state
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.chkbtn_horizontal"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on chkbtn_rotation changed state do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.chkbtn_rotation"
 try
 (
 (
			a_tcbCOM[3] = state
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.chkbtn_rotation"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_applyTCB pressed do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.btn_applyTCB"
 try
 (
 (
			g_ZYLB_BH.f_evaluateTCBprocess a_tcbCOM rdobtns_tcbType.state spn_TCB.value
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.btn_applyTCB"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_TCB0 pressed do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.btn_TCB0"
 try
 (
 (
			g_ZYLB_BH.f_evaluateTCBprocess a_tcbCOM rdobtns_tcbType.state 0.0
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.btn_TCB0"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_TCB5 pressed do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.btn_TCB5"
 try
 (
 (
			g_ZYLB_BH.f_evaluateTCBprocess a_tcbCOM rdobtns_tcbType.state 5.0
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.btn_TCB5"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_TCB10 pressed do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.btn_TCB10"
 try
 (
 (
			g_ZYLB_BH.f_evaluateTCBprocess a_tcbCOM rdobtns_tcbType.state 10.0
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.btn_TCB10"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_TCB15 pressed do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.btn_TCB15"
 try
 (
 (
			g_ZYLB_BH.f_evaluateTCBprocess a_tcbCOM rdobtns_tcbType.state 15.0
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.btn_TCB15"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_TCB20 pressed do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.btn_TCB20"
 try
 (
 (
			g_ZYLB_BH.f_evaluateTCBprocess a_tcbCOM rdobtns_tcbType.state 20.0
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.btn_TCB20"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_TCB25 pressed do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.btn_TCB25"
 try
 (
 (
			g_ZYLB_BH.f_evaluateTCBprocess a_tcbCOM rdobtns_tcbType.state 25.0
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.btn_TCB25"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
			
		on chkbtn_posX changed state do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.chkbtn_posX"
 try
 (
 (
			f_evaluateAxesToggles()
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.chkbtn_posX.state = state
			)
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.chkbtn_posX"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on chkbtn_posY changed state do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.chkbtn_posY"
 try
 (
 (
			f_evaluateAxesToggles()
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.chkbtn_posY.state = state
			)
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.chkbtn_posY"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_posZ changed state do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.chkbtn_posZ"
 try
 (
 (
			f_evaluateAxesToggles()
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.chkbtn_posZ.state = state
			)
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.chkbtn_posZ"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_rotXYZ changed state do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.chkbtn_rotXYZ"
 try
 (
 (
			f_evaluateAxesToggles()
			
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.chkbtn_rotXYZ.state = state
			)
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.chkbtn_rotXYZ"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_copyTM pressed do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.btn_copyTM"
 try
 (
 (
			if selection.count == 1 then
			(
				local sel = selection[1]
				g_ZYLB_BH.copiedTransform = sel.transform
				lbl_copiedTM.text = g_ZYLB_BH.copiedMsg
				btn_pasteTM.enabled = btn_bakeTM.enabled = true
				
				--// Update the Picker if open
				if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
				(
					g_ZYLB_BH.BipedPicker_Rollout.btn_copiedTM.images = #((g_ZYLB_BH.f_buttonColor 12 18 g_ZYLB_BH.clr_orange),undefined,1,1,1,1,1,false)
					g_ZYLB_BH.BipedPicker_Rollout.btn_pasteTM.enabled = g_ZYLB_BH.BipedPicker_Rollout.btn_bakeTM.enabled = true
				)
			)
			else
			(
				ZYDiagMessageBox "请先只选择一个对象。" title:"Biped 助手"
			)
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.btn_copyTM"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_pasteTM pressed do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.btn_pasteTM"
 try
 (
 (
			undo "PasteTransform" on
			(
				if selection.count == 1 then
				(
					local sel = selection[1]
					if g_ZYLB_BH.copiedTransform != undefined then
					(
						f_evaluateAxesToggles()
						if NOT g_ZYLB_BH.a_ATtoggles[1] AND NOT g_ZYLB_BH.a_ATtoggles[2] AND NOT g_ZYLB_BH.a_ATtoggles[3] AND NOT g_ZYLB_BH.a_ATtoggles[4] then
						(
							ZYDiagMessageBox "请先选择要应用的位置轴或旋转。" title:"Biped 助手"
						)
						else
						(
							with animate on
							(
								g_ZYLB_BH.f_pasteCopiedTM sel
							)
						)
						redrawViews()
					)
					else
					(
						ZYDiagMessageBox "尚未复制变换。请选中一个对象并点击「复制世界变换」。" title:"Biped 助手"
					)
				)
				else
				(
					ZYDiagMessageBox "请先只选择一个对象。" title:"Biped 助手"
				)
			)
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.btn_pasteTM"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_bakeTM pressed do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.btn_bakeTM"
 try
 (
 (
			if selection.count == 1 then
			(
				local sel = selection[1]
				undo "BakeTransform" on
				(
					setCommandPanelTaskMode #create --// switching out of motion panel greatly decreases processing time
					if g_ZYLB_BH.copiedTransform != undefined then
					(
						f_evaluateAxesToggles()
						if NOT g_ZYLB_BH.a_ATtoggles[1] AND NOT g_ZYLB_BH.a_ATtoggles[2] AND NOT g_ZYLB_BH.a_ATtoggles[3] AND NOT g_ZYLB_BH.a_ATtoggles[4] then
						(
							ZYDiagMessageBox "请先选择要应用的位置轴或旋转。" title:"Biped 助手"
						)
						else
						(
							local prevTime = sliderTime
							disableSceneRedraw()
							with animate on
							(
								for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
								(
									at time t
									(
										sliderTime = t
										g_ZYLB_BH.f_pasteCopiedTM sel
									)
								)
							)
							enableSceneRedraw()
							sliderTime = prevTime
						)
						redrawViews()
					)
					else
					(
						ZYDiagMessageBox "尚未复制变换。请选中一个肢体并点击「复制世界变换」。" title:"Biped 助手"
					)
				)
			)
			else
			(
				ZYDiagMessageBox "请先只选择一个对象。" title:"Biped 助手"
			)
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.btn_bakeTM"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on rdobtns_applyTo changed state do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.rdobtns_applyTo"
 try
 (
 (
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.rdobtns_applyTo.state = state
			)
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.rdobtns_applyTo"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on rdobtns_PRY changed state do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.rdobtns_PRY"
 try
 (
 (
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.rdobtns_PRY.state = state
			)
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.rdobtns_PRY"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbx_onlySnapBelow changed state do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.chkbx_onlySnapBelow"
 try
 (
 (
			--// Update the Picker if open
			if g_ZYLB_BH.BipedPicker_Rollout != undefined AND g_ZYLB_BH.BipedPicker_Rollout.open then
			(
				g_ZYLB_BH.BipedPicker_Rollout.chkbx_onlySnapBelow.state = state
			)
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.chkbx_onlySnapBelow"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_orientFoot pressed do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.btn_orientFoot"
 try
 (
 (
			try
			(
				if selection.count == 1 AND selection[1] == g_ZYLB_BH.bFootL OR selection[1] == g_ZYLB_BH.bFootR then
				(
					local foot = selection[1]
					undo "OrientFoot" on
					(
						setCommandPanelTaskMode #create --// switching out of motion panel greatly decreases processing time
						case rdobtns_applyTo.state of
						(
							1:( --// Frame
								with animate on
								(
									g_ZYLB_BH.f_applyFootOrientation foot rdobtns_PRY.state
								)
							)
							2:( --// Bake
								disableSceneRedraw()
								with animate on
								(
									for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
									(
										at time t
										(
											pb_cleanup.value = 100 * ((t as integer) / TicksPerFrame) / ((g_ZYLB_BH.TRend as integer) / TicksPerFrame)
											g_ZYLB_BH.f_applyFootOrientation foot rdobtns_PRY.state
										)
									)
								)
								pb_cleanup.value = 0
								enableSceneRedraw()
							)
							3:( --// All Keys
								disableSceneRedraw()
								with animate on
								(
									local a_times = g_ZYLB_BH.f_getAllKeyTimesTR foot g_ZYLB_BH.TRstart g_ZYLB_BH.TRend
									if a_times.count > 0 then
									(
										for t in a_times while NOT keyboard.escPressed do
										(
											at time t
											(
												pb_cleanup.value = 100 * ((t as integer) / TicksPerFrame) / ((g_ZYLB_BH.TRend as integer) / TicksPerFrame)
												g_ZYLB_BH.f_applyFootOrientation foot rdobtns_PRY.state
											)
										)
									)
									else
									(
										ZYDiagMessageBox "指定范围内没有关键帧。" title:"Biped 助手"
									)
								)
								pb_cleanup.value = 0
								enableSceneRedraw()
							)
							4:( --// Selected Keys
								disableSceneRedraw()
								with animate on
								(
									local a_times = g_ZYLB_BH.f_getAllKeyTimesTR foot g_ZYLB_BH.TRstart g_ZYLB_BH.TRend selectedOnly:true
									if a_times.count > 0 then
									(
										for t in a_times while NOT keyboard.escPressed do
										(
											at time t
											(
												pb_cleanup.value = 100 * ((t as integer) / TicksPerFrame) / ((g_ZYLB_BH.TRend as integer) / TicksPerFrame)
												g_ZYLB_BH.f_applyFootOrientation foot rdobtns_PRY.state
											)
										)
									)
									else
									(
										ZYDiagMessageBox "指定范围内没有选中的关键帧。" title:"Biped 助手"
									)
								)
								pb_cleanup.value = 0
								enableSceneRedraw()
							)
						)
						if isValidNode g_ZYLB_BH.dumYawCalf then delete g_ZYLB_BH.dumYawCalf
						if isValidNode g_ZYLB_BH.dumYawFoot then delete g_ZYLB_BH.dumYawFoot
						redrawViews()
					)
				)
				else
				(
					ZYDiagMessageBox "请只选择 Biped 左脚或右脚。" title:"Biped 助手"
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.btn_orientFoot"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
			
		on btn_snapToFloor pressed do
		(
 ZYDiagEvent "tool_begin" "Keys_Rollout.btn_snapToFloor"
 try
 (
 (
			try
			(
				if selection.count == 1 AND selection[1] == g_ZYLB_BH.bFootL OR selection[1] == g_ZYLB_BH.bFootR then
				(
					local foot = selection[1]
					undo "SnapFootToFloor" on
					(
						setCommandPanelTaskMode #create --// switching out of motion panel greatly decreases processing time
						case rdobtns_applyTo.state of
						(
							1:( --// Frame
								with animate on
								(
									g_ZYLB_BH.f_snapFootToFloor foot chkbx_onlySnapBelow.checked
								)
							)
							2:( --// Bake
								disableSceneRedraw()
								with animate on
								(
									for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
									(
										at time t
										(
											pb_cleanup.value = 100 * ((t as integer) / TicksPerFrame) / ((g_ZYLB_BH.TRend as integer) / TicksPerFrame)
											g_ZYLB_BH.f_snapFootToFloor foot chkbx_onlySnapBelow.checked
										)
									)
								)
								pb_cleanup.value = 0
								enableSceneRedraw()
							)
							3:( --// All Keys
								disableSceneRedraw()
								with animate on
								(
									local a_times = g_ZYLB_BH.f_getAllKeyTimesTR foot g_ZYLB_BH.TRstart g_ZYLB_BH.TRend
									if a_times.count > 0 then
									(
										for t in a_times while NOT keyboard.escPressed do
										(
											at time t
											(
												pb_cleanup.value = 100 * ((t as integer) / TicksPerFrame) / ((g_ZYLB_BH.TRend as integer) / TicksPerFrame)
												g_ZYLB_BH.f_snapFootToFloor foot chkbx_onlySnapBelow.checked
											)
										)
									)
									else
									(
										ZYDiagMessageBox "指定范围内没有关键帧。" title:"Biped 助手"
									)
								)
								pb_cleanup.value = 0
								enableSceneRedraw()
							)
							4:( --// Selected Keys
								disableSceneRedraw()
								with animate on
								(
									local a_times = g_ZYLB_BH.f_getAllKeyTimesTR foot g_ZYLB_BH.TRstart g_ZYLB_BH.TRend selectedOnly:true
									if a_times.count > 0 then
									(
										for t in a_times while NOT keyboard.escPressed do
										(
											at time t
											(
												pb_cleanup.value = 100 * ((t as integer) / TicksPerFrame) / ((g_ZYLB_BH.TRend as integer) / TicksPerFrame)
												g_ZYLB_BH.f_snapFootToFloor foot chkbx_onlySnapBelow.checked
											)
										)
									)
									else
									(
										ZYDiagMessageBox "指定范围内没有选中的关键帧。" title:"Biped 助手"
									)
								)
								pb_cleanup.value = 0
								enableSceneRedraw()
							)
						)
						redrawViews()
					)
				)
				else
				(
					ZYDiagMessageBox "请只选择 Biped 左脚或右脚。" title:"Biped 助手"
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Keys_Rollout.btn_snapToFloor"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	) --// end rollout

	rollout LimbSpaces_Rollout "四肢空间"
	(
		group "手臂 IK 空间"
		(
			button btn_bothArmsObject "双臂：对象空间" align:#center width:160 height:18 tooltip:"给双臂设置对象空间的滑动 IK 帧；按 Shift 改设固定 IK 帧。"
			button btn_LarmObject "左臂：对象" align:#left across:2 width:78 height:18 offset:[3,0] tooltip:"给左臂设置对象空间的滑动 IK 帧；按 Shift 改设固定 IK 帧。"
			button btn_RarmObject "右臂：对象" align:#right width:78 height:18 offset:[-3,0] tooltip:"给右臂设置对象空间的滑动 IK 帧；按 Shift 改设固定 IK 帧。"
			button btn_bothArmsBody "双臂：身体空间" align:#center width:160 height:18 tooltip:"给双臂设置身体空间的自由帧。"
			button btn_LarmBody "左臂：身体" align:#left across:2 width:78 height:18 offset:[3,0] tooltip:"给左臂设置身体空间的自由关键帧。"
			button btn_RarmBody "右臂：身体" align:#right width:78 height:18 offset:[-3,0] tooltip:"给右臂设置身体空间的自由关键帧。"
		)
		group "腿部 IK 空间"
		(
			button btn_bothLegsObject "双腿：对象空间" align:#center width:160 height:18 tooltip:"给双腿设置对象空间的滑动 IK 帧；按 Shift 改设固定 IK 帧。"
			button btn_LlegObject "左腿：对象" align:#center across:2 width:78 height:18 tooltip:"给左腿设置对象空间的滑动 IK 帧；按 Shift 改设固定 IK 帧。"
			button btn_RlegObject "右腿：对象" align:#center width:78 height:18 tooltip:"给右腿设置对象空间的滑动 IK 帧；按 Shift 改设固定 IK 帧。"
			button btn_bothLegsBody "双腿：身体空间" align:#center width:160 height:18 tooltip:"给双腿设置身体空间的自由帧。"
			button btn_LlegBody "左腿：身体" align:#center across:2 width:78 height:18 tooltip:"给左腿设置身体空间的自由关键帧。"
			button btn_RlegBody "右腿：身体" align:#center width:78 height:18 tooltip:"给右腿设置身体空间的自由关键帧。"
		)
		group "暂存与切换 IK 空间"
		(
			button btn_limbObject "所选：对象空间" across:2 align:#left width:78 height:18 offset:[3,0] tooltip:"将所选四肢的全部关键帧切换为对象空间 IK。请先在副本确认手脚运动结果。"
			button btn_storeSpaces "暂存空间状态" align:#right width:78 height:18 offset:[-3,0] tooltip:"暂存全部四肢各帧的身体/对象空间设置，再统一切为身体空间。"
			button btn_limbBody "所选：身体空间" across:2 align:#left width:78 height:18 offset:[3,0] tooltip:"将所选四肢的全部关键帧切换为身体空间。"
			button btn_loadSpaces "恢复空间状态" align:#right width:78 height:18 offset:[-3,0] tooltip:"恢复之前通过「暂存空间状态」保存的四肢空间设置。"
		)
		
		on btn_bothArmsObject pressed do
		(
 ZYDiagEvent "tool_begin" "LimbSpaces_Rollout.btn_bothArmsObject"
 try
 (
 (
			try(
				if keyboard.shiftPressed then
				(
					biped.setPlantedKey g_ZYLB_BH.bHandL
					biped.setPlantedKey g_ZYLB_BH.bHandR					
				)
				else
				(
					biped.setSlidingKey g_ZYLB_BH.bHandL
					biped.setSlidingKey g_ZYLB_BH.bHandR
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LimbSpaces_Rollout.btn_bothArmsObject"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
			
		on btn_LarmObject pressed do
		(
 ZYDiagEvent "tool_begin" "LimbSpaces_Rollout.btn_LarmObject"
 try
 (
 (
			try(
				if keyboard.shiftPressed then
				(
					biped.setPlantedKey g_ZYLB_BH.bHandL
				)
				else
				(
					biped.setSlidingKey g_ZYLB_BH.bHandL
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LimbSpaces_Rollout.btn_LarmObject"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_LarmBody pressed do
		(
 ZYDiagEvent "tool_begin" "LimbSpaces_Rollout.btn_LarmBody"
 try
 (
 (
			try
			(
				biped.setFreeKey g_ZYLB_BH.bHandL
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LimbSpaces_Rollout.btn_LarmBody"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	
		on btn_bothArmsBody pressed do
		(
 ZYDiagEvent "tool_begin" "LimbSpaces_Rollout.btn_bothArmsBody"
 try
 (
 (
			try
			(
				biped.setFreeKey g_ZYLB_BH.bHandL
			)catch(g_ZYLB_BH.f_initBipedParts())
			try
			(
				biped.setFreeKey g_ZYLB_BH.bHandR
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LimbSpaces_Rollout.btn_bothArmsBody"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_RarmObject pressed do
		(
 ZYDiagEvent "tool_begin" "LimbSpaces_Rollout.btn_RarmObject"
 try
 (
 (
			try(
				if keyboard.shiftPressed then
				(
					biped.setPlantedKey g_ZYLB_BH.bHandR
				)
				else
				(
					biped.setSlidingKey g_ZYLB_BH.bHandR
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LimbSpaces_Rollout.btn_RarmObject"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_RarmBody pressed do
		(
 ZYDiagEvent "tool_begin" "LimbSpaces_Rollout.btn_RarmBody"
 try
 (
 (
			try
			(
				biped.setFreeKey g_ZYLB_BH.bHandR
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LimbSpaces_Rollout.btn_RarmBody"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)	
		
		on btn_bothLegsObject pressed do
		(
 ZYDiagEvent "tool_begin" "LimbSpaces_Rollout.btn_bothLegsObject"
 try
 (
 (
			try(
				if keyboard.shiftPressed then
				(
					biped.setPlantedKey g_ZYLB_BH.bFootL
					biped.setPlantedKey g_ZYLB_BH.bFootR
				)
				else
				(
					biped.setSlidingKey g_ZYLB_BH.bFootL
					biped.setSlidingKey g_ZYLB_BH.bFootR
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LimbSpaces_Rollout.btn_bothLegsObject"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
			
		on btn_LlegObject pressed do
		(
 ZYDiagEvent "tool_begin" "LimbSpaces_Rollout.btn_LlegObject"
 try
 (
 (
			try(
				if keyboard.shiftPressed then
				(
					biped.setPlantedKey g_ZYLB_BH.bFootL
				)
				else
				(
					biped.setSlidingKey g_ZYLB_BH.bFootL
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LimbSpaces_Rollout.btn_LlegObject"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_LlegBody pressed do
		(
 ZYDiagEvent "tool_begin" "LimbSpaces_Rollout.btn_LlegBody"
 try
 (
 (
			try
			(
				biped.setFreeKey g_ZYLB_BH.bFootL
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LimbSpaces_Rollout.btn_LlegBody"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	
		on btn_bothLegsBody pressed do
		(
 ZYDiagEvent "tool_begin" "LimbSpaces_Rollout.btn_bothLegsBody"
 try
 (
 (
			try(
				biped.setFreeKey g_ZYLB_BH.bFootL
				biped.setFreeKey g_ZYLB_BH.bFootR
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LimbSpaces_Rollout.btn_bothLegsBody"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_RlegObject pressed do
		(
 ZYDiagEvent "tool_begin" "LimbSpaces_Rollout.btn_RlegObject"
 try
 (
 (
			try(
				if keyboard.shiftPressed then
				(
					biped.setPlantedKey g_ZYLB_BH.bFootR
				)
				else
				(
					biped.setSlidingKey g_ZYLB_BH.bFootR
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LimbSpaces_Rollout.btn_RlegObject"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_RlegBody pressed do
		(
 ZYDiagEvent "tool_begin" "LimbSpaces_Rollout.btn_RlegBody"
 try
 (
 (
			try
			(
				biped.setFreeKey g_ZYLB_BH.bFootR
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LimbSpaces_Rollout.btn_RlegBody"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_storeSpaces pressed do
		(
 ZYDiagEvent "tool_begin" "LimbSpaces_Rollout.btn_storeSpaces"
 try
 (
 (
			try
			(
				g_ZYLB_BH.a_storedSpaces = g_ZYLB_BH.f_storeSpaces()
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LimbSpaces_Rollout.btn_storeSpaces"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on btn_loadSpaces pressed do
		(
 ZYDiagEvent "tool_begin" "LimbSpaces_Rollout.btn_loadSpaces"
 try
 (
 (
			try
			(
				undo "LoadSpaces" on
				(
					g_ZYLB_BH.f_loadSpaces g_ZYLB_BH.a_storedSpaces
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LimbSpaces_Rollout.btn_loadSpaces"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)	

		on btn_limbBody pressed do
		(
 ZYDiagEvent "tool_begin" "LimbSpaces_Rollout.btn_limbBody"
 try
 (
 (
			try(
				undo "LimbBody" on
				(
					g_ZYLB_BH.f_limbBody()
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LimbSpaces_Rollout.btn_limbBody"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_limbObject pressed do
		(
 ZYDiagEvent "tool_begin" "LimbSpaces_Rollout.btn_limbObject"
 try
 (
 (
			try(
				undo "LimbObject" on
				(
					g_ZYLB_BH.f_limbObject()
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LimbSpaces_Rollout.btn_limbObject"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	) --// end rollout
	
	rollout BipFiles_Rollout "载入 / 保存"
	(
		group ""
		(
			button btn_loadAnimDialog "载入 BIP…" align:#left width:78 height:18 offset:[3,0] across:2 tooltip:"选择 BIP 文件并载入当前 Biped；会影响现有动画。"
			button btn_saveAnimDialog "保存 BIP…" align:#right width:78 height:18 offset:[-3,0] tooltip:"选择保存位置，将当前 Biped 动画保存为 BIP 文件。"
			button btn_loadAnimQuick "快速载入" align:#left width:78 height:18 offset:[3,0] across:2 tooltip:"载入本工具上次快速保存的 Biped 动画。"
			button btn_saveAnimQuick "快速保存" align:#right width:78 height:18 offset:[-3,0] tooltip:"将当前 Biped 动画快速保存到本工具独立文件。"
		)
			
		on btn_loadAnimDialog pressed do
		(
 ZYDiagEvent "tool_begin" "BipFiles_Rollout.btn_loadAnimDialog"
 try
 (
 (
			try
			(
				biped.loadBipFileDlg g_ZYLB_BH.bRoot.controller
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "BipFiles_Rollout.btn_loadAnimDialog"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_saveAnimDialog pressed do
		(
 ZYDiagEvent "tool_begin" "BipFiles_Rollout.btn_saveAnimDialog"
 try
 (
 (
			try
			(
				biped.saveBipFileDlg g_ZYLB_BH.bRoot.controller
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "BipFiles_Rollout.btn_saveAnimDialog"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_loadAnimQuick pressed do
		(
 ZYDiagEvent "tool_begin" "BipFiles_Rollout.btn_loadAnimQuick"
 try
 (
 (
			try
			(
				if (doesFileExist g_ZYLB_BH.quickBipFile) then
				(
					biped.loadBipFile g_ZYLB_BH.bRoot.controller g_ZYLB_BH.quickBipFile
					ZYDiagMessageBox "动画已载入。" title:"Biped 助手"
				)
				else
				(
					ZYDiagMessageBox "未找到本工具之前快速保存的动画。" title:"Biped 助手"
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "BipFiles_Rollout.btn_loadAnimQuick"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_saveAnimQuick pressed do
		(
 ZYDiagEvent "tool_begin" "BipFiles_Rollout.btn_saveAnimQuick"
 try
 (
 (
			try
			(
				biped.saveBipFile g_ZYLB_BH.bRoot.controller g_ZYLB_BH.quickBipFile
				ZYDiagMessageBox "动画已保存。" title:"Biped 助手"
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "BipFiles_Rollout.btn_saveAnimQuick"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	) --// end rollout
		
	rollout LayersRetargeting_Rollout "Biped 图层"
	(
		local ctrl = undefined
		
		fn f_filter obj = NOT (matchPattern obj.name pattern:(g_ZYLB_BH.bRoot.name + "*"))
		
		group "IK 重定向"
		(
			radiobuttons rdobtns_base labels:#("Biped 基础层") align:#left offsets:#([15,0]) default:1 tooltip:#("以当前 Biped 的基础动画层作为 IK 重定向参考。")
			radiobuttons rdobtns_ref labels:#("参考 Biped") align:#left offsets:#([15,0]) default:0 enabled:false tooltip:#("以拾取的另一个 Biped 作为 IK 重定向参考。")
			pickbutton pkbtn_refBiped "拾取参考 Biped" width:173 height:18 align:#center offset:[-2,0] filter:f_filter message:"拾取另一个 Biped 作为参考。" tooltip:"拾取另一个 Biped 的部件，以该角色作为重定向参考。"
			checkbutton chkbtn_leftArm "左臂" across:4 width:40 height:18 align:#left tooltip:"将左臂纳入本次 IK 重定向处理。"
			checkbutton chkbtn_rightArm "右臂" width:40 height:18 align:#left tooltip:"将右臂纳入本次 IK 重定向处理。"
			checkbutton chkbtn_leftLeg "左腿" width:40 height:18 align:#right tooltip:"将左腿纳入本次 IK 重定向处理。"
			checkbutton chkbtn_rightLeg "右腿" width:40 height:18 align:#right tooltip:"将右腿纳入本次 IK 重定向处理。"
			button btn_update "更新" width:100 height:18 align:#left across:2 tooltip:"按指定参考更新所选四肢的 IK 重定向设置。"
			checkbox chkbx_IKonly "仅 IK" align:#right offset:[-10,2] tooltip:"将重定向处理限制到 IK 关键帧。"
		)
		
		on LayersRetargeting_Rollout open do
		(
			ctrl = g_ZYLB_BH.bRoot.controller
			
			local obj = biped.getRetargetRefBip ctrl
			if isValidNode obj then
			(
				pkbtn_refBiped.text = obj.name
				rdobtns_ref.enabled = true
			)
			else
			(
				pkbtn_refBiped.object = undefined
			)

			if g_ZYLB_BH.retargetingOption == 1 then
			(
				rdobtns_base.state = 1
				rdobtns_ref.state = 0
			)
			else if g_ZYLB_BH.retargetingOption == 2 then
			(
				rdobtns_base.state = 0
				rdobtns_ref.state = 1
			)
				
			chkbtn_leftArm.checked = biped.getLimbRetargetState g_ZYLB_BH.bHandL
			chkbtn_rightArm.checked = biped.getLimbRetargetState g_ZYLB_BH.bHandR
			chkbtn_leftLeg.checked = biped.getLimbRetargetState g_ZYLB_BH.bFootL
			chkbtn_rightLeg.checked = biped.getLimbRetargetState g_ZYLB_BH.bFootR
		)
		
		on LayersRetargeting_Rollout close do
		(
			g_ZYLB_BH.Layers_Rollout.chkbtn_retargeting.state = false
		)
		
		on pkbtn_refBiped picked obj do
		(
 ZYDiagEvent "tool_begin" "LayersRetargeting_Rollout.pkbtn_refBiped"
 try
 (
 (
			if isValidNode obj AND classof obj.baseObject == Biped_Object then
			(
				local rootObj = g_ZYLB_BH.f_findHierarchyRoot obj
				if rootObj != g_ZYLB_BH.bRoot then
				(
					pkbtn_refBiped.text = rootObj.name
					rdobtns_base.state = 0
					rdobtns_ref.state = 1
					rdobtns_ref.enabled = true
					biped.setRetargetRefBip ctrl rootObj
				)
				else
				(
					ZYDiagMessageBox "参考 Biped 必须是另一个角色。" title:"Biped 动画层"
				)
			)
			else
			(
				ZYDiagMessageBox "请拾取一个 Biped 部件。" title:"Biped 动画层"
			)
		)
 ZYDiagEvent "tool_end" "LayersRetargeting_Rollout.pkbtn_refBiped"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on rdobtns_base changed state do
		(
 ZYDiagEvent "tool_begin" "LayersRetargeting_Rollout.rdobtns_base"
 try
 (
 (
			if state == 1 then
			(
				rdobtns_ref.state = 0
				g_ZYLB_BH.retargetingOption = 1
			)
		)
 ZYDiagEvent "tool_end" "LayersRetargeting_Rollout.rdobtns_base"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on rdobtns_ref changed state do
		(
 ZYDiagEvent "tool_begin" "LayersRetargeting_Rollout.rdobtns_ref"
 try
 (
 (
			if state == 1 then
			(
				rdobtns_base.state = 0
				g_ZYLB_BH.retargetingOption = 2
			)
		)
 ZYDiagEvent "tool_end" "LayersRetargeting_Rollout.rdobtns_ref"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_leftArm changed state do
		(
 ZYDiagEvent "tool_begin" "LayersRetargeting_Rollout.chkbtn_leftArm"
 try
 (
 (
			try
			(
				biped.setLimbRetargetState g_ZYLB_BH.bHandL state
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LayersRetargeting_Rollout.chkbtn_leftArm"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_rightArm changed state do
		(
 ZYDiagEvent "tool_begin" "LayersRetargeting_Rollout.chkbtn_rightArm"
 try
 (
 (
			try
			(
				biped.setLimbRetargetState g_ZYLB_BH.bHandR state
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LayersRetargeting_Rollout.chkbtn_rightArm"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_leftLeg changed state do
		(
 ZYDiagEvent "tool_begin" "LayersRetargeting_Rollout.chkbtn_leftLeg"
 try
 (
 (
			try
			(
				biped.setLimbRetargetState g_ZYLB_BH.bFootL state
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LayersRetargeting_Rollout.chkbtn_leftLeg"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_rightLeg changed state do
		(
 ZYDiagEvent "tool_begin" "LayersRetargeting_Rollout.chkbtn_rightLeg"
 try
 (
 (
			try
			(
				biped.setLimbRetargetState g_ZYLB_BH.bFootR state
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LayersRetargeting_Rollout.chkbtn_rightLeg"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
			
		on btn_update pressed do
		(
 ZYDiagEvent "tool_begin" "LayersRetargeting_Rollout.btn_update"
 try
 (
 (
			try
			(
				if rdobtns_base.state == 1 then
				(
					biped.retargetToBaseLayer ctrl chkbx_IKonly.state
				)
				else if rdobtns_ref.state == 1 then
				(
					local obj = biped.getRetargetRefBip ctrl
					if isValidNode obj then
					(
						biped.retargetToReferenceBiped ctrl chkbx_IKonly.state 
					)
				)
				redrawViews()
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "LayersRetargeting_Rollout.btn_update"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	) --// end rollout
	
	rollout Layers_Rollout "图层"
	(
		local a_layerNames = #()
		local a_layersActiveState = #()
		local ctrl = undefined
		local numLayers = 0
		local layerIndex = 1
		local retargetingUIoffset = [220,540]

		group ""
		(
			checkbox chkbx_active "当前" align:#left tooltip:"启用或停用当前 Biped 动画层。"
			checkbutton chkbtn_solo "独显" width:50 height:18 align:#left across:3 offset:[3,0] tooltip:"仅启用当前动画层，其余层停用。"
			button btn_allOn "全部启用" width:50 height:18 align:#center offset:[0,0] tooltip:"启用全部 Biped 动画层。"
			button btn_allOff "全部停用" width:50 height:18 align:#right offset:[-3,0] tooltip:"停用全部 Biped 动画层。"
			button btn_moveDown "切到下层" width:78 height:18 align:#left across:2 offset:[3,0] tooltip:"切换到编号更小的 Biped 动画层；不会调整图层顺序。"
			button btn_moveUp "切到上层" width:78 height:18 align:#right offset:[-3,0] tooltip:"切换到编号更大的 Biped 动画层；不会调整图层顺序。"
			edittext edtxt_index "" readonly:true across:3 align:#left width:25 offset:[0,2] tooltip:"当前 Biped 动画层编号，只读显示。"
			dropDownList ddl_layers "" width:110 align:#center offset:[3,0] tooltip:"切换当前 Biped 动画层；下方操作针对选中层。"
			button btn_refreshList "R" width:20 height:18 align:#right offset:[-2,0] tooltip:"与 Max 的 Biped 面板同步，刷新动画层列表。"
			edittext edtxt_LayerName "" fieldwidth:103 align:#left across:2 offset:[0,2] tooltip:"输入动画层名称，再点击重命名或添加。"
			button btn_renameLayer "重命名" width:50 height:18 align:#right offset:[-3,0] tooltip:"使用左侧输入的名称重命名当前 Biped 动画层。"
			button btn_addLayer "添加" width:50 height:18 align:#left across:3 offset:[3,0] tooltip:"创建新的 Biped 动画层。"
			button btn_deleteLayer "删除" width:50 height:18 align:#center tooltip:"删除当前 Biped 动画层及其动画；先确认层号和内容。"
			button btn_collapseLayers "合并" width:50 height:18 align:#right offset:[-3,0] tooltip:"将当前层合并到紧邻下层；当前层及以下各层必须启用。"
			button btn_snapSetKey "吸附并打帧" align:#center width:160 height:18 tooltip:"在当前层创建吸附帧，使当前姿势匹配基础层。"
			checkbutton chkbtn_retargeting "打开 IK 重定向…" align:#center width:160 height:18 tooltip:"打开 IK 重定向窗口，指定基础层或参考 Biped 与处理四肢。"
		)
			
		fn f_getDisplayNames =
		(
			local a_displayNames = deepCopy a_layerNames
			for i = 1 to a_displayNames.count-1 do
			(
				if (biped.getLayerActive ctrl i) then
				(
					a_displayNames[i+1] = a_layerNames[i+1]
				)
				else
				(
					a_displayNames[i+1] = "* " + a_layerNames[i+1]
				)	
			)
			
			a_displayNames
		)
		
		fn f_syncBipedPanel =
		(
			numLayers = biped.numLayers ctrl
			layerIndex = biped.getCurrentLayer ctrl
		)
		
		fn f_updateLayers =
		(
			if chkbtn_solo.state then
			(
				btn_addLayer.enabled = false
				btn_deleteLayer.enabled = false
				btn_collapseLayers.enabled = false
				btn_renameLayer.enabled = false
				btn_allOn.enabled = false
				btn_allOff.enabled = false
				btn_moveDown.enabled = false
				btn_moveUp.enabled = false
				ddl_layers.enabled = false
				btn_refreshList.enabled = false
			)
			else
			(
				btn_addLayer.enabled = true
				btn_deleteLayer.enabled = true
				btn_collapseLayers.enabled = true
				btn_renameLayer.enabled = true
				btn_allOn.enabled = true
				btn_allOff.enabled = true
				btn_moveUp.enabled = true
				btn_moveDown.enabled = true
				ddl_layers.enabled = true
				btn_refreshList.enabled = true
				chkbx_active.enabled = true
				chkbx_active.checked = true
				chkbtn_solo.enabled = true
			)
			
			if g_ZYLB_BH.f_isValidBiped() then
			(
				ctrl = g_ZYLB_BH.bRoot.controller
				a_layerNames = #(("# "+(biped.getLayerName ctrl 0)+" #"))
				numLayers = biped.numLayers ctrl
				if numLayers > 0 then
				(
					layerIndex = biped.getCurrentLayer ctrl
					edtxt_index.text = layerIndex as string
					for i = 1 to numLayers do
					(
						append a_layerNames (biped.getLayerName ctrl i)
					)
				)
				else
				(
					layerIndex = 0
					edtxt_index.text = "0"
					chkbx_active.enabled = false
				)

				if layerIndex > 0 then
				(
					chkbx_active.checked = (biped.getLayerActive ctrl layerIndex)
				)
				else
				(
					chkbx_active.enabled = false
				)
				
				ddl_layers.items = f_getDisplayNames()
				ddl_layers.selection = layerIndex + 1
			)
			else
			(
				g_ZYLB_BH.f_initBipedParts()
			)
			
			if layerIndex == numLayers then
			(
				btn_moveUp.enabled = false
			)
			if layerIndex == 0 then
			(
				btn_moveDown.enabled = false
			)
			if numLayers == 0 then
			(
				btn_deleteLayer.enabled = false
				btn_collapseLayers.enabled = false
			)
			else
			(
				if NOT chkbtn_solo.state then
				(
					btn_deleteLayer.enabled = true
					btn_collapseLayers.enabled = true
				)
			)
			redrawViews()
		)
		
		on Layers_Rollout open do
		(
			f_updateLayers()
		)
		
		on btn_renameLayer pressed do
		(
 ZYDiagEvent "tool_begin" "Layers_Rollout.btn_renameLayer"
 try
 (
 (
			try
			(
				undo "RenameLayer" on
				(
					local a_filtered = filterstring edtxt_layerName.text " "
					if a_filtered.count > 0 then
					(
						local index = biped.getCurrentLayer ctrl
						biped.setLayerName ctrl index edtxt_layerName.text
					)
					else
					(
						ZYDiagMessageBox "请先输入有效的动画层名称。" title:"Biped 助手"
						edtxt_layerName.text = ""
					)
				)
				f_updateLayers()
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Layers_Rollout.btn_renameLayer"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_addLayer pressed do
		(
 ZYDiagEvent "tool_begin" "Layers_Rollout.btn_addLayer"
 try
 (
 (
			try
			(
				undo "AddLayer" on
				(
					local index = (biped.getCurrentLayer ctrl) + 1
					biped.createLayer ctrl index ("Layer " + index as string)
				)
				f_updateLayers()
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Layers_Rollout.btn_addLayer"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_deleteLayer pressed do
		(
 ZYDiagEvent "tool_begin" "Layers_Rollout.btn_deleteLayer"
 try
 (
 (
			try
			(
				if layerIndex != 0 then
				(
					undo "DeleteLayer" on
					(
						try(biped.deleteLayer ctrl layerIndex)catch(f_updateLayers())
					)
				)
				f_updateLayers()
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Layers_Rollout.btn_deleteLayer"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_collapseLayers pressed do
		(
 ZYDiagEvent "tool_begin" "Layers_Rollout.btn_collapseLayers"
 try
 (
 (
			try
			(
				local index = (biped.getCurrentLayer ctrl) - 1
				if index != -1 then
				(
					undo "CollapseLayers" on
					(
						biped.collapseAtLayer ctrl index
					)
				)
				f_updateLayers()
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Layers_Rollout.btn_collapseLayers"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_snapSetKey pressed do
		(
 ZYDiagEvent "tool_begin" "Layers_Rollout.btn_snapSetKey"
 try
 (
 (
			try
			(
				f_syncBipedPanel()
				if $selection.count == 1 then
				(
					biped.setSnapKey selection[1]
				)
				else
				(
					ZYDiagMessageBox "请只选择一个 Biped 节点，再执行吸附并打帧。" title:"Biped 动画层"
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Layers_Rollout.btn_snapSetKey"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_retargeting changed state do
		(
 ZYDiagEvent "tool_begin" "Layers_Rollout.chkbtn_retargeting"
 try
 (
 (
			try
			(
				if state then
				(
					try(destroyDialog g_ZYLB_BH.LayersRetargeting_Rollout)catch()
					createDialog g_ZYLB_BH.LayersRetargeting_Rollout width:200 pos:(g_ZYLB_BH.BH_pos + g_ZYLB_BH.layersRetargetingUIoffset) style:#(#style_toolwindow, #style_sysmenu)
				)
				else
				(
					try(destroyDialog g_ZYLB_BH.LayersRetargeting_Rollout)catch()
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Layers_Rollout.chkbtn_retargeting"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_moveDown pressed do
		(
 ZYDiagEvent "tool_begin" "Layers_Rollout.btn_moveDown"
 try
 (
 (
			try
			(
				if g_ZYLB_BH.f_isValidBiped() then
				(
					f_syncBipedPanel()
					layerIndex = layerIndex - 1
					if layerIndex >= 0 then
					(
						biped.setCurrentLayer ctrl layerIndex
						btn_moveUp.enabled = true
						if layerIndex == 0 then
						(
							btn_moveDown.enabled = false
						)
					)
					else
					(
						layerIndex = 0
					)
				)	
				f_updateLayers()
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Layers_Rollout.btn_moveDown"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_moveUp pressed do
		(
 ZYDiagEvent "tool_begin" "Layers_Rollout.btn_moveUp"
 try
 (
 (
			try
			(
				if g_ZYLB_BH.f_isValidBiped() then
				(
					f_syncBipedPanel()
					layerIndex = layerIndex + 1
					if layerIndex <= numLayers then
					(
						biped.setCurrentLayer ctrl layerIndex
						btn_moveDown.enabled = true
						if layerIndex == numLayers then
						(
							btn_moveUp.enabled = false
						)
					)
					else
					(
						layerIndex = numLayers
						btn_moveUp.enabled = false
					)
				)
				f_updateLayers()
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Layers_Rollout.btn_moveUp"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_solo changed state do
		(
 ZYDiagEvent "tool_begin" "Layers_Rollout.chkbtn_solo"
 try
 (
 (
			try
			(
				f_syncBipedPanel()
				if state then
				(					
					for i = 1 to numLayers do
					(
						local activeState = biped.getLayerActive ctrl i
						if activeState then
						(
							append a_layersActiveState true
						)
						else
						(
							append a_layersActiveState false
						)
					)
					
					for i = 1 to numLayers do
					(
						biped.setLayerActive ctrl i false
					)
					biped.setLayerActive ctrl layerIndex true
				)
				else
				(
					for i = 1 to numLayers do
					(
						biped.setLayerActive ctrl i a_layersActiveState[i]
					)
					a_layersActiveState = #()
				)
				f_updateLayers()
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Layers_Rollout.chkbtn_solo"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_allOn pressed do
		(
 ZYDiagEvent "tool_begin" "Layers_Rollout.btn_allOn"
 try
 (
 (
			try
			(
				f_syncBipedPanel()
				for i = 1 to numLayers do
				(
					biped.setLayerActive ctrl i true
				)
				f_updateLayers()
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Layers_Rollout.btn_allOn"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_allOff pressed do
		(
 ZYDiagEvent "tool_begin" "Layers_Rollout.btn_allOff"
 try
 (
 (
			try
			(
				f_syncBipedPanel()
				for i = 1 to numLayers do
				(
					biped.setLayerActive ctrl i false
				)
				f_updateLayers()
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Layers_Rollout.btn_allOff"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbx_active changed state do
		(
 ZYDiagEvent "tool_begin" "Layers_Rollout.chkbx_active"
 try
 (
 (
			try
			(
				f_syncBipedPanel()
				if state then
				(
					biped.setLayerActive ctrl layerIndex true
				)
				else
				(
					biped.setLayerActive ctrl layerIndex false
				)
				f_updateLayers()
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Layers_Rollout.chkbx_active"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on ddl_layers selected val do
		(
 ZYDiagEvent "tool_begin" "Layers_Rollout.ddl_layers"
 try
 (
 (
			try
			(
				f_syncBipedPanel()
				local index = val - 1
				if index <= numLayers then
				(
					biped.setCurrentLayer ctrl index
				)
				f_updateLayers()
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Layers_Rollout.ddl_layers"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_refreshList pressed do
		(
 ZYDiagEvent "tool_begin" "Layers_Rollout.btn_refreshList"
 try
 (
 (
			try
			(
				f_updateLayers()
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "Layers_Rollout.btn_refreshList"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	) --// end rollout
	
	rollout PosePosture_Rollout "姿势 / 部分姿势"
	(
		local TCBmode = undefined
		
		group "粘贴选项"
		(
			checkbox chkbx_pasteOpposite "粘贴到对侧四肢" align:#left offset:[0,0] tooltip:"将复制的全身或局部姿势粘贴到对应的另一侧四肢。"
			label lbl_COM "根轨道：" align:#left offset:[0,3] across:5
			checkbutton chkbtn_horizontal "横" width:24 height:18 align:#left offset:[-5,0] checked:true tooltip:"粘贴复制姿势中的根节点水平位移。"
			checkbutton chkbtn_vertical "竖" width:24 height:18 align:#left offset:[-10,0] checked:true tooltip:"粘贴复制姿势中的根节点垂直位移。"
			checkbutton chkbtn_rotation "转" width:24 height:18 align:#left offset:[-15,0] checked:true tooltip:"粘贴复制姿势中的根节点朝向。"
			checkbox chkbx_velocity "保留根运动速度" align:#right offset:[7,2] tooltip:"按根节点之前的运动轨迹计算启用轨道的速度延续；没有可参考的历史轨迹时使用绝对值。"
			radiobuttons rdobtns_tcb "自动打帧的 TCB / IK 值：" labels:#("默认","复制值","插值") columns:3 align:#left tooltip:#("使用默认插值：Ease To/From 为 0，张力、连续性和偏置均为 25。","使用复制数据中的 TCB 与 IK 设置。","按粘贴位置的原动画插值计算 TCB 值。")
		)
		group "全身姿势"
		(
			button btn_copyPose "复制全身姿势" width:85 height:18 align:#left offset:[-5,0] across:2 tooltip:"复制当前帧全身姿势到本工具文件，之后用「粘贴全身姿势」调用。"
			button btn_pastePose "粘贴全身姿势" width:85 height:18 align:#right offset:[5,0] tooltip:"在当前帧粘贴已复制的全身姿势；按 Shift/Ctrl 按范围应用。"
		)
		group "局部姿势（所选部件）"
		(
			button btn_copyPosture "复制局部姿势" width:77 height:18 across:3 align:#left offset:[-3,0] tooltip:"复制当前所选 Biped 部件的局部姿势，保存供之后粘贴。"
			button btn_pastePosture "粘贴局部姿势" width:77 height:18 align:#left offset:[22,0] tooltip:"在当前帧向对应部件粘贴已保存的局部姿势；按 Shift/Ctrl 按范围应用。"
			button btn_selectPostureObjs "选" width:24 height:18 align:#right offset:[6,0] tooltip:"选中之前复制局部姿势时涉及的 Biped 部件。"
		)
		group "左右镜像姿势"
		(
			button btn_mirrorArmLeft "镜像左→右臂" width:85 height:18 across:2 offset:[-5,0] align:#left tooltip:"将左臂姿势镜像复制到右臂，包含手指。"
			button btn_mirrorArmRight "镜像右→左臂" width:85 height:18 offset:[5,0] align:#right tooltip:"将右臂姿势镜像复制到左臂，包含手指。"
			button btn_mirrorLegLeft "镜像左→右腿" width:85 height:18 offset:[-5,0] across:2 align:#left tooltip:"将左腿姿势镜像复制到右腿，包含脚趾。"
			button btn_mirrorLegRight "镜像右→左腿" width:85 height:18 offset:[5,0] align:#right tooltip:"将右腿姿势镜像复制到左腿，包含脚趾。"
		)
		group "手指对齐"
		(
			button btn_straightenFingers "伸直" width:85 height:18 align:#left offset:[-5,0] across:2 tooltip:"伸直所选手指末两节；按 Shift/Ctrl 伸直该手指全部关节。"
			button btn_selectAllFingers "选择手指" width:85 height:18 align:#right offset:[5,0] tooltip:"选择双手的全部 Biped 手指关节。"
		)
		group "脊柱对齐"
		(
			button btn_straightenSpine "伸直" width:85 height:18 across:2 offset:[-5,0] align:#left tooltip:"将脊柱各节伸直到默认朝向；会改变姿势。"
			button btn_untwistSpine "消除扭转" width:85 height:18 offset:[5,0] align:#right tooltip:"校正脊柱各节朝向，消除扭转。"
		)
		
		fn f_getTCBmode =
		(
			case rdobtns_tcb.state of
			(
				1: TCBmode = #pstdefault
				2: TCBmode = #pstcopied
				3: TCBmode = #pstinterp
			)
		)
		
		fn f_mirrorPosture a_bipObjs =
		(
			if isValidNode g_ZYLB_BH.bRoot then
			(
				f_getTCBmode()
				local bRootCtrl = g_ZYLB_BH.bRoot.controller
				biped.createCopyCollection bRootCtrl "MirrorTemp"
				local colIndex = biped.numCopyCollections bRootCtrl
				local copyCol = biped.getCopyCollection bRootCtrl colIndex
				biped.copyBipPosture bRootCtrl copyCol a_bipObjs #snapAuto
				local mirroreBH_pose = getCopy copyCol #posture 1
				with animate on
				(
					undo "MirrorPosture" on
					(
						biped.pasteBipPosture bRootCtrl mirroreBH_pose true TCBmode chkbtn_horizontal.checked chkbtn_vertical.checked chkbtn_rotation.checked chkbx_velocity.checked
						biped.pasteBipPosture bRootCtrl mirroreBH_pose true TCBmode chkbtn_horizontal.checked chkbtn_vertical.checked chkbtn_rotation.checked chkbx_velocity.checked
					)
				)
				biped.deleteCopyCollection bRootCtrl colIndex
			)
		)
		
		fn f_storePostureObjs a_objs = ZYRigPostureStore a_objs
		fn f_retrievePostureObjs = ZYRigPostureRead()
		on PosePosture_Rollout open do ()
		
		on btn_copyPose pressed do
		(
 ZYDiagEvent "tool_begin" "PosePosture_Rollout.btn_copyPose"
 try
 (
 (
			try
			(
				local bRootCtrl = g_ZYLB_BH.bRoot.controller
				biped.createCopyCollection bRootCtrl "PoseGrabber"
				local colIndex = biped.numCopyCollections bRootCtrl
				local copyCol = biped.getCopyCollection bRootCtrl colIndex
				biped.copyBipPose bRootCtrl copyCol #snapAuto
				biped.saveCopyPasteFile bRootCtrl g_ZYLB_BH.copiedPose
				biped.deleteCopyCollection bRootCtrl colIndex
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "PosePosture_Rollout.btn_copyPose"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_pastePose pressed do
		(
 ZYDiagEvent "tool_begin" "PosePosture_Rollout.btn_pastePose"
 try
 (
 (
			try
			(
				if doesFileExist g_ZYLB_BH.copiedPose then
				(
					f_getTCBmode()
					local bRootCtrl = g_ZYLB_BH.bRoot.controller
					biped.loadCopyPasteFile bRootCtrl g_ZYLB_BH.copiedPose
					local colIndex = biped.numCopyCollections bRootCtrl
					local copyCol = biped.getCopyCollection bRootCtrl colIndex
					local copyBH_pose = getCopy copyCol #pose 1
					with animate on
					(
						undo "PastePose" on
						(
							if keyboard.shiftPressed OR keyboard.controlPressed then
							(
								for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
								(
									slidertime = t
									biped.pasteBipPose bRootCtrl copyBH_pose chkbx_pasteOpposite.checked TCBmode chkbtn_horizontal.checked chkbtn_vertical.checked chkbtn_rotation.checked chkbx_velocity.checked
									biped.pasteBipPose bRootCtrl copyBH_pose chkbx_pasteOpposite.checked TCBmode chkbtn_horizontal.checked chkbtn_vertical.checked chkbtn_rotation.checked chkbx_velocity.checked
								)
							)
							else
							(
								biped.pasteBipPose bRootCtrl copyBH_pose chkbx_pasteOpposite.checked TCBmode chkbtn_horizontal.checked chkbtn_vertical.checked chkbtn_rotation.checked chkbx_velocity.checked
								biped.pasteBipPose bRootCtrl copyBH_pose chkbx_pasteOpposite.checked TCBmode chkbtn_horizontal.checked chkbtn_vertical.checked chkbtn_rotation.checked chkbx_velocity.checked
							)
						)
					)
					biped.deleteCopyCollection bRootCtrl colIndex
				)
				else
				(
					ZYDiagMessageBox "尚未保存姿势，请先复制姿势。" title:"Biped 助手"
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "PosePosture_Rollout.btn_pastePose"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_copyPosture pressed do
		(
 ZYDiagEvent "tool_begin" "PosePosture_Rollout.btn_copyPosture"
 try
 (
 (
			try
			(
				if selection.count > 0 then
				(
					local a_objs = selection as array
					--// Make sure only Biped parts are selected for copying by filtering out non-Biped parts
					a_objs = f_filterBipedParts a_objs
					if a_objs.count > 0 then
					(
						f_storePostureObjs a_objs
						if isValidNode g_ZYLB_BH.bRoot then
						(
							local bRootCtrl = g_ZYLB_BH.bRoot.controller
							biped.createCopyCollection bRootCtrl "CopyPosture"
							local colIndex = biped.numCopyCollections bRootCtrl
							local copyCol = biped.getCopyCollection bRootCtrl colIndex
							biped.copyBipPosture bRootCtrl copyCol a_objs #snapAuto
							biped.saveCopyPasteFile bRootCtrl g_ZYLB_BH.copiedPosture
							biped.deleteCopyCollection bRootCtrl colIndex
						)
					)
					else
					(
						ZYDiagMessageBox "没有选中 Biped 对象。" title:"Biped 助手"
					)
				)
				else
				(
					ZYDiagMessageBox "请先选择需要复制姿势的 Biped 部件。" title:"Biped 助手"
				)
			)catch(g_ZYLB_BH.f_initBipedParts())			
		)
 ZYDiagEvent "tool_end" "PosePosture_Rollout.btn_copyPosture"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_pastePosture pressed do
		(
 ZYDiagEvent "tool_begin" "PosePosture_Rollout.btn_pastePosture"
 try
 (
 (
			try
			(
				if doesFileExist g_ZYLB_BH.copiedPosture then
				(
					f_getTCBmode()
					local bRootCtrl = g_ZYLB_BH.bRoot.controller
					biped.loadCopyPasteFile bRootCtrl g_ZYLB_BH.copiedPosture
					local colIndex = biped.numCopyCollections bRootCtrl
					local copyCol = biped.getCopyCollection bRootCtrl colIndex
					local copyBH_posture = getCopy copyCol #posture 1
					if copyBH_posture != false then
					(
						with animate on
						(
							undo "PastePosture" on
							(
								if keyboard.shiftPressed OR keyboard.controlPressed then
								(
									for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
									(
										slidertime = t
										biped.pasteBipPosture bRootCtrl copyBH_posture chkbx_pasteOpposite.checked TCBmode chkbtn_horizontal.checked chkbtn_vertical.checked chkbtn_rotation.checked chkbx_velocity.checked
										biped.pasteBipPosture bRootCtrl copyBH_posture chkbx_pasteOpposite.checked TCBmode chkbtn_horizontal.checked chkbtn_vertical.checked chkbtn_rotation.checked chkbx_velocity.checked
									)
								)
								else
								(
									biped.pasteBipPosture bRootCtrl copyBH_posture chkbx_pasteOpposite.checked TCBmode chkbtn_horizontal.checked chkbtn_vertical.checked chkbtn_rotation.checked chkbx_velocity.checked
									biped.pasteBipPosture bRootCtrl copyBH_posture chkbx_pasteOpposite.checked TCBmode chkbtn_horizontal.checked chkbtn_vertical.checked chkbtn_rotation.checked chkbx_velocity.checked
								)
							)
						)
					)
					else
					(
						ZYDiagMessageBox "请确保局部姿势的复制集合中没有名为 CopyPosture 的集合。" title:"Biped 助手"
					)
					local colIndex = biped.numCopyCollections bRootCtrl
					biped.deleteCopyCollection bRootCtrl colIndex
				)
				else
				(
					ZYDiagMessageBox "尚未保存姿势，请先复制姿势。" title:"Biped 助手"
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "PosePosture_Rollout.btn_pastePosture"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectPostureObjs pressed do
		(
 ZYDiagEvent "tool_begin" "PosePosture_Rollout.btn_selectPostureObjs"
 try
 (
 (
			try
			(
				local a_objs = f_retrievePostureObjs()
				if a_objs != undefined then
				(
					try
					(
						select a_objs
					)catch(ZYDiagMessageBox "无法选中之前复制局部姿势时涉及的 Biped 部件。" title:"Biped 助手")
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "PosePosture_Rollout.btn_selectPostureObjs"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_mirrorArmLeft pressed do
		(
 ZYDiagEvent "tool_begin" "PosePosture_Rollout.btn_mirrorArmLeft"
 try
 (
 (
			try
			(
				f_mirrorPosture (join g_ZYLB_BH.a_armLeft g_ZYLB_BH.a_fingersLeft)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "PosePosture_Rollout.btn_mirrorArmLeft"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_mirrorArmRight pressed do
		(
 ZYDiagEvent "tool_begin" "PosePosture_Rollout.btn_mirrorArmRight"
 try
 (
 (
			try
			(
				f_mirrorPosture (join g_ZYLB_BH.a_armRight g_ZYLB_BH.a_fingersRight)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "PosePosture_Rollout.btn_mirrorArmRight"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_mirrorLegLeft pressed do
		(
 ZYDiagEvent "tool_begin" "PosePosture_Rollout.btn_mirrorLegLeft"
 try
 (
 (
			try
			(
				f_mirrorPosture (join g_ZYLB_BH.a_legLeft g_ZYLB_BH.a_toesLeft)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "PosePosture_Rollout.btn_mirrorLegLeft"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_mirrorLegRight pressed do
		(
 ZYDiagEvent "tool_begin" "PosePosture_Rollout.btn_mirrorLegRight"
 try
 (
 (
			try
			(
				f_mirrorPosture (join g_ZYLB_BH.a_legRight g_ZYLB_BH.a_toesRight)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "PosePosture_Rollout.btn_mirrorLegRight"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_straightenFingers pressed do
		(
 ZYDiagEvent "tool_begin" "PosePosture_Rollout.btn_straightenFingers"
 try
 (
 (
			try
			(
				with animate on
				(
					undo "StraightenFingers" on
					(
						if selection.count > 0 then
						(
							local a_selFingerParts = #()
							for obj in $selection where ((findItem g_ZYLB_BH.a_fingersLeft obj) != 0) OR ((findItem g_ZYLB_BH.a_fingersRight obj) != 0) do
							(
								append a_selFingerParts obj
							)
							local a_selFingers = #()
							for finger in a_selFingerParts do
							(
								local fingerRoot = g_ZYLB_BH.f_findFingerRoot finger
								if keyboard.shiftPressed OR keyboard.controlPressed then
								(
									append a_selFingers fingerRoot
								)
								g_ZYLB_BH.f_getBipedChildren fingerRoot a_nodes:a_selFingers
							)
							for obj in a_selFingers do
							(
								biped.setTransform g_ZYLB_BH.bRoot #rotation obj.parent.transform.rotation false limb:obj
								biped.setSelectedKey obj.controller
							)
						)
						else
						(
							ZYDiagMessageBox "请先选择需要伸直的 Biped 手指关节。" title:"Biped 助手"
						)
					)
				)
				redrawViews()
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "PosePosture_Rollout.btn_straightenFingers"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectAllFingers pressed do
		(
 ZYDiagEvent "tool_begin" "PosePosture_Rollout.btn_selectAllFingers"
 try
 (
 (
			try
			(
				clearSelection()
				select g_ZYLB_BH.a_fingersLeft
				selectmore g_ZYLB_BH.a_fingersRight
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "PosePosture_Rollout.btn_selectAllFingers"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_straightenSpine pressed do
		(
 ZYDiagEvent "tool_begin" "PosePosture_Rollout.btn_straightenSpine"
 try
 (
 (
			try
			(
				with animate on
				(
					biped.zeroAll g_ZYLB_BH.bSpine1
				)
				redrawViews()
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "PosePosture_Rollout.btn_straightenSpine"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_untwistSpine pressed do
		(
 ZYDiagEvent "tool_begin" "PosePosture_Rollout.btn_untwistSpine"
 try
 (
 (
			try
			(
				with animate on
				(
					biped.zeroTwist g_ZYLB_BH.bSpine1
				)
				redrawViews()
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "PosePosture_Rollout.btn_untwistSpine"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	) --// end rollout
		
	rollout AlignBake_Rollout "对齐与烘焙"
	(
		local bool_head = false, bool_root = true, bool_allLimbs = false, bool_both = false, bool_selLimbs = false, bool_nextSlideKey = false, bool_lastSlideKey = false
		local a_limbSel = #() --// Used by the selected limb toggles on the interface
		local propTargetObj = undefined
		
		group "Biped 运动对齐"
		(
			button btn_alignToOffset "偏移对齐" width:160 height:18 align:#center tooltip:"拾取目标，将 Biped 根运动的起点位置与朝向对齐到目标。"
			button btn_alignToMatch "匹配对齐" width:160 height:18 align:#center tooltip:"拾取目标，重算 Biped 根的全部关键帧，使其跟随目标运动。"
		)
		group "Biped 动画烘焙"
		(
			radiobuttons rbtns_head "" labels:#("头部（注视目标）") align:#left default:0 tooltip:#("按指定范围烘焙头部注视运动，随后解除注视目标引用；不删除目标节点。")
			radiobuttons rbtns_rootLimbsBoth labels:#("根节点", "全部四肢", "根与四肢") align:#left default:1 offsets:#([0,0],[2,0],[2,0]) tooltip:#("烘焙根节点跟随父级的运动，完成后解除根的父级链接；链接约束模式使用 Max 当前范围。", "根据四肢已有的对象绑定烘焙动画。", "同时烘焙根节点及全部四肢动画。")
			radiobuttons rbtns_selLimbs labels:#("指定四肢：") columns:1 align:#left default:0 tooltip:"指定要烘焙的左手、右手、左脚或右脚。"
			checkbutton chkbtn_leftHand "左手" width:60 height:18 offset:[10,0] across:2 align:#center enabled:false tooltip:"在滑动关键帧之间烘焙左手动画。"
			checkbutton chkbtn_rightHand "右手" width:60 height:18 offset:[-10,0] align:#center enabled:false tooltip:"在滑动关键帧之间烘焙右手动画。"
			checkbutton chkbtn_leftFoot "左脚" width:60 height:18 offset:[10,0] across:2 align:#center enabled:false tooltip:"在滑动关键帧之间烘焙左脚动画。"
			checkbutton chkbtn_rightFoot "右脚" width:60 height:18 offset:[-10,0] align:#center enabled:false tooltip:"在滑动关键帧之间烘焙右脚动画。"
			label lbl_note1 "选择一个肢体，从当前帧起：" align:#left
			label lbl_note2 "处理范围内的滑动关键帧" align:#left
			radiobuttons rbtns_nextSlideKey labels:#("烘焙到下一个滑动帧") columns:1 align:#left default:0 tooltip:"从当前帧向后找到的第一个关键帧开始；它及紧邻下一键均须为滑动帧，在两键之间补帧。"
			radiobuttons rbtns_lastSlideKey labels:#("烘焙到最后一个滑动帧") columns:1 align:#left default:0 tooltip:"从当前帧向后找到关键帧，再在连续滑动键之间补帧，到最后一个滑动键。"
			button btn_bakeAnimationKeys "烘焙动画关键帧" width:160 height:18 align:#center tooltip:"按上方所选模式烘焙动画；请先核对范围与目标。"
		)
		group "Biped 道具对齐"
		(
			label lbl_tgt "目标：" align:#left across:2 offset:[0,3]
			pickbutton pkbtn_propTarget "拾取目标对象" autoDisplay:true width:140 height:18 align:#right offset:[-3,0] tooltip:"拾取用于 Biped 道具对齐或烘焙的目标对象。"
			button btn_alignPropToTarget "对齐到目标" width:110 height:18 align:#left offset:[3,0] across:2 tooltip:"将所选 Biped 道具对齐到目标，并在当前帧打帧；启用烘焙选项后按范围处理。"
			checkbox chkbx_propBake "烘焙" align:#right offset:[-3,2] tooltip:"在指定时间范围内烘焙 Biped 道具对目标的对齐运动。"
		)
		
		fn f_isProp obj =
		(
			if obj == g_ZYLB_BH.bProp1 OR obj == g_ZYLB_BH.bProp2 OR obj == g_ZYLB_BH.bProp3 then
			(
				return true
			)
			false
		)
		
		on btn_alignToOffset pressed do
		(
 ZYDiagEvent "tool_begin" "AlignBake_Rollout.btn_alignToOffset"
 try
 (
 (
			try
			(
				setCommandPanelTaskMode #create
				local bipObj = g_ZYLB_BH.bRoot
				local pickedObj = pickObject message:"Pick a target object to align to..." rubberband:bipObj.center
				if pickedObj != undefined AND pickedObj != #escape then
				(
					select bipObj
					local pt1 = Point()
					local pt2 = Point()
					hide pt1
					hide pt2
					pt2.parent = pt1
					pt1.transform = bipObj.transform
					with animate on
					(
						for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
						(
							at time t (pt2.transform = bipObj.transform)
						)
					)
					pt1.transform = pickedObj.transform
					with animate on
					(
						local a_storedSpaces = g_ZYLB_BH.f_storeSpaces()
						for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
						(
							sliderTime = t
							local verticalIndex = getKeyIndex bipObj[3][1].controller slidertime
							local horizontalIndex = getKeyIndex bipObj[3][2].controller slidertime
							local turningIndex = getKeyIndex bipObj[3][3].controller slidertime
							if verticalIndex > 0 OR horizontalIndex > 0 OR turningIndex > 0 then
							(
								at time t
								(
									bipObj.transform = pt2.transform
									if verticalIndex == 0 then
									(
										selectKeys bipObj[3][1] t
										deleteKeys bipObj[3][1].keys #selection
									)
									if horizontalIndex == 0 then
									(
										selectKeys bipObj[3][2] t
										deleteKeys bipObj[3][2].keys #selection
									)
									if turningIndex == 0 then
									(
										selectKeys bipObj[3][3] t
										deleteKeys bipObj[3][3].keys #selection
									)								
								)
							)
						)
						g_ZYLB_BH.f_loadSpaces a_storedSpaces
					)
					delete pt1
					delete pt2
				)
				else
				(
					ZYDiagMessageBox "已取消拾取对象。" title:"Biped 起点偏移对齐"
				)
				clearSelection()
				setCommandPanelTaskMode #motion
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "AlignBake_Rollout.btn_alignToOffset"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_alignToMatch pressed do
		(
 ZYDiagEvent "tool_begin" "AlignBake_Rollout.btn_alignToMatch"
 try
 (
 (
			try
			(
				setCommandPanelTaskMode #create
				local bipObj = g_ZYLB_BH.bRoot
				local pickedObj = pickObject message:"Pick a target object to align to..." rubberband:bipObj.center
				if pickedObj != undefined AND pickedObj != #escape then
				(
					select bipObj
					with animate on
					(
						local a_storedSpaces = g_ZYLB_BH.f_storeSpaces()
						for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
						(
							sliderTime = t
							local verticalIndex = getKeyIndex bipObj[3][1].controller slidertime
							local horizontalIndex = getKeyIndex bipObj[3][2].controller slidertime
							local turningIndex = getKeyIndex bipObj[3][3].controller slidertime
							if verticalIndex > 0 OR horizontalIndex > 0 OR turningIndex > 0 then
							(
								at time t
								(
									bipObj.transform = pickedObj.transform
									if verticalIndex == 0 then
									(
										selectKeys bipObj[3][1] t
										deleteKeys bipObj[3][1].keys #selection
									)
									if horizontalIndex == 0 then
									(
										selectKeys bipObj[3][2] t
										deleteKeys bipObj[3][2].keys #selection
									)
									if turningIndex == 0 then
									(
										selectKeys bipObj[3][3] t
										deleteKeys bipObj[3][3].keys #selection
									)								
								)
							)
						)
						g_ZYLB_BH.f_loadSpaces a_storedSpaces
					)
				)
				else
				(
					ZYDiagMessageBox "已取消拾取对象。" title:"Biped 跟随目标对齐"
				)
				clearSelection()
				setCommandPanelTaskMode #motion
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "AlignBake_Rollout.btn_alignToMatch"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on rbtns_head changed state do
		(
 ZYDiagEvent "tool_begin" "AlignBake_Rollout.rbtns_head"
 try
 (
 (
			if state == 1 do
			(
				bool_head = true
				bool_root = false; bool_allLimbs = false; bool_both = false; rbtns_rootLimbsBoth.state = 0; rbtns_selLimbs.state = 0; bool_selLimbs = false; bool_nextSlideKey = false; rbtns_nextSlideKey.state = 0; rbtns_lastSlideKey.state = 0
				chkbtn_leftHand.enabled = false; chkbtn_rightHand.enabled = false; chkbtn_leftFoot.enabled = false; chkbtn_rightFoot.enabled = false
				chkbtn_leftHand.state = false; chkbtn_rightHand.state = false; chkbtn_leftFoot.state = false; chkbtn_rightFoot.state = false
				a_limbSel = #()
			)
		)
 ZYDiagEvent "tool_end" "AlignBake_Rollout.rbtns_head"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on rbtns_rootLimbsBoth changed state do
		(
 ZYDiagEvent "tool_begin" "AlignBake_Rollout.rbtns_rootLimbsBoth"
 try
 (
 (
			bool_head = false; rbtns_head.state = 0
			case rbtns_rootLimbsBoth.state of
			(
				1:(bool_root = true; bool_allLimbs = false; bool_both = false; bool_selLimbs = false; rbtns_selLimbs.state = 0; bool_nextSlideKey = false; rbtns_nextSlideKey.state = 0; rbtns_lastSlideKey.state = 0
					chkbtn_leftHand.enabled = false; chkbtn_rightHand.enabled = false; chkbtn_leftFoot.enabled = false; chkbtn_rightFoot.enabled = false
					chkbtn_leftHand.state = false; chkbtn_rightHand.state = false; chkbtn_leftFoot.state = false; chkbtn_rightFoot.state = false
					a_limbSel = #())
				2:(bool_root = false; bool_allLimbs = true; bool_both = false; bool_selLimbs = false; rbtns_selLimbs.state = 0; bool_nextSlideKey = false; rbtns_nextSlideKey.state = 0; rbtns_lastSlideKey.state = 0
					chkbtn_leftHand.enabled = false; chkbtn_rightHand.enabled = false; chkbtn_leftFoot.enabled = false; chkbtn_rightFoot.enabled = false
					chkbtn_leftHand.state = false; chkbtn_rightHand.state = false; chkbtn_leftFoot.state = false; chkbtn_rightFoot.state = false
					a_limbSel = #())
				3:(bool_root = false; bool_allLimbs = false; bool_both = true; bool_selLimbs = false; rbtns_selLimbs.state = 0; bool_nextSlideKey = false; rbtns_nextSlideKey.state = 0; rbtns_lastSlideKey.state = 0
					chkbtn_leftHand.enabled = false; chkbtn_rightHand.enabled = false; chkbtn_leftFoot.enabled = false; chkbtn_rightFoot.enabled = false
					chkbtn_leftHand.state = false; chkbtn_rightHand.state = false; chkbtn_leftFoot.state = false; chkbtn_rightFoot.state = false
					a_limbSel = #())
			)
		)
 ZYDiagEvent "tool_end" "AlignBake_Rollout.rbtns_rootLimbsBoth"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on rbtns_selLimbs changed state do
		(
 ZYDiagEvent "tool_begin" "AlignBake_Rollout.rbtns_selLimbs"
 try
 (
 (
			if state == 1 do
			(
				bool_head = false; rbtns_head.state = 0
				bool_root = false; bool_allLimbs = false; bool_both = false; rbtns_rootLimbsBoth.state = 0; bool_selLimbs = true; bool_nextSlideKey = false; rbtns_nextSlideKey.state = 0; rbtns_lastSlideKey.state = 0
				chkbtn_leftHand.enabled = true; chkbtn_rightHand.enabled = true; chkbtn_leftFoot.enabled = true; chkbtn_rightFoot.enabled = true
				chkbtn_leftHand.state = false; chkbtn_rightHand.state = false; chkbtn_leftFoot.state = false; chkbtn_rightFoot.state = false
				a_limbSel = #()
			)
		)
 ZYDiagEvent "tool_end" "AlignBake_Rollout.rbtns_selLimbs"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on rbtns_nextSlideKey changed state do
		(
 ZYDiagEvent "tool_begin" "AlignBake_Rollout.rbtns_nextSlideKey"
 try
 (
 (
			if state == 1 do
			(
				bool_head = false; rbtns_head.state = 0
				bool_root = false; bool_allLimbs = false; bool_both = false; rbtns_rootLimbsBoth.state = 0; bool_selLimbs = false; rbtns_selLimbs.state = 0; rbtns_lastSlideKey.state = 0; bool_nextSlideKey = true; bool_lastSlideKey = false
				chkbtn_leftHand.enabled = false; chkbtn_rightHand.enabled = false; chkbtn_leftFoot.enabled = false; chkbtn_rightFoot.enabled = false
				chkbtn_leftHand.state = false; chkbtn_rightHand.state = false; chkbtn_leftFoot.state = false; chkbtn_rightFoot.state = false
				a_limbSel = #()
			)
		)
 ZYDiagEvent "tool_end" "AlignBake_Rollout.rbtns_nextSlideKey"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on rbtns_lastSlideKey changed state do
		(
 ZYDiagEvent "tool_begin" "AlignBake_Rollout.rbtns_lastSlideKey"
 try
 (
 (
			if state == 1 do
			(
				bool_head = false; rbtns_head.state = 0
				bool_root = false; bool_allLimbs = false; bool_both = false; rbtns_rootLimbsBoth.state = 0; bool_selLimbs = false; rbtns_selLimbs.state = 0; rbtns_nextSlideKey.state = 0; bool_nextSlideKey = false; bool_lastSlideKey = true;
				chkbtn_leftHand.enabled = false; chkbtn_rightHand.enabled = false; chkbtn_leftFoot.enabled = false; chkbtn_rightFoot.enabled = false
				chkbtn_leftHand.state = false; chkbtn_rightHand.state = false; chkbtn_leftFoot.state = false; chkbtn_rightFoot.state = false
				a_limbSel = #()
			)
		)
 ZYDiagEvent "tool_end" "AlignBake_Rollout.rbtns_lastSlideKey"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_leftHand changed state do
		(
 ZYDiagEvent "tool_begin" "AlignBake_Rollout.chkbtn_leftHand"
 try
 (
 (
			if state == on do
			(
				append a_limbSel g_ZYLB_BH.bHandL
			)
			if state == off do
			(
				local item = findItem a_limbSel g_ZYLB_BH.bHandL
				if item != 0 do
				(
					deleteItem a_limbSel item
				)
			)
		)
 ZYDiagEvent "tool_end" "AlignBake_Rollout.chkbtn_leftHand"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on chkbtn_rightHand changed state do
		(
 ZYDiagEvent "tool_begin" "AlignBake_Rollout.chkbtn_rightHand"
 try
 (
 (
			if state == on do
			(
				append a_limbSel g_ZYLB_BH.bHandR
			)
			if state == off do
			(
				local item = findItem a_limbSel g_ZYLB_BH.bHandR
				if item != 0 do
				(
					deleteItem a_limbSel item
				)
			)
		)
 ZYDiagEvent "tool_end" "AlignBake_Rollout.chkbtn_rightHand"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on chkbtn_leftFoot changed state do
		(
 ZYDiagEvent "tool_begin" "AlignBake_Rollout.chkbtn_leftFoot"
 try
 (
 (
			if state == on do
			(
				append a_limbSel g_ZYLB_BH.bFootL
			)
			if state == off do
			(
				local item = findItem a_limbSel g_ZYLB_BH.bFootL
				if item != 0 do
				(
					deleteItem a_limbSel item
				)
			)
		)
 ZYDiagEvent "tool_end" "AlignBake_Rollout.chkbtn_leftFoot"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on chkbtn_rightFoot changed state do
		(
 ZYDiagEvent "tool_begin" "AlignBake_Rollout.chkbtn_rightFoot"
 try
 (
 (
			if state == on do
			(
				append a_limbSel g_ZYLB_BH.bFootR
			)
			if state == off do
			(
				local item = findItem a_limbSel g_ZYLB_BH.bFootR
				if item != 0 do
				(
					deleteItem a_limbSel item
				)
			)
		)
 ZYDiagEvent "tool_end" "AlignBake_Rollout.chkbtn_rightFoot"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on btn_bakeAnimationKeys pressed do
		(
 ZYDiagEvent "tool_begin" "AlignBake_Rollout.btn_bakeAnimationKeys"
 try
 (
 (
			try
			(
				undo "BakeAnimationKeys" on
				(
					if bool_head then
					(
						g_ZYLB_BH.f_bipedBakeHead()
					)
					
					if bool_root then
					(
						if isValidNode g_ZYLB_BH.bRoot.parent then
						(
							g_ZYLB_BH.f_bipedBakeRoot()
						)
					)
					
					if bool_allLimbs then
					(
						g_ZYLB_BH.f_bipedBakeSlidingKeys #(g_ZYLB_BH.bHandL, g_ZYLB_BH.bHandR, g_ZYLB_BH.bFootL, g_ZYLB_BH.bFootR)
					)
					
					if bool_both then
					(
						if isValidNode g_ZYLB_BH.bRoot.parent then
						(
							g_ZYLB_BH.a_storedSpaces = g_ZYLB_BH.f_storeSpaces()
							g_ZYLB_BH.f_bipedBakeRoot()
							g_ZYLB_BH.f_loadSpaces g_ZYLB_BH.a_storedSpaces
						)
						g_ZYLB_BH.f_bipedBakeSlidingKeys #(g_ZYLB_BH.bHandL, g_ZYLB_BH.bHandR, g_ZYLB_BH.bFootL, g_ZYLB_BH.bFootR)
					)
					
					if bool_selLimbs then
					(
						if a_limbSel.count != 0 then
						(
							g_ZYLB_BH.f_bipedBakeSlidingKeys a_limbSel
						)
						else
						(
							ZYDiagMessageBox "请先勾选需要处理的手或脚。"
						)
					)
					
					if bool_nextSlideKey then
					(
						if selection.count == 1 then
						(
							local obj = selection[1]
							if isValidNode obj then
							(
								local index = findItem g_ZYLB_BH.a_bipedLimbs obj
								if index != 0 then
								(
									g_ZYLB_BH.f_bipedBakeSlidingKeyNext()
								)
								else
								(
									ZYDiagMessageBox "请只选择一个 Biped 肢体；当前帧之后至少需要两个滑动关键帧。" title:"Biped 烘焙"
								)
							)
							else
							(
								ZYDiagMessageBox "所选对象无效。" title:"Biped 烘焙"
							)
						)
						else
						(
							ZYDiagMessageBox "请只选择一个 Biped 肢体；当前帧之后至少需要两个滑动关键帧。" title:"Biped 烘焙"
						)
					)
					
					if bool_lastSlideKey then
					(
						if selection.count == 1 then
						(
							local obj = selection[1]
							if isValidNode obj then
							(
								local index = findItem g_ZYLB_BH.a_bipedLimbs obj
								if index != 0 then
								(
									g_ZYLB_BH.f_bipedBakeSlidingKeyLast()
								)
								else
								(
									ZYDiagMessageBox "请只选择一个 Biped 肢体；当前帧之后至少需要两个滑动关键帧。" title:"Biped 烘焙"
								)
							)
							else
							(
								ZYDiagMessageBox "所选对象无效。" title:"Biped 烘焙"
							)
						)
						else
						(
							ZYDiagMessageBox "请只选择一个 Biped 肢体；当前帧之后至少需要两个滑动关键帧。" title:"Biped 烘焙"
						)
					)
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "AlignBake_Rollout.btn_bakeAnimationKeys"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on pkbtn_propTarget picked obj do
		(
 ZYDiagEvent "tool_begin" "AlignBake_Rollout.pkbtn_propTarget"
 try
 (
 (
			pkbtn_propTarget.object = propTargetObj = obj
		)
 ZYDiagEvent "tool_end" "AlignBake_Rollout.pkbtn_propTarget"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_alignPropToTarget pressed do
		(
 ZYDiagEvent "tool_begin" "AlignBake_Rollout.btn_alignPropToTarget"
 try
 (
 (
			if isValidNode propTargetObj then
			(
				if selection.count > 0 then
				(
					undo "AlignPropToTarget" on
					(
						for prop in $selection where (f_isProp prop) do
						(
							with animate on
							(
								if chkbx_propBake.checked then
								(
									for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
									(
										sliderTime = t
										prop.transform = propTargetObj.transform
									)
								)
								else
								(
									prop.transform = propTargetObj.transform
								)
							)
						)
					)
				)
				else
				(
					ZYDiagMessageBox "请先选择一个或多个 Biped 道具节点，再对齐到目标。" title:"Biped 烘焙"
				)
			)
			else
			(
				ZYDiagMessageBox "道具目标对象无效，请重新拾取。" title:"Biped 烘焙"
				pkbtn_propTarget.object = undefined
			)
			sliderTime = animationRange.start
		)
 ZYDiagEvent "tool_end" "AlignBake_Rollout.btn_alignPropToTarget"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	) --// end rollout

	rollout About_Rollout "关于"
	(		
		label lbl_author "原作者：Lorne Brooks"
		hyperLink myEmail "lbtools2k@gmail.com" across:2 align:#center offset:[30,10] color:(color 0 0 255) hovercolor:(color 0 0 190) visitedcolor:(color 190 0 0) align:#center address:"mailto:lbtools2k@gmail.com"
		button btn_guide "" align:#right offset:[-10,0] images:#(g_ZYLB_BH.imageGuide, undefined, 1, 1, 1, 1, 1, false) tooltip:"打开作者在线功能指南。"
		label lbl_version "原版 3.5 · 2024-06-18"
		
		on btn_guide pressed do
		(
 ZYDiagEvent "tool_begin" "About_Rollout.btn_guide"
 try
 (
 (
			shellLaunch "https://sites.google.com/view/lbtools-guide/home/biped-helper" ""
		)
 ZYDiagEvent "tool_end" "About_Rollout.btn_guide"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	) --// end rollout
	
	fn f_openBipedUI =
	(
		g_ZYLB_BH.BH_pos = g_ZYLB_BH.f_readIniPosition "Floater" g_ZYLB_BH.defaultPos
		g_ZYLB_BH.a_bips = #()
		g_ZYLB_BH.f_collectBipRoots()
		if g_ZYLB_BH.a_bips.count > 0 then
		(
			--// Floater definition
			try(closeRolloutFloater g_ZYLB_BH.bipedUI_Floater)catch()
			g_ZYLB_BH.bipedUI_Floater = newRolloutFloater "LB Biped 助手 3.5 · 本地 1.9.9" 220 730
			g_ZYLB_BH.bipedUI_Floater.pos = g_ZYLB_BH.BH_pos
			addRollout g_ZYLB_BH.SelectionDisplayTime_Rollout g_ZYLB_BH.bipedUI_Floater rolledup:false
			addRollout g_ZYLB_BH.Keys_Rollout g_ZYLB_BH.bipedUI_Floater rolledup:true
			addRollout g_ZYLB_BH.LimbSpaces_Rollout g_ZYLB_BH.bipedUI_Floater rolledup:true
			addRollout g_ZYLB_BH.PosePosture_Rollout g_ZYLB_BH.bipedUI_Floater rolledup:true
			addRollout g_ZYLB_BH.Reference_Rollout g_ZYLB_BH.bipedUI_Floater rolledup:true
			addRollout g_ZYLB_BH.Layers_Rollout g_ZYLB_BH.bipedUI_Floater rolledup:true
			addRollout g_ZYLB_BH.BipFiles_Rollout g_ZYLB_BH.bipedUI_Floater rolledup:true
			addRollout g_ZYLB_BH.AlignBake_Rollout g_ZYLB_BH.bipedUI_Floater rolledup:true
			addRollout g_ZYLB_BH.About_Rollout g_ZYLB_BH.bipedUI_Floater rolledup:true
		)
		else
		(
			ZYDiagMessageBox "场景中没有 Biped。请载入角色或创建 Biped 后重试。" title:"Biped 助手"
			setIniSetting g_ZYLB_BH.bhINIfile "BipedPanel" "CurrentBip" "1"
			try(closeRolloutFloater g_ZYLB_BH.bipedUI_Floater)catch()
		)
	)
	
	g_ZYLB_BH.f_openBipedUI()
),

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

fn f_bipedPickerUI =
(
	rollout BipedPicker_Rollout "LB Biped 选择器 3.5 · 本地 1.9.9"
	(
        button btn_ZYLanguage "中文 / EN" width:88 height:24 across:3 align:#left tooltip:"切换中英文并保留参数。"
        button btn_ZYGuide "使用指南" width:88 height:24 align:#center tooltip:"打开选择器操作指南和图标说明。"
        button btn_ZYMore "更多" width:88 height:24 align:#right tooltip:"完整助手、角色控制器绑定和日志。"
        on btn_ZYLanguage pressed do ZYLB_SwitchLanguage()
        on btn_ZYGuide pressed do shellLaunch (ZYBipedRoot+"Guide.html") ""
        on btn_ZYMore pressed do ZYBipedMore()

		local imagePickerKeys = ZYLB_IconDir + @"\LBTools_BipedHelper_Picker_Keys.png"
		local imagePickerKeysMask = ZYLB_IconDir + @"\LBTools_BipedHelper_Picker_Keys_Mask.png"
		local imagePickerLimbSpaces = ZYLB_IconDir + @"\LBTools_BipedHelper_Picker_LimbSpaces.png"
		local imagePickerLimbSpacesMask = ZYLB_IconDir + @"\LBTools_BipedHelper_Picker_LimbSpaces_Mask.png"
		local imagePickerDisplay = ZYLB_IconDir + @"\LBTools_BipedHelper_Picker_Display.png"
		local imagePickerDisplayMask = ZYLB_IconDir + @"\LBTools_BipedHelper_Picker_Display_Mask.png"
		local imagePickerATFC = ZYLB_IconDir + @"\LBTools_BipedHelper_Picker_AT_FC.png"
		local imagePickerATFCMask = ZYLB_IconDir + @"\LBTools_BipedHelper_Picker_AT_FC_Mask.png"
		local imagePickerATXYZ = ZYLB_IconDir + @"\LBTools_BipedHelper_Picker_AT_XYZ.png"
		local imagePickerATXYZMask = ZYLB_IconDir + @"\LBTools_BipedHelper_Picker_AT_XYZ_Mask.png"
		local imagePickerPoseBuffer = ZYLB_IconDir + @"\LBTools_BipedHelper_Picker_PoseBuffer.png"
		local imagePickerPoseBufferMask = ZYLB_IconDir + @"\LBTools_BipedHelper_Picker_PoseBuffer_Mask.png"
		local imagePickerGeometrySnapshot = ZYLB_IconDir + @"\LBTools_BipedHelper_Picker_GeometrySnapshot.png"
		local imagePickerGeometrySnapshotMask = ZYLB_IconDir + @"\LBTools_BipedHelper_Picker_GeometrySnapshot_Mask.png"
		local imagePickerTrajectoryHelpers = ZYLB_IconDir + @"\LBTools_BipedHelper_Picker_TrajectoryHelpers.png"
		local imagePickerTrajectoryHelpersMask = ZYLB_IconDir + @"\LBTools_BipedHelper_Picker_TrajectoryHelpers_Mask.png"
		
		button btn_guide "" images:#(g_ZYLB_BH.imageGuide, undefined, 1, 1, 1, 1, 1, false) align:#left width:24 height:24 offset:[0,0] across:6 tooltip:"打开作者在线功能指南。"
		label lbl_selectBiped "当前:" align:#left offset:[-10,3]
		dropDownList ddl_bips "" width:120 align:#left offset:[-10,0] tooltip:"选择当前 Biped 根。Shift 选择根；Ctrl 选择全身。节点名保持原样。"
		button btn_refreshUI "刷" width:22 height:20 align:#right offset:[45,0] tooltip:"重新搜索场景中的 Biped；换工程或改名后使用。"
		button btn_openBipedHelperUI "助" width:23 height:20 align:#right offset:[33,0] tooltip:"打开完整 Biped 助手。"
		button btn_resetMainPos "归" align:#right width:20 height:20 offset:[10,0] tooltip:"关闭助手并重置其窗口位置。"
		group ""
		(
			label lbl_info1 "加选: Shift/Ctrl" align:#left across:2
			label lbl_info2 "减选: Alt" align:#right
			
			button btn_selectClavicleL "" images:#((g_ZYLB_BH.f_buttonColor 30 12 g_ZYLB_BH.clr_blue),undefined,1,1,1,1,1,false) width:35 height:15 align:#left offset:[90,30] tooltip:"选择左锁骨。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectArmUpperL "" images:#((g_ZYLB_BH.f_buttonColor 12 26 g_ZYLB_BH.clr_blue),undefined,1,1,1,1,1,false) width:16 height:30 align:#left offset:[85,-2] tooltip:"选择左上臂。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectArmLowerL "" images:#((g_ZYLB_BH.f_buttonColor 12 26 g_ZYLB_BH.clr_blue),undefined,1,1,1,1,1,false) width:16 height:30 align:#left offset:[85,-2] tooltip:"选择左前臂。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectHandL "" images:#((g_ZYLB_BH.f_buttonColor 16 16 g_ZYLB_BH.clr_blue),undefined,1,1,1,1,1,false) width:20 height:20 align:#left offset:[83,-2] tooltip:"选择左手。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectFingersAllL "" images:#((g_ZYLB_BH.f_buttonColor 16 16 g_ZYLB_BH.clr_purple),undefined,1,1,1,1,1,false) width:20 height:20 align:#left offset:[83,-2] tooltip:"选择左全部手指。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			
			button btn_selectHead "" images:#((g_ZYLB_BH.f_buttonColor 30 34 g_ZYLB_BH.clr_orange),undefined,1,1,1,1,1,false) width:36 height:40 align:#center offset:[0,-182] tooltip:"选择头部。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			checkbutton btn_selectPonytailL "马尾1" width:35 height:18 align:#left offset:[80,-21] tooltip:"选择标准 Biped 马尾 1 的根节点；不是全部头发。自定义头发/飘带请用「+ 自定义按钮 → 管理绑定」配置选择组。"
			checkbutton btn_selectPonytailR "马尾2" width:35 height:18 align:#right offset:[-80,-25] tooltip:"选择标准 Biped 马尾 2 的根节点；不是全部头发。自定义头发/飘带请用「+ 自定义按钮 → 管理绑定」配置选择组。"
			button btn_selectNeck "" images:#((g_ZYLB_BH.f_buttonColor 13 17 g_ZYLB_BH.clr_cyan),undefined,1,1,1,1,1,false) width:18 height:22 align:#center offset:[0,-2] tooltip:"选择颈部。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"

			button btn_selectAllSpines "全部脊柱" images:#((g_ZYLB_BH.f_buttonColor 14 76 g_ZYLB_BH.clr_cyan),undefined,1,1,1,1,1,false) width:20 height:82 align:#center offset:[-18,0] tooltip:"选择全部脊柱。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectSpine4 "" images:#((g_ZYLB_BH.f_buttonColor 31 14 g_ZYLB_BH.clr_cyan),undefined,1,1,1,1,1,false) width:37 height:19 align:#center offset:[13,-87] tooltip:"选择脊柱 4。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectSpine3 "" images:#((g_ZYLB_BH.f_buttonColor 26 14 g_ZYLB_BH.clr_cyan),undefined,1,1,1,1,1,false) width:32 height:19 align:#center offset:[11,-3] tooltip:"选择脊柱 3。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectSpine2 "" images:#((g_ZYLB_BH.f_buttonColor 21 14 g_ZYLB_BH.clr_cyan),undefined,1,1,1,1,1,false) width:27 height:19 align:#center offset:[8,-3] tooltip:"选择脊柱 2。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectSpine1 "" images:#((g_ZYLB_BH.f_buttonColor 16 14 g_ZYLB_BH.clr_cyan),undefined,1,1,1,1,1,false) width:22 height:19 align:#center offset:[6,-3] tooltip:"选择脊柱 1。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			checkbutton chkbtn_bendLinks "BL" images:#(imagePickerDisplay, imagePickerDisplayMask, 12, 3, 9, 1, 1, false) width:26 height:20 align:#center offset:[0,0] tooltip:"切换脊柱、手指、尾部和马尾的弯曲链接模式。"
			button btn_selectPelvis "" images:#((g_ZYLB_BH.f_buttonColor 35 13 g_ZYLB_BH.clr_yellow),undefined,1,1,1,1,1,false) width:40 height:19 align:#center offset:[0,0] tooltip:"选择骨盆。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectCOM "" images:#((g_ZYLB_BH.f_buttonColor 51 13 g_ZYLB_BH.clr_lightblue),undefined,1,1,1,1,1,false) width:58 height:19 align:#center offset:[0,-3] tooltip:"选择根 COM。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"

			button btn_selectClavicleR "" images:#((g_ZYLB_BH.f_buttonColor 30 12 g_ZYLB_BH.clr_green),undefined,1,1,1,1,1,false) width:36 height:16 align:#right offset:[-90,-178] tooltip:"选择右锁骨。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectArmUpperR "" images:#((g_ZYLB_BH.f_buttonColor 12 26 g_ZYLB_BH.clr_green),undefined,1,1,1,1,1,false) width:17 height:31 align:#right offset:[-85,-3] tooltip:"选择右上臂。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectArmLowerR "" images:#((g_ZYLB_BH.f_buttonColor 12 26 g_ZYLB_BH.clr_green),undefined,1,1,1,1,1,false) width:17 height:31 align:#right offset:[-85,-3] tooltip:"选择右前臂。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectHandR "" images:#((g_ZYLB_BH.f_buttonColor 16 16 g_ZYLB_BH.clr_green),undefined,1,1,1,1,1,false) width:21 height:21 align:#right offset:[-83,-3] tooltip:"选择右手。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectFingersAllR "" images:#((g_ZYLB_BH.f_buttonColor 16 16 g_ZYLB_BH.clr_chartroose),undefined,1,1,1,1,1,false) width:21 height:21 align:#right offset:[-83,-3] tooltip:"选择右全部手指。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			
			button btn_selectLegUpperL "" images:#((g_ZYLB_BH.f_buttonColor 20 28 g_ZYLB_BH.clr_blue),undefined,1,1,1,1,1,false) width:24 height:32 align:#left offset:[100,43] tooltip:"选择左大腿。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectLegLowerL "" images:#((g_ZYLB_BH.f_buttonColor 14 28 g_ZYLB_BH.clr_blue),undefined,1,1,1,1,1,false) width:18 height:32 align:#left offset:[100,-2] tooltip:"选择左小腿。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectToeL "" images:#((g_ZYLB_BH.f_buttonColor 14 14 g_ZYLB_BH.clr_purple),undefined,1,1,1,1,1,false) width:18 height:18 align:#left offset:[60,-2] tooltip:"选择左脚趾。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectFootL "" images:#((g_ZYLB_BH.f_buttonColor 28 14 g_ZYLB_BH.clr_blue),undefined,1,1,1,1,1,false) width:32 height:18 align:#left offset:[80,-23] tooltip:"选择左脚。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			
			button btn_selectLegUpperR "" images:#((g_ZYLB_BH.f_buttonColor 20 28 g_ZYLB_BH.clr_green),undefined,1,1,1,1,1,false) width:25 height:33 align:#right offset:[-100,-94] tooltip:"选择右大腿。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectLegLowerR "" images:#((g_ZYLB_BH.f_buttonColor 14 28 g_ZYLB_BH.clr_green),undefined,1,1,1,1,1,false) width:19 height:33 align:#right offset:[-100,-3] tooltip:"选择右小腿。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectFootR "" images:#((g_ZYLB_BH.f_buttonColor 28 14 g_ZYLB_BH.clr_green),undefined,1,1,1,1,1,false) width:33 height:19 align:#right offset:[-80,-3] tooltip:"选择右脚。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectToeR "" images:#((g_ZYLB_BH.f_buttonColor 14 14 g_ZYLB_BH.clr_chartroose),undefined,1,1,1,1,1,false) width:19 height:19 align:#right offset:[-60,-24]  tooltip:"选择右脚趾。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			
			button btn_selectPinky3L "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_purple),undefined,1,1,1,1,1,false) width:12 height:16 align:#left offset:[0,-250] tooltip:"选择左小指 3。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectPinky2L "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_purple),undefined,1,1,1,1,1,false) width:12 height:16 align:#left offset:[0,0] tooltip:"选择左小指 2。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectPinky1L "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_purple),undefined,1,1,1,1,1,false) width:12 height:16 align:#left offset:[0,0] tooltip:"选择左小指 1。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectRing3L "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_purple),undefined,1,1,1,1,1,false) width:12 height:16 align:#left offset:[15,-70] tooltip:"选择左无名指 3。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectRing2L "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_purple),undefined,1,1,1,1,1,false) width:12 height:16 align:#left offset:[15,0] tooltip:"选择左无名指 2。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectRing1L "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_purple),undefined,1,1,1,1,1,false) width:12 height:16 align:#left offset:[15,0] tooltip:"选择左无名指 1。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectMiddle3L "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_purple),undefined,1,1,1,1,1,false) width:12 height:16 align:#left offset:[30,-70] tooltip:"选择左中指 3。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectMiddle2L "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_purple),undefined,1,1,1,1,1,false) width:12 height:16 align:#left offset:[30,0] tooltip:"选择左中指 2。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectMiddle1L "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_purple),undefined,1,1,1,1,1,false) width:12 height:16 align:#left offset:[30,0] tooltip:"选择左中指 1。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectIndex3L "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_purple),undefined,1,1,1,1,1,false) width:12 height:16 align:#left offset:[45,-50] tooltip:"选择左食指 3。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectIndex2L "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_purple),undefined,1,1,1,1,1,false) width:12 height:16 align:#left offset:[45,0] tooltip:"选择左食指 2。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectIndex1L "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_purple),undefined,1,1,1,1,1,false) width:12 height:16 align:#left offset:[45,0] tooltip:"选择左食指 1。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectThumb3L "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_red),undefined,1,1,1,1,1,false) width:12 height:16 align:#left offset:[60,-20] tooltip:"选择左拇指 3。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectThumb2L "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_red),undefined,1,1,1,1,1,false) width:12 height:16 align:#left offset:[60,-1] tooltip:"选择左拇指 2。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectThumb1L "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_red),undefined,1,1,1,1,1,false) width:12 height:16 align:#left offset:[60,-1] tooltip:"选择左拇指 1。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectFingersL "" images:#((g_ZYLB_BH.f_buttonColor 52 8 g_ZYLB_BH.clr_purple),undefined,1,1,1,1,1,false) width:56 height:12 align:#left offset:[0,-40] tooltip:"选择左四指。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectThumbL "" images:#((g_ZYLB_BH.f_buttonColor 8 34 g_ZYLB_BH.clr_red),undefined,1,1,1,1,1,false) width:12 height:40 align:#left offset:[45,0] tooltip:"选择左拇指。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectHandLrgL "" images:#((g_ZYLB_BH.f_buttonColor 36 36 g_ZYLB_BH.clr_blue),undefined,1,1,1,1,1,false) width:40 height:40 align:#left offset:[0,-45] tooltip:"选择左手。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			
			button btn_selectThumb3R "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_yellow),undefined,1,1,1,1,1,false) width:14 height:17 align:#right offset:[-60,-84] tooltip:"选择右拇指 3。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectThumb2R "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_yellow),undefined,1,1,1,1,1,false) width:14 height:17 align:#right offset:[-60,-2] tooltip:"选择右拇指 2。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectThumb1R "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_yellow),undefined,1,1,1,1,1,false) width:14 height:17 align:#right offset:[-60,-2] tooltip:"选择右拇指 1。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectIndex3R "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_chartroose),undefined,1,1,1,1,1,false) width:14 height:17 align:#right offset:[-45,-106] tooltip:"选择右食指 3。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectIndex2R "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_chartroose),undefined,1,1,1,1,1,false) width:14 height:17 align:#right offset:[-45,0] tooltip:"选择右食指 2。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectIndex1R "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_chartroose),undefined,1,1,1,1,1,false) width:14 height:17 align:#right offset:[-45,0] tooltip:"选择右食指 1。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectMiddle3R "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_chartroose),undefined,1,1,1,1,1,false) width:14 height:17 align:#right offset:[-30,-78] tooltip:"选择右中指 3。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectMiddle2R "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_chartroose),undefined,1,1,1,1,1,false) width:14 height:17 align:#right offset:[-30,0] tooltip:"选择右中指 2。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectMiddle1R "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_chartroose),undefined,1,1,1,1,1,false) width:14 height:17 align:#right offset:[-30,0] tooltip:"选择右中指 1。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectRing3R "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_chartroose),undefined,1,1,1,1,1,false) width:14 height:17 align:#right offset:[-15,-61] tooltip:"选择右无名指 3。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectRing2R "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_chartroose),undefined,1,1,1,1,1,false) width:14 height:17 align:#right offset:[-15,0] tooltip:"选择右无名指 2。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectRing1R "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_chartroose),undefined,1,1,1,1,1,false) width:14 height:17 align:#right offset:[-15,0] tooltip:"选择右无名指 1。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectPinky3R "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_chartroose),undefined,1,1,1,1,1,false) width:14 height:17 align:#right offset:[0,-60] tooltip:"选择右小指 3。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectPinky2R "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_chartroose),undefined,1,1,1,1,1,false) width:14 height:17 align:#right offset:[0,0] tooltip:"选择右小指 2。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectPinky1R "" images:#((g_ZYLB_BH.f_buttonColor 8 12 g_ZYLB_BH.clr_chartroose),undefined,1,1,1,1,1,false) width:14 height:17 align:#right offset:[0,0] tooltip:"选择右小指 1。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectFingersR "" images:#((g_ZYLB_BH.f_buttonColor 52 8 g_ZYLB_BH.clr_chartroose),undefined,1,1,1,1,1,false) width:57 height:14 align:#right offset:[0,0] tooltip:"选择右四指。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectThumbR "" images:#((g_ZYLB_BH.f_buttonColor 8 36 g_ZYLB_BH.clr_yellow),undefined,1,1,1,1,1,false) width:14 height:41 align:#right offset:[-45,-3] tooltip:"选择右拇指。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectHandLrgR "" images:#((g_ZYLB_BH.f_buttonColor 36 36 g_ZYLB_BH.clr_green),undefined,1,1,1,1,1,false) width:41 height:41 align:#right offset:[0,-45] tooltip:"选择右手。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"

			checkbutton chkbtn_pivotsLHand "左手轴心" width:55 height:18 align:#left offset:[0,2] tooltip:"打开左手 IK 轴心选择；须存在标准 Biped 左手。"
			checkbutton chkbtn_pivotsRHand "右手轴心" width:55 height:18 align:#right offset:[0,-24] tooltip:"打开右手 IK 轴心选择；须存在标准 Biped 右手。"
			
			checkbutton btn_LArm "左臂" width:55 height:18 align:#left offset:[10,10] tooltip:"选择左整臂与手指。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			checkbutton btn_LLeg "左腿" width:55 height:18 align:#left offset:[20,10] tooltip:"选择左整腿与脚趾。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			checkbutton btn_RArm "右臂" width:55 height:18 align:#right offset:[-10,-56] tooltip:"选择右整臂与手指。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			checkbutton btn_RLeg "右腿" width:55 height:18 align:#right offset:[-20,10] tooltip:"选择右整腿与脚趾。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			
			checkbutton chkbtn_pivotsLFoot "左脚轴心" width:55 height:18 align:#left offset:[0,12] tooltip:"打开左脚 IK 轴心选择；须存在标准 Biped 左脚。"
			checkbutton chkbtn_pivotsRFoot "右脚轴心" width:55 height:18 align:#right offset:[0,-24] tooltip:"打开右脚 IK 轴心选择；须存在标准 Biped 右脚。"

			checkbutton btn_tailBase "尾部" width:40 height:18 align:#center offset:[0,-22] tooltip:"选择尾根。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			
			checkbutton btn_selectProp1 "道1" width:24 height:18 align:#left offset:[0,0] tooltip:"选择标准 Biped 道具 1 节点（Prop1）。不存在时灰显；不会自动选择枪、刀或剑。自定义武器请用下方「+ 自定义按钮」配置控制骨骼。"
			checkbutton btn_selectProp2 "道2" width:24 height:18 align:#left offset:[26,-23] tooltip:"选择标准 Biped 道具 2 节点（Prop2）。不存在时灰显；不会自动选择枪、刀或剑。自定义武器请用下方「+ 自定义按钮」配置控制骨骼。"
			checkbutton btn_selectProp3 "道3" width:24 height:18 align:#left offset:[52,-23] tooltip:"选择标准 Biped 道具 3 节点（Prop3）。不存在时灰显；不会自动选择枪、刀或剑。自定义武器请用下方「+ 自定义按钮」配置控制骨骼。"
			checkbutton btn_selectHands "双手" width:60 height:18 align:#center offset:[-32,-23] tooltip:"选择双手。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			checkbutton btn_selectFeet "双脚" width:60 height:18 align:#center offset:[32,-23] tooltip:"选择双脚。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			checkbutton btn_selectAll "全身" width:70 height:18 align:#right offset:[0,-23] tooltip:"选择全身。当前 Biped 须有该部件。\nShift/Ctrl 加选；Alt 减选；左右按角色自身。"
			button btn_selectBipedParentGrow "+ 父级" width:50 height:18 across:5 align:#left tooltip:"所选 Biped 向上加选父级。"
			button btn_selectBipedParentNext "父级" width:50 height:18 align:#left offset:[-1,0] tooltip:"选择所选 Biped 的父级。"
			button btn_selectBipedChildren "子级" width:60 height:18 align:#center offset:[1,0] tooltip:"选择所选 Biped 的所有子级。"
			button btn_selectBipedChildNext "下级" width:50 height:18 align:#right offset:[4,0] tooltip:"选择所选 Biped 的下一个子级。"
			button btn_selectBipedChildGrow "下级 +" width:50 height:18 align:#right offset:[3,0] tooltip:"所选 Biped 向下加选子级。"

            checkbutton btn_ZYHair "头发" width:64 height:23 across:4 align:#left
            checkbutton btn_ZYRibbon "飘带" width:64 height:23 align:#left
            checkbutton btn_ZYWeapon1 "武器1" width:64 height:23 align:#left
            checkbutton btn_ZYWeapon2 "武器2" width:64 height:23 align:#right
            button btn_ZYExtra "+  自定义按钮" width:274 height:23 align:#left tooltip:"展开 / 收起自定义按钮窗；每页 12 组，拖动按钮排序，拖动标题栏移动窗口。"
            on btn_ZYExtra pressed do ZYSideToggle()
            label lbl_ZYSelection "选择控制骨骼；悬停查看绑定状态。" width:274 height:24 align:#left
            checkbutton chkbtn_collapsePickerTools "展开动画工具" width:268 height:22 align:#center offset:[0,2] tooltip:"展开或收起关键帧、IK、变换和参考工具。"

		)
		group ""
		(
			radiobuttons rdobtns_timeRange labels:#("时间轴", "自定") default:1 columns:2 align:#left offset:[0,0] offsets:#([0,0],[3,0]) across:4 tooltip:#("整段时间轴范围：读取 Max 动画开始 / 结束帧。不是只处理当前帧。","自定整段范围：填写始 / 末 / 步。补帧需右键选择按范围，或 Shift/Ctrl 点击。")
			spinner spn_TRstartTime "始" range:[0,99999, g_ZYLB_BH.TRstart] type:#integer fieldwidth:32 enabled:false align:#right offset:[20,1]  tooltip:"范围开始帧；用于批量补帧、删帧与烘焙。"
			spinner spn_TRendTime "末" range:[1,99999, g_ZYLB_BH.TRend] type:#integer fieldwidth:32 align:#right enabled:false offset:[15,1] tooltip:"范围结束帧；用于批量补帧、删帧与烘焙。"
			spinner spn_TRstepSize "步" range:[1,99, g_ZYLB_BH.TRstep] type:#integer fieldwidth:20 align:#right offset:[0,1] tooltip:"批量处理的帧间隔；1 表示逐帧。"
			button btn_setTRstart "" width:55 height:10 align:#center offset:[60,-3] across:2 enabled:false tooltip:"将开始值设为当前帧；Shift 跳到该值。"
			button btn_setTRend "" width:55 height:10 align:#center offset:[-14,-3] enabled:false tooltip:"将结束值设为当前帧；Shift 跳到该值。"
			
			label lbl_ZYKeyStatus "补帧：单击当前帧 · Shift/Ctrl 范围 · 右键" width:274 height:16 align:#left tooltip:"右键全身补帧或所选补帧，可明确选择当前帧或按范围。结果显示在这里。"
			label lbl_key "打帧:" align:#left offset:[0,3] across:9
			button btn_keyAllParts "KA" images:#(imagePickerKeys, imagePickerKeysMask, 14, 1, 8, 1, 1, false) width:26 height:20 align:#left offset:[-5,0] tooltip:"给当前 Biped 各主要轨道的已有值补帧。单击仅当前帧；Shift/Ctrl 按范围；右键选择模式。\n不会提交刚改的新姿势；改姿势请开 Auto Key 或用运动面板 Set Key。"
			button btn_keySelectedParts "KS" images:#(imagePickerKeys, imagePickerKeysMask, 14, 2, 9, 2, 2, false) width:26 height:20 align:#left offset:[-5,0] tooltip:"给所选 Biped 轨道的已有值补帧。单击仅当前帧；Shift/Ctrl 按范围；右键选择模式。\n不会提交刚改的新姿势；改姿势请开 Auto Key 或用运动面板 Set Key。"
			button btn_deleteAllKeys "DA" images:#(imagePickerKeys, imagePickerKeysMask, 14, 3, 10, 3, 3, false) width:26 height:20 align:#left offset:[-5,0] tooltip:"清空当前 Biped 所有动画关键帧；会要求确认。"
			button btn_deleteFrameKeys "DF" images:#(imagePickerKeys, imagePickerKeysMask, 14, 4, 11, 4, 4, false) width:26 height:20 align:#left offset:[-5,0] tooltip:"删除所选 Biped 当前帧的 key；Shift/Ctrl 对全身生效。"
			button btn_deleteRangeKeys "DR" images:#(imagePickerKeys, imagePickerKeysMask, 14, 5, 12, 5, 5, false) width:26 height:20 align:#left offset:[-5,0] tooltip:"删除所选 Biped 范围内的 key；Shift/Ctrl 对全身生效。"
			button btn_deleteBetweenKeys "DB" images:#(imagePickerKeys, imagePickerKeysMask, 14, 6, 13, 6, 6, false) width:26 height:20 align:#left offset:[-5,0] tooltip:"按间隔保留 key 并删除中间帧；Shift/Ctrl 对全身生效。"
			spinner spn_keepStep "" type:#integer range:[2,100,2] fieldwidth:26 align:#left offset:[-8,3] tooltip:"间隔删帧时每 N 帧保留一个 key。"
			button btn_applyIncrement "AI" images:#(imagePickerKeys, imagePickerKeysMask, 14, 7, 14, 7, 7, false) width:26 height:20 align:#right offset:[0,0] tooltip:"将最近一次变换增量应用到所选 Biped 的选中 key。"
			
			label lbl_ik "IK:" align:#left offset:[0,3] across:9
			button btn_limbPlanted "LP" images:#(imagePickerLimbSpaces, imagePickerLimbSpacesMask, 6, 1, 4, 1, 1, false) width:26 height:20 align:#left offset:[-12,0] tooltip:"为所选 Biped 四肢设置固定 IK key；用于手脚保持接触点。"
			button btn_limbSliding "LS" images:#(imagePickerLimbSpaces, imagePickerLimbSpacesMask, 6, 2, 5, 1, 1, false) width:26 height:20 align:#left offset:[-12,0] tooltip:"为所选 Biped 四肢设置滑动 IK key；允许接触点滑动。"
			button btn_limbFree "LF" images:#(imagePickerLimbSpaces, imagePickerLimbSpacesMask, 6, 3, 6, 1, 1, false) width:26 height:20 align:#left offset:[-12,0] tooltip:"为所选 Biped 四肢设置自由 key；用于离地或解除固定。"
			
			label lbl_display "显示:" align:#right offset:[0,3]
			checkbutton chkbtn_trajectories "Traj" images:#(imagePickerDisplay, imagePickerDisplayMask, 12, 1, 7, 1, 1, false) width:26 height:20 align:#right offset:[0,0] tooltip:"切换所选 Biped 的 Max 原生轨迹显示。"
			button btn_boxMode "BM" images:#(imagePickerDisplay, imagePickerDisplayMask, 12, 6, 12, 1, 1, false) width:26 height:20 align:#right offset:[0,0] tooltip:"全部 Biped 改为方块显示；Shift 恢复正常显示。"
			button btn_hideBiped "HB" images:#(imagePickerDisplay, imagePickerDisplayMask, 12, 4, 10, 1, 1, false) width:26 height:20 align:#right offset:[0,0] tooltip:"隐藏当前 Biped 的全部部件。"
			button btn_unhideBiped "UB" images:#(imagePickerDisplay, imagePickerDisplayMask, 12, 5, 11, 1, 1, false) width:26 height:20 align:#right offset:[0,0] tooltip:"显示当前 Biped；末端、扭转与脚步节点仍不显示。"
			
			label lbl_applyTransform "变换:" align:#left offset:[0,3] across:11
			button btn_copyTM "C" images:#(imagePickerATFC, imagePickerATFCMask, 17, 4, 12, 17, 17, false) width:26 height:20 align:#left offset:[-6,0] tooltip:"复制一个所选对象的世界位置与旋转。"
			button btn_copiedTM "" images:#((g_ZYLB_BH.f_buttonColor 12 18 g_ZYLB_BH.clr_darkgrey),undefined,1,1,1,1,1,false) enabled:false width:12 height:18 align:#left offset:[0,1] tooltip:"橙色表示已经复制了变换。"
			label lbl_pos "位:" align:#left offset:[-6,3]
			checkbutton chkbtn_posX "X" images:#(imagePickerATFC, imagePickerATFCMask, 17, 1, 9, 17, 17, false) width:26 height:20 align:#left offset:[-18,0] checked:false tooltip:"粘贴或烘焙时应用世界 X 位置。"
			checkbutton chkbtn_posY "Y" images:#(imagePickerATFC, imagePickerATFCMask, 17, 2, 10, 17, 17, false) width:26 height:20 align:#left offset:[-14,0] checked:false tooltip:"粘贴或烘焙时应用世界 Y 位置。"
			checkbutton chkbtn_posZ "Z" images:#(imagePickerATFC, imagePickerATFCMask, 17, 3, 11, 17, 17, false) width:26 height:20 align:#left offset:[-10,0] checked:false tooltip:"粘贴或烘焙时应用世界 Z 位置。"
			label lbl_rot "转:" align:#left offset:[-4,3]
			checkbutton chkbtn_rotXYZ "XYZ" images:#(imagePickerATXYZ, imagePickerATXYZMask, 2, 1, 2, 1, 1, false) width:34 height:20 align:#left offset:[-16,0] checked:false tooltip:"粘贴或烘焙时应用全部旋转轴。"
			button btn_pasteTM "P" images:#(imagePickerATFC, imagePickerATFCMask, 17, 5, 13, 17, 17, false) width:26 height:20 align:#right offset:[0,0] enabled:false tooltip:"向所选对象粘贴已复制的世界变换；先复制并选择轴。"
			button btn_bakeTM "B" images:#(imagePickerATFC, imagePickerATFCMask, 17, 6, 14, 17, 17, false) width:26 height:20  align:#right offset:[6,0] enabled:false tooltip:"将已复制的世界变换按开始、结束与步长烘焙到所选对象。"

			label lbl_footCleanup "脚部:" align:#left offset:[0,3] across:2
			radiobuttons rdobtns_applyTo labels:#("当前帧","逐帧","全部键","选中键") align:#left offset:[-5,2] offsets:#([-110,0],[-80,0],[-60,0],[-28,0]) columns:4 tooltip:#("只处理当前帧","按指定范围逐帧处理","只处理范围内已有 key","只处理范围内选中 key")
			radiobuttons rdobtns_PRY labels:#("俯仰","侧倾","朝向") align:#left offset:[22,2] offsets:#([0,0],[11,0],[12,0]) columns:3 across:4 tooltip:#("校正脚部俯仰，使脚底平行世界 XY 平面","校正脚部侧倾，使脚底平行世界 XY 平面","以当前帧朝向为基准校正")
			button btn_orientFoot "O" images:#(imagePickerATFC, imagePickerATFCMask, 17, 7, 15, 17, 17, false) width:26 height:20 align:#right offset:[84,0] tooltip:"选择 Biped 脚，按俯仰/侧倾/朝向校正。俯仰和侧倾对齐世界 XY 平面；朝向以当前帧为准。"
			button btn_snapToFloor "贴" images:#(imagePickerATFC, imagePickerATFCMask, 17, 8, 16, 17, 17, false) width:26 height:20 align:#right offset:[46,0] tooltip:"将所选 Biped 脚的底面移动到地平面。"
			checkbox chkbx_onlySnapBelow "F" checked:true align:#right offset:[12,3] tooltip:"只在脚底低于地平面时执行贴地。"
			
			label lbl_referenceTools "残影 · 姿势缓存 · 快照 · 轨迹" align:#left
			
			checkbutton chkbtn_ghosting "残影" images:#(imagePickerDisplay, imagePickerDisplayMask, 12, 2, 8, 1, 1, false) width:26 height:20 align:#left offset:[0,0] across:6 tooltip:"切换所选 Biped 的残影显示。"
			radiobuttons rdobtns_ghostType "" labels:#("<",">","<>") columns:3 align:#left offset:[-16,1] offsets:#([0,0],[-4,0],[-7,0]) tooltip:#("只显示之前","只显示之后","同时显示前后")
			spinner spn_ghostTotalFrames "T" range:[1,100,3] fieldwidth:26 type:#integer align:#right offset:[40,1] tooltip:"残影显示的帧数。"
			spinner spn_ghostNthFrame "N" range:[1,100,1] type:#integer fieldwidth:26 align:#right offset:[43,1] tooltip:"每 N 帧显示一份残影。"
			checkbox chkbx_ghostWireframe "W" align:#right offset:[33,2] checked:true tooltip:"将残影以线框显示。"
			checkbox chkbx_ghostFrameNumbers "F" align:#right offset:[14,2] tooltip:"显示残影帧号。"
			
			checkbutton chkbtn_visiblePB "TPB" images:#(imagePickerPoseBuffer, imagePickerPoseBufferMask, 9, 1, 2, 3, 3, false) width:26 height:20 align:#left enabled:false across:7 tooltip:"切换已有姿势缓存网格的显示。"
			button btn_snapPB "PB" images:#(imagePickerPoseBuffer, imagePickerPoseBufferMask, 9, 4, 7, 3, 3, false) width:26 height:20 align:#left offset:[-8,0] tooltip:"在当前帧为当前 Biped 创建姿势缓存；需要蒙皮网格。"
			button btn_swapPB "SPB" images:#(imagePickerPoseBuffer, imagePickerPoseBufferMask, 9, 5, 8, 3, 3, false) width:26 height:20 align:#left offset:[-18,0] enabled:false across:2 tooltip:"当前姿势与已有缓存互换，并留下新的缓存网格。"
			checkbox chkbx_keySwapPB "打帧" align:#left offset:[-28,3] checked:true tooltip:"互换缓存姿势时在当前帧打帧；即使 Auto Key 关闭也会打帧。"			
			button btn_removePB "RPB" images:#(imagePickerPoseBuffer, imagePickerPoseBufferMask, 9, 6, 9, 3, 3, false) width:26 height:20 align:#left offset:[-22,0] enabled:false tooltip:"移除已有姿势缓存网格。"
			spinner spn_PBopacity "不透明度:" range:[0,100,g_ZYLB_BH.defaultPBopacity] type:#integer fieldwidth:30 align:#right offset:[15,2] tooltip:"调整姿势缓存网格不透明度。" across:2
			button btn_defaultPBopacity "<" width:20 height:18 align:#right offset:[0,0] tooltip:"恢复缓存的默认不透明度。"		
		
			checkbutton chkbtn_visibleSnapshots "快照显示" images:#(imagePickerGeometrySnapshot, imagePickerGeometrySnapshotMask, 7, 1, 2, 3, 3, false) enabled:false width:26 height:20 align:#left offset:[0,0] across:6 tooltip:"切换已有快照图层的显示。"
			edittext edtxt_snapshotSceneLayer "" width:74 align:#left offset:[-18,2] tooltip:"输入待生成快照的蒙皮网格图层名；须与场景原名一致。"
			button btn_snapshotGeometry "当前帧快照" images:#(imagePickerGeometrySnapshot, imagePickerGeometrySnapshotMask, 7, 4, 5, 3, 3, false) width:26 height:20 align:#left offset:[15,0] tooltip:"为指定图层中的蒙皮网格生成当前帧合并快照。"
			button btn_deleteSnapshots "删除快照" images:#(imagePickerGeometrySnapshot, imagePickerGeometrySnapshotMask, 7, 6, 7, 3, 3, false) enabled:false width:26 height:20 align:#right offset:[-20,0] tooltip:"删除快照图层及其中全部快照。"
			spinner spn_snapshotOpacity "不透明度:" range:[0,100,g_ZYLB_BH.defaultSnapshotsOpacity] type:#integer fieldwidth:30 align:#right offset:[24,1] tooltip:"调整已有快照的不透明度。"
			button btn_defaultSnapshotOpacity "<" width:20 height:18 align:#right offset:[3,0] tooltip:"恢复快照默认不透明度。"
		
			checkbutton chkbtn_visibleTrajHelpers "显示" images:#(imagePickerTrajectoryHelpers, imagePickerTrajectoryHelpersMask, 7, 1, 2, 3, 3, false) width:26 height:20 align:#left offset:[0,0] enabled:false across:6 tooltip:"切换已有 Biped 轨迹辅助对象的显示。"
			checkbutton chkbtn_addTrajHelper "添加轨迹辅助" images:#(imagePickerTrajectoryHelpers, imagePickerTrajectoryHelpersMask, 7, 4, 6, 3, 3, false) width:26 height:20 offset:[-15,0] align:#left tooltip:"点击后在 Biped 表面拾取位置，添加原生轨迹辅助对象。"
			button btn_deleteTrajHelpers "删除" images:#(imagePickerTrajectoryHelpers, imagePickerTrajectoryHelpersMask, 7, 5, 7, 3, 3, false) width:26 height:20 align:#left offset:[-30,0] enabled:false tooltip:"删除全部 Biped 轨迹辅助对象及其图层。"
			spinner spn_limitStart "始" range:[0,1000000,animationRange.start] fieldwidth:50 type:#integer align:#right offset:[-16,3] enabled:false tooltip:"原生轨迹裁剪的开始帧。"
			spinner spn_limitEnd "末" range:[0,1000000,animationRange.end] fieldwidth:50 type:#integer align:#right offset:[17,3] enabled:false tooltip:"原生轨迹裁剪的结束帧。"
			checkbox chkbx_limitTrajDisplay "T" width:26 height:18 align:#right offset:[2,2] checked:false tooltip:"按开始与结束值裁剪原生轨迹显示。"
		)
		
		fn f_evaluateAxesToggles =
		(
			g_ZYLB_BH.a_ATtoggles[1] = chkbtn_posX.state
			g_ZYLB_BH.a_ATtoggles[2] = chkbtn_posY.state
			g_ZYLB_BH.a_ATtoggles[3] = chkbtn_posZ.state
			g_ZYLB_BH.a_ATtoggles[4] = chkbtn_rotXYZ.state
		)
		
		fn f_setAxisToggles =
		(
			chkbtn_posX.state = g_ZYLB_BH.a_ATtoggles[1]
			chkbtn_posY.state = g_ZYLB_BH.a_ATtoggles[2]
			chkbtn_posZ.state = g_ZYLB_BH.a_ATtoggles[3]
			chkbtn_rotXYZ.state = g_ZYLB_BH.a_ATtoggles[4]
		)
		
		fn f_closePivotDialogs =
		(
			if chkbtn_pivotsLHand.state then try(destroyDialog g_ZYLB_BH.leftHandPivots_Rollout)catch()
			if chkbtn_pivotsRHand.state then try(destroyDialog g_ZYLB_BH.rightHandPivots_Rollout)catch()
			if chkbtn_pivotsLFoot.state then try(destroyDialog g_ZYLB_BH.leftFootPivots_Rollout)catch()
			if chkbtn_pivotsRFoot.state then try(destroyDialog g_ZYLB_BH.rightFootPivots_Rollout)catch()
		)
		
        imgTag hit_ZYHair "" pos:[0,0] width:64 height:23 opacity:0.0
        on hit_ZYHair lbuttondown p flags do ZYGroupDown 1 quick:true
 on hit_ZYHair lbuttonup p flags do ZYDragReleased=true
        on hit_ZYHair lbuttondblclk p flags do ZYGroupDown 1 quick:true

        on hit_ZYHair rbuttonup p flags do ZYGroupRight 1 quick:true
        on btn_ZYHair changed state do ZYMapSelect "Hair"
        imgTag hit_ZYRibbon "" pos:[0,0] width:64 height:23 opacity:0.0
        on hit_ZYRibbon lbuttondown p flags do ZYGroupDown 2 quick:true
 on hit_ZYRibbon lbuttonup p flags do ZYDragReleased=true
        on hit_ZYRibbon lbuttondblclk p flags do ZYGroupDown 2 quick:true

        on hit_ZYRibbon rbuttonup p flags do ZYGroupRight 2 quick:true
        on btn_ZYRibbon changed state do ZYMapSelect "Ribbon"
        imgTag hit_ZYWeapon1 "" pos:[0,0] width:64 height:23 opacity:0.0
        on hit_ZYWeapon1 lbuttondown p flags do ZYGroupDown 3 quick:true
 on hit_ZYWeapon1 lbuttonup p flags do ZYDragReleased=true
        on hit_ZYWeapon1 lbuttondblclk p flags do ZYGroupDown 3 quick:true

        on hit_ZYWeapon1 rbuttonup p flags do ZYGroupRight 3 quick:true
        on btn_ZYWeapon1 changed state do ZYMapSelect "Weapon1"
        imgTag hit_ZYWeapon2 "" pos:[0,0] width:64 height:23 opacity:0.0
        on hit_ZYWeapon2 lbuttondown p flags do ZYGroupDown 4 quick:true
 on hit_ZYWeapon2 lbuttonup p flags do ZYDragReleased=true
        on hit_ZYWeapon2 lbuttondblclk p flags do ZYGroupDown 4 quick:true

        on hit_ZYWeapon2 rbuttonup p flags do ZYGroupRight 4 quick:true
        on btn_ZYWeapon2 changed state do ZYMapSelect "Weapon2"
        -- Native events isolate ESC cancellation from .NET delegates. Both timers are idle by default.
        imgTag hit_ZYBuiltin "" pos:[-10,-10] width:1 height:1
        timer ZYDragPulse interval:35 active:false
        timer ZYRefreshPulse interval:80 active:false
        on hit_ZYBuiltin lbuttondown p flags do
        (
            try(ZYBuiltinTick undefined undefined)catch
            (ZYNativeInput.ClearBuiltinEdits();format "Biped binding: %\n" (getCurrentException()))
        )
        on ZYDragPulse tick do
        (
            ZYDragPulse.active=false
            try
            (
                ZYSidePageTick undefined undefined
                if ZYDragControl!=undefined do ZYDragPulse.active=true
            )
            catch (ZYSideCancelDrag();format "Biped drag cancelled: %\n" (getCurrentException()))
        )
        on ZYRefreshPulse tick do
        (
            ZYRefreshPulse.active=false
            try(ZYGroupFinishRefresh undefined undefined)catch
            (ZYGroupDeleting=false;format "Biped refresh: %\n" (getCurrentException()))
        )
		on BipedPicker_Rollout open do
		(
			ZYSelectionPrepare()
			
			--// Populate available Bipeds list
			local a_bipNames = #()
			for b in g_ZYLB_BH.a_bips do
			(
				append a_bipNames b.name
			)
			ddl_bips.items = a_bipNames
			ddl_bips.selection = g_ZYLB_BH.f_readIniIndex "BipedPanel" "CurrentBip" g_ZYLB_BH.a_bips.count
			if ddl_bips.selection > 0 then
			(
				g_ZYLB_BH.bRoot = g_ZYLB_BH.a_bips[ddl_bips.selection]
				g_ZYLB_BH.f_initBipedParts picker:true
				ddl_bips.height = (ddl_bips.items.count + 1) * 100
			)
			else
			(
				g_ZYLB_BH.f_missingBipedError picker:true					
			)
			
            ZYRigEnsure()
            callbacks.removeScripts id:#ZYPickerSelection
            callbacks.addScript #selectionSetChanged "if not ZYPickerSelecting do ZYPickerSync()" id:#ZYPickerSelection
            ZYPickerSync()
            ZYSideResume()
			--// Initialize time range
			spn_TRstartTime.value = g_ZYLB_BH.TRstart = animationRange.start
			spn_TRendTime.value = g_ZYLB_BH.TRend = animationRange.end
			spn_TRstepSize.value = g_ZYLB_BH.TRstep = 1
			--// Sync with Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				rdobtns_timeRange.state = g_ZYLB_BH.SelectionDisplayTime_Rollout.rdobtns_timeRange.state
				spn_TRstartTime.enabled = spn_TRendTime.enabled = btn_setTRstart.enabled = btn_setTRend.enabled = rdobtns_timeRange.state - 1
				spn_TRstartTime.value = g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRstartTime.value
				spn_TRendTime.value = g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRendTime.value
				spn_TRstepSize.value = g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRstepSize.value
			)			
			
			--// Initialize trajectories and bend links
			chkbtn_trajectories.state = g_ZYLB_BH.bRoot.controller.displaytrajectories
			chkbtn_bendLinks.state = g_ZYLB_BH.bRoot.controller.bendLinksMode
			
			--// Initialize delete between
			--// Sync with Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				spn_keepStep.value = g_ZYLB_BH.Keys_Rollout.spn_keepStep.value
			)
			
			--// Initialize apply transform
			btn_pasteTM.enabled = btn_bakeTM.enabled = false
			if g_ZYLB_BH.copiedTransform != undefined then
			(
				btn_pasteTM.enabled = btn_bakeTM.enabled = true
				btn_copiedTM.images = #((g_ZYLB_BH.f_buttonColor 12 18 g_ZYLB_BH.clr_orange),undefined,1,1,1,1,1,false)
			)
			else
			(
				btn_copiedTM.images = #((g_ZYLB_BH.f_buttonColor 12 18 g_ZYLB_BH.clr_darkgrey),undefined,1,1,1,1,1,false)
			)
			f_setAxisToggles()
			
			--// Initialize foot CleanUp
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				rdobtns_applyTo.state = g_ZYLB_BH.Keys_Rollout.rdobtns_applyTo.state
				rdobtns_PRY.state = g_ZYLB_BH.Keys_Rollout.rdobtns_PRY.state
				chkbx_onlySnapBelow.state = g_ZYLB_BH.Keys_Rollout.chkbx_onlySnapBelow.state
			)
			
			--// Initialize ghost settings based on preferences
			chkbtn_ghosting.state = GhostingManager.ShowGhosting
			rdobtns_ghostType.state = GhostingManager.GhostType
			spn_ghostTotalFrames.value = GhostingManager.TotalGhostFrames
			spn_ghostNthFrame.value = GhostingManager.GhostFrameIncrement
			chkbx_ghostWireframe.checked = GhostingManager.DisplayGhostInWireframe
			chkbx_ghostFrameNumbers.checked = GhostingManager.ShowGhostFrameNumbers
			
			--// Initialize pose buffer
			local layer = LayerManager.getLayerFromName g_ZYLB_BH.poseBuffStr
			if layer != undefined then
			(
				local a_nodes = #()
				layer.nodes &a_nodes
				if a_nodes.count > 0 then
				(
					btn_removePB.enabled = chkbtn_visiblePB.enabled = true
					chkbtn_visiblePB.state = layer.on
					spn_PBopacity.value = $'#_BIPED_POSE_#'.material.opacity
					btn_swapPB.enabled = true
				)
				else
				(
					layerManager.deleteLayerByName g_ZYLB_BH.poseBuffStr
					btn_removePB.enabled = chkbtn_visiblePB.enabled = false
					chkbtn_visiblePB.state = false
					spn_PBopacity.value = g_ZYLB_BH.defaultPBopacity
					btn_swapPB.enabled = false
				)
			)
			--// Sync with Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				spn_PBopacity.value = g_ZYLB_BH.Reference_Rollout.spn_PBopacity.value
			)
			
			--// Initialize geometry snapshot layer and visibility state
			local snapshotLayerName = getIniSetting g_ZYLB_BH.bhINIfile "SnapshotLayer" "LayerName"
			if snapshotLayerName == "*** BLANK ***" and (layerManager.getLayerFromName snapshotLayerName)==undefined do snapshotLayerName=""
			if snapshotLayerName == "" do
			(
				setIniSetting g_ZYLB_BH.bhINIfile "SnapshotLayer" "LayerName" "*** 空白 ***"
				snapshotLayerName = "*** 空白 ***"
			)
			edtxt_snapshotSceneLayer.text = snapshotLayerName
			local layerSnapshots = layerManager.getLayerFromName "SNAPSHOTS"
			if layerSnapshots != undefined then
			(
				btn_deleteSnapshots.enabled = chkbtn_visibleSnapshots.enabled = true
				if layerSnapshots.isHidden then chkbtn_visibleSnapshots.state = false
				else chkbtn_visibleSnapshots.state = true
			)
			else
			(
				btn_deleteSnapshots.enabled = chkbtn_visibleSnapshots.enabled = chkbtn_visibleSnapshots.state = false
			)
			--// Sync with Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				spn_snapshotOpacity.value = g_ZYLB_BH.Reference_Rollout.spn_snapshotOpacity.value
			)
			
			--// Initialize biped trajectories
			maxOps.fixedTrimRange = true
			maxOps.trimTrajectories = false
			local layerBipedTrajectories = layerManager.getLayerFromName "BIPED_TRAJECTORIES"
			if layerBipedTrajectories != undefined then
			(
				btn_deleteTrajHelpers.enabled = chkbtn_visibleTrajHelpers.enabled = true
				if layerBipedTrajectories.isHidden then chkbtn_visibleTrajHelpers.state = false
				else chkbtn_visibleTrajHelpers.state = true
				
				if layerBipedTrajectories.getNumNodes() == 0 then
				(
					g_ZYLB_BH.f_trajectoryHelpersDelete query:false
					btn_deleteTrajHelpers.enabled = chkbtn_visibleTrajHelpers.enabled = chkbtn_visibleTrajHelpers.state = false
				)
			)
			else
			(
				btn_deleteTrajHelpers.enabled = chkbtn_visibleTrajHelpers.enabled = chkbtn_visibleTrajHelpers.state = false
			)
			--// Sync with Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				spn_limitStart.enabled = g_ZYLB_BH.Reference_Rollout.spn_limitStart.enabled
				spn_limitEnd.enabled = g_ZYLB_BH.Reference_Rollout.spn_limitEnd.enabled
				spn_limitStart.value = g_ZYLB_BH.Reference_Rollout.spn_limitStart.value
				spn_limitEnd.value = g_ZYLB_BH.Reference_Rollout.spn_limitEnd.value
				chkbx_limitTrajDisplay.state = g_ZYLB_BH.Reference_Rollout.chkbx_limitTrajDisplay.state
			)
			
			--// Set the state of the tools visibility button, based on stored dialog height state
			g_ZYLB_BH.BP_state = g_ZYLB_BH.f_readIniIndex "Picker" "Height" 2
			chkbtn_collapsePickerTools.state = g_ZYLB_BH.BP_state - 1
			local toolsColor = g_ZYLB_BH.clr_darkgrey
			if chkbtn_collapsePickerTools.state then toolsColor = g_ZYLB_BH.clr_orange
			chkbtn_collapsePickerTools.text = (ZYText "Animation tools" (if chkbtn_collapsePickerTools.state then "收起动画工具" else "展开动画工具"))
		)
		
		on BipedPicker_Rollout close do
		(
            callbacks.removeScripts id:#ZYPickerSelection
            ZYSideSuspend()
            ZYPickerReleaseVisuals()
			f_closePivotDialogs()
		)
		
		on BipedPicker_Rollout moved pos do
		(
			g_ZYLB_BH.BP_pos = pos
			setIniSetting g_ZYLB_BH.bhINIfile "Picker" "Position" (g_ZYLB_BH.BP_pos as string)
			
			--// update any external dialog positions (if open)
			if chkbtn_pivotsLHand.state then SetDialogPos g_ZYLB_BH.leftHandPivots_Rollout (g_ZYLB_BH.BP_pos + g_ZYLB_BH.picker_leftHandUIoffset)
			if chkbtn_pivotsRHand.state then SetDialogPos g_ZYLB_BH.rightHandPivots_Rollout (g_ZYLB_BH.BP_pos + g_ZYLB_BH.picker_rightHandUIoffset)
			if chkbtn_pivotsLFoot.state then SetDialogPos g_ZYLB_BH.leftFootPivots_Rollout (g_ZYLB_BH.BP_pos + g_ZYLB_BH.picker_leftFootUIoffset)
			if chkbtn_pivotsRFoot.state then SetDialogPos g_ZYLB_BH.rightFootPivots_Rollout (g_ZYLB_BH.BP_pos + g_ZYLB_BH.picker_rightFootUIoffset)
		)
		
		on btn_guide pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_guide"
 try
 (
 (
			shellLaunch "https://sites.google.com/view/lbtools-guide/home/biped-helper" ""
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_guide"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on ddl_bips selected val do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.ddl_bips"
 try
 (
 (
			if isValidNode g_ZYLB_BH.a_bips[ddl_bips.selection] then
			(
				if ddl_bips.selected == g_ZYLB_BH.a_bips[ddl_bips.selection].name then
				(
					g_ZYLB_BH.bRoot = g_ZYLB_BH.a_bips[ddl_bips.selection]
					g_ZYLB_BH.f_initBipedParts picker:true
					setIniSetting g_ZYLB_BH.bhINIfile "BipedPanel" "CurrentBip" (ddl_bips.selection as string)
					ZYSelectionPrepare()
					if keyboard.shiftPressed do
					(
						try(select g_ZYLB_BH.bRoot)catch(g_ZYLB_BH.f_initBipedParts picker:true)
					)
					if keyboard.controlPressed do
					(
						try(select g_ZYLB_BH.a_bipedAllParts)catch(g_ZYLB_BH.f_initBipedParts picker:true)
					)
					
					--// Update Biped Helper if open
					if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
					(
						g_ZYLB_BH.SelectionDisplayTime_Rollout.ddl_bips.selection = ddl_bips.selection
					)
				)
				else
				(
					g_ZYLB_BH.f_missingBipedError picker:true
				)
			)
			else
			(
				g_ZYLB_BH.f_missingBipedError picker:true
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.ddl_bips"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_refreshUI pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_refreshUI"
 try
 (
 (
			g_ZYLB_BH.f_openBipedPickerUI()
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_refreshUI"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_openBipedHelperUI pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_openBipedHelperUI"
 try
 (
 (
			g_ZYLB_BH.f_bipedHelperUI()
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_openBipedHelperUI"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_resetMainPos pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_resetMainPos"
 try
 (
 (
			if (hasIniSetting g_ZYLB_BH.bhINIfile "Floater" "Position") then
			(
				setIniSetting g_ZYLB_BH.bhINIfile "Floater" "Position" (g_ZYLB_BH.defaultPos as string)
				ZYDiagMessageBox "完整助手窗口位置已重置。" title:"Biped 助手"
				try(closeRolloutFloater g_ZYLB_BH.bipedUI_Floater)catch()
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_resetMainPos"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectClavicleL pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectClavicleL"
 try
 (
 ZYBuiltinSelect #btn_selectClavicleL
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectClavicleL"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectArmUpperL pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectArmUpperL"
 try
 (
 ZYBuiltinSelect #btn_selectArmUpperL
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectArmUpperL"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectArmLowerL pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectArmLowerL"
 try
 (
 ZYBuiltinSelect #btn_selectArmLowerL
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectArmLowerL"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectHandL pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectHandL"
 try
 (
 ZYBuiltinSelect #btn_selectHandL
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectHandL"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectFingersAllL pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectFingersAllL"
 try
 (
 ZYBuiltinSelect #btn_selectFingersAllL
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectFingersAllL"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectHead pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectHead"
 try
 (
 ZYBuiltinSelect #btn_selectHead
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectHead"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectPonytailL changed state do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectPonytailL"
 try
 (
 ZYBuiltinSelect #btn_selectPonytailL	
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectPonytailL"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectPonytailR changed state do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectPonytailR"
 try
 (
 ZYBuiltinSelect #btn_selectPonytailR
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectPonytailR"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectNeck pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectNeck"
 try
 (
 ZYBuiltinSelect #btn_selectNeck
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectNeck"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectAllSpines pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectAllSpines"
 try
 (
 ZYBuiltinSelect #btn_selectAllSpines
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectAllSpines"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectSpine4 pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectSpine4"
 try
 (
 ZYBuiltinSelect #btn_selectSpine4
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectSpine4"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectSpine3 pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectSpine3"
 try
 (
 ZYBuiltinSelect #btn_selectSpine3
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectSpine3"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectSpine2 pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectSpine2"
 try
 (
 ZYBuiltinSelect #btn_selectSpine2
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectSpine2"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectSpine1 pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectSpine1"
 try
 (
 ZYBuiltinSelect #btn_selectSpine1
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectSpine1"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectPelvis pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectPelvis"
 try
 (
 ZYBuiltinSelect #btn_selectPelvis
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectPelvis"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectCOM pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectCOM"
 try
 (
 ZYBuiltinSelect #btn_selectCOM
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectCOM"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectClavicleR pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectClavicleR"
 try
 (
 ZYBuiltinSelect #btn_selectClavicleR
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectClavicleR"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectArmUpperR pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectArmUpperR"
 try
 (
 ZYBuiltinSelect #btn_selectArmUpperR
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectArmUpperR"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectArmLowerR pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectArmLowerR"
 try
 (
 ZYBuiltinSelect #btn_selectArmLowerR
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectArmLowerR"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectHandR pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectHandR"
 try
 (
 ZYBuiltinSelect #btn_selectHandR
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectHandR"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectFingersAllR pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectFingersAllR"
 try
 (
 ZYBuiltinSelect #btn_selectFingersAllR
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectFingersAllR"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectLegUpperL pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectLegUpperL"
 try
 (
 ZYBuiltinSelect #btn_selectLegUpperL
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectLegUpperL"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectLegLowerL pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectLegLowerL"
 try
 (
 ZYBuiltinSelect #btn_selectLegLowerL
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectLegLowerL"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectToeL pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectToeL"
 try
 (
 ZYBuiltinSelect #btn_selectToeL
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectToeL"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectFootL pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectFootL"
 try
 (
 ZYBuiltinSelect #btn_selectFootL
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectFootL"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectLegUpperR pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectLegUpperR"
 try
 (
 ZYBuiltinSelect #btn_selectLegUpperR
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectLegUpperR"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectLegLowerR pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectLegLowerR"
 try
 (
 ZYBuiltinSelect #btn_selectLegLowerR
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectLegLowerR"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectFootR pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectFootR"
 try
 (
 ZYBuiltinSelect #btn_selectFootR
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectFootR"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectToeR pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectToeR"
 try
 (
 ZYBuiltinSelect #btn_selectToeR
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectToeR"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectPinky3L pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectPinky3L"
 try
 (
 ZYBuiltinSelect #btn_selectPinky3L
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectPinky3L"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectPinky2L pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectPinky2L"
 try
 (
 ZYBuiltinSelect #btn_selectPinky2L
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectPinky2L"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectPinky1L pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectPinky1L"
 try
 (
 ZYBuiltinSelect #btn_selectPinky1L
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectPinky1L"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectRing3L pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectRing3L"
 try
 (
 ZYBuiltinSelect #btn_selectRing3L
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectRing3L"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectRing2L pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectRing2L"
 try
 (
 ZYBuiltinSelect #btn_selectRing2L
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectRing2L"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectRing1L pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectRing1L"
 try
 (
 ZYBuiltinSelect #btn_selectRing1L
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectRing1L"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectMiddle3L pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectMiddle3L"
 try
 (
 ZYBuiltinSelect #btn_selectMiddle3L
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectMiddle3L"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectMiddle2L pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectMiddle2L"
 try
 (
 ZYBuiltinSelect #btn_selectMiddle2L
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectMiddle2L"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectMiddle1L pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectMiddle1L"
 try
 (
 ZYBuiltinSelect #btn_selectMiddle1L
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectMiddle1L"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectIndex3L pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectIndex3L"
 try
 (
 ZYBuiltinSelect #btn_selectIndex3L
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectIndex3L"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectIndex2L pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectIndex2L"
 try
 (
 ZYBuiltinSelect #btn_selectIndex2L
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectIndex2L"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectIndex1L pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectIndex1L"
 try
 (
 ZYBuiltinSelect #btn_selectIndex1L
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectIndex1L"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectThumb3L pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectThumb3L"
 try
 (
 ZYBuiltinSelect #btn_selectThumb3L
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectThumb3L"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectThumb2L pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectThumb2L"
 try
 (
 ZYBuiltinSelect #btn_selectThumb2L
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectThumb2L"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectThumb1L pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectThumb1L"
 try
 (
 ZYBuiltinSelect #btn_selectThumb1L
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectThumb1L"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectFingersL pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectFingersL"
 try
 (
 ZYBuiltinSelect #btn_selectFingersL
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectFingersL"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectThumbL pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectThumbL"
 try
 (
 ZYBuiltinSelect #btn_selectThumbL
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectThumbL"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectHandLrgL pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectHandLrgL"
 try
 (
 ZYBuiltinSelect #btn_selectHandLrgL
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectHandLrgL"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectThumb3R pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectThumb3R"
 try
 (
 ZYBuiltinSelect #btn_selectThumb3R
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectThumb3R"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectThumb2R pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectThumb2R"
 try
 (
 ZYBuiltinSelect #btn_selectThumb2R
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectThumb2R"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectThumb1R pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectThumb1R"
 try
 (
 ZYBuiltinSelect #btn_selectThumb1R
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectThumb1R"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectIndex3R pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectIndex3R"
 try
 (
 ZYBuiltinSelect #btn_selectIndex3R
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectIndex3R"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectIndex2R pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectIndex2R"
 try
 (
 ZYBuiltinSelect #btn_selectIndex2R
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectIndex2R"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectIndex1R pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectIndex1R"
 try
 (
 ZYBuiltinSelect #btn_selectIndex1R
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectIndex1R"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectMiddle3R pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectMiddle3R"
 try
 (
 ZYBuiltinSelect #btn_selectMiddle3R
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectMiddle3R"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectMiddle2R pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectMiddle2R"
 try
 (
 ZYBuiltinSelect #btn_selectMiddle2R
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectMiddle2R"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectMiddle1R pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectMiddle1R"
 try
 (
 ZYBuiltinSelect #btn_selectMiddle1R
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectMiddle1R"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectRing3R pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectRing3R"
 try
 (
 ZYBuiltinSelect #btn_selectRing3R
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectRing3R"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectRing2R pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectRing2R"
 try
 (
 ZYBuiltinSelect #btn_selectRing2R
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectRing2R"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectRing1R pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectRing1R"
 try
 (
 ZYBuiltinSelect #btn_selectRing1R
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectRing1R"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectPinky3R pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectPinky3R"
 try
 (
 ZYBuiltinSelect #btn_selectPinky3R
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectPinky3R"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectPinky2R pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectPinky2R"
 try
 (
 ZYBuiltinSelect #btn_selectPinky2R
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectPinky2R"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectPinky1R pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectPinky1R"
 try
 (
 ZYBuiltinSelect #btn_selectPinky1R
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectPinky1R"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectFingersR pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectFingersR"
 try
 (
 ZYBuiltinSelect #btn_selectFingersR
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectFingersR"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectThumbR pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectThumbR"
 try
 (
 ZYBuiltinSelect #btn_selectThumbR
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectThumbR"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectHandLrgR pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectHandLrgR"
 try
 (
 ZYBuiltinSelect #btn_selectHandLrgR
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectHandLrgR"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on btn_LArm changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_LArm"
 try
 (
 (
			local a_parts = join (deepCopy g_ZYLB_BH.a_armLeft) g_ZYLB_BH.a_fingersOnlyLeft
			a_parts = join a_parts g_ZYLB_BH.a_thumbLeft
			ZYBuiltinSelect #btn_LArm
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_LArm"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_LLeg changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_LLeg"
 try
 (
 (
			local a_parts = join (deepCopy g_ZYLB_BH.a_legLeft) #(g_ZYLB_BH.bToeL)
			ZYBuiltinSelect #btn_LLeg
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_LLeg"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_RArm changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_RArm"
 try
 (
 (
			local a_parts = join (deepCopy g_ZYLB_BH.a_armRight) g_ZYLB_BH.a_fingersOnlyRight
			a_parts = join a_parts g_ZYLB_BH.a_thumbRight
			ZYBuiltinSelect #btn_RArm
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_RArm"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_RLeg changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_RLeg"
 try
 (
 (
			local a_parts = join (deepCopy g_ZYLB_BH.a_legRight) #(g_ZYLB_BH.bToeR)
			ZYBuiltinSelect #btn_RLeg
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_RLeg"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_tailBase changed state do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_tailBase"
 try
 (
 ZYBuiltinSelect #btn_tailBase
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_tailBase"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_selectProp1 changed state do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectProp1"
 try
 (
 ZYBuiltinSelect #btn_selectProp1
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectProp1"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectProp2 changed state do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectProp2"
 try
 (
 ZYBuiltinSelect #btn_selectProp2
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectProp2"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectProp3 changed state do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectProp3"
 try
 (
 ZYBuiltinSelect #btn_selectProp3
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectProp3"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectHands changed state do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectHands"
 try
 (
 ZYBuiltinSelect #btn_selectHands
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectHands"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectFeet changed state do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectFeet"
 try
 (
 ZYBuiltinSelect #btn_selectFeet
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectFeet"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectAll changed state do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectAll"
 try
 (
 ZYBuiltinSelect #btn_selectAll
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectAll"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
			
		on btn_selectBipedParentGrow pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectBipedParentGrow"
 try
 (
 g_ZYLB_BH.f_selectBipedParent (selection as array) clearSel:false
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectBipedParentGrow"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectBipedParentNext pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectBipedParentNext"
 try
 (
 g_ZYLB_BH.f_selectBipedParent (selection as array)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectBipedParentNext"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectBipedChildren pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectBipedChildren"
 try
 (
 g_ZYLB_BH.f_selectBipedChildren (selection as array)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectBipedChildren"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectBipedChildNext pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectBipedChildNext"
 try
 (
 g_ZYLB_BH.f_selectBipedChild (selection as array)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectBipedChildNext"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		on btn_selectBipedChildGrow pressed do (
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_selectBipedChildGrow"
 try
 (
 g_ZYLB_BH.f_selectBipedChild (selection as array) clearSel:false
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_selectBipedChildGrow"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_pivotsLHand changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbtn_pivotsLHand"
 try
 (
 (
			try
			(
				if state then
				(
					g_ZYLB_BH.f_openPivotsUI_LeftHand pos:(g_ZYLB_BH.BP_pos + g_ZYLB_BH.picker_leftHandUIoffset)
					chkbtn_pivotsLHand.state = true
				)
				else
				(
					try(destroyDialog g_ZYLB_BH.leftHandPivots_Rollout)catch()
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbtn_pivotsLHand"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
			
		on chkbtn_pivotsRHand changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbtn_pivotsRHand"
 try
 (
 (
			try
			(
				if state then
				(
					g_ZYLB_BH.f_openPivotsUI_RightHand pos:(g_ZYLB_BH.BP_pos + g_ZYLB_BH.picker_rightHandUIoffset)
					chkbtn_pivotsRHand.state = true
				)
				else
				(
					try(destroyDialog g_ZYLB_BH.rightHandPivots_Rollout)catch()
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbtn_pivotsRHand"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_pivotsLFoot changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbtn_pivotsLFoot"
 try
 (
 (
			try
			(
				if state then
				(
					g_ZYLB_BH.f_openPivotsUI_LeftFoot pos:(g_ZYLB_BH.BP_pos + g_ZYLB_BH.picker_leftFootUIoffset)
					chkbtn_pivotsLFoot.state = true
				)
				else
				(
					try(destroyDialog g_ZYLB_BH.leftFootPivots_Rollout)catch()
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbtn_pivotsLFoot"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_pivotsRFoot changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbtn_pivotsRFoot"
 try
 (
 (
			try
			(
				if state then
				(
					g_ZYLB_BH.f_openPivotsUI_RightFoot pos:(g_ZYLB_BH.BP_pos + g_ZYLB_BH.picker_rightFootUIoffset)
					chkbtn_pivotsRFoot.state = true
				)
				else
				(
					try(destroyDialog g_ZYLB_BH.rightFootPivots_Rollout)catch()
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbtn_pivotsRFoot"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_collapsePickerTools changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbtn_collapsePickerTools"
 try
 (
 (
			g_ZYLB_BH.BP_state = (state as integer) + 1
			setIniSetting g_ZYLB_BH.bhINIfile "Picker" "Height" (g_ZYLB_BH.BP_state as string)
			g_ZYLB_BH.BipedPicker_Rollout.height = g_ZYLB_BH.BP_height[g_ZYLB_BH.BP_state]
			local toolsColor = g_ZYLB_BH.clr_darkgrey
			if state then toolsColor = g_ZYLB_BH.clr_orange
			chkbtn_collapsePickerTools.text = (ZYText "Animation tools" (if chkbtn_collapsePickerTools.state then "收起动画工具" else "展开动画工具"))
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbtn_collapsePickerTools"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on rdobtns_timeRange changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.rdobtns_timeRange"
 try
 (
 (
			case state of
			(
				1: (
						g_ZYLB_BH.TRstart = animationRange.start
						g_ZYLB_BH.TRend = animationRange.end
						spn_TRstartTime.enabled = false
						spn_TRendTime.enabled = false
						btn_setTRstart.enabled = false
						btn_setTRend.enabled = false
					)
				2: (
						g_ZYLB_BH.TRstart = spn_TRstartTime.value as time
						g_ZYLB_BH.TRend = spn_TRendTime.value as time
						spn_TRstartTime.enabled = true
						spn_TRendTime.enabled = true
						btn_setTRstart.enabled = true
						btn_setTRend.enabled = true
					)
			)
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.SelectionDisplayTime_Rollout.rdobtns_timeRange.state = state
				case state of
				(
					1: (
							g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRstartTime.enabled = false
							g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRendTime.enabled = false
							g_ZYLB_BH.SelectionDisplayTime_Rollout.btn_setTRstart.enabled = false
							g_ZYLB_BH.SelectionDisplayTime_Rollout.btn_setTRend.enabled = false
					   )
					2: (
							g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRstartTime.enabled = true
							g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRendTime.enabled = true
							g_ZYLB_BH.SelectionDisplayTime_Rollout.btn_setTRstart.enabled = true
							g_ZYLB_BH.SelectionDisplayTime_Rollout.btn_setTRend.enabled = true
					   )
				)
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.rdobtns_timeRange"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on spn_TRstartTime changed val do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.spn_TRstartTime"
 try
 (
 (
			if val >= spn_TRendTime.value then
			(
				g_ZYLB_BH.TRend = spn_TRendTime.value = val + 1
			)
			g_ZYLB_BH.TRstart = val as time
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				if val >= g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRendTime.value then
				(
					g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRendTime.value = val + 1
				)
				g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRstartTime.value = val
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.spn_TRstartTime"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on spn_TRendTime changed val do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.spn_TRendTime"
 try
 (
 (
			if val <= spn_TRstartTime.value then
			(
				g_ZYLB_BH.TRstart = spn_TRstartTime.value = val - 1
			)
			g_ZYLB_BH.TRend = val as time
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				if val <= g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRstartTime.value then
				(
					g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRstartTime.value = val - 1
				)
				g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRendTime.value = val
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.spn_TRendTime"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on spn_TRstepSize changed val do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.spn_TRstepSize"
 try
 (
 (
			g_ZYLB_BH.TRstep = val
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRstepSize.value = val
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.spn_TRstepSize"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
			
		on btn_setTRstart pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_setTRstart"
 try
 (
 (
			if keyboard.shiftPressed then
			(
				sliderTime = spn_TRstartTime.value as time
			)
			else
			(
				spn_TRstartTime.value = sliderTime
				if sliderTime >= spn_TRendTime.value then
				(
					g_ZYLB_BH.TRend = spn_TRendTime.value = sliderTime + 1
				)
				g_ZYLB_BH.TRstart = sliderTime
				
				--// Update Biped Helper if open
				if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
				(
					g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRstartTime.value = sliderTime
					if sliderTime >= spn_TRendTime.value then
					(
						g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRendTime.value = sliderTime + 1
					)
				)
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_setTRstart"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_setTRend pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_setTRend"
 try
 (
 (
			if keyboard.shiftPressed then
			(
				sliderTime = spn_TRendTime.value as time
			)
			else
			(
				spn_TRendTime.value = sliderTime
				if sliderTime <= spn_TRstartTime.value then
				(
					g_ZYLB_BH.TRstart = spn_TRstartTime.value = sliderTime - 1
				)
				g_ZYLB_BH.TRend = sliderTime
				
				--// Update Biped Helper if open
				if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
				(
					g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRendTime.value = sliderTime
					if sliderTime <= spn_TRstartTime.value then
					(
						g_ZYLB_BH.SelectionDisplayTime_Rollout.spn_TRstartTime.value = sliderTime - 1
					)
				)
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_setTRend"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_keyAllParts pressed do (ZYKeyMenuSource=#picker;ZYKeyApply true (keyboard.shiftPressed or keyboard.controlPressed))
		on btn_keyAllParts rightclick do ZYKeyOpenMenu true
		
		on btn_keySelectedParts pressed do (ZYKeyMenuSource=#picker;ZYKeyApply false (keyboard.shiftPressed or keyboard.controlPressed))
		on btn_keySelectedParts rightclick do ZYKeyOpenMenu false
		
		on btn_deleteAllkeys pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_deleteAllkeys"
 try
 (
 (
			try
			(
				if g_ZYLB_BH.bRoot.controller.figureMode == false then
				(
					if (ZYDiagQueryBox "确认删除当前 Biped 的全部动画？此操作会删除所有关键帧。" title:"Biped 助手") do
					(
						biped.clearAllAnimation g_ZYLB_BH.bRoot.controller
						g_ZYLB_BH.bRoot.controller.figureMode = true
						g_ZYLB_BH.bRoot.controller.figureMode = false
					)
				)
				else
				(
					ZYDiagMessageBox "请先退出 Biped 的形体模式。" title:"Biped 助手"
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_deleteAllkeys"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
			
		on btn_deleteFrameKeys pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_deleteFrameKeys"
 try
 (
 (
			try
			(
				if g_ZYLB_BH.bRoot.controller.figureMode == false then
				(
					undo "DeleteFrameKeys" on
					(
						if keyboard.shiftPressed OR keyboard.controlPressed then
						(
							g_ZYLB_BH.f_deleteAllFrameKeys()
						)
						else --// Default method, removes keys only on selected parts
						(
							if selection.count > 0 then
							(
								local a_bipedParts = selection as array
								for b in a_bipedParts do
								(
									g_ZYLB_BH.f_deleteBipedPartKeys b
								)
							)
							else
							(
								ZYDiagMessageBox "请先选择一个或多个 Biped 部件。" title:"Biped 助手"
							)
						)
					)
				)
				else
				(
					ZYDiagMessageBox "请先退出 Biped 的形体模式。" title:"Biped 助手"
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_deleteFrameKeys"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_deleteRangeKeys pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_deleteRangeKeys"
 try
 (
 (
			try
			(
				if g_ZYLB_BH.bRoot.controller.figureMode == false then
				(
					undo "DeleteRangeKeys" on
					(
						if keyboard.shiftPressed OR keyboard.controlPressed then
						(
							for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
							(
								g_ZYLB_BH.f_deleteAllFrameKeys atTime:t
							)
						)
						else --// Default method, removes keys only on selected parts
						(
							if selection.count > 0 then
							(
								local a_bipedParts = selection as array
								for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
								(
									for b in a_bipedParts do
									(
										g_ZYLB_BH.f_deleteBipedPartKeys b atTime:t
									)
								)
							)
							else
							(
								ZYDiagMessageBox "请先选择一个或多个 Biped 部件。" title:"Biped 助手"
							)
						)
					)
				)
				else
				(
					ZYDiagMessageBox "请先退出 Biped 的形体模式。" title:"Biped 助手"
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_deleteRangeKeys"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_deleteBetweenKeys pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_deleteBetweenKeys"
 try
 (
 (
			try
			(
				if g_ZYLB_BH.bRoot.controller.figureMode == false then
				(
					undo "DeleteBetweenKeys" on
					(
						--// Delete Between will ignore the time range step size value, so it uses the keep step value instead.
						if keyboard.shiftPressed OR keyboard.controlPressed then
						(
							for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend while NOT keyboard.escPressed do
							(
								if (mod t.frame spn_keepStep.value) != 0 then
								(
									g_ZYLB_BH.f_deleteAllFrameKeys atTime:t
								)
							)
						)
						else --// Default method, removes keys only on selected parts
						(
							if selection.count > 0 then
							(
								local a_bipedParts = selection as array
								for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend while NOT keyboard.escPressed do
								(
									if (mod t.frame spn_keepStep.value) != 0 then
									(
										for b in a_bipedParts do
										(
											g_ZYLB_BH.f_deleteBipedPartKeys b atTime:t
										)
									)
								)
							)
							else
							(
								ZYDiagMessageBox "请先选择一个或多个 Biped 部件。" title:"Biped 助手"
							)
						)
					)
				)
				else
				(
					ZYDiagMessageBox "请先退出 Biped 的形体模式。" title:"Biped 助手"
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_deleteBetweenKeys"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on spn_keepStep changed val do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.spn_keepStep"
 try
 (
 (
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Keys_Rollout.spn_keepStep.value = val
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.spn_keepStep"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_applyIncrement pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_applyIncrement"
 try
 (
 (
			try
			(
				biped.setmultiplekeys g_ZYLB_BH.bRoot.controller
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_applyIncrement"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_limbPlanted pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_limbPlanted"
 try
 (
 (
			try(
				if selection.count > 0 then
				(
					for obj in (selection as array) do
					(
						biped.setPlantedKey obj
					)
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_limbPlanted"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_limbSliding pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_limbSliding"
 try
 (
 (
			try(
				if selection.count > 0 then
				(
					for obj in (selection as array) do
					(
						biped.setSlidingKey obj
					)
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_limbSliding"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_limbFree pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_limbFree"
 try
 (
 (
			try(
				if selection.count > 0 then
				(
					for obj in (selection as array) do
					(
						biped.setFreeKey obj
					)
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_limbFree"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_trajectories changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbtn_trajectories"
 try
 (
 (
			try
			(
				setCommandPanelTaskMode #motion
				g_ZYLB_BH.bRoot.controller.displaytrajectories = state
				
				--// Update Biped Helper if open
				if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
				(
					g_ZYLB_BH.SelectionDisplayTime_Rollout.chkbtn_trajectories.state = state
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbtn_trajectories"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
			
		on chkbtn_bendLinks changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbtn_bendLinks"
 try
 (
 (
			try
			(
				g_ZYLB_BH.bRoot.controller.bendLinksMode = state
				
				--// Update Biped Helper if open
				if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
				(
					g_ZYLB_BH.SelectionDisplayTime_Rollout.chkbtn_bendLinks.state = state
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbtn_bendLinks"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_boxMode pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_boxMode"
 try
 (
 (
			try
			(
				g_ZYLB_BH.a_bipedAllParts.displayByLayer = false
				if keyboard.shiftPressed then g_ZYLB_BH.a_bipedAllParts.boxMode = false
				else g_ZYLB_BH.a_bipedAllParts.boxMode = true
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_boxMode"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_hideBiped pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_hideBiped"
 try
 (
 (
			try
			(
				local a_bipedObjs = g_ZYLB_BH.f_findHierarchy g_ZYLB_BH.bRoot
				a_bipedObjs = g_ZYLB_BH.f_filterBipedParts a_bipedObjs
				for h in helpers do
				(
					if matchpattern h.name pattern:"*Nub" do
					(
						append a_bipedObjs h
					)
				)
				hide a_bipedObjs
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_hideBiped"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on btn_unhideBiped pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_unhideBiped"
 try
 (
 (
			try
			(
				unhide g_ZYLB_BH.a_bipedAllParts
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_unhideBiped"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_posX changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbtn_posX"
 try
 (
 (
			f_evaluateAxesToggles()
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Keys_Rollout.chkbtn_posX.state = state
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbtn_posX"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on chkbtn_posY changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbtn_posY"
 try
 (
 (
			f_evaluateAxesToggles()
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Keys_Rollout.chkbtn_posY.state = state
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbtn_posY"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_posZ changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbtn_posZ"
 try
 (
 (
			f_evaluateAxesToggles()
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Keys_Rollout.chkbtn_posZ.state = state
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbtn_posZ"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_rotXYZ changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbtn_rotXYZ"
 try
 (
 (
			f_evaluateAxesToggles()
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Keys_Rollout.chkbtn_rotXYZ.state = state
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbtn_rotXYZ"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_copyTM pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_copyTM"
 try
 (
 (
			if selection.count == 1 then
			(
				local sel = selection[1]
				g_ZYLB_BH.copiedTransform = sel.transform
				btn_copiedTM.images = #((g_ZYLB_BH.f_buttonColor 12 18 g_ZYLB_BH.clr_orange),undefined,1,1,1,1,1,false)
				btn_pasteTM.enabled = btn_bakeTM.enabled = true
				
				--// Update Biped Helper if open
				if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
				(
					g_ZYLB_BH.Keys_Rollout.lbl_copiedTM.text = g_ZYLB_BH.copiedMsg
					g_ZYLB_BH.Keys_Rollout.btn_pasteTM.enabled = g_ZYLB_BH.Keys_Rollout.btn_bakeTM.enabled = true
				)
			)
			else
			(
				ZYDiagMessageBox "请先只选择一个对象。" title:"Biped 助手"
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_copyTM"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_pasteTM pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_pasteTM"
 try
 (
 (
			undo "PasteTransform" on
			(
				if selection.count == 1 then
				(
					local sel = selection[1]
					if g_ZYLB_BH.copiedTransform != undefined then
					(
						f_evaluateAxesToggles()
						if NOT g_ZYLB_BH.a_ATtoggles[1] AND NOT g_ZYLB_BH.a_ATtoggles[2] AND NOT g_ZYLB_BH.a_ATtoggles[3] AND NOT g_ZYLB_BH.a_ATtoggles[4] then
						(
							ZYDiagMessageBox "请先选择要应用的位置轴或旋转。" title:"Biped 助手"
						)
						else
						(
							with animate on
							(
								g_ZYLB_BH.f_pasteCopiedTM sel
							)
						)
						redrawViews()
					)
					else
					(
						ZYDiagMessageBox "尚未复制变换。请选中一个对象并点击「复制世界变换」。" title:"Biped 助手"
					)
				)
				else
				(
					ZYDiagMessageBox "请先只选择一个对象。" title:"Biped 助手"
				)
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_pasteTM"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_bakeTM pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_bakeTM"
 try
 (
 (
			if selection.count == 1 then
			(
				local sel = selection[1]
				undo "BakeTransform" on
				(
					setCommandPanelTaskMode #create --// switching out of motion panel greatly decreases processing time
					if g_ZYLB_BH.copiedTransform != undefined then
					(
						f_evaluateAxesToggles()
						if NOT g_ZYLB_BH.a_ATtoggles[1] AND NOT g_ZYLB_BH.a_ATtoggles[2] AND NOT g_ZYLB_BH.a_ATtoggles[3] AND NOT g_ZYLB_BH.a_ATtoggles[4] then
						(
							ZYDiagMessageBox "请先选择要应用的位置轴或旋转。" title:"Biped 助手"
						)
						else
						(
							local prevTime = sliderTime
							disableSceneRedraw()
							with animate on
							(
								for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
								(
									at time t
									(
										sliderTime = t
										g_ZYLB_BH.f_pasteCopiedTM sel
									)
								)
							)
							enableSceneRedraw()
							sliderTime = prevTime
						)
						redrawViews()
					)
					else
					(
						ZYDiagMessageBox "尚未复制变换。请选中一个肢体并点击「复制世界变换」。" title:"Biped 助手"
					)
				)
			)
			else
			(
				ZYDiagMessageBox "请先只选择一个对象。" title:"Biped 助手"
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_bakeTM"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on rdobtns_applyTo changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.rdobtns_applyTo"
 try
 (
 (
			--// Sync with Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Keys_Rollout.rdobtns_applyTo.state = state
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.rdobtns_applyTo"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on rdobtns_PRY changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.rdobtns_PRY"
 try
 (
 (
			--// Sync with Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Keys_Rollout.rdobtns_PRY.state = state
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.rdobtns_PRY"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbx_onlySnapBelow changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbx_onlySnapBelow"
 try
 (
 (
			--// Sync with Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Keys_Rollout.chkbx_onlySnapBelow.state = state
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbx_onlySnapBelow"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_orientFoot pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_orientFoot"
 try
 (
 (
			try
			(
				if selection.count == 1 AND selection[1] == g_ZYLB_BH.bFootL OR selection[1] == g_ZYLB_BH.bFootR then
				(
					local foot = selection[1]
					undo "OrientFoot" on
					(
						setCommandPanelTaskMode #create --// switching out of motion panel greatly decreases processing time
						case rdobtns_applyTo.state of
						(
							1:( --// Frame
								with animate on
								(
									g_ZYLB_BH.f_applyFootOrientation foot rdobtns_PRY.state
								)
							)
							2:( --// Bake
								disableSceneRedraw()
								with animate on
								(
									for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
									(
										at time t
										(
											g_ZYLB_BH.f_applyFootOrientation foot rdobtns_PRY.state
										)
									)
								)
								enableSceneRedraw()
							)
							3:( --// All Keys
								disableSceneRedraw()
								with animate on
								(
									local a_times = g_ZYLB_BH.f_getAllKeyTimesTR foot g_ZYLB_BH.TRstart g_ZYLB_BH.TRend
									if a_times.count > 0 then
									(
										for t in a_times while NOT keyboard.escPressed do
										(
											at time t
											(
												g_ZYLB_BH.f_applyFootOrientation foot rdobtns_PRY.state
											)
										)
									)
									else
									(
										ZYDiagMessageBox "指定范围内没有关键帧。" title:"Biped 助手"
									)
								)
								enableSceneRedraw()
							)
							4:( --// Selected Keys
								disableSceneRedraw()
								with animate on
								(
									local a_times = g_ZYLB_BH.f_getAllKeyTimesTR foot g_ZYLB_BH.TRstart g_ZYLB_BH.TRend selectedOnly:true
									if a_times.count > 0 then
									(
										for t in a_times while NOT keyboard.escPressed do
										(
											at time t
											(
												g_ZYLB_BH.f_applyFootOrientation foot rdobtns_PRY.state
											)
										)
									)
									else
									(
										ZYDiagMessageBox "指定范围内没有选中的关键帧。" title:"Biped 助手"
									)
								)
								enableSceneRedraw()
							)
						)
						if isValidNode g_ZYLB_BH.dumYawCalf then delete g_ZYLB_BH.dumYawCalf
						if isValidNode g_ZYLB_BH.dumYawFoot then delete g_ZYLB_BH.dumYawFoot
						redrawViews()
					)
				)
				else
				(
					ZYDiagMessageBox "请只选择 Biped 左脚或右脚。" title:"Biped 助手"
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_orientFoot"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
			
		on btn_snapToFloor pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_snapToFloor"
 try
 (
 (
			try
			(
				if selection.count == 1 AND selection[1] == g_ZYLB_BH.bFootL OR selection[1] == g_ZYLB_BH.bFootR then
				(
					local foot = selection[1]
					undo "SnapFootToFloor" on
					(
						setCommandPanelTaskMode #create --// switching out of motion panel greatly decreases processing time
						case rdobtns_applyTo.state of
						(
							1:( --// Frame
								with animate on
								(
									g_ZYLB_BH.f_snapFootToFloor foot chkbx_onlySnapBelow.checked
								)
							)
							2:( --// Bake
								disableSceneRedraw()
								with animate on
								(
									for t = g_ZYLB_BH.TRstart to g_ZYLB_BH.TRend by g_ZYLB_BH.TRstep while NOT keyboard.escPressed do
									(
										at time t
										(
											g_ZYLB_BH.f_snapFootToFloor foot chkbx_onlySnapBelow.checked
										)
									)
								)
								enableSceneRedraw()
							)
							3:( --// All Keys
								disableSceneRedraw()
								with animate on
								(
									local a_times = g_ZYLB_BH.f_getAllKeyTimesTR foot g_ZYLB_BH.TRstart g_ZYLB_BH.TRend
									if a_times.count > 0 then
									(
										for t in a_times while NOT keyboard.escPressed do
										(
											at time t
											(
												g_ZYLB_BH.f_snapFootToFloor foot chkbx_onlySnapBelow.checked
											)
										)
									)
									else
									(
										ZYDiagMessageBox "指定范围内没有关键帧。" title:"Biped 助手"
									)
								)
								enableSceneRedraw()
							)
							4:( --// Selected Keys
								disableSceneRedraw()
								with animate on
								(
									local a_times = g_ZYLB_BH.f_getAllKeyTimesTR foot g_ZYLB_BH.TRstart g_ZYLB_BH.TRend selectedOnly:true
									if a_times.count > 0 then
									(
										for t in a_times while NOT keyboard.escPressed do
										(
											at time t
											(
												g_ZYLB_BH.f_snapFootToFloor foot chkbx_onlySnapBelow.checked
											)
										)
									)
									else
									(
										ZYDiagMessageBox "指定范围内没有选中的关键帧。" title:"Biped 助手"
									)
								)
								enableSceneRedraw()
							)
						)
						redrawViews()
					)
				)
				else
				(
					ZYDiagMessageBox "请只选择 Biped 左脚或右脚。" title:"Biped 助手"
				)
			)catch(g_ZYLB_BH.f_initBipedParts())
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_snapToFloor"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_ghosting changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbtn_ghosting"
 try
 (
 (
			GhostingManager.ShowGhosting = state
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Reference_Rollout.chkbtn_ghosting.state = state
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbtn_ghosting"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on rdobtns_ghostType changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.rdobtns_ghostType"
 try
 (
 (
			GhostingManager.GhostType = state
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Reference_Rollout.rdobtns_ghostType.state = state
			)
			
			redrawViews()
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.rdobtns_ghostType"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on spn_ghostTotalFrames changed val do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.spn_ghostTotalFrames"
 try
 (
 (
			GhostingManager.TotalGhostFrames = val
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Reference_Rollout.spn_ghostTotalFrames.value = val
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.spn_ghostTotalFrames"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)

		on spn_ghostNthFrame changed val do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.spn_ghostNthFrame"
 try
 (
 (
			GhostingManager.GhostFrameIncrement = val
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Reference_Rollout.spn_ghostNthFrame.value = val
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.spn_ghostNthFrame"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbx_ghostWireframe changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbx_ghostWireframe"
 try
 (
 (
			GhostingManager.DisplayGhostInWireframe = state
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Reference_Rollout.chkbx_ghostWireframe.state = state
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbx_ghostWireframe"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbx_ghostFrameNumbers changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbx_ghostFrameNumbers"
 try
 (
 (
			GhostingManager.ShowGhostFrameNumbers = state
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Reference_Rollout.chkbx_ghostFrameNumbers.state = state
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbx_ghostFrameNumbers"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_visiblePB changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbtn_visiblePB"
 try
 (
 (
			try
			(
				local poseNode = $'#_BIPED_POSE_#'
				if poseNode != undefined then
				(
					local layer = LayerManager.getLayerFromName g_ZYLB_BH.poseBuffStr
					if layer != undefined then
					(
						btn_swapPB.enabled = layer.on = state
					)
					else
					(
						btn_swapPB.enabled = chkbtn_visiblePB.state = chkbtn_visiblePB.enabled = false
					)
				)
				else
				(
					g_ZYLB_BH.f_cleanupPoseBuffer()
					btn_swapPB.enabled = chkbtn_visiblePB.state = chkbtn_visiblePB.enabled = false
					btn_removePB.enabled = false
				)
				
				--// Update Biped Helper if open
				if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
				(
					if poseNode != undefined then
					(
						g_ZYLB_BH.Reference_Rollout.chkbtn_visiblePB.state = state
						g_ZYLB_BH.Reference_Rollout.btn_swapPB.enabled = state
					)
					else
					(
						g_ZYLB_BH.Reference_Rollout.btn_swapPB.enabled = g_ZYLB_BH.Reference_Rollout.chkbtn_visiblePB.state = g_ZYLB_BH.Reference_Rollout.chkbtn_visiblePB.enabled = false
					)
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbtn_visiblePB"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
				
		on btn_snapPB pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_snapPB"
 try
 (
 (
			try
			(
				g_ZYLB_BH.f_snapPB spn_PBopacity.value
				--// Activate toggle, remove and swap buttons
				btn_removePB.enabled = btn_swapPB.enabled = chkbtn_visiblePB.state = chkbtn_visiblePB.enabled = true
				--// Store a copy of the current pose as a file for use with swap pose buffer
				g_ZYLB_BH.f_savePoseBufferFile()
				
				--// Update Biped Helper if open
				if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
				(
					g_ZYLB_BH.Reference_Rollout.btn_removePB.enabled = g_ZYLB_BH.Reference_Rollout.btn_swapPB.enabled = g_ZYLB_BH.Reference_Rollout.chkbtn_visiblePB.state = g_ZYLB_BH.Reference_Rollout.chkbtn_visiblePB.enabled = true
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_snapPB"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_swapPB pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_swapPB"
 try
 (
 (
			try
			(
				local poseNode = $'#_BIPED_POSE_#'
				if poseNode != undefined then
				(
					--// Create a new pose buffer using the current Biped pose
					g_ZYLB_BH.f_snapPB spn_PBopacity.value
					--// Swap the Biped pose with the pose buffer
					g_ZYLB_BH.f_swapPB chkbx_keySwapPB.checked
				)
				else
				(
					g_ZYLB_BH.f_cleanupPoseBuffer()
					btn_swapPB.enabled = chkbtn_visiblePB.state = chkbtn_visiblePB.enabled = false
					btn_removePB.enabled = false
				)
				
				--// Update Biped Helper if open
				if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
				(
					if poseNode == undefined then
					(
						g_ZYLB_BH.Reference_Rollout.btn_swapPB.enabled = g_ZYLB_BH.Reference_Rollout.chkbtn_visiblePB.state = g_ZYLB_BH.Reference_Rollout.chkbtn_visiblePB.enabled = false
						g_ZYLB_BH.Reference_Rollout.btn_removePB.enabled = false
					)
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_swapPB"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_removePB pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_removePB"
 try
 (
 (
			try
			(
				local poseNode = $'#_BIPED_POSE_#'
				if poseNode != undefined then
				(
					if (ZYDiagQueryBox "确认删除姿势缓存？" title:"Biped 助手") then
					(
						g_ZYLB_BH.f_cleanupPoseBuffer showMsg:false
						btn_swapPB.enabled = chkbtn_visiblePB.state = chkbtn_visiblePB.enabled = false
						btn_removePB.enabled = false
					)
				)
				else
				(
					g_ZYLB_BH.f_cleanupPoseBuffer()
					btn_swapPB.enabled = chkbtn_visiblePB.state = chkbtn_visiblePB.enabled = false
					btn_removePB.enabled = false
				)
				
				--// Update Biped Helper if open
				if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
				(
					if poseNode != undefined then
					(
						g_ZYLB_BH.Reference_Rollout.btn_swapPB.enabled = g_ZYLB_BH.Reference_Rollout.chkbtn_visiblePB.state = g_ZYLB_BH.Reference_Rollout.chkbtn_visiblePB.enabled = false
						g_ZYLB_BH.Reference_Rollout.btn_removePB.enabled = false
					)
					else
					(
						g_ZYLB_BH.Reference_Rollout.btn_swapPB.enabled = g_ZYLB_BH.Reference_Rollout.chkbtn_visiblePB.state = g_ZYLB_BH.Reference_Rollout.chkbtn_visiblePB.enabled = false
						g_ZYLB_BH.Reference_Rollout.btn_removePB.enabled = false
					)
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_removePB"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on spn_PBopacity changed val do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.spn_PBopacity"
 try
 (
 (
			local poseNode = $'#_BIPED_POSE_#'
			if poseNode != undefined then
			(
				with animate off
				(
					poseNode.material.opacity = val
				)
			)
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Reference_Rollout.spn_PBopacity.value = val
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.spn_PBopacity"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_defaultPBopacity pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_defaultPBopacity"
 try
 (
 (
			spn_PBopacity.value = g_ZYLB_BH.defaultPBopacity
			local poseNode = $'#_BIPED_POSE_#'
			if poseNode != undefined then
			(
				with animate off
				(
					poseNode.material.opacity = g_ZYLB_BH.defaultPBopacity
				)
			)
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Reference_Rollout.spn_PBopacity.value = g_ZYLB_BH.defaultPBopacity
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_defaultPBopacity"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on edtxt_snapshotSceneLayer changed val do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.edtxt_snapshotSceneLayer"
 try
 (
 (
			setIniSetting g_ZYLB_BH.bhINIfile "SnapshotLayer" "LayerName" val
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Reference_Rollout.edtxt_snapshotSceneLayer.text = val
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.edtxt_snapshotSceneLayer"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_snapshotGeometry pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_snapshotGeometry"
 try
 (
 (
			try
			(
				undo "SnapshotGeometry" on
				(
					local successful = g_ZYLB_BH.f_snapshotGeometry spn_snapshotOpacity.value
					if successful then
					(
						btn_deleteSnapshots.enabled = chkbtn_visibleSnapshots.enabled = chkbtn_visibleSnapshots.state = true
					
						--// Update Biped Helper if open
						if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
						(
							g_ZYLB_BH.Reference_Rollout.btn_deleteSnapshots.enabled = g_ZYLB_BH.Reference_Rollout.chkbtn_visibleSnapshots.enabled = g_ZYLB_BH.Reference_Rollout.chkbtn_visibleSnapshots.state = true
						)
					)
				)
			)catch(g_ZYLB_BH.f_initBipedParts picker:true)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_snapshotGeometry"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_visibleSnapshots changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbtn_visibleSnapshots"
 try
 (
 (
			g_ZYLB_BH.f_snaphotsVisibility state
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Reference_Rollout.chkbtn_visibleSnapshots.state = state
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbtn_visibleSnapshots"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_deleteSnapshots pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_deleteSnapshots"
 try
 (
 (
			undo "SnapshotsDelete" on
			(
				local deleteConfirmed = g_ZYLB_BH.f_snapshotsDelete()
				if deleteConfirmed then
				(
					btn_deleteSnapshots.enabled = chkbtn_visibleSnapshots.enabled = chkbtn_visibleSnapshots.state = false
					
					--// Update Biped Helper if open
					if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
					(
						g_ZYLB_BH.Reference_Rollout.btn_deleteSnapshots.enabled = g_ZYLB_BH.Reference_Rollout.chkbtn_visibleSnapshots.enabled = g_ZYLB_BH.Reference_Rollout.chkbtn_visibleSnapshots.state = false
					)
				)
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_deleteSnapshots"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on spn_snapshotOpacity changed val do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.spn_snapshotOpacity"
 try
 (
 (
			undo "SnapshotsOpacity" on
			(
				g_ZYLB_BH.f_snapshotsOpacity val
				
				--// Update Biped Helper if open
				if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
				(
					g_ZYLB_BH.Reference_Rollout.spn_snapshotOpacity.value = val
				)
			)
			
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.spn_snapshotOpacity"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_defaultSnapshotOpacity pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_defaultSnapshotOpacity"
 try
 (
 (
			undo "SnapshotsDefaultOpacity" on
			(
				spn_snapshotOpacity.value = g_ZYLB_BH.defaultSnapshotsOpacity
				g_ZYLB_BH.f_snapshotsOpacity g_ZYLB_BH.defaultSnapshotsOpacity
				
				--// Update Biped Helper if open
				if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
				(
					g_ZYLB_BH.Reference_Rollout.spn_snapshotOpacity.value = g_ZYLB_BH.defaultSnapshotsOpacity
				)
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_defaultSnapshotOpacity"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_visibleTrajHelpers changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbtn_visibleTrajHelpers"
 try
 (
 (
			local layerBipedTrajectories = layerManager.getLayerFromName "BIPED_TRAJECTORIES"
			if layerBipedTrajectories != undefined then
			(
				if state then layerBipedTrajectories.isHidden = false
				else layerBipedTrajectories.isHidden = true
			)
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Reference_Rollout.chkbtn_visibleTrajHelpers.state = state
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbtn_visibleTrajHelpers"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbtn_addTrajHelper changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbtn_addTrajHelper"
 try
 (
 (
			local pt = undefined
			if state then
			(
				g_ZYLB_BH.f_addTrajectoryHelper &pt
			)
			chkbtn_addTrajHelper.state = false
			local layerBipedTrajectories = layerManager.getLayerFromName "BIPED_TRAJECTORIES"
			if layerBipedTrajectories != undefined then
			(
				btn_deleteTrajHelpers.enabled = chkbtn_visibleTrajHelpers.enabled = chkbtn_visibleTrajHelpers.state = true
			)
			else
			(
				btn_deleteTrajHelpers.enabled = chkbtn_visibleTrajHelpers.enabled = chkbtn_visibleTrajHelpers.state = false
			)
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				if layerBipedTrajectories != undefined then
				(
					g_ZYLB_BH.Reference_Rollout.btn_deleteTrajHelpers.enabled = g_ZYLB_BH.Reference_Rollout.chkbtn_visibleTrajHelpers.enabled = g_ZYLB_BH.Reference_Rollout.chkbtn_visibleTrajHelpers.state = true
				)
				else
				(
					g_ZYLB_BH.Reference_Rollout.btn_deleteTrajHelpers.enabled = g_ZYLB_BH.Reference_Rollout.chkbtn_visibleTrajHelpers.enabled = g_ZYLB_BH.Reference_Rollout.chkbtn_visibleTrajHelpers.state = false
				)
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbtn_addTrajHelper"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on chkbx_limitTrajDisplay changed state do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.chkbx_limitTrajDisplay"
 try
 (
 (
			maxOps.trimTrajectories = state
			spn_limitStart.enabled = spn_limitEnd.enabled = state
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Reference_Rollout.chkbx_limitTrajDisplay.state = state
				g_ZYLB_BH.Reference_Rollout.spn_limitStart.enabled = g_ZYLB_BH.Reference_Rollout.spn_limitEnd.enabled = state
				g_ZYLB_BH.Reference_Rollout.spn_limitStart.value = spn_limitStart.value
				g_ZYLB_BH.Reference_Rollout.spn_limitEnd.value = spn_limitEnd.value
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.chkbx_limitTrajDisplay"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on spn_limitStart changed val do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.spn_limitStart"
 try
 (
 (
			maxOps.trimTrajectoriesStart = val
			
			if val >= spn_limitEnd.value then
			(
				spn_limitEnd.value = val + 1
			)
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Reference_Rollout.spn_limitStart.value = val
				if val >= g_ZYLB_BH.Reference_Rollout.spn_limitEnd.value then
				(
					g_ZYLB_BH.Reference_Rollout.spn_limitEnd.value = val + 1
				)
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.spn_limitStart"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on spn_limitEnd changed val do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.spn_limitEnd"
 try
 (
 (
			maxOps.trimTrajectoriesEnd = val
			
			if val <= spn_limitStart.value then
			(
				spn_limitStart.value = val - 1
			)
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Reference_Rollout.spn_limitEnd.value = val
				if val <= g_ZYLB_BH.Reference_Rollout.spn_limitStart.value then
				(
					g_ZYLB_BH.Reference_Rollout.spn_limitStart.value = val - 1
				)
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.spn_limitEnd"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
		
		on btn_deleteTrajHelpers pressed do
		(
 ZYDiagEvent "tool_begin" "BipedPicker_Rollout.btn_deleteTrajHelpers"
 try
 (
 (
			g_ZYLB_BH.f_trajectoryHelpersDelete()
			btn_deleteTrajHelpers.enabled = chkbtn_visibleTrajHelpers.enabled = chkbtn_visibleTrajHelpers.state = false
			
			--// Update Biped Helper if open
			if g_ZYLB_BH.bipedUI_Floater != undefined AND g_ZYLB_BH.bipedUI_Floater.open then
			(
				g_ZYLB_BH.Reference_Rollout.btn_deleteTrajHelpers.enabled = g_ZYLB_BH.Reference_Rollout.chkbtn_visibleTrajHelpers.enabled = g_ZYLB_BH.Reference_Rollout.chkbtn_visibleTrajHelpers.state = false
			)
		)
 ZYDiagEvent "tool_end" "BipedPicker_Rollout.btn_deleteTrajHelpers"
 )catch(
 ZYDiagEvent "script_error" (getCurrentException())
 throw()
 )
)
	) --// end rollout

	fn f_openBipedPickerUI =
	(
		g_ZYLB_BH.BP_pos = g_ZYLB_BH.f_readIniPosition "Picker" g_ZYLB_BH.defaultPos
		g_ZYLB_BH.BP_state = g_ZYLB_BH.f_readIniIndex "Picker" "Height" 2
		g_ZYLB_BH.a_bips = #()
		g_ZYLB_BH.f_collectBipRoots()
		if g_ZYLB_BH.a_bips.count > 0 then
		(
			try(destroyDialog g_ZYLB_BH.BipedPicker_Rollout)catch()
			createDialog g_ZYLB_BH.BipedPicker_Rollout width:300 height:g_ZYLB_BH.BP_height[g_ZYLB_BH.BP_state] pos:g_ZYLB_BH.BP_pos
		)
		else
		(
			ZYDiagMessageBox "场景中没有 Biped。请载入角色或创建 Biped 后重试。" title:"Biped 选择器"
			setIniSetting g_ZYLB_BH.bhINIfile "BipedPanel" "CurrentBip" "1"
			try(destroyDialog g_ZYLB_BH.BipedPicker_Rollout)catch()
		)
	)

	g_ZYLB_BH.f_openBipedPickerUI()
)

) --// end struct

g_ZYLB_BH = s_ZYLB_bipedHelper()


/*********************************************************************************************************************************************************************/
--// MACRO CALLS FOR UI
/*********************************************************************************************************************************************************************/

macroScript ZYLB_bipedHelper
	category:"Zhuoyu Biped"
	buttontext:"完整 Biped 助手 1.9.9"
	icon:#("ZYLB_BipedHelper",1)
	tooltip:"完整 Biped 助手：中文 / English"
(
	if keyboard.shiftPressed then
	(
		g_ZYLB_BH.f_bipedPickerUI()
	)
	else
	(
		g_ZYLB_BH.f_bipedHelperUI()
	)
)

/*********************************************************************************************************************************************************************/

macroScript ZYLB_bipedHelperPicker
	category:"Zhuoyu Biped"
	buttontext:"Biped 选择器 1.9.9"
	icon:#("ZYLB_BipedHelper_Picker",1)
	tooltip:"Biped 选择器：中文 / English"
(
	if keyboard.shiftPressed then
	(
		g_ZYLB_BH.f_bipedHelperUI()
	)
	else
	(
		g_ZYLB_BH.f_bipedPickerUI()
	)
)

/*********************************************************************************************************************************************************************/
