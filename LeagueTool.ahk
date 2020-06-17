#NoEnv  
SendMode Input  
SetWorkingDir %A_ScriptDir%  
#include scripts\Class_CtlColors.ahk
#include scripts\JSON.ahk
#include scripts\Jxon.ahk
#singleinstance, Force

;##############################################################################
; Init
;##############################################################################
global imageDir := A_ScriptDir . "\img"
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
update := new update(league)

try{
	SplashTextOn,300,30,, Updating poe.ninja data...
	scarabDict := update.scarab()
	currencyDict := update.currency()
	SplashTextOn,300,30,, Values updated from poe.ninja! 
	sleep 1000
	SplashTextOff
	ini.Save(scarabDict, sectionScarab)
}catch e {
	SplashTextOn,300,30,, Could not load new values from poe.ninja.
	sleep 2000
	SplashTextOff
}

syn := new syndicate(memDict)
cur := new currency(currencyDict)
SetTimer, currencyUpdate, 600000


SplashTextOn,300,30,, Leaguetools loaded!
sleep 700
SplashTextOff

;Load Hotkeys
gosub, loadHotkeys

#Persistent
Menu, Tray, Add
Menu, Tray, Add, Settings, SettingsGUI ;Creates settings tab in tray icon menu
return

;##############################################################################
; Subs
;##############################################################################

loadHotkeys:
for x, y in hotkeyDict{
	hotkey, %y%, %x%, On
}
return

currencyUpdate:
if !cur{
	cur := new currency(memDict)
}
currencyDict := update.currency()
cur.update(currencyDict)
return

Currency_Ratio:
if(WinActive("ahk_exe PathOfExile.exe") or WinActive("ahk_exe PathOfExile_x64.exe")){
	if !cur{
		cur := new currency(memDict)
	}
	cur.toggle()
}
return

Syndicate_Table:
if(WinActive("ahk_exe PathOfExile.exe") or WinActive("ahk_exe PathOfExile_x64.exe")){
	if !syn{
		syn := new syndicate(memDict)
	}
	syn.toggle()
}
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
yHotkeysOrigin := 75
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

togSet := 1

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
				Gui, LTSettingsName:Add, Radio, x%px% y%py% w%radioWidth% h%radioHeight% hwnd%radioHwnd%%counter% Checked%checker% Group v%x% cFFFFFF Center,
			}else if(rcounter<5){
				Gui, LTSettingsName:Add, Radio, x%px% y%py% w%radioWidth% h%radioHeight% hwnd%radioHwnd%%counter% Checked%checker% cFFFFFF Center,
			}else{
				px := px - 1 ;to align with above radios due to width difference
				Gui, LTSettingsName:Add, Radio, x%px% y%clearY% w%clearWidth% h%clearHeight% hwnd%radioHwnd%%counter% +Centred Checked%checker%, Clear
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
	
	; tag scarab prices
	GuiControl, LTSettingsName:Text, %RB4%, % scarabDict["gilded-metamorph-scarab"]
	GuiControl, LTSettingsName:Text, %RB9%, % scarabDict["gilded-sulphite-scarab"]
	GuiControl, LTSettingsName:Text, %RB14%, % scarabDict["gilded-reliquary-scarab"]
	GuiControl, LTSettingsName:Text, %RB19%, % scarabDict["gilded-divination-scarab"]
	GuiControl, LTSettingsName:Text, %RB29%, % scarabDict["gilded-ambush-scarab"]
	GuiControl, LTSettingsName:Text, %RB39%, % scarabDict["gilded-breach-scarab"]
	GuiControl, LTSettingsName:Text, %RB44%, % scarabDict["gilded-perandus-scarab"]
	GuiControl, LTSettingsName:Text, %RB49%, % scarabDict["gilded-bestiary-scarab"]
	GuiControl, LTSettingsName:Text, %RB54%, % scarabDict["gilded-elder-scarab"]
	GuiControl, LTSettingsName:Text, %RB59%, % scarabDict["gilded-torment-scarab"]
	GuiControl, LTSettingsName:Text, %RB69%, % scarabDict["gilded-cartography-scarab"]
	GuiControl, LTSettingsName:Text, %RB74%, % scarabDict["gilded-harbinger-scarab"]
	GuiControl, LTSettingsName:Text, %RB79%, % scarabDict["gilded-legion-scarab"]
	GuiControl, LTSettingsName:Text, %RB84%, % scarabDict["gilded-shaper-scarab"]
	
	; create hotkey options
	rcounter := 1
	for x, y in hotkeyDict{
		px := xHotkeysOrigin + xHotkeysOffset
		py := yHotkeysOrigin + (rcounter - 1)*yHotkeysOffset
		Gui, LTSettingsName:Add, Text, x%xHotkeysOrigin% y%py% w%hotkeyTextWidth% h%hotkeyTextWidth% hwndhotkeyText Right, %x% : 
		Gui, LTSettingsName:Add, Hotkey, x%px% y%py% v%x%, %y%
		CtlColors.Attach(hotkeyText, darkGrey, "White")
		rcounter++
	}
	
	; create league options & show GUI
	px := xHotkeysOrigin + xHotkeysOffset
	py := yHotkeysOrigin + (rcounter - 1)*yHotkeysOffset
	Gui, LTSettingsName:Add, Text, x%xHotkeysOrigin% y%py% w%hotkeyTextWidth% h%hotkeyTextWidth% hwndhotkeyText Right, League :
	Gui, LTSettingsName:Add, DropDownList,x%px% y%py% w%hotkeyTextWidth% h%hotkeyTextWidth% vLeague1, Standard||Harvest
	GuiControl, ChooseString, League1, % league
	CtlColors.Attach(hotkeyText, darkGrey, "White")
	Gui, LTSettingsName:Add, Button, x%xButtonOrigin% y%yButtonOrigin% w%buttonWidth% h%buttonHeight% gSubmit, Save
} catch e{
	SplashTextOn,300,30,, Couldnt load Settings GUI
	sleep 1000
	SplashTextOff
}

Gui, LTSettingsName:Show, Center w%guiWidth% h%guiHeight%, Settings
return


GuiClose:
Gui, Destroy
togSet := 0
return

; Submit button
; Saves all settings into ini file & closes all overlays
Submit:
Gui, Submit, NoHide
for x, y in memDict{
	memDict[x] := %x%
}
for x, y in hotkeyDict{
	hotkey, %y%, %x%, Off
	hotkeyDict[x] := %x%
}
Gosub, loadHotkeys
league := League1
ini.Save(league, sectionOthers, "League")
ini.Save(memDict, sectionSyndicate)
ini.Save(hotkeyDict, sectionHotkeys)
update := new update(league)
scarabDict := update.scarab()
currencyDict := update.currency()
cur := new currency(currencyDict)
syn := new syndicate(memDict)
Gosub, SettingsGUI
return


;##############################################################################
; Functions
;##############################################################################

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

; Class for syndicate overlay
class syndicate{
	
	imgWidth := 71
	imgHeight := 89
	xOrigin := 0
	yOrigin := 330
	numStates := 5
	
	toggler := 0
	
	; Creates syndicate overlay GUI in background
	__New(memDict){
		; Destroy any current gui in background
		Gui, Synoverlay:Destroy
		this.toggler := 0
		xOrigin := this.xOrigin
		yOrigin := this.yOrigin
		splashStatus := [0,0,0,0]
		
		WinGet, windowName, ProcessName, Path of Exile
		windowName := WinExist("ahk_exe PathOfExile_x64.exe")
		if (!windowName){
			windowName := WinExist("ahk_exe PathOfExile.exe")
		}
		
		this.windowName := windowName
		
		if (windowName){
			Gui, Synoverlay:New
			For x, y in memDict{
				if(0 < y and y < this.numStates){
					total := splashStatus[1]+splashStatus[2]+splashStatus[3]+splashStatus[4]+1
					xpos := this.imgWidth*splashStatus[y]
					ypos := ((y-1)*this.imgHeight)
					Gui, Add, Picture, x%xpos% y%ypos%, %imageDir%\Members\%x%.jpg
					splashStatus[y]++
				}
			}
			Gui, Synoverlay: -Caption +LastFound +ToolWindow +OwnDialogs -Sysmenu
			Gui, Synoverlay: +Owner%windowName%
			Gui, Synoverlay:Color, EEAA99
			WinSet, TransColor, EEAA99 255
			return this
		}
		return 0
	}
	
	; Overlay toggler
	toggle(){
		xOrigin := this.xOrigin
		yOrigin := this.yOrigin
		windowName := this.windowName
		if this.toggler{
			Gui, Synoverlay:Hide
			this.toggler := 0			
		} else{
			Gui, Synoverlay:Show, x%xOrigin% y%yOrigin% h600 w1000
			WinActivate, ahk_id  %windowName%
			this.toggler := 1
		}
		return
	}
}

; currency overlay
class currency{
	xOrigin := 0
	yOrigin := 155
	
	imageWidth := 220
	imageHeight := 120
	
	test := 0
	
	toggler := 0
	
	__New(dict){
		Gui, Currency:Destroy
		this.toggler := 0
		;Text1 := this.Text1
		
		imageWidth := this.imageWidth
		imageHeight := this.imageHeight
		
		xTextOrigin := 61
		yTextOrigin := 30 
		textWidth := 100
		textHeight := 40
		
		global Text1 := "Text1"
		global Text2 := "Text2"
		
		exSell := dict["exSell"]
		exBuy := dict["exBuy"]
		
		WinGet, windowName, ProcessName, Path of Exile
		windowName := WinExist("ahk_exe PathOfExile_x64.exe")
		if (!windowName){
			windowName := WinExist("ahk_exe PathOfExile.exe")
		}
		
		this.windowName := windowName
		
		if(windowName){
			Gui, Currency:New
			Gui, Currency: Color, 424242
			Gui, Currency:Add, Picture, x0 y0 w%imageWidth% h%imageHeight% , %imageDir%\Currency.png
			Gui, Currency:Font, s13, 
			Gui, Currency:Add, Text, x%xTextOrigin% y%yTextOrigin%  w%textWidth% h%textHeight% +Center vText1 cFFFFFF , %exSell%  :  1 
			Gui, Currency:Add, Text, x%xTextOrigin% y%yTextOrigin% y+5 w%textWidth% h%textHeight% +Center vText2 cFFFFFF, 1  : %exBuy%
			Gui, Currency: -Caption +LastFound +ToolWindow +OwnDialogs -Sysmenu
			Gui, Currency: +Owner%windowName%
			return this
		}
		return 0
	}
	
	
	toggle(){
		imageWidth := this.imageWidth
		imageHeight := this.imageHeight
		xOrigin := this.xOrigin
		yOrigin := this.yOrigin
		
		windowName := this.windowName
		
		if this.toggler{
			Gui, Currency:Hide
			this.toggler := 0			
		} else{
			Gui, Currency:Show, x%xOrigin% y%yOrigin% w%imageWidth% h%imageHeight%
			WinActivate, ahk_id %windowName%
			this.toggler := 1
			return
		}
	}
	update(dict){
		exSell := dict["exSell"]
		exBuy := dict["exBuy"]
		GuiControl, Currency:Text, Text1, %exSell%  :  1 
		GuiControl, Currency:Text, Text2, 1  : %exBuy%
		Gui, Currency:Submit,NoHide
		return
	}
}
	
; class for loading from/saving into ini file
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

; class for connecting to poe.ninja and retrieving/parsing data
class update{
	static url := "https://poe.ninja/api/data/"
	
	__New(league){
		this.league := league
		return this
	}
	
	currency(){
		try{
			url := this.url
			url .= "currencyoverview?type=Currency"
			url .= "&league=" . this.league
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
		}catch e{
			; reserved for log
			return
		}
		return
	}
	
	scarab(){
		try{
			total_scarabs := 14
			url := this.url
			url .= "itemoverview?type=Scarab"
			url .= "&league=" . this.league
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
		}catch e{
			; reserved for log
			return
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