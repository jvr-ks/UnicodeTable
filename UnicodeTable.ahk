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

Fileencoding "UTF-8-RAW"

#Include UnicodeTableHelper.ahk
#Include UnicodeTableScintilla2.ahk
#Include UnicodeTableShow.ahk
#Include UnicodeTableMenuGen.ahk
#Include UnicodeTableFonts.ahk
#Include UnicodeTableConvert.ahk
#Include AutoXYWH2.ahk


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
appVersion := "0.008"

appTitle := appName " " "v" appVersion

voiceEnabled := 0
voiceIsSpeed := 1 ; -10 .. +10
autoOpenParamBox := 1
inversInputRunning := 0

fontName := "Segoe UI"
fontSize := 11
tableFontName := "Consolas"
tableFontSize := 11


configFile := "UnicodeTable.ini"
wrkDir := A_ScriptDir

quickIsHelpVisible := 0
currentTableStartPositionDefault := 0x2550
currentTableStartPosition := currentTableStartPositionDefault
  
;------------------------------- gui variables -------------------------------
minPosLeft := -16
minPosTop := -16
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

cursorChanged := 0
indexVisible := 1

mwheelModifierDefault := "!"
mwheelModifier := mwheelModifierDefault

wDown := mwheelModifier . "WheelDown"
wUp := mwheelModifier . "WheelUp"

HotIfWinActive "ahk_class AutoHotkeyGUI"
hotkey("F1", quickHelp, "On")
hotkey(wDown, showUnicodeTableDown, "On")
hotkey(wUp, showUnicodeTableUp, "On")

readConfig()
readFavorites()
readFontsList()
mainGui()

showUTF32Table(currentTableStartPosition)

OnMessage 0x200, WM_MOUSEMOVED, 1 ; enable WM_MOUSEMOVE = 0x200

OnClipboardChange(OnClipboardChangeFunction, 1)

return
;------------------------- OnClipboardChangeFunction -------------------------
OnClipboardChangeFunction(type){
  global 
  local characters, stringUTF8
  
  OnClipboardChange(OnClipboardChangeFunction, 0)
  
  MouseGetPos ,,, &OutputVarControl
  
  if (InStr(OutputVarControl,"Scintilla1")|| inversInputRunning){
    if (type == 1){
      characters := A_Clipboard
      clipWait 5, 0
      
      if (autoOpenParamBox)
        showParamBox()
      
      guiParamBoxRow1.Value := StrReplace(characters, "`t", " ")
      utf32All := ""
      stringUTF8 := asUTF8(characters, &utf32All)
      guiParamBoxRow2.Value := utf32All
      guiParamBoxRow3.Value := asUTF16(characters)
      guiParamBoxRow4.Value := stringUTF8
      guiParamBoxRow5.Value := asBinary(stringUTF8)
    }
    inversInputRunning := 0
  }
  OnClipboardChange(OnClipboardChangeFunction, 1)
}

;------------------------------- WM_MOUSEMOVED -------------------------------
WM_MOUSEMOVED(*){
 
  ;checkFocus()
}
;-------------------------------- checkFocus --------------------------------
/* checkFocus(){
  global 
  
  if (guiMain.Hwnd != WinActive("A")){
    RestoreCursor()
    cursorChanged := 0
  } else {
    if (!cursorChanged){
      SetSystemCursor(getCrossCursor())
      cursorChanged := 1
    }
  }
  
  SetTimer(checkFocus, 0)
  SetTimer(checkFocus, -3000)

  return
} */
;---------------------------------- mainGui ----------------------------------
mainGui(){
  global
  local msg1

  paddingTopSci := 2
  paddingBottomSci := 2
  paddingRightSci := 2
  
  padding := 2
  padding2 := 2 * padding
  paramBoxEditPadding := 150
  
  sciWidthDefault := 800
  sciHeightDefault := 600
  
  sciStartX := padding
  sciStarty := paddingTopSci
  
;---------------------------------- guiMain ----------------------------------
  guiMain := Gui("MaximizeBox +Resize ", appTitle)
 
  generateBlocksMenu()
  generateTableFontsMenu()
  generateSettingsMenu()
  if (indexVisible)
    SettingsMenu.Check("Show index")
    
  if (voiceEnabled)
    SettingsMenu.Check("Enable voice")
    
  if (autoOpenParamBox)
    SettingsMenu.Check("Auto Open ParamBox")

  guiMainMenu := MenuBar()
  guiMainMenu.Add("" " Startvalue", selectStartValue)
  
  guiMainMenu.Add("Favorites", FavoritesMenu)
  guiMainMenu.Add("Blocks", BlocksMenu)
  guiMainMenu.Add("TableFont", TableFontsMenu)
  guiMainMenu.Add("▼ Down", showUnicodeTableDown)
  guiMainMenu.Add("▲ Up", showUnicodeTableUp)
  guiMainMenu.Add("♒ ParamBox", showParamBox)
  guiMainMenu.Add("⚙ Settings", SettingsMenu)
  
  guiMainMenu.Add("ℹ Quickhelp (F1)", quickHelp)
  guiMainMenu.Add("⟳ Refresh", refresh)

  guiMainMenu.Add("🗙" " Exit", guiMain_Close)
  
  guiMain.MenuBar := guiMainMenu
    
  guiMain.SetFont("S" . fontSize, fontName)
  
  sciWidth := sciWidthDefault
  sciHeight := sciHeightDefault - paddingTopSci - paddingBottomSci
  
  ;mainText := guiMain.AddScintilla("x" sciStartX " y" sciStarty " w" sciWidth " h" sciHeight "  DefaultOpt")
  mainText := guiMain.AddScintilla("x" sciStartX " y" sciStarty " w" sciWidth " h" sciHeight "DefaultOpt  LightTheme")
  
  setLighTheme(mainText)
  ;setlexer(mainText)
  
  mainText.callback := sci_Change
  
  mainText.Doc.ptr := mainText.Doc.Create(10000+100)
  mainText.cust.Editor.Font := tableFontName
  mainText.cust.Editor.Size := tableFontSize
  mainText.Tab.Use := true
  mainText.Tab.Width := 5
  mainText.Margin.Width := 0
  mainText.Margin.Type := 0
  
  mainText.AutoSizeNumberMargin := false
  
  mainText.Margin.Count := 0
  mainText.Wrap.Mode := 0
  
  guiMain.show("x" guiMainPosX " y" guiMainPosY " w" guiMainClientWidth " h" guiMainClientHeight)
  
  
  guiMain.OnEvent("Size", guiMain_Size , 1)
  guiMain.OnEvent("Close", guiMain_Close)
  OnMessage(0x03, moveEventSwitch)
  
  guiMainHwnd := guiMain.Hwnd
  
  guiMain.Show()
  
  ; trigger a size event
  WinMaximize "ahk_id " guiMainHwnd
  WinRestore "ahk_id " guiMainHwnd
  
;-------------------------------- guiParamBox --------------------------------
  guiParamBox := Gui("+OwnDialogs MaximizeBox +Resize", appTitle "- ParamBox")
  
  guiParamBoxMenu := MenuBar()
  guiParamBoxMenu.Add("♒" " Close ParamBox", showMain)
  
  guiParamBoxMenu.Add("🗙" " Exit", guiMain_Close)
  guiParamBox.MenuBar := guiParamBoxMenu
  
  
  guiParamBox.SetFont("S" . fontSize, fontName)
  
  if(guiParamBoxPosX = 0 || guiParamBoxPosY = 0 || guiParamBoxClientWidth = 0 || guiParamBoxClientHeight = 0){
    guiParamBoxPosX := guiMainPosX
    guiParamBoxPosY := guiMainPosY
    guiParamBoxClientWidth := guiMainClientWidth
    guiParamBoxClientHeight := guiMainClientHeight
  }
  msg1 := "First copy a character from the Unicode-table! (Using the context-menu or [Ctrl] + [c])" 
  guiParamBoxText1 := guiParamBox.Add("Text", "x" padding " r1 vParamBoxValueT1", "Character(s): ") 
  guiParamBoxRow1 := guiParamBox.Add("Edit", "readonly x+m section y" padding " r4 vParamBoxValue1 w" guiParamBoxClientWidth - paramBoxEditPadding , msg1)

  guiParamBoxText2 := guiParamBox.Add("Text", "x" padding " r1 vParamBoxValueT2", "UTF-32 (U+): ") 
  guiParamBoxRow2 := guiParamBox.Add("Edit", "readonly xs yp+0 r4 vParamBoxValue2 w" guiParamBoxClientWidth - paramBoxEditPadding, "") 

  guiParamBoxText3 := guiParamBox.Add("Text", "x" padding " r1 vParamBoxValueT3", "UTF-16 (U+): ") 
  guiParamBoxRow3 := guiParamBox.Add("Edit", "readonly xs yp+0 r4 vParamBoxValue3 w" guiParamBoxClientWidth - paramBoxEditPadding, "") 

  guiParamBoxText4 := guiParamBox.Add("Text", "x" padding " r1 vParamBoxValueT4", "UTF-8: (U+) ") 
  guiParamBoxRow4 := guiParamBox.Add("Edit", "readonly xs yp+0 r4 vParamBoxValue4 w" guiParamBoxClientWidth - paramBoxEditPadding, "") 

  guiParamBoxText5 := guiParamBox.Add("Text", "x" padding " r1 vParamBoxValueT5", "UTF-8: (binary) ") 
  guiParamBoxRow5 := guiParamBox.Add("Edit", "readonly xs yp+0 r4 vParamBoxValue5 w" guiParamBoxClientWidth - paramBoxEditPadding, "") 

  guiParamBoxText6 := guiParamBox.Add("Text", "x" padding " r1 vParamBoxValueT6", "Num. (U+) to`nUTF-32 Char.") 
  guiParamBoxRow6 := guiParamBox.Add("Edit", "xs yp+0 r1 vParamBoxValue6 w" guiParamBoxClientWidth - paramBoxEditPadding - buttonWidth, "") 
  guiParamBoxButton6 := guiParamBox.Add("Button", "x+m yp+0", "Show character") 
  
  guiParamBoxButton6.OnEvent("Click", inversInput)

  guiParamBox.Show("Hide x" guiParamBoxPosX " y" guiParamBoxPosY " autosize")
  WinGetPos ,,, &guiParamBoxClientHeight, guiParamBox
  
  guiParamBox.OnEvent("Size", guiParamBox_Size, 1)
}
;-------------------------------- inversInput --------------------------------
inversInput(*){
  global
  local v, f, r
  
  inversInputRunning := 1
  v := guiParamBoxRow6.Value
  r := ""
   
  ;v := RegExReplace(v, "[^0-9a-fA-F ]","")
  v := Trim(v)
  
  if (v == "")
    return

  if (InStr(v, " ")){
    Loop parse v, " ","`r" {
      f := A_LoopField
      if (isAnyControlCharacter(f)){
        msgbox("Input is a Control-character!")
      } else {
        f := "0x" f
        if (isNumber(f)){
          r .= Chr(f) " "
        } else {
          msgbox("Input is not a number!")
        }
      }
    }
    A_Clipboard := r
    r := ""
  } else {
    if (isAnyControlCharacter(v)){
      msgbox("Input is a Control-character!")
    } else {
      f := "0x" v
      if (isNumber(f)){
        r := Chr(f)
        A_Clipboard := r
        r := ""
      } else {
        msgbox("Input is not a number!")
      }
    }
  }
}
;------------------------------- showParamBox -------------------------------
showParamBox(*){
  global
  
  guiParamBox.Show()
}
;--------------------------------- showMain ---------------------------------
showMain(*){
  global
  
  guiParamBox.Hide()
}
;------------------------------- guiMain_Size -------------------------------
guiMain_Size(theGui, theMinMax, clientWidth, clientHeight, *) {
  global 
  local mainTextWidth, mainTextHeight
  
  if (theMinMax = -1)
      return
  
  guiMainClientWidth := clientWidth
  guiMainClientHeight := clientHeight
  
  IniWrite guiMainClientWidth, configFile, "gui", "guiMainClientWidth"
  IniWrite guiMainClientHeight, configFile, "gui", "guiMainClientHeight"
  
  mainTextWidth := (guiMainClientWidth - paddingRightSci)
  mainTextHeight := (guiMainClientHeight - paddingTopSci - paddingBottomSci)
  
  mainText.Move(, , mainTextWidth, mainTextHeight)
}
;----------------------------- guiParamBox_Size -----------------------------
guiParamBox_Size(theGui, theMinMax, clientWidth, clientHeight, *) {
  global 
  
  if (theMinMax = -1)
      return
  
  guiParamBoxClientWidth := clientWidth
  ;guiParamBoxClientHeight := clientHeight ; height is fixed!
  
  IniWrite clientWidth, configFile, "gui", "guiParamBoxClientWidth"
  ; IniWrite clientHeight, configFile, "gui", "guiParamBoxClientHeight"
  
  AutoXYWH2("w", guiParamBoxRow1)
  AutoXYWH2("w", guiParamBoxRow2)
  AutoXYWH2("w", guiParamBoxRow3)
  AutoXYWH2("w", guiParamBoxRow4)
  AutoXYWH2("w", guiParamBoxRow5)
  AutoXYWH2("w", guiParamBoxRow6)
  AutoXYWH2("x", guiParamBoxButton6)
  
  ; reset height
  WinMove ,,, guiParamBoxClientHeight, guiParamBox
}
;------------------------------ guiMainMove ------------------------------
guiMainMove(){
  global
  local posX, posY

  guiMain.GetPos(&posX, &posY)

  if (posX != 0 && posY != 0){  
    guiMainPosX := max(coordsAppToScreen(posX), minPosLeft)
    guiMainPosY := max(coordsAppToScreen(posY), minPosTop)
    
    IniWrite guiMainPosX, configFile, "gui", "guiMainPosX"
    IniWrite guiMainPosY, configFile, "gui", "guiMainPosY"
  }
}
;------------------------------ guiParamBoxMove ------------------------------
guiParamBoxMove(){
  global
  local posX, posY

  guiParamBox.GetPos(&posX, &posY)

  if (posX != 0 && posY != 0){  
    guiParamBoxPosX := max(coordsAppToScreen(posX), minPosLeft)
    guiParamBoxPosY := max(coordsAppToScreen(posY), minPosTop)
    
    IniWrite guiParamBoxPosX, configFile, "gui", "guiParamBoxPosX"
    IniWrite guiParamBoxPosY, configFile, "gui", "guiParamBoxPosY"
  }
}
;------------------------------ moveEventSwitch ------------------------------
moveEventSwitch(p1, p2, p3, p4, *){
  local h1, h2, h3
  
  h1 := 0, h2 := 0
  
  if (IsSet(guiMain)){
    h1 := guiMain.hwnd
  }
    
  if (IsSet(guiParamBox)){
    h2 := guiParamBox.hwnd
  }
  
  Switch  p4
  {
    Case h1:
      guiMainMove()
    
    Case h2:
      guiParamBoxMove()
  
  }
}
;----------------------------- guiMain_Close -----------------------------
guiMain_Close(*){
  global
  
  guiMain.Hide()
  exit()
}
;----------------------------- selectStartValue -----------------------------
selectStartValue(*){
  global
  
  inBox := InputBox("", "Please enter a hexadezimal value (without the leading 0x)", "h70 w500", toHex6(currentTableStartPosition))
  if (inBox.Result != "Cancel"){
    showUTF32Table("0x" inBox.Value)
  }
}
;-------------------------------- selectFont --------------------------------
selectFont(f, *){
  global
  
  tableFontName := f

  mainText.cust.Editor.Font := tableFontName
  ; mainText.cust.Editor.Size := tableFontSize
  
  IniWrite tableFontName, configFile, "config", "tableFontName"
}
;-------------------------------- sci_Change --------------------------------
sci_Change(*){
  global 
  local guiCtrlObj, CurrentCol, CurrentLine, oSaved

  guiCtrlObj := guiMain.FocusedCtrl
  if (IsObject(guiCtrlObj)){
    CurrentCol := EditGetCurrentCol(guiCtrlObj)
    CurrentLine := EditGetCurrentLine(guiCtrlObj)
    ;oSaved := guiMain.Submit(0)
    ;currentLineContent := guiMain.Text
    ;tooltip currentLineContent
    ;SB.SetText("Line: " CurrentLine " Column: " CurrentCol , 2, 1)
  }
}
;------------------------------- setLighTheme -------------------------------
setLighTheme(ctl) {
  ; Light theme
  ctl.cust.Caret.LineBack := 0xF6F9FC	; active line (with caret)
  ctl.cust.Editor.Back := 0xFDFDFD

  ctl.cust.Editor.Fore := 0x000000
  ;ctl.cust.Editor.Font := "Consolas"
  ctl.cust.Editor.Size := 11

  ctl.Style.ClearAll()	; apply style 32

  ctl.cust.Margin.Back := 0xF0F0F0
  ctl.cust.Margin.Fore := 0x000000

  ctl.cust.Caret.Fore := 0x00FF00
  ctl.cust.Selection.Back := 0x398FFB
  ctl.cust.Selection.ForeColor := 0xFFFFFF

  ctl.cust.Brace.Fore := 0x5F6364	; basic brace color
  ctl.cust.BraceH.Fore := 0x00FF00	; brace color highlight
  ctl.cust.BraceHBad.Fore := 0xFF0000	; brace color bad light
  ctl.cust.Punct.Fore := 0xA57F5B
  ctl.cust.String1.Fore := 0x329C1B	; "" double quoted text
  ctl.cust.String2.Fore := 0x329C1B	; '' single quoted text

  ctl.cust.Comment1.Fore := 0x7D8B98	; keeping comment color same
  ctl.cust.Comment2.Fore := 0x7D8B98	; keeping comment color same
  ctl.cust.Number.Fore := 0xC72A31
  
  ctl.cust.kw1.Fore := 0x329C1B	; flow - set keyword list colors, kw1 - kw8
  ctl.cust.kw2.Fore := 0x1001BF	; funcion
  ctl.cust.kw2.Bold := true	; funcion
  ctl.cust.kw3.Fore := 0x2390B6	; method
  ctl.cust.kw3.Bold := true	; funcion
  ctl.cust.kw4.Fore := 0x3F8CD4	; prop
  ctl.cust.kw5.Fore := 0xC72A31	; vars

  ctl.cust.kw6.Fore := 0xEC9821	; directives
  ctl.cust.kw7.Fore := 0x2390B6	; var decl
}
;----------------------------------------------------------------------------


































