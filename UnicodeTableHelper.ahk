; UnicodeTableHelper.ahk
; Part of UnicodeTable.ahk

;-------------------------------- readConfig --------------------------------
readConfig(){
  global
  local v 
  
  if (FileExist(configFile)){
    ; config section:
    guiMainFontName := iniReadSave("guiMainFontName", "config", "Segoe UI")
    guiMainFontSize := iniReadSave("guiMainFontSize", "config", 10)
    
    guiMainEditFontName := iniReadSave("guiMainEditFontName", "config", "Consolas")
    guiMainEditFontSize := iniReadSave("guiMainEditFontSize", "config", 11)
    
    catchAll := iniReadSave("catchAll", "config", 0)
    tableIsWritable := iniReadSave("tableIsWritable", "config", 0)
    
    mwheelModifier := iniReadSave("mwheelModifier", "config", mwheelModifierDefault)
    currentTableStartPosition := iniReadSave("currentTableStartPosition", "config", currentTableStartPositionDefault)
    
    indexVisible := iniReadSave("indexVisible", "gui", 1)
    dpiScaleValue := iniReadSave("dpiScaleValue", "gui", dpiScaleValueDefault)
    paramBoxRows := iniReadSave("paramBoxRows", "gui", paramBoxRowsDefault)
    
    voiceEnabled := iniReadSave("voiceEnabled", "config", 0)
    
    guiMainPosX := iniReadSave("guiMainPosX", "gui", guiMainPosXDefault)
    guiMainPosY := iniReadSave("guiMainPosY", "gui", guiMainPosYDefault)
    guiMainClientWidth := iniReadSave("guiMainClientWidth", "gui", guiMainClientWidthDefault)
    guiMainClientHeight := iniReadSave("guiMainClientHeight", "gui", guiMainClientHeightDefault)
    
    guiMainPosX := min(guiMainPosX, maxPosLeft)
    guiMainPosX := max(guiMainPosX, minPosLeft)
    
    guiMainPosY := min(guiMainPosY, maxPosTop)
    guiMainPosY := max(guiMainPosY, minPosTop)
    
    guiParamBoxPosX := iniReadSave("guiParamBoxPosX", "gui", guiMainPosXDefault)
    guiParamBoxPosY := iniReadSave("guiParamBoxPosY", "gui", guiMainPosYDefault)
    guiParamBoxClientWidth := iniReadSave("guiParamBoxClientWidth", "gui", guiMainClientWidthDefault)
    guiParamBoxClientHeight := iniReadSave("guiParamBoxClientHeight", "gui", guiMainClientHeightDefault)
    
    guiParamBoxPosX := min(guiParamBoxPosX, maxPosLeft)
    guiParamBoxPosX := max(guiParamBoxPosX, minPosLeft)
    
    guiParamBoxPosY := min(guiParamBoxPosY, maxPosTop)
    guiParamBoxPosY := max(guiParamBoxPosY, minPosTop)
      
  } else {
  FileAppend "
(
[config]
guiMainFontName=Segoe UI
guiMainFontSize=10
voiceEnabled=1
[gui]
dpiScaleValue=96
paramBoxRows=4
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
/* readFontsList(){
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
} */
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
    newfont := guiMainFontName
    
  if (newfontsize == "")
    newfontsize := guiMainFontSize
    
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
    newfont := guiMainFontName
    
  if (newfontsize == "")
    newfontsize := guiMainFontSize
  
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
;--------------------------- GetProcessMemoryUsage ---------------------------
GetProcessMemoryUsage() {
  local PID, size, pmcex, ret, hProcess
  
  PID := DllCall("GetCurrentProcessId")
  size := 880
  pmcex := Buffer(size, 0)
  ret := ""
  
  hProcess := DllCall("OpenProcess", "UInt", 0x400|0x0010, "Int", 0, "Ptr", PID, "Ptr")
  if (hProcess)
  {
      if (DllCall("psapi.dll\GetProcessMemoryInfo", "Ptr", hProcess, "Ptr", pmcex, "UInt", size))
        ret := Round(NumGet(pmcex, "16", "UInt") / 1024**2, 2)
      DllCall("CloseHandle", "Ptr", hProcess)
  }
  return ret
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
;------------------------------- stringToHTML -------------------------------
stringToHTML(s, complete := 0){
  convertMap := Map()

  convertMap.Set("&", "&amp;")
  convertMap.Set("<", "&lt;")
  convertMap.Set(">", "&gt;")
  convertMap.Set(Chr(160), "&nbsp;")
  convertMap.Set("¡", "&iexcl;") ; 161
  convertMap.Set("¢", "&cent;")
  convertMap.Set("£", "&pound;")
  convertMap.Set("¤", "&curren;")
  convertMap.Set("¥", "&yen;")
  convertMap.Set("¦", "&brvbar;")
  convertMap.Set("§", "&sect;")
  convertMap.Set("¨", "&uml;")
  convertMap.Set("©", "&copy;")
  convertMap.Set("ª", "&ordf;")
  convertMap.Set("«", "&laquo;")
  convertMap.Set("¬", "&not;")
  convertMap.Set("Chr(173)", "&shy;")
  convertMap.Set("®", "&reg;")
  convertMap.Set("¯", "&macr;")
  convertMap.Set("°", "&deg;")
  convertMap.Set("±", "&plusmn;")
  convertMap.Set("²", "&sup2;")
  convertMap.Set("³", "&sup3;")
  convertMap.Set("´", "&acute;")
  convertMap.Set("µ", "&micro;")
  convertMap.Set("¶", "&para;")
  convertMap.Set("¸", "&cedil;")
  convertMap.Set("¹", "&sup1;")
  convertMap.Set("º", "&ordm;")
  convertMap.Set("»", "&raquo;")
  convertMap.Set("¼", "&frac14;")
  convertMap.Set("½", "&frac12;")
  convertMap.Set("¾", "&frac34;")
  convertMap.Set("¿", "&iquest;")
  convertMap.Set("×", "&times;")
  convertMap.Set("÷", "&divide;")
  convertMap.Set("∀", "&forall;")
  convertMap.Set("∂", "&part;")
  convertMap.Set("∃", "&exist;")
  convertMap.Set("∅", "&empty;")
  convertMap.Set("∇", "&nabla;")
  convertMap.Set("∈", "&isin;")
  convertMap.Set("∉", "&notin;")
  convertMap.Set("∋", "&ni;")
  convertMap.Set("∏", "&prod;")
  convertMap.Set("∑", "&sum;")
  convertMap.Set("−", "&minus;")
  convertMap.Set("∗", "&lowast;")
  convertMap.Set("√", "&radic;")
  convertMap.Set("∝", "&prop;")
  convertMap.Set("∞", "&infin;")
  convertMap.Set("∠", "&ang;")
  convertMap.Set("∧", "&and;")
  convertMap.Set("∨", "&or;")
  convertMap.Set("∩", "&cap;")
  convertMap.Set("∪", "&cup;")
  convertMap.Set("∫", "&int;")
  convertMap.Set("∴", "&there4;")
  convertMap.Set("∼", "&sim;")
  convertMap.Set("≅", "&cong;")
  convertMap.Set("≈", "&asymp;")
  convertMap.Set("≠", "&ne;")
  convertMap.Set("≡", "&equiv;")
  convertMap.Set("≤", "&le;")
  convertMap.Set("≥", "&ge;")
  convertMap.Set("⊂", "&sub;")
  convertMap.Set("⊃", "&sup;")
  convertMap.Set("⊄", "&nsub;")
  convertMap.Set("⊆", "&sube;")
  convertMap.Set("⊇", "&supe;")
  convertMap.Set("⊕", "&oplus;")
  convertMap.Set("⊗", "&otimes;")
  convertMap.Set("⊥", "&perp;")
  convertMap.Set("⋅", "&sdot;")
  convertMap.Set("Α", "&Alpha;")
  convertMap.Set("Β", "&Beta;")
  convertMap.Set("Γ", "&Gamma;")
  convertMap.Set("Δ", "&Delta;")
  convertMap.Set("Ε", "&Epsilon;")
  convertMap.Set("Ζ", "&Zeta;")
  convertMap.Set("Η", "&Eta;")
  convertMap.Set("Θ", "&Theta;")
  convertMap.Set("Ι", "&Iota;")
  convertMap.Set("Κ", "&Kappa;")
  convertMap.Set("Λ", "&Lambda;")
  convertMap.Set("Μ", "&Mu;")
  convertMap.Set("Ν", "&Nu;")
  convertMap.Set("Ξ", "&Xi;")
  convertMap.Set("Ο", "&Omicron;")
  convertMap.Set("Π", "&Pi;")
  convertMap.Set("Ρ", "&Rho;")
  convertMap.Set("Σ", "&Sigma;")
  convertMap.Set("Τ", "&Tau;")
  convertMap.Set("Υ", "&Upsilon;")
  convertMap.Set("Φ", "&Phi;")
  convertMap.Set("Χ", "&Chi;")
  convertMap.Set("Ψ", "&Psi;")
  convertMap.Set("Ω", "&Omega;")
  convertMap.Set("α", "&alpha;")
  convertMap.Set("β", "&beta;")
  convertMap.Set("γ", "&gamma;")
  convertMap.Set("δ", "&delta;")
  convertMap.Set("ε", "&epsilon;")
  convertMap.Set("ζ", "&zeta;")
  convertMap.Set("η", "&eta;")
  convertMap.Set("θ", "&theta;")
  convertMap.Set("ι", "&iota;")
  convertMap.Set("κ", "&kappa;")
  convertMap.Set("λ", "&lambda;")
  convertMap.Set("μ", "&mu;")
  convertMap.Set("ν", "&nu;")
  convertMap.Set("ξ", "&xi;")
  convertMap.Set("ο", "&omicron;")
  convertMap.Set("π", "&pi;")
  convertMap.Set("ρ", "&rho;")
  convertMap.Set("ς", "&sigmaf;")
  convertMap.Set("σ", "&sigma;")
  convertMap.Set("τ", "&tau;")
  convertMap.Set("υ", "&upsilon;")
  convertMap.Set("φ", "&phi;")
  convertMap.Set("χ", "&chi;")
  convertMap.Set("ψ", "&psi;")
  convertMap.Set("ω", "&omega;")
  convertMap.Set("ϑ", "&thetasym;")
  convertMap.Set("ϒ", "&upsih;")
  convertMap.Set("ϖ", "&piv;")
  convertMap.Set("Œ", "&OElig;")
  convertMap.Set("œ", "&oelig;")
  convertMap.Set("Š", "&Scaron;")
  convertMap.Set("š", "&scaron;")
  convertMap.Set("Ÿ", "&Yuml;")
  convertMap.Set("ƒ", "&fnof;")
  convertMap.Set("ˆ", "&circ;")
  convertMap.Set("˜", "&tilde;")
  convertMap.Set("Chr(8194)", "&ensp;")
  convertMap.Set("Chr(8195)", "&emsp;")
  convertMap.Set("Chr(8201)", "&thinsp;")
  convertMap.Set("Chr(8204)", "&zwnj;")
  convertMap.Set("Chr(8205)", "&zwj;")
  convertMap.Set("Chr(8206)", "&lrm;")
  convertMap.Set("Chr(8207)", "&rlm;")
  convertMap.Set("–", "&ndash;")
  convertMap.Set("—", "&mdash;")
  convertMap.Set("‘", "&lsquo;")
  convertMap.Set("’", "&rsquo;")
  convertMap.Set("‚", "&sbquo;")
  convertMap.Set("“", "&ldquo;")
  convertMap.Set("”", "&rdquo;")
  convertMap.Set("„", "&bdquo;")
  convertMap.Set("†", "&dagger;")
  convertMap.Set("‡", "&Dagger;")
  convertMap.Set("•", "&bull;")
  convertMap.Set("…", "&hellip;")
  convertMap.Set("‰", "&permil;")
  convertMap.Set("′", "&prime;")
  convertMap.Set("″", "&Prime;")
  convertMap.Set("‹", "&lsaquo;")
  convertMap.Set("›", "&rsaquo;")
  convertMap.Set("‾", "&oline;")
  convertMap.Set("€", "&euro;")
  convertMap.Set("™", "&trade;")
  convertMap.Set("←", "&larr;")
  convertMap.Set("↑", "&uarr;")
  convertMap.Set("→", "&rarr;")
  convertMap.Set("↓", "&darr;")
  convertMap.Set("↔", "&harr;")
  convertMap.Set("↵", "&crarr;")
  convertMap.Set("⌈", "&lceil;")
  convertMap.Set("⌉", "&rceil;")
  convertMap.Set("⌊", "&lfloor;")
  convertMap.Set("⌋", "&rfloor;")
  convertMap.Set("◊", "&loz;")
  convertMap.Set("♠", "&spades;")
  convertMap.Set("♣", "&clubs;")
  convertMap.Set("♥", "&hearts;")
  convertMap.Set("♦", "&diams;")

  ret := ""

  Loop Parse, s, " `t", "`r" {
    if (convertMap.Has(A_Loopfield)){
      ret .= convertMap.Get(A_Loopfield)
    } else {
      ret .= A_Loopfield
    }
  }

  return ret
}
;-------------------------------- stringToUri --------------------------------
stringToUri(s, complete := 0){
  convertMap := Map()
  if (complete){
    convertMap.Set("0", "%30")
    convertMap.Set("1", "%31")
    convertMap.Set("2", "%32")
    convertMap.Set("3", "%33")
    convertMap.Set("4", "%34")
    convertMap.Set("5", "%35")
    convertMap.Set("6", "%36")
    convertMap.Set("7", "%37")
    convertMap.Set("8", "%38")
    convertMap.Set("9", "%39")
    convertMap.Set("A", "%41")
    convertMap.Set("B", "%42")
    convertMap.Set("C", "%43")
    convertMap.Set("D", "%44")
    convertMap.Set("E", "%45")
    convertMap.Set("F", "%46")
    convertMap.Set("G", "%47")
    convertMap.Set("H", "%48")
    convertMap.Set("I", "%49")
    convertMap.Set("J", "%4A")
    convertMap.Set("K", "%4B")
    convertMap.Set("L", "%4C")
    convertMap.Set("M", "%4D")
    convertMap.Set("N", "%4E")
    convertMap.Set("O", "%4F")
    convertMap.Set("P", "%50")
    convertMap.Set("Q", "%51")
    convertMap.Set("R", "%52")
    convertMap.Set("S", "%53")
    convertMap.Set("T", "%54")
    convertMap.Set("U", "%55")
    convertMap.Set("V", "%56")
    convertMap.Set("W", "%57")
    convertMap.Set("X", "%58")
    convertMap.Set("Y", "%59")
    convertMap.Set("Z", "%5A")
    convertMap.Set("a", "%61")
    convertMap.Set("b", "%62")
    convertMap.Set("c", "%63")
    convertMap.Set("d", "%64")
    convertMap.Set("e", "%65")
    convertMap.Set("f", "%66")
    convertMap.Set("g", "%67")
    convertMap.Set("h", "%68")
    convertMap.Set("i", "%69")
    convertMap.Set("j", "%6A")
    convertMap.Set("k", "%6B")
    convertMap.Set("l", "%6C")
    convertMap.Set("m", "%6D")
    convertMap.Set("n", "%6E")
    convertMap.Set("o", "%6F")
    convertMap.Set("p", "%70")
    convertMap.Set("q", "%71")
    convertMap.Set("r", "%72")
    convertMap.Set("s", "%73")
    convertMap.Set("t", "%74")
    convertMap.Set("u", "%75")
    convertMap.Set("v", "%76")
    convertMap.Set("w", "%77")
    convertMap.Set("x", "%78")
    convertMap.Set("y", "%79")
    convertMap.Set("z", "%7A")
  }
  
  convertMap.Set(" ", "%20")
  convertMap.Set("!", "%21")
  convertMap.Set("`"", "%22") ;"
  convertMap.Set("#", "%23")
  convertMap.Set("$", "%24")
  convertMap.Set("%", "%25")
  convertMap.Set("&", "%26")
  convertMap.Set("'", "%27")
  convertMap.Set("(", "%28")
  convertMap.Set(")", "%29")
  convertMap.Set("*", "%2A")
  convertMap.Set("+", "%2B")
  convertMap.Set(",", "%2C")
  convertMap.Set("-", "%2D")
  convertMap.Set(".", "%2E")
  convertMap.Set("/", "%2F")

  convertMap.Set(":", "%3A")
  convertMap.Set("", "%3B")
  convertMap.Set("<", "%3C")
  convertMap.Set("=", "%3D")
  convertMap.Set(">", "%3E")
  convertMap.Set("?", "%3F")
  convertMap.Set("@", "%40")

  convertMap.Set("[", "%5B")
  convertMap.Set("\", "%5C")
  convertMap.Set("]", "%5D")
  convertMap.Set("^", "%5E")
  convertMap.Set("_", "%5F")
  convertMap.Set("``", "%60")

  convertMap.Set("{", "%7B")
  convertMap.Set("|", "%7C")
  convertMap.Set("}", "%7D")
  convertMap.Set("~", "%7E")
  convertMap.Set(" ", "%7F")
  convertMap.Set("€", "%E2%82%AC")
  convertMap.Set("", "%81")
  convertMap.Set("‚", "%E2%80%9A")
  convertMap.Set("ƒ", "%C6%92")
  convertMap.Set("„", "%E2%80%9E")
  convertMap.Set("…", "%E2%80%A6")
  convertMap.Set("†", "%E2%80%A0")
  convertMap.Set("‡", "%E2%80%A1")
  convertMap.Set("ˆ", "%CB%86")
  convertMap.Set("‰", "%E2%80%B0")
  convertMap.Set("Š", "%C5%A0")
  convertMap.Set("‹", "%E2%80%B9")
  convertMap.Set("Œ", "%C5%92")
  convertMap.Set("", "%C5%8D")
  convertMap.Set("Ž", "%C5%BD")
  convertMap.Set("", "%8F")
  convertMap.Set("", "%C2%90")
  convertMap.Set("‘", "%E2%80%98")
  convertMap.Set("’", "%E2%80%99")
  convertMap.Set("“", "%E2%80%9C")
  convertMap.Set("”", "%E2%80%9D")
  convertMap.Set("•", "%E2%80%A2")
  convertMap.Set("–", "%E2%80%93")
  convertMap.Set("—", "%E2%80%94")
  convertMap.Set("˜", "%CB%9C")
  convertMap.Set("™", "%E2%84")
  convertMap.Set("š", "%C5%A1")
  convertMap.Set("›", "%E2%80")
  convertMap.Set("œ", "%C5%93")
  convertMap.Set("", "%9D")
  convertMap.Set("ž", "%C5%BE")
  convertMap.Set("Ÿ", "%C5%B8")
  convertMap.Set(" ", "%C2%A0")
  convertMap.Set("¡", "%C2%A1")
  convertMap.Set("¢", "%C2%A2")
  convertMap.Set("£", "%C2%A3")
  convertMap.Set("¤", "%C2%A4")
  convertMap.Set("¥", "%C2%A5")
  convertMap.Set("¦", "%C2%A6")
  convertMap.Set("§", "%C2%A7")
  convertMap.Set("¨", "%C2%A8")
  convertMap.Set("©", "%C2%A9")
  convertMap.Set("ª", "%C2%AA")
  convertMap.Set("«", "%C2%AB")
  convertMap.Set("¬", "%C2%AC")
  convertMap.Set("Chr(173)", "%C2%AD")
  convertMap.Set("®", "%C2%AE")
  convertMap.Set("¯", "%C2%AF")
  convertMap.Set("°", "%C2%B0")
  convertMap.Set("±", "%C2%B1")
  convertMap.Set("²", "%C2%B2")
  convertMap.Set("³", "%C2%B3")
  convertMap.Set("´", "%C2%B4")
  convertMap.Set("µ", "%C2%B5")
  convertMap.Set("¶", "%C2%B6")
  convertMap.Set("·", "%C2%B7")
  convertMap.Set("¸", "%C2%B8")
  convertMap.Set("¹", "%C2%B9")
  convertMap.Set("º", "%C2%BA")
  convertMap.Set("»", "%C2%BB")
  convertMap.Set("¼", "%C2%BC")
  convertMap.Set("½", "%C2%BD")
  convertMap.Set("¾", "%C2%BE")
  convertMap.Set("¿", "%C2%BF")
  convertMap.Set("À", "%C3%80")
  convertMap.Set("Á", "%C3%81")
  convertMap.Set("Â", "%C3%82")
  convertMap.Set("Ã", "%C3%83")
  convertMap.Set("Ä", "%C3%84")
  convertMap.Set("Å", "%C3%85")
  convertMap.Set("Æ", "%C3%86")
  convertMap.Set("Ç", "%C3%87")
  convertMap.Set("È", "%C3%88")
  convertMap.Set("É", "%C3%89")
  convertMap.Set("Ê", "%C3%8A")
  convertMap.Set("Ë", "%C3%8B")
  convertMap.Set("Ì", "%C3%8C")
  convertMap.Set("Í", "%C3%8D")
  convertMap.Set("Î", "%C3%8E")
  convertMap.Set("Ï", "%C3%8F")
  convertMap.Set("Ð", "%C3%90")
  convertMap.Set("Ñ", "%C3%91")
  convertMap.Set("Ò", "%C3%92")
  convertMap.Set("Ó", "%C3%93")
  convertMap.Set("Ô", "%C3%94")
  convertMap.Set("Õ", "%C3%95")
  convertMap.Set("Ö", "%C3%96")
  convertMap.Set("×", "%C3%97")
  convertMap.Set("Ø", "%C3%98")
  convertMap.Set("Ù", "%C3%99")
  convertMap.Set("Ú", "%C3%9A")
  convertMap.Set("Û", "%C3%9B")
  convertMap.Set("Ü", "%C3%9C")
  convertMap.Set("Ý", "%C3%9D")
  convertMap.Set("Þ", "%C3%9E")
  convertMap.Set("ß", "%C3%9F")
  convertMap.Set("à", "%C3%A0")
  convertMap.Set("á", "%C3%A1")
  convertMap.Set("â", "%C3%A2")
  convertMap.Set("ã", "%C3%A3")
  convertMap.Set("ä", "%C3%A4")
  convertMap.Set("å", "%C3%A5")
  convertMap.Set("æ", "%C3%A6")
  convertMap.Set("ç", "%C3%A7")
  convertMap.Set("è", "%C3%A8")
  convertMap.Set("é", "%C3%A9")
  convertMap.Set("ê", "%C3%AA")
  convertMap.Set("ë", "%C3%AB")
  convertMap.Set("ì", "%C3%AC")
  convertMap.Set("í", "%C3%AD")
  convertMap.Set("î", "%C3%AE")
  convertMap.Set("ï", "%C3%AF")
  convertMap.Set("ð", "%C3%B0")
  convertMap.Set("ñ", "%C3%B1")
  convertMap.Set("ò", "%C3%B2")
  convertMap.Set("ó", "%C3%B3")
  convertMap.Set("ô", "%C3%B4")
  convertMap.Set("õ", "%C3%B5")
  convertMap.Set("ö", "%C3%B6")
  convertMap.Set("÷", "%C3%B7")
  convertMap.Set("ø", "%C3%B8")
  convertMap.Set("ù", "%C3%B9")
  convertMap.Set("ú", "%C3%BA")
  convertMap.Set("û", "%C3%BB")
  convertMap.Set("ü", "%C3%BC")
  convertMap.Set("ý", "%C3%BD")
  convertMap.Set("þ", "%C3%BE")
  convertMap.Set("ÿ", "%C3%BF")
  convertMap.Set("", "%01")
  convertMap.Set("", "%02")
  convertMap.Set("", "%03")
  convertMap.Set("", "%04")
  convertMap.Set("", "%05")
  convertMap.Set("", "%06")
  convertMap.Set("", "%07")
  convertMap.Set("", "%08")
  convertMap.Set("`t", "%09")
  convertMap.Set("`n", "%0A")
  convertMap.Set("", "%0B")
  convertMap.Set("", "%0C")
  convertMap.Set("`r", "%0D")
  convertMap.Set("", "%0E")
  convertMap.Set("", "%0F")
  convertMap.Set("", "%10")
  convertMap.Set("", "%11")
  convertMap.Set("", "%12")
  convertMap.Set("", "%13")
  convertMap.Set("", "%14")
  convertMap.Set("", "%15")
  convertMap.Set("", "%16")
  convertMap.Set("", "%17")
  convertMap.Set("", "%18")
  convertMap.Set("", "%19")
  convertMap.Set("", "%1A")
  convertMap.Set("", "%1B")
  convertMap.Set("", "%1C")
  convertMap.Set("", "%1D")
  convertMap.Set("", "%1E")
  convertMap.Set("", "%1F")
  convertMap.Set("", "%7F")
  convertMap.Set("", "%80")
  convertMap.Set("", "%81")
  convertMap.Set("", "%82")
  convertMap.Set("", "%83")
  convertMap.Set("", "%84")
  convertMap.Set("", "%85")
  convertMap.Set("", "%86")
  convertMap.Set("", "%87")
  convertMap.Set("", "%88")
  convertMap.Set("", "%89")
  convertMap.Set("", "%8A")
  convertMap.Set("", "%8B")
  convertMap.Set("", "%8C")
  convertMap.Set("", "%8D")
  convertMap.Set("", "%8E")
  convertMap.Set("", "%8F")
  convertMap.Set("", "%90")
  convertMap.Set("", "%91")
  convertMap.Set("", "%92")
  convertMap.Set("", "%93")
  convertMap.Set("", "%94")
  convertMap.Set("", "%95")
  convertMap.Set("", "%96")
  convertMap.Set("", "%97")
  convertMap.Set("", "%98")
  convertMap.Set("", "%99")
  convertMap.Set("", "%9A")
  convertMap.Set("", "%9B")
  convertMap.Set("", "%9C")
  convertMap.Set("", "%9D")
  convertMap.Set("", "%9E")
  convertMap.Set("", "%9F")

  ret := ""
  Loop Parse, s, " `t", "`r" {
    if (convertMap.Has(A_Loopfield)){
      ret .= convertMap.Get(A_Loopfield)
    } else {
      ret .= A_Loopfield
    }
  }

  return ret
}
;--------------------------------- AutoXYWH2 ---------------------------------
AutoXYWH2(DimSize, cList*){   ;https://www.autohotkey.com/boards/viewtopic.php?t=1079

; =================================================================================
; From https://www.autohotkey.com/boards/viewtopic.php?style=1&f=83&t=114445
;
; Function: AutoXYWH
;   Move and resize control automatically when GUI resizes.
; Parameters:
;   DimSize - Can be one or more of x/y/w/h  optional followed by a fraction
;       add a '*' to DimSize to 'MoveDraw' the controls rather then just 'Move', this is recommended for Groupboxes
;       add a 't' to DimSize to tell AutoXYWH that the controls in cList are on/in a tab3 control
;   cList   - variadic list of GuiControl objects
;
; Examples:
;   AutoXYWH("xy", "Btn1", "Btn2")
;   AutoXYWH("w0.5 h 0.75", hEdit, "displayed text", "vLabel", "Button1")
;   AutoXYWH("*w0.5 h 0.75", hGroupbox1, "GrbChoices")
;   AutoXYWH("t x h0.5", "Btn1")
; ---------------------------------------------------------------------------------
; Version: 2023-02-25 / converted to v2 (Relayer)
;      2020-5-20 / small code improvements (toralf)
;      2018-1-31 / added a line to prevent warnings (pramach)
;      2018-1-13 / added t option for controls on Tab3 (Alguimist)
;      2015-5-29 / added 'reset' option (tmplinshi)
;      2014-7-03 / mod by toralf
;      2014-1-02 / initial version tmplinshi
; requires AHK version : v2+
; =================================================================================

  static cInfo := map()

  if (DimSize = "reset")
  Return cInfo := map()

  for i, ctrl in cList {
    ctrlObj := ctrl
    ctrlObj.Gui.GetPos(&gx, &gy, &gw, &gh)
    if !cInfo.Has(ctrlObj) {
      ctrlObj.GetPos(&ix, &iy, &iw, &ih)
      MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
      f := map( "x", 0
        , "y", 0
        , "w", 0
        , "h", 0 )

      for i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]"))) 
      if !RegExMatch(DimSize, "i)" . dim . "\s*\K[\d.-]+", &tmp)
        f[dim] := 1
      else
        f[dim] := tmp

      if (InStr(DimSize, "t")) {
      hWnd := ctrlObj.Hwnd
      hParentWnd := DllCall("GetParent", "Ptr", hWnd, "Ptr")
      RECT := buffer(16, 0)
      DllCall("GetWindowRect", "Ptr", hParentWnd, "Ptr", RECT)
      DllCall("MapWindowPoints", "Ptr", 0, "Ptr", DllCall("GetParent", "Ptr", hParentWnd, "Ptr"), "Ptr", RECT, "UInt", 1)
      ix := ix - NumGet(RECT, 0, "Int")
      iy := iy - NumGet(RECT, 4, "Int")
      }
      cInfo[ctrlObj] := {x:ix, fx:f["x"], y:iy, fy:f["y"], w:iw, fw:f["w"], h:ih, fh:f["h"], gw:gw, gh:gh, a:a, m:MMD}
    } else {
      dg := map( "x", 0
         , "y", 0
         , "w", 0
         , "h", 0 )
      dg["x"] := dg["w"] := gw - cInfo[ctrlObj].gw, dg["y"] := dg["h"] := gh - cInfo[ctrlObj].gh
      ctrlObj.Move(  dg["x"] * cInfo[ctrlObj].fx + cInfo[ctrlObj].x
         , dg["y"] * cInfo[ctrlObj].fy + cInfo[ctrlObj].y
         , dg["w"] * cInfo[ctrlObj].fw + cInfo[ctrlObj].w
         , dg["h"] * cInfo[ctrlObj].fh + cInfo[ctrlObj].h  )
      if (cInfo[ctrlObj].m = "MoveDraw")
      ctrlObj.Redraw()
    }
  }
}
;----------------------------------- todo -----------------------------------
todo(p1, p2 ,*){

  showHintColored("TODO: UNDER CONSTRUCTION!", 5000)

}
;----------------------------------------------------------------------------


















