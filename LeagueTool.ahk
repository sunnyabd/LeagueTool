#NoEnv  
SendMode Input  
SetWorkingDir %A_ScriptDir%  
#include Class_CtlColors.ahk
#include JSON.ahk
#include Jxon.ahk
#singleinstance, Force
;Todo
; remember to set to correct date update code

; updating function
; add internet connection
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
global imageDir := A_ScriptDir . "\img"
togSyn := 0
togCur := 0
togSet := 0
sectionSyndicate := "Members"
sectionHotkeys := "Hotkeys"
sectionOthers := "Others"
sectionCurrency := "Currency"
sectionScarab := "Scarab"
user_settings_path := A_ScriptDir . "/user_settings.ini"


; Load Settings
ini := new ini(user_settings_path)
MemDict := ini.Load(sectionSyndicate)
hotkeyDict := ini.Load(sectionHotkeys)
currencyDict := ini.Load(sectionCurrency)
scarabDict := ini.Load(sectionScarab)
league := ini.Load(sectionOthers, "League")
if(A_YYYY . A_MM . A_DD != ini.Load(sectionOthers, "Last_Updated")){
	try{
		SplashTextOn,300,30,, Updating poe.ninja data...
		scarabDict := update.scarab(league)
		SplashTextOn,300,30,, Values updated from poe.ninja! 
		sleep 1000
		SplashTextOff
		;iniSave(user_settings_path, A_YYYY . A_MM . A_DD,sectionOthers, "Last_Updated")
		ini.Save(scarabDict, sectionScarab)
	}
	catch e {
		SplashTextOn,300,30,, Could not load new values from poe.ninja.
		sleep 2000
		SplashTextOff
	}
}

SplashTextOn,300,30,, Leaguetools loaded!
sleep 700
SplashTextOff

;Load Hotkeys
gosub, loadHotkeys

#Persistent
ImageOn := 0
Menu, Tray, Add
Menu, Tray, Add, Settings, Settings ;Creates settings tab in tray icon menu
return

;##############################################################################
; Subs
;##############################################################################

loadHotkeys:
for x, y in hotkeyDict{
	hotkey, %y%, %x%
}
return


Currency_Ratio:
currencyDict := update.currency(league)
ini.Save(currencyDict, sectionCurrency)
togCur := toggleCur(currencyDict, togCur)
return

Syndicate_Table:
togSyn := toggleSyn(memDict, togSyn)
return

Settings:
if (togSet = 0){
	Gosub,SettingsGUI
	togSet := 1
}else{
	Gui, LTSettingsName:Destroy
	togSet := 0
}
return

SettingsGUI:
; Dimensional constants
;gui
guiWidth := 1685
guiHeight := 620
;radio
xRadioOrigin := 83
yRadioOrigin := 201
columnWidth := 80
rowHeight := 120
radioWidth := columnWidth - 3
radioHeight := 19
;clears
clearWidth := 70
clearHeight := 30
clearY := 584
;hotkeys
xHotkeysOrigin := 1445
yHotkeysOrigin := 60
xHotkeysOffset := 100
yHotkeysOffset := 25
hotkeyTextWidth := 95
hotkeyTextHeight := 20
;save button
xButtonOrigin := 1586
yButtonOrigin := clearY + 4
buttonWidth := 90
buttonHeight := 24
; Naming constants
radioHwnd = RB
; Color constants
lightGrey := "4B4B4B"
darkGrey := "424242"

; Initialize GUI
Gui, LTSettingsName:New
Gui, Add, Picture, x0 y0 w%guiWidth% h%guiHeight% , %imageDir%\SyndicateTable.png

rcounter := 1
ccounter := 1
counter := 1
try{
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
				Gui, Add, Radio, x%px% y%py% w%radioWidth% h%radioHeight% hwnd%radioHwnd%%counter% Checked%checker% Group v%x% cFFFFFF Center,
			}else if(rcounter<5){
				Gui, Add, Radio, x%px% y%py% w%radioWidth% h%radioHeight% hwnd%radioHwnd%%counter% Checked%checker% cFFFFFF Center,
			}else{
				px := px - 1 ;to align with above radios due to width difference
				Gui, Add, Radio, x%px% y%clearY% w%clearWidth% h%clearHeight% hwnd%radioHwnd%%counter% +Centred Checked%checker%, Clear
				clearColor := "White"
			}
			
			
			if(rcounter=5){
				CtlColors.Attach(%radioHwnd%%counter%, darkGrey, "White")
			}else if(Mod((rcounter+ccounter),2)=0){
				CtlColors.Attach(%radioHwnd%%counter%, darkGrey, "White")
			}else{
				CtlColors.Attach(%radioHwnd%%counter%, lightGrey, "White")
			}
			
			counter++ 
			clearColor := ""
			rcounter++
		}
		
		rcounter := 1
		ccounter++
	}
	
	GuiControl, Text, %RB4%, % scarabDict["gilded-metamorph-scarab"]
	GuiControl, Text, %RB9%, % scarabDict["gilded-sulphite-scarab"]
	GuiControl, Text, %RB14%, % scarabDict["gilded-reliquary-scarab"]
	GuiControl, Text, %RB19%, % scarabDict["gilded-divination-scarab"]
	GuiControl, Text, %RB29%, % scarabDict["gilded-ambush-scarab"]
	GuiControl, Text, %RB39%, % scarabDict["gilded-breach-scarab"]
	GuiControl, Text, %RB44%, % scarabDict["gilded-perandus-scarab"]
	GuiControl, Text, %RB49%, % scarabDict["gilded-bestiary-scarab"]
	GuiControl, Text, %RB54%, % scarabDict["gilded-elder-scarab"]
	GuiControl, Text, %RB59%, % scarabDict["gilded-torment-scarab"]
	GuiControl, Text, %RB69%, % scarabDict["gilded-cartography-scarab"]
	GuiControl, Text, %RB74%, % scarabDict["gilded-harbinger-scarab"]
	GuiControl, Text, %RB79%, % scarabDict["gilded-legion-scarab"]
	GuiControl, Text, %RB84%, % scarabDict["gilded-shaper-scarab"]
	
	rcounter := 1
	for x, y in hotkeyDict{
		px := xHotkeysOrigin + xHotkeysOffset
		py := yHotkeysOrigin + (rcounter - 1)*yHotkeysOffset
		Gui, Add, Text, x%xHotkeysOrigin% y%py% w%hotkeyTextWidth% h%hotkeyTextWidth% hwndhotkeyText Right, %x% : 
		Gui, Add, Hotkey, x%px% y%py% v%x%, %y%
		CtlColors.Attach(hotkeyText, darkGrey, "White")
		rcounter++
	}
	
	px := xHotkeysOrigin + xHotkeysOffset
	py := yHotkeysOrigin + (rcounter - 1)*yHotkeysOffset
	Gui, Add, Text, x%xHotkeysOrigin% y%py% w%hotkeyTextWidth% h%hotkeyTextWidth% hwndhotkeyText Right, League :
	Gui, Add, DropDownList,x%px% y%py% w%hotkeyTextWidth% h%hotkeyTextWidth% vLeague1 Choose%league%, Standard||Harvest
	CtlColors.Attach(hotkeyText, darkGrey, "White")
	Gui, Add, Button, x%xButtonOrigin% y%yButtonOrigin% w%buttonWidth% h%buttonHeight% gSubmit, Save
} catch e{
	SplashTextOn,300,30,Couldnt load Settings GUI
	sleep 1000
	SplashTextOff
}

Gui, Show, Center w%guiWidth% h%guiHeight%, Settings
return


GuiClose:
Gui, Destroy
togSet := 0
return


Submit:
Gui, Submit, NoHide
for x, y in memDict{
	memDict[x] := %x%
}
for x, y in hotkeyDict{
	hotkey, %y%, empty
	hotkeyDict[x] := %x%
}
Gosub, loadHotkeys
league := League1
ini.Save(league, sectionOthers, "League")
ini.Save(memDict, sectionSyndicate)
ini.Save(hotkeyDict, sectionHotkeys)
togCur := toggleCur(currencyDict, 1)
togSyn := toggleSyn(memDict, 1)
return

empty:
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
	yOrigin := 330
	numStates := 5
	WinGet, windowName, ID, Path of Exile
	if((tog=0) and windowName){
		Gui, Synoverlay:New
		For x, y in memDict{
			if(0 < y and y < numStates){
				total := splashStatus[1]+splashStatus[2]+splashStatus[3]+splashStatus[4]+1
				xpos := imgWidth*splashStatus[y]
				ypos := ((y-1)*imgHeight)
				Gui, Add, Picture, X%xpos% Y%ypos%, %imageDir%\Members\%x%.jpg
				splashStatus[y]++
			}
		}
		Gui, -Caption +LastFound +ToolWindow +OwnDialogs -Sysmenu
		Gui, Synoverlay: +Owner%windowName% 
		Gui, Show, x%xOrigin% y%yOrigin% h600 w1000
		Gui, Color, EEAA99
		WinSet, TransColor, EEAA99 255
		tog := 1
	}else{
		Gui, Synoverlay:Destroy
		tog := 0
	}
	return tog
}


toggleCur(dict, tog){
	xOrigin := 0
	yOrigin := 155
	
	imageWidth := 220
	imageHeight := 120
	
	xTextOrigin := 61
	yTextOrigin := 30 
	textWidth := 100
	textHeight := 40
	
	exSell := dict["exSell"]
	exBuy := dict["exBuy"]
	WinGet, windowName, ID, Path of Exile
	if ((tog = 0) and windowName){
		
		Gui, Currency:New
		Gui, Color, 424242
		Gui, Add, Picture, x0 y0 w220 h120 , %imageDir%\Currency.png
		Gui, Font, s13, 
		Gui, Add, Text, x%xTextOrigin% y%yTextOrigin%  w100 h40 +Center hwndText1 cFFFFFF , %exSell%  :  1 
		Gui, Add, Text, x%xTextOrigin% y%yTextOrigin% y+5 w100 h40 +Center hwndText1 cFFFFFF, 1  : %exBuy%
		Gui, -Caption +LastFound +ToolWindow +OwnDialogs -Sysmenu
		Gui, Currency: +Owner%windowName%
		Gui, Currency:Show, x%xOrigin% y%yOrigin% w220 h120, New GUI Window
		tog:=1
	}else{
		Gui, Currency:Destroy
		tog:=0
	}
	return tog
}

PairMembers(mem, arr)
{
	coun := 1
	For x in mem
	{
		mem[x] := arr[coun]
		coun++
	}
	return mem
}


;##############################################################################
; Classes
;##############################################################################

class ini{
	__New(path){
		this.path := path 
	}
	Load(sect, key := "")
	{
		path := this.path
	; Loads and formats data into a dict
		if key{
			IniRead, Output, %path%, %sect%, %key%
		}else{
			IniRead, sOutput, %path%, %sect%
			Output := Object()
			settingRows := StrSplit(sOutput, "`n")
			For x, y in settingRows
			{
				temp := StrSplit(y, "=")
				Output[temp[1]] := temp[2]
			}
		}
		return Output
	}
	
	Save(pairs ,sect, key := "")
	{
		path := this.path		
		if key{
			IniDelete, %path%, %sect%, %key%
			IniWrite, %pairs%, %path%, %sect%, %key%
		} else {
			IniDelete, %path%, %sect%
			for x, y in pairs{
				IniWrite, %y%, %path%, %sect%, %x%
			}
		}
		return
	}
}


class update{
	static url := "https://poe.ninja/api/data/"
	currency(league){
		url := this.url
		url .= "currencyoverview?type=Currency"
		url .= "&league=" . league
		jsonCurrency := this.connect(url)
		output := {}
		for x, y in jsonCurrency["lines"]{
			if (y["detailsId"] = "exalted-orb"){
				SetFormat,float, 0.2
				exSell := 1*(1/y["pay"]["value"])
				exBuy := 1*y["receive"]["value"]
				output["exSell"] := exSell
				output["exBuy"] := exBuy
				return output
			}
		}
		return
	}
	
	scarab(league){
		total_scarabs := 14
		url := this.url
		url .= "itemoverview?type=Scarab"
		url .= "&league=" . league
		jsonScarabs := this.connect(url)
		output := {}
		for x, y in jsonScarabs["lines"]{
			if InStr(y["detailsId"], "gilded") {
				output[y["detailsId"]] := y["chaosValue"]
			}
			if (output.Count() > total_scarabs){
				return output
			}
		}
		return output
	}
	
	connect(url){
		con := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		con.Open("GET", url, true)
		con.Send()
		con.WaitForResponse()
		data := con.ResponseText
		parsedData := JSON.Load(data)
		return parsedData
	}
}