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
