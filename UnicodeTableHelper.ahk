; UnicodeTableHelper.ahk
; Part of UnicodeTable.ahk

;-------------------------------- readConfig --------------------------------
readConfig(){
  global
  local v 
  
  if (FileExist(configFile)){
    ; config section:
    fontName := iniReadSave("fontName", "config", "Segoe UI")
    fontSize := iniReadSave("fontSize", "config", 10)
    tableFontName := iniReadSave("tableFontName", "config", "Consolas")
    tableFontSize := iniReadSave("tableFontSize", "config", 11)
    voiceEnabled := iniReadSave("voiceEnabled", "config", 0)
    catchAll := iniReadSave("catchAll", "config", 0)
    
    
    mwheelModifier := iniReadSave("mwheelModifier", "config", mwheelModifierDefault)
    currentTableStartPosition := iniReadSave("currentTableStartPosition", "config", currentTableStartPositionDefault)
    
    indexVisible := iniReadSave("indexVisible", "gui", 1)
    dpiScaleValue := iniReadSave("dpiScaleValue", "gui", dpiScaleValueDefault)
    
    guiMainPosX := iniReadSave("guiMainPosX", "gui", guiMainPosXDefault)
    guiMainPosY := iniReadSave("guiMainPosY", "gui", guiMainPosYDefault)
    guiMainClientWidth := iniReadSave("guiMainClientWidth", "gui", guiMainClientWidthDefault)
    guiMainClientHeight := iniReadSave("guiMainClientHeight", "gui", guiMainClientHeightDefault)
    
    guiParamBoxPosX := iniReadSave("guiParamBoxPosX", "gui", guiMainPosXDefault)
    guiParamBoxPosY := iniReadSave("guiParamBoxPosY", "gui", guiMainPosYDefault)
    guiParamBoxClientWidth := iniReadSave("guiParamBoxClientWidth", "gui", guiMainClientWidthDefault)
    guiParamBoxClientHeight := iniReadSave("guiParamBoxClientHeight", "gui", guiMainClientHeightDefault)
    
  } else {
  FileAppend "
(
[config]
fontName=Segoe UI
fontSize=10
voiceEnabled=1
[gui]
dpiScaleValue=96
guiMainPosX=0
guiMainPosY=0
guiMainClientWidth=800
guiMainClientHeight=600
guiParamBoxPosX=0
guiParamBoxPosY=0
guiParamBoxClientWidth=800
guiParamBoxClientHeight=600
)", configFile, "`n"
  
  }
  
  dpiCorrect := A_ScreenDPI / dpiScaleValue
  
  guiMainPosX := max(guiMainPosX, minPosLeft)
  guiMainPosY := max(guiMainPosY, minPosTop)
  
  guiParamBoxPosX := max(guiParamBoxPosX, minPosLeft)
  guiParamBoxPosY := max(guiParamBoxPosY, minPosTop)
}
;------------------------------- readFavorites -------------------------------
readFavorites(){
  global
  
  tableStartPositionFavorites := []
  if (FileExist("UnicodeTableFavorites.txt")){
    favoritesRaw := FileRead("UnicodeTableFavorites.txt")
    Loop read, "UnicodeTableFavorites.txt" {
      if (!InStr(SubStr(A_LoopReadLine,1 , 2), ";"))
        tableStartPositionFavorites.push(A_LoopReadLine)
    }
  }
}
;-------------------------------- iniReadSave --------------------------------
iniReadSave(name, section, defaultValue){
  global configFile
  local retValue
  
  retValue := IniRead(configFile, section, name, defaultValue)
  if (retValue == "" || retValue == "ERROR")
    retValue := defaultValue
    
  return retValue
}
;------------------------------- readFontsList -------------------------------
readFontsList(){
  global
  
  usableFonts := []
  if (FileExist("UnicodeTableFonts.txt")){
    favoritesRaw := FileRead("UnicodeTableFonts.txt")
    Loop read, "UnicodeTableFonts.txt" {
      if (!InStr(SubStr(A_LoopReadLine,1 , 2), ";"))
        if (A_LoopReadLine != "")
          usableFonts.push(A_LoopReadLine)
    }
  }
}
;-------------------------------- editFavFile --------------------------------
editFavFile(*){
  global
  
  Run "UnicodeTableFavorites.txt"
  showHintColored("If editing has finished, please press the [Refresh]-button!")

}
;---------------------------------- refresh ----------------------------------
refresh(*){

  Reload
}
;----------------------------- coordsScreenToApp -----------------------------
coordsScreenToApp(n){
  global dpiCorrect
  local retValue
  
  retValue := 0
  if (dpiCorrect > 0)
    retValue := round(n / dpiCorrect)

  return retValue
}
;----------------------------- coordsAppToScreen -----------------------------
coordsAppToScreen(n){
  global dpiCorrect
  local retValue

  retValue := round(n * dpiCorrect)

  return retValue
}
;--------------------------------- quickHelp ---------------------------------
quickHelp(*){
  global
  local msg, width, height, opt, wb
  
  if (!quickIsHelpVisible){
    guiShortHelp := Gui("+OwnDialogs +Resize +parent" guiMain.Hwnd, "UnicodeTable Quick-help")
    
    width := round(A_ScreenWidth * 0.9)
    height := round(A_ScreenHeight * 0.9)
    guiShortHelp.Add("Edit", "x2 y2 r0 w0 h0", "") ; Focus dummy
    wb := guiShortHelp.Add("ActiveX", "x2 y2 w" width " h" height " vWB", "about:<!DOCTYPE html><meta http-equiv=`"X-UA-Compatible`" content=`"IE=edge`"").Value
    ;ComObjConnect(wb, wb_events)
    doc := wb.document
    doc.documentElement.style.overflow := "scroll"
    quickHelpContent := FileRead(A_ScriptDir "\" "UnicodeTableQHelp.html")
    doc.write(quickHelpContent)
    
    guiShortHelp.Opt("+Owner" guiMain.Hwnd)
    
    guiShortHelp.show("center autosize")
    
    guiShortHelp.OnEvent("Close", guiShortHelp_Close)
  } else {
    guiShortHelp.destroy
  }
  
  quickIsHelpVisible := !quickIsHelpVisible
}
;---------------------------- guiShortHelp_Close ----------------------------
guiShortHelp_Close(*){
  global quickIsHelpVisible
  
  quickIsHelpVisible := 0
}
;------------------------------ showHintColored ------------------------------
showHintColored(s := "", n := 3000, fg := "cFFFFFF", bg := "a900ff", newfont := "", newfontsize := ""){
  global
  local t
  
  if (newfont == "")
    newfont := fontName
    
  if (newfontsize == "")
    newfontsize := fontsize
    
  if (IsSet(hintColored))
    hintColored.Destroy()
    
  hintColored := Gui("+0x80000000")
  hintColored.SetFont("c" fg " s" newfontsize, newfont)
  hintColored.BackColor := bg
  hintColored.add("Text", , s)
  hintColored.Opt("-Caption")
  hintColored.Opt("+ToolWindow")
  hintColored.Opt("+AlwaysOnTop")
  hintColored.Show("center")
  
  if (n > 0){
    sleep(n)
    hintColored.Destroy()
  }
}
;---------------------------- showHintColoredTop ----------------------------
showHintColoredTop(s := "", n := 3000, fg := "cFFFFFF", bg := "a900ff", newfont := "", newfontsize := ""){
  global
  local t
  
  if (hintColored != 0)
    hintColored.Destroy()
    
  if (newfont == "")
    newfont := fontName
    
  if (newfontsize == "")
    newfontsize := fontsize
  
  hintColored := Gui("+0x80000000")
  hintColored.SetFont("c" fg " s" newfontsize, newfont)
  hintColored.BackColor := bg
  hintColored.add("Text", , s)
  hintColored.Opt("-Caption")
  hintColored.Opt("+ToolWindow")
  hintColored.Opt("+AlwaysOnTop")
  hintColored.Show("y10 xcenter")
  
  if (n > 0){
    sleep(n)
    hintColored.Destroy()
  }
}
;----------------------------------- speak -----------------------------------
speak(text){
  global

  if (voiceEnabled){
    voice := ComObject("SAPI.SpVoice")
    voice.Voice := voice.GetVoices().Item(voiceIsSpeaker)
    voice.Rate := voiceIsSpeed
    voice.Speak(text)
  }
  
  return
}
;--------------------------------- HexToDec ---------------------------------
HexToDec(hex) {
    dec := Buffer(66, 0)
    val := DllCall("msvcrt.dll\_wcstoui64", "Str", hex, "UInt", 0, "UInt", 16, "CDECL Int64")
    DllCall("msvcrt.dll\_i64tow", "Int64", val, "Str", dec, "UInt", 10, "CDECL") 
    ; V1toV2: if 'dec' is a UTF-16 string, use 'VarSetStrCapacity(&dec, 66)'
    
    return dec
}
;-------------------------------- Win_Center --------------------------------
/* Win_Center(handle, hChild, Visible := 0) {
  DetectHiddenWindows(true)
  WinGetPos(&X, &Y, &W, &H, "ahk_ID " handle)
  WinGetPos(&_X, &_Y, &_W, &_H, "ahk_ID " hChild)
  If Visible {
    MonitorGetWorkArea(Win_Monitor(handle), &MWALeft, &MWATop, &MWARight, &MWABottom)
    X := X+(W-_W)//2, X := X < MWALeft ? MWALeft+5 : X, X := (X + _W) > MWARight ? MWARight-_W-5 : X
    Y := Y+(H-_H)//2, Y := Y < MWATop ? MWATop+5 : Y, Y := (Y + _H) > MWABottom ? MWABottom-_H-5 : Y
} Else X := X+(W-_W)//2, Y := Y+(H-_H)//2
  WinMove(X, Y, , , "ahk_ID " hChild)
  WinShow("ahk_ID " hChild)
  return
} */
;-------------------------------- Win_Monitor --------------------------------
/* Win_Monitor(handle, Center := 1) {
  MonitorCount := SysGet(80)
  WinGetPos(&X, &Y, &W, &H, "ahk_ID " handle)
  Center ? (X := X+(W//2), Y := Y+(H//2))
  Loop MonitorCount {
    MonitorGet(A_Index, &MonLeft, &MonTop, &MonRight, &MonBottom)
    if (X >= MonLeft && X <= MonRight && Y >= MonTop && Y <= MonBottom)
        Return A_Index
    }
    
  return
} */
;;-------------------------------- wrkPath --------------------------------
wrkPath(p){
  global wrkdir
  local retValue
  
  retValue := wrkdir . p
    
  return retValue
}
;------------------------------- pathToAbsolut -------------------------------
pathToAbsolut(p){
  global
  local retValue
  
  retValue := p
  if (!InStr(p, ":"))
    retValue := wrkPath(p)
    
  if (SubStr(retValue, -1, 1) != "\")
    retValue .= "\"
    
  return retValue
}
;------------------------------ getCrossCursor ------------------------------
getCrossCursor(){
  B64 := "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAQMAAABJtOi3AAAAAXNSR0IB2cksfwAAAAlwSFlzAAAM6wAADOsB5dZE0gAAAAZQTFRFAAAALuUr"
       . "GAEszAAAAAJ0Uk5TAP9bkSK1AAAAF0lEQVR4nGNgYGxgYKAO8R8IIAT1DAUAMHgXFyzrq5IAAAAASUVORK5CYII="
  return B64
}
;------------------------------ SetSystemCursor ------------------------------
SetSystemCursor(Cursor := "", cx := 0, cy := 0) {

   static SystemCursors := Map("APPSTARTING", 32650, "ARROW", 32512, "CROSS", 32515, "HAND", 32649, "HELP", 32651, "IBEAM", 32513, "NO", 32648,
                           "SIZEALL", 32646, "SIZENESW", 32643, "SIZENS", 32645, "SIZENWSE", 32642, "SIZEWE", 32644, "UPARROW", 32516, "WAIT", 32514)

   if (Cursor = "") {
      AndMask := Buffer(128, 0xFF), XorMask := Buffer(128, 0)

      for CursorName, CursorID in SystemCursors {
         CursorHandle := DllCall("CreateCursor", "ptr", 0, "int", 0, "int", 0, "int", 32, "int", 32, "ptr", AndMask, "ptr", XorMask, "ptr")
         DllCall("SetSystemCursor", "ptr", CursorHandle, "int", CursorID) ; calls DestroyCursor
      }
      return
   }

   if (Cursor ~= "^(IDC_)?(?i:AppStarting|Arrow|Cross|Hand|Help|IBeam|No|SizeAll|SizeNESW|SizeNS|SizeNWSE|SizeWE|UpArrow|Wait)$") {
      Cursor := RegExReplace(Cursor, "^IDC_")

      if !(CursorShared := DllCall("LoadCursor", "ptr", 0, "ptr", SystemCursors[StrUpper(Cursor)], "ptr"))
         throw Error("Error: Invalid cursor name")

      for CursorName, CursorID in SystemCursors {
         CursorHandle := DllCall("CopyImage", "ptr", CursorShared, "uint", 2, "int", cx, "int", cy, "uint", 0, "ptr")
         DllCall("SetSystemCursor", "ptr", CursorHandle, "int", CursorID) ; calls DestroyCursor
      }
      return
   }

   if FileExist(Cursor) {
      SplitPath Cursor,,, &Ext:="" ; auto-detect type
      if !(uType := (Ext = "ani" || Ext = "cur") ? 2 : (Ext = "ico") ? 1 : 0)
         throw Error("Error: Invalid file type")

      if (Ext = "ani") {
         for CursorName, CursorID in SystemCursors {
            CursorHandle := DllCall("LoadImage", "ptr", 0, "str", Cursor, "uint", uType, "int", cx, "int", cy, "uint", 0x10, "ptr")
            DllCall("SetSystemCursor", "ptr", CursorHandle, "int", CursorID) ; calls DestroyCursor
         }
      } else {
         if !(CursorShared := DllCall("LoadImage", "ptr", 0, "str", Cursor, "uint", uType, "int", cx, "int", cy, "uint", 0x8010, "ptr"))
            throw Error("Error: Corrupted file")

         for CursorName, CursorID in SystemCursors {
            CursorHandle := DllCall("CopyImage", "ptr", CursorShared, "uint", 2, "int", 0, "int", 0, "uint", 0, "ptr")
            DllCall("SetSystemCursor", "ptr", CursorHandle, "int", CursorID) ; calls DestroyCursor
         }
      }
      return
   }

   ; Base64PNG_to_HICON https://www.autohotkey.com/boards/viewtopic.php?p=524691#p524691
   BLen := StrLen(Cursor), nBytes := Floor(StrLen(RTrim(Cursor,"=")) * 3/4 ),  Bin :=Buffer(nBytes)
   CursorShared := DllCall("Crypt32\CryptStringToBinary", "str", Cursor, "uint", BLen, "uint", 1, "ptr", Bin, "uint*", nBytes, "uint", 0, "uint", 0)
                   && DllCall("User32\CreateIconFromResourceEx", "ptr", Bin, "uint", nBytes, "int", true, "uint", 0x30000, "int", cx, "int", cy, "uint", 0, "uptr")
   if CursorShared {
      for CursorName, CursorID in SystemCursors {
         CursorHandle := DllCall("CopyImage", "ptr", CursorShared, "uint", 2, "int", 0, "int", 0, "uint", 0, "ptr")
         DllCall("SetSystemCursor", "ptr", CursorHandle, "int", CursorID) ; calls DestroyCursor
      }
      return
   }

   throw Error("Error: Invalid file path or cursor name")
}

RestoreCursor() {
   return DllCall("SystemParametersInfo", "uint", SPI_SETCURSORS := 0x57, "uint", 0, "ptr", 0, "uint", 0)
}
;----------------------------------- exit -----------------------------------
exit(*){
  global
  
  ;RestoreCursor()
  
  OnMessage 0x03, moveEventSwitch, 0
  OnMessage 0x200, WM_MOUSEMOVED, 0
  
  voiceIsSpeaker := 1
  voiceIsSpeed := 0 ; -10 .. +10
  
  sp := "<speak version='1.0' xmlns='http://www.w3.org/2001/10/synthesis' xml:lang='us-US'>"
  sp .= "Thank you for using Unicode Table"
  sp .= "</speak>"
  speak(sp)
  
  ExitApp
}
;-------------------------- isControlCharacter --------------------------
isControlCharacter(s){
  ret := 0

    if (InStr(s, "NUL") || InStr(s, "HT") || InStr(s, "CR") ||
    InStr(s, "LF") || InStr(s, "OVF") || InStr(s, "END")){
      ret := 1
    }
    
  return ret
}
;--------------------------- isAnyControlCharacter ---------------------------
isAnyControlCharacter(s){
  local ret, shortened 
  
  ret := 0
  shortened := StrReplace(s, "0", "")
    
  if (InStr(s, "NUL") || InStr(s, "HT") || InStr(s, "CR") ||
    InStr(s, "LF") || InStr(s, "OVF") || InStr(s, "END") ||
    shortened = "" || shortened = "9" || 
    shortened = "8" || shortened = "9" || 
    shortened = "a" || shortened = "d"  ){
      ret := 1
    }
    
  return ret
}
;----------------------------------- todo -----------------------------------
todo(p1, p2 ,*){

  showHintColored("TODO: UNDER CONSTRUCTION!", 5000)

}
;----------------------------------------------------------------------------


















