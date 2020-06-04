#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;##############################################################################
; Init
;##############################################################################
tog := 0
user_settings_path := A_ScriptDir . "/user_settings.ini"
MemDict := LoadSettings(user_settings_path, "Members")

#Persistent
ImageOn := 0
Menu, Tray, Add
Menu, Tray, Add, Settings, LTSettings ;Creates settings tab in tray icon menu
return

;##############################################################################
; Main Code
;##############################################################################

^j::
tog := toggleSyn(memDict, tog)
return



^q::
ExitApp

;##############################################################################
; GoSubs
;##############################################################################

LTSettings:
Gui, +AlwaysOnTop
Gui, Add, Picture, x112 y39 w690 h290 , %A_ScriptDir%\syndicate.jpg
Gui, Add, Text, x142 y379 w200 h30 , test
Gui, Add, Button, x672 y489 w90 h30 gButton1, Button
Gui, Add, Radio, x132 y119 w40 h30 Group vAis, 1
Gui, Add, Radio, x132 y179 w40 h30 , 2
Gui, Add, Radio, x132 y239 w40 h30 , 3,  Checked
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
memArr := [Ais, Cam]
MemDict := PairMembers(MemDict, memArr)
SaveSettings(user_settings_path, memDict, "Members")
toggleSyn(memDict, 1)
tog := 0
return

;##############################################################################
; Functions
;##############################################################################

toggleSyn(memDict, tog)
{	
	;Constants
	splashStatus := [0,0,0,0]
	if(tog=0){
		For x, y in memDict{
			if(memDict[x] != 0){
				total := splashStatus[1]+splashStatus[2]+splashStatus[3]+splashStatus[4]+1
				xpos := 60*splashStatus[y]
				ypos := 270+((y-1)*75)
				SplashImage , %total%:%A_ScriptDir%/%x%.png, B X%xpos% Y%ypos%
				splashStatus[y] := splashStatus[y] + 1
			}
		}
		tog := 1
	}else{
		counter := 1
		Loop, 10{
			SplashImage , %counter%: Off
			counter := counter +1 
		}
		tog := 0
	}
	return tog
}

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

