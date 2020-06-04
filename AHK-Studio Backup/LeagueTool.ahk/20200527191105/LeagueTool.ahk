#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

user_settings_path := A_ScriptDir . "/user_settings.ini"
GoSub, LoadSettings

#Persistent
ImageOn := 0
Menu, Tray, Add
Menu, Tray, Add, Settings, MenuHandler
return


MenuHandler:
	Gui, Add, Picture, x112 y39 w690 h290 , %A_ScriptDir%\syndicate.jpg
	Gui, Add, Text, x142 y379 w200 h30 , test
	Gui, Add, Button, x672 y489 w90 h30 gButton1, Button
	Gui, Add, Radio, x132 y119 w40 h30 Group vAis, 1
	Gui, Add, Radio, x132 y179 w40 h30 , 2
	Gui, Add, Radio, x132 y239 w40 h30 , 3
	Gui, Add, Radio, x132 y299 w40 h30 , 4
	Gui, Add, Radio, x172 y119 w40 h30 Group vCam, 1
	Gui, Add, Radio, x172 y179 w40 h30 , 2
	Gui, Add, Radio, x172 y239 w40 h30 , 3
	Gui, Add, Radio, x172 y299 w40 h30 , 4
	; Generated using SmartGUI Creator 4.0
	Gui, Show, x442 y225 h627 w929, New GUI Window
	Return

	
Button1:
	Gui, Submit, NoHide
	Gosub, SaveSettings
	Msgbox %Ais%, %Cam%
	return

transportAis:
	if (tAis = 0){
		tAis := 1
	}else{
		tAis := 0
	}
	return

transportCam:
	if (tCam = 0){
		tCam := 1
	}else{
		tCam := 0
	}
	return

^j::
if (ImageOn = 0){
	SplashImage, %A_ScriptDir%/syndicate.jpg
	ImageOn := 1
	}else{
	SplashImage, Off
	ImageOn := 0
	}
return



^q::
ExitApp

;##############################################################################
; GoSubs
;##############################################################################
LoadSettings:
	; Initialize user_settings
	IniRead, sOutput, %something%, Something
	return
	

SaveSettings:
	IniDelete, %Something%, Something ,Transport_Aisling
	IniWrite, %Ais%, %A_ScriptDir%/user_settings.ini, Something, Transport_Aisling ;%A_ScriptDir%/user_settings.ini
	return