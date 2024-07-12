; UnicodeTableMainGui.ahk
; Part of UnicodeTable.ahk

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
  
  ; sciWidthDefault := 800
  ; sciHeightDefault := 600
  
  paddingLeft := padding
  paddingTop := paddingTopSci
  
;---------------------------------- guiMain ----------------------------------
  guiMain := Gui("MaximizeBox +Resize ", appTitle)
 
  generateBlocksMenu()
  generateGuiEditFontsMenu()
  generateGuiEditFontSizeMenu()
  generateGuiFontsMenu()
  generateGuiFontSizeMenu()
  
  generateSettingsMenu()
  generateMainMenuInsert()
  
  if (indexVisible)
    SettingsMenu.Check("Show index")
  
  if (catchAll)
    SettingsMenu.Check("Catch characters outside the app")
  
  if (tableIsWritable)
    SettingsMenu.Check("Table is writable")
  
  if (autoOpenParamBox)
    SettingsMenu.Check("Auto Open ParamBox")
  
  if (voiceEnabled)
    SettingsMenu.Check("Enable voice")
    
  GuiEditFontsMenu.Check(guiMainEditFontName) 
  GuiEditFontSizeMenu.Check(guiMainEditFontsize) 
  
  GuiFontsMenu.Check(guiMainFontName) 
  GuiFontSizeMenu.Check(guiMainFontsize) 
  
  guiMainMenu := MenuBar()
  guiMainMenu.Add("" " Startvalue", selectStartValue)
  
  guiMainMenu.Add("Favorites", FavoritesMenu)
  guiMainMenu.Add("Blocks", BlocksMenu)
  guiMainMenu.Add("Frequently used", MainMenuInsert)
  guiMainMenu.Add("▼ Down", showUnicodeTableDown)
  guiMainMenu.Add("▲ Up", showUnicodeTableUp)
  guiMainMenu.Add("♒ ParamBox", toggleParamBox)
  guiMainMenu.Add("⚙ Settings", SettingsMenu)
  
  guiMainMenu.Add("ℹ Quickhelp (F1)", quickHelp)
  guiMainMenu.Add("⟳ Refresh", refresh)

  guiMainMenu.Add("🗙" " Exit", guiMain_Close)
  
  guiMain.MenuBar := guiMainMenu
    
  guiMain.SetFont("S" . guiMainFontSize, guiMainFontName)
  
  ; sciWidth := sciWidthDefault
  ; sciHeight := sciHeightDefault - paddingTopSci - paddingBottomSci
  
  ; guiMainEdit := guiMain.AddScintilla("x" sciStartX " y" sciStarty " w" sciWidth " h" sciHeight "DefaultOpt  LightTheme")
  ; overwritten by size event
  guiMainEdit := guiMain.AddScintilla("x" paddingLeft " y" paddingTop " w800 h600 DefaultOpt LightTheme")
  
  ;setlexer(guiMainEdit)
  ;guiMainEdit.callback := sci_Change
  guiMainEdit.OnNotify(0x7D6, dcCallback , 1) ; 0x7D6
  
  guiMainEdit.Doc.ptr := guiMainEdit.Doc.Create(10000+100)
  guiMainEdit.cust.Editor.Font := guiMainEditguiMainFontName
  guiMainEdit.cust.Editor.Size := guiMainEditFontSize
  
  guiMainEdit.Tab.Use := true
  guiMainEdit.Tab.Width := 6
  guiMainEdit.Tab.MinimumWidth := 20
  guiMainEdit.Margin.Width := 0
  guiMainEdit.Margin.Type := 0
  
  guiMainEdit.AutoSizeNumberMargin := false
  
  guiMainEdit.Margin.Count := 0
  guiMainEdit.Wrap.Mode := 0
  
  SB := guiMain.Add("StatusBar")
  
  ; gui show / hide
  guiMain.Show("Hide x" . guiMainPosX . " y" . guiMainPosY . " w" . guiMainClientWidth . " h" . guiMainClientHeight)
  
  guiMain.Show("Autosize")
  
  SB.SetParts(round(guiMainClientWidth * 0.4), round(guiMainClientWidth * 0.4))
  updateMainSB()
;------------------------------------
 
  guiMain.OnEvent("Size", guiMain_Size , 1)
  guiMain.OnEvent("Close", guiMain_Close)
  OnMessage(0x03, moveEventSwitch)
  
  guiMainHwnd := guiMain.Hwnd
  
  ; trigger a size event
  WinMaximize "ahk_id " guiMainHwnd
  WinRestore "ahk_id " guiMainHwnd
}
;------------------------------- updateMainSB -------------------------------
updateMainSB(){
  global
  local mem
  
  SB.SetText(" " . configFile, 1, 1)
  SB.SetText(" [" guiMainEditguiMainFontName "]", 2, 1)
    
  mem := "?"
  try {
    mem := getProcessMemoryUsage()
    SB.SetText("`t`t[" mem " MB]   ", 3, 2)
  }
}
;--------------------------------- showMain ---------------------------------
showMain(*){
  global
  
  guiParamBox.Hide()
}
;------------------------------- guiMain_Size -------------------------------
guiMain_Size(theGui, theMinMax, clientWidth, clientHeight, *) {
  global 
  ; local guiMainEditWidth, guiMainEditHeight
  local Width, Height
  
  if (theMinMax = -1)
      return
      
  guiMain.GetPos(&posX, &posY, &Width, &Height)
  
  guiMainWidth := Width
  guiMainHeight := Height
  
  IniWrite guiMainWidth, configFile, "gui", "guiMainWidth"
  IniWrite guiMainHeight, configFile, "gui", "guiMainHeight"
  
  guiMainClientWidth := clientWidth
  guiMainClientHeight := clientHeight
  
  IniWrite guiMainClientWidth, configFile, "gui", "guiMainClientWidth"
  IniWrite guiMainClientHeight, configFile, "gui", "guiMainClientHeight"
  
  mainEditWidth := guiMainClientWidth - paddingLeft - paddingRight
  mainEditHeight := guiMainClientHeight - paddingBottom - paddingTop
  
  guiMainEdit.Move(,, mainEditWidth, mainEditHeight)
}

;------------------------------ guiMainMove ------------------------------
guiMainMove(){
  global
  local posX, posY

  guiMain.GetPos(&posX, &posY)

  if (posX != 0 && posY != 0){
    guiMainPosX := min(posX, maxPosLeft)
    guiMainPosX := max(posX, minPosLeft)
    
    guiMainPosY := min(posY, maxPosTop)
    guiMainPosY := max(posY, minPosTop)
    
    IniWrite guiMainPosX, configFile, "gui", "guiMainPosX"
    IniWrite guiMainPosY, configFile, "gui", "guiMainPosY"
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
;-------------------------------- sci_Change --------------------------------
/* sci_Change(ctl, scn, *){
  global 
  local guiCtrlObj, CurrentCol, CurrentLine, oSaved

  guiCtrlObj := guiMain.FocusedCtrl
  
  if (IsObject(guiCtrlObj)){
    ;CurrentCol := EditGetCurrentCol(guiCtrlObj)
    ;CurrentLine := EditGetCurrentLine(guiCtrlObj)
    ;oSaved := guiMain.Submit(0)
    ;tooltip scn.line
    ;currentLineContent := guiMainEdit.Text
    ;tooltip currentLineContent
    ;SB.SetText("Line: " CurrentLine " Column: " CurrentCol , 2, 1)
  }
} */

;-------------------------------- dcCallback --------------------------------
dcCallback(*){
  global 

  ;tooltip "doubleClick!"
  MouseGetPos ,,, &OutputVarControl
  
  if (InStr(OutputVarControl,"Scintilla1")){
    SendInput "^c"
  }
}
;----------------------------------------------------------------------------


































