#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

user_settings_path := A_ScriptDir . "/user_settings.ini"
Members := LoadSettings(user_settings_path, "Members")

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
stoArray := [Ais, Cam]
Members := PairMembers(Members, stoArray)
SaveSettings(user_settings_path, Members, "Members")
return


^j::
if (ImageOn = 0){
	SplashImage , 1:%A_ScriptDir%/dog1.jpg, B X0 Y100
	SplashImage , 2:%A_ScriptDir%/dog2.jpg, B X0 Y250
	ImageOn := 1
}else{
	SplashImage ,1: Off
	SplashImage ,2: Off
	ImageOn := 0
}
return



^q::
ExitApp

;##############################################################################
; GoSubs
;##############################################################################


;##############################################################################
; Functions
;##############################################################################

LoadSettings(path, sect)
{
	; Initialize user_settings
	IniRead, sOutput, %path%, %sect%
	Member_Settings := Object()
	memSection := StrSplit(sOutput, "`n")
	For x, y in memSection
	{
		temp := StrSplit(y, "=")
		Member_Settings[temp[1]] := temp[2]
	}
	return Member_Settings
}


SaveSettings(path, pairs ,sect)
{
	IniDelete, %path%, %sect%
	for x, y in pairs
	{
		IniWrite, %y%, %path%, %sect%, %x%
	}
	return
}

PairMembers(mem, arr)
{
	coun := 1
	For x in mem
	{
		mem[x] := arr[coun]
		coun := coun+1
	}
	return mem
}

