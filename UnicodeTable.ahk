/*
 *********************************************************************************
 * 
 * UnicodeTable.ahk
 * 
 * Version: look at appVersion := below
 * 
 * Copyright (c) 2024 jvr.de. All rights reserved.
 *
 *
 *********************************************************************************
*/
/*
 *********************************************************************************
 * 
 * GNU GENERAL PUBLIC LICENSE
 * 
 * A copy is included in the file "license.txt"
 *
  *********************************************************************************
*/

#Requires AutoHotkey v2

#Warn
#SingleInstance force

Fileencoding "UTF-8"

#Include UnicodeTableHelper.ahk
#Include UnicodeTableScintilla2.ahk
#Include UnicodeTableShow.ahk
#Include UnicodeTableMenuGen.ahk
#Include lib\GuiEditFontsMenu.ahk
#Include lib\FontsHelper.ahk
#Include lib\GuiFontsMenu.ahk
#Include UnicodeTableConvert.ahk
#Include UnicodeTableMainGui.ahk
#Include UnicodeTableParamBoxGui.ahk



SetTitleMatchMode "2"
DetectHiddenWindows false
SendMode "Input" 

InstallKeybdHook true

;-------------------------------- read cmdline param --------------------------------
hasParams := A_Args.Length

if (hasParams != 0){
  Loop hasParams
  {
    if(A_Args[A_index] == "remove"){
      ExitApp 0
    }
  }
}
;------------------------------ setup global variables ------------------------------;
baseDirectory := A_ScriptDir

appName := "UnicodeTable"
appnameLower := "UnicodeTable"
extension := ".exe"
appVersion := "0.018"

appTitle := appName " " "v" appVersion

catchAll := 0
tableIsWritable := 0
voiceEnabled := 0
voiceIsSpeed := 1 ; -10 .. +10
autoOpenParamBox := 1
inversInputRunning := 0

guiMainFontName := "Segoe UI"
guiMainFontSize := 11
guiMainEditguiMainFontName := "Consolas"
guiMainEditFontSize := 11


configFile := "UnicodeTable.ini"
wrkDir := A_ScriptDir

quickIsHelpVisible := 0
currentTableStartPositionDefault := 0x2550
currentTableStartPosition := currentTableStartPositionDefault
  
;------------------------------- gui variables -------------------------------
buttonWidth := 128

dpiScaleValueDefault := 96
dpiScaleValue := dpiScaleValueDefault

guiMainPosXDefault := 0 
guiMainPosYDefault := 0

guiMainPosX := guiMainPosXDefault
guiMainPosY := guiMainPosYDefault

guiMainClientWidthDefault := 600
guiMainClientHeightDefault := 200

guiMainClientWidth := guiMainClientWidthDefault
guiMainClientHeight := guiMainClientHeightDefault


guiParamBoxPosX := 0
guiParamBoxPosY := 0
guiParamBoxClientWidth := 0
guiParamBoxClientHeight := 0

; limits
minPosTop := -20
minPosLeft := -20
maxPosTop := (A_ScreenHeight - 100)
maxPosLeft := (A_ScreenWidth - 200)

; editarea
paddingLeft := 2
paddingRight := 8
paddingTop := 5
paddingBottom := 27

preferredFont1Default := "Consolas"
preferredFont2Default := "Noto colored emoji"
preferredFont3Default := "Segoe UI"
preferredFont4Default := "OCR-A BT"

preferredFont1 := preferredFont1Default
preferredFont2 := preferredFont2Default
preferredFont3 := preferredFont3Default
preferredFont4 := preferredFont4Default

cursorChanged := 0
indexVisible := 1
paramBoxRowsDefault := 4
paramBoxRows := paramBoxRowsDefault

mwheelModifierDefault := "!"
mwheelModifier := mwheelModifierDefault

wDown := mwheelModifier . "WheelDown"
wUp := mwheelModifier . "WheelUp"

allFontsList := []
getFontsList()

lastChar := ""

HotIfWinActive "ahk_class AutoHotkeyGUI"
hotkey("F1", quickHelp, "On")
hotkey(wDown, showUnicodeTableDown, "On")
hotkey(wUp, showUnicodeTableUp, "On")

readConfig()
readFavorites()
; readFontsList()

unicodeNameMapFileName := "unicodeNames.txt"
unicodeNameMap := Map()
unicodeNameMapRead()

mainGui()
paramBoxGui()

showUTF32Table(currentTableStartPosition)

OnClipboardChange(OnClipboardChangeFunction, 1)

return
;------------------------- OnClipboardChangeFunction -------------------------
OnClipboardChangeFunction(type){
  global 
  local characters, stringUTF8
  
  OnClipboardChange(OnClipboardChangeFunction, 0)
  
  MouseGetPos ,,, &OutputVarControl
  
  if (InStr(OutputVarControl,"Scintilla1") || inversInputRunning || catchAll){
    if (type == 1){
      characters := A_Clipboard
      clipWait 5, 0
      
      if (autoOpenParamBox)
        showParamBox()
      
      characters := StrReplace(characters, "`t", " ")
      guiParamBoxRow1.Value := characters
      
      arrayUTF32:= stringUTF16ToUTF32(characters)
      stringUTF32 := ""
      stringUTF8 := ""
      loop arrayUTF32.Length {
        stringUTF32 .= format("{1:6.6X}", arrayUTF32[A_Index]) " "
      }
      guiParamBoxRow2.Value := Trim(stringUTF32)
      
      guiParamBoxRow3.Value := Trim(asUTF16(characters))
      stringUTF8 := asUTF8(characters)
      guiParamBoxRow4.Value := stringUTF8
      guiParamBoxRow5.Value := asBinary(stringUTF8)
      guiParamBoxRow6.Value := asHTML(characters)
      guiParamBoxRow7.Value := asURI(characters)
      
      lastChar := SubStr(characters, 1, 1)
    }
    inversInputRunning := 0
  }
  OnClipboardChange(OnClipboardChangeFunction, 1)
}
;---------------------------- unicodeNameMapRead ----------------------------
unicodeNameMapRead(*){
  global
  local k, v

  k := ""
  v := ""
  Loop Read, unicodeNameMapFileName {
    Loop parse, A_LoopReadLine, "|" {
      if (A_Index = 1)
        k := A_LoopField
        
      if (A_Index = 2)
        v := A_LoopField
    }
    if (k != "" && v != "")
      unicodeNameMap.Set(k, v)
  }
  ;fixed values
  unicodeNameMap.Set("000000", "NUL")
  unicodeNameMap.Set("000009", "HT")
  unicodeNameMap.Set("00000A", "VT")
  unicodeNameMap.Set("00000B", "FF")
  unicodeNameMap.Set("00000C", "FF")
  unicodeNameMap.Set("00000D", "CR")
  unicodeNameMap.Set("00000E", "SO")
  unicodeNameMap.Set("00000F", "SI")

}
;---------------------------- unicodeNameMapSave ----------------------------
unicodeNameMapSave(*){
  global
  local kv
  
  if (FileExist(unicodeNameMapFileName))
    FileDelete(unicodeNameMapFileName)
    
  for k, v in unicodeNameMap {
    FileAppend k "|" v "`n", unicodeNameMapFileName, "`n UTF-8"
  }
}
;----------------------------------------------------------------------------


































