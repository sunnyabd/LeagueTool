#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include Class_CtlColors.ahk
#singleinstance force
;Todo
; adjust based on screen size
; Variable Image Size
; Timer function for farmville
; Item Desc on syntable
; Currency equiv

; fix splash always on top (Problem lies with Vulkan engine) (might be fixed?)

; Done
; Design and finish the splash...
; Fix bug where u can minimize and reopen LTSettings
;##############################################################################
; Init
;##############################################################################
tog := 0
sectionSyndicate := "Members"
sectionHotkeys := "Hotkeys"

; Load Settings
user_settings_path := A_ScriptDir . "/user_settings.ini"
MemDict := LoadSection(user_settings_path, sectionSyndicate)
hotkeyDict := LoadSection(user_settings_path, sectionHotkeys)

;Load Hotkeys
gosub, loadHotkeys

#Persistent
ImageOn := 0
Menu, Tray, Add
Menu, Tray, Add, Settings, LTSettings ;Creates settings tab in tray icon menu
return

;##############################################################################
; Subs
;##############################################################################

loadHotkeys:
hotkeySettings := hotkeyDict["Settings"]
hotkeySyndicateTable := hotkeyDict["SyndicateTable"]
hotkey, %hotkeySettings%, LTSettings, 
hotkey, %hotkeySyndicateTable%, toggleSynSub, Toggle
return

toggleSynSub:
tog := toggleSyn(memDict, tog)
return

LTSettings:
; Dimensional constants
xRadioOrigin := 80
yRadioOrigin := 175
columnWidth := 80
rowHeight := 100
radioWidth := 15
radioHeight := 15
clearWidth := 70
clearHeight := 30
clearY := 500
xHotkeysOrigin := xRadioOrigin
yHotkeysOrigin := yRadioOrigin+(4*rowHeight)
xHotkeysOffset := 100
yHotkeysOffset := 25
hotkeyTextWidth := 95
hotkeyTextHeight := 20
; Naming constants
radioHwnd = RB
; Color constants
lightGrey := "4B4B4B"
darkGrey := "424242"

; Initialize GUI
Gui, LTSettingsName:New
Gui, Add, Picture, x-8 y-1 w1440 h600 , E:\GitHub\LeagueTool\SyndicateTable1.png

rcounter := 1
ccounter := 1
for x, y in MemDict{
	Loop, 5{
		px := xRadioOrigin + ((ccounter-1)*columnWidth)
		py := yRadioOrigin + ((rcounter-1)*rowHeight)
		if(rcounter = y){
			checker := 1
		}else{
			checker := 0
		}
		
		; Generates radio buttons with conditions for:
		; 1) First button in Group
		; 2) rest of Group
		; 3) clear button
		if(rcounter = 1){
			Gui, Add, Radio, x%px% y%py% w%radioWidth% h%radioHeight% hwnd%radioHwnd% Checked%checker% Group v%x%,
		}else if(rcounter<5){
			Gui, Add, Radio, x%px% y%py% w%radioWidth% h%radioHeight% hwnd%radioHwnd% Checked%checker%,
		}else{
			px := px - 1 ;to align with above radios due to width difference
			Gui, Add, Radio, x%px% y%clearY% w%clearWidth% h%clearHeight% hwnd%radioHwnd% +Centred Checked%checker%, Clear
			clearColor := "White"
		}
		
		if(rcounter=5){
			CtlColors.Attach(%radioHwnd%, darkGrey, clearColor)
		}else if(Mod((rcounter+ccounter),2)=0){
			CtlColors.Attach(%radioHwnd%, darkGrey, clearColor)
		}else{
			CtlColors.Attach(%radioHwnd%, lightGrey, clearColor)
		}
		
		clearColor := ""
		rcounter := rcounter + 1
	}
	
	rcounter := 1
	ccounter := ccounter + 1
}
MsgBox 2

rcounter := 1
for x, y in hotkeyDict{
	MsgBox 1
	px := xHotkeysOrigin + xHotkeysOffset
	py := yHotkeysOrigin + (rcounter - 1)*yHotkeysOffset
	Gui, Add, Text, x%xHotkeysOrigin% y%py% w%hotkeyTextWidth% h%hotkeyTextWidth% hwndhotkeyText Right, %x% : 
	Gui, Add, Hotkey, x%px% y%py% v%x%, %y%
	CtlColors.Attach(hotkeyText, darkGrey, "White")
	rcounter := rcounter + 1
}
;Gui, Add, Hotkey, x%columnWidth% y570 h15 w135 vsyndicateHotkey
;Gui, Add, Hotkey, x%columnWidth% x+10 y570 h15 w135 vsettingsHotkey
Gui, Add, Button, x1312 y549 w100 h30 gSubmit, Button
Gui, Show, x265 y170 h702 w1534, Settings
return


GuiClose:
Gui, Destroy
return


Submit:
Gui, Submit, NoHide
for x, y in memDict{
	memDict[x] := %x%
}
for x, y in hotkeyDict{
	hotkeyDict[x] := %x%
}

SaveSettings(user_settings_path, memDict, sectionSyndicate)
SaveSettings(user_settings_path, hotkeyDict, sectionHotkeys)
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
	imgWidth := 71
	imgHeight := 89
	xOrigin := 0
	yOrigin := 270
	numStates := 5
	if(tog=0){
		Gui, Synoverlay:New
		Gui, Color, EEAA99
		For x, y in memDict{
			if(0 < y and y < numStates){
				total := splashStatus[1]+splashStatus[2]+splashStatus[3]+splashStatus[4]+1
				xpos := imgWidth*splashStatus[y]
				ypos := ((y-1)*imgHeight)
				Gui, Add, Picture, X%xpos% Y%ypos%, %A_ScriptDir%/Members/%x%.jpg
				splashStatus[y] := splashStatus[y] + 1
			}
		}
		Gui, -Caption +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs -Sysmenu
		Gui, Show, x%xOrigin% y%yOrigin% h600 w1000
		WinSet, TransColor, EEAA99 255
		tog := 1
	}else{
		Gui, Synoverlay:Destroy
		tog := 0
	}
	return tog
}

LoadSection(path, sect)
{
	; Initialize user_settings
	IniRead, sOutput, %path%, %sect%
	Settings := Object()
	settingRows := StrSplit(sOutput, "`n")
	For x, y in settingRows
	{
		temp := StrSplit(y, "=")
		Settings[temp[1]] := temp[2]
	}
	return Settings
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