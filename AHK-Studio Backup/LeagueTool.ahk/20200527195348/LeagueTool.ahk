#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

user_settings_path := A_ScriptDir . "/user_settings.ini"
GoSub, LoadSettings
MsgBox %sOutput%

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
	return
	
	GuiClose:
	Gui, Destroy
	return

	
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
	IniRead, sOutput, %user_settings_path%, Members
	Member_Settings := Object()
	memSection := StrSplit(sOutput, "`n")
	MsgBox memSection . "Hello"
	For x in memSection
	{
		temp := StrSplit(x, =, A_Space)
		MsgBox %temp%
		Member_Settings[(temp[0])] := temp[1]
		MsgBox %Member_Settings%
	}
	return


SaveSettings:
	IniDelete, %user_settings_path%, Members
	IniWrite, %Ais%, %user_settings_path%, Members, Aisling
	IniWrite, %Cam%, %user_settings_path%, Members, Cameria
	IniWrite, %Elr%, %user_settings_path%, Members, Elreon
	IniWrite, %Gra%, %user_settings_path%, Members, Gravicius
	IniWrite, %Guf%, %user_settings_path%, Members, Guff
	IniWrite, %Hak%, %user_settings_path%, Members, Haku
	IniWrite, %Hil%, %user_settings_path%, Members, Hillock
	IniWrite, %Itt%, %user_settings_path%, Members, ItThatFled
	IniWrite, %Jan%, %user_settings_path%, Members, Janus
	IniWrite, %Jor%, %user_settings_path%, Members, Jorgin
	IniWrite, %Kor%, %user_settings_path%, Members, Korell
	IniWrite, %Leo%, %user_settings_path%, Members, Leo
	IniWrite, %Rik%, %user_settings_path%, Members, Riker
	IniWrite, %Rin%, %user_settings_path%, Members, Rin
	IniWrite, %Tor%, %user_settings_path%, Members, Tora
	IniWrite, %Vag%, %user_settings_path%, Members, Vagan
	IniWrite, %Vor%, %user_settings_path%, Members, Vorici
	return

;##############################################################################
; Functions
;##############################################################################