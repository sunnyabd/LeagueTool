#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

user_settings_path := A_ScriptDir . "/user_settings.ini"
GoSub, LoadSettings
MsgBox sOutput[1]

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
IniDelete, %Something%, Members
IniWrite, %Ais%, %Something%, Members, Aisling
IniWrite, %Cam%, %Something%, Members, Cameria
IniWrite, %Elr%, %Something%, Members, Elreon
IniWrite, %Gra%, %Something%, Members, Gravicius
IniWrite, %Guf%, %Something%, Members, Guff
IniWrite, %Hak%, %Something%, Members, Haku
IniWrite, %Hil%, %Something%, Members, Hillock
IniWrite, %Itt%, %Something%, Members, ItThatFled
IniWrite, %Jan%, %Something%, Members, Janus
IniWrite, %Jor%, %Something%, Members, Jorgin
IniWrite, %Kor%, %Something%, Members, Korell
IniWrite, %Leo%, %Something%, Members, Leo
IniWrite, %Rik%, %Something%, Members, Riker
IniWrite, %Rin%, %Something%, Members, Rin
IniWrite, %Tor%, %Something%, Members, Tora
IniWrite, %Vag%, %Something%, Members, Vagan
IniWrite, %Vor%, %Something%, Members, Vorici
return

;##############################################################################
; Functions
;##############################################################################