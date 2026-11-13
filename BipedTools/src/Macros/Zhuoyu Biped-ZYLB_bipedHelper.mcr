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

