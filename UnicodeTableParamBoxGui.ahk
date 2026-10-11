; UnicodeTableParamBoxGui.ahk
; Part of unicodeTable.ahk

;-------------------------------- paramBoxGui --------------------------------
paramBoxGui(){
  global
  
  ;ExportMenu := Menu()
  ;ExportMenu.Add("Append the first character to `"insertUnicode.txt`"-file", saveToInsertUnicodeFile)
  
  guiParamBox := Gui("+OwnDialogs MaximizeBox +Resize", appTitle "- ParamBox")
  
  guiParamBoxMenu := MenuBar()
  guiParamBoxMenu.Add("⟹" " `"Frequently used`"", saveToInsertUnicodeFile)
  guiParamBoxMenu.Add("☛" " Character name", showCharName)
  guiParamBoxMenu.Add("♒" " Close ParamBox", showMain)
  
  guiParamBoxMenu.Add("🗙" " Exit", guiMain_Close)
  guiParamBox.MenuBar := guiParamBoxMenu
  
  
  guiParamBox.SetFont("S" . guiMainFontSize, guiMainFontName)
  
  if(guiParamBoxPosX = 0 || guiParamBoxPosY = 0 || guiParamBoxClientWidth = 0 || guiParamBoxClientHeight = 0){
    guiParamBoxPosX := guiMainPosX
    guiParamBoxPosY := guiMainPosY
    guiParamBoxClientWidth := guiMainClientWidth
    guiParamBoxClientHeight := guiMainClientHeight
  }
  msg1 := "First copy a character from the Unicode-table! (Using the context-menu or [Ctrl] + [c])" 
  guiParamBoxText1 := guiParamBox.Add("Text", "x" padding " r1 vParamBoxValueT1", "Character(s): ") 
  guiParamBoxRow1 := guiParamBox.Add("Edit", "readonly x+m section y" padding " r" paramBoxRows " vParamBoxValue1 w" guiParamBoxClientWidth - paramBoxEditPadding , msg1)

  guiParamBoxText2 := guiParamBox.Add("Text", "x" padding " r1 vParamBoxValueT2", "UTF-32 (U+): ") 
  guiParamBoxRow2 := guiParamBox.Add("Edit", "readonly xs yp+0 r" paramBoxRows " vParamBoxValue2 w" guiParamBoxClientWidth - paramBoxEditPadding, "") 

  guiParamBoxText3 := guiParamBox.Add("Text", "x" padding " r1 vParamBoxValueT3", "UTF-16 (U+): ") 
  guiParamBoxRow3 := guiParamBox.Add("Edit", "readonly xs yp+0 r" paramBoxRows " vParamBoxValue3 w" guiParamBoxClientWidth - paramBoxEditPadding, "") 

  guiParamBoxText4 := guiParamBox.Add("Text", "x" padding " r1 vParamBoxValueT4", "UTF-8: (U+) ") 
  guiParamBoxRow4 := guiParamBox.Add("Edit", "readonly xs yp+0 r" paramBoxRows " vParamBoxValue4 w" guiParamBoxClientWidth - paramBoxEditPadding, "") 

  guiParamBoxText5 := guiParamBox.Add("Text", "x" padding " r1 vParamBoxValueT5", "UTF-8: (binary) ") 
  guiParamBoxRow5 := guiParamBox.Add("Edit", "readonly xs yp+0 r" paramBoxRows " vParamBoxValue5 w" guiParamBoxClientWidth - paramBoxEditPadding, "") 

  guiParamBoxText6 := guiParamBox.Add("Text", "x" padding " r1 vParamBoxValueT6", "HTML:  ") 
  guiParamBoxRow6 := guiParamBox.Add("Edit", "readonly xs yp+0 r" paramBoxRows " vParamBoxValue6 w" guiParamBoxClientWidth - paramBoxEditPadding, "") 

  guiParamBoxText7 := guiParamBox.Add("Text", "x" padding " r1 vParamBoxValueT7", "URI: ") 
  guiParamBoxRow7 := guiParamBox.Add("Edit", "readonly xs yp+0 r" paramBoxRows " vParamBoxValue7 w" guiParamBoxClientWidth - paramBoxEditPadding, "") 

  guiParamBoxText10 := guiParamBox.Add("Text", "x" padding " r1 vParamBoxValueT10", "Num. (U+) to`nUTF-32 Char.") 
  guiParamBoxRow10 := guiParamBox.Add("Edit", "xs yp+0 r1 vParamBoxValue10 w" guiParamBoxClientWidth - paramBoxEditPadding - buttonWidth, "") 
  guiParamBoxButton10 := guiParamBox.Add("Button", "x+m yp+0", "Show character") 
  
  guiParamBoxButton10.OnEvent("Click", inversInput)

  guiParamBox.Show("Hide x" guiParamBoxPosX " y" guiParamBoxPosY " autosize")
  WinGetPos ,,, &guiParamBoxClientHeight, guiParamBox
  
  guiParamBox.OnEvent("Size", guiParamBox_Size, 1)
}
;------------------------------- showCharName -------------------------------
showCharName(*){
  global
  local charName, charInfo, value4, value6
  
  charName := ""
  charInfo := ""
  lastChar := SubStr(guiParamBoxRow1.value, 1, 1)
  if (lastChar != ""){
    utf32String := guiParamBoxRow2.Value
    utf32Hex := Format("0x{:X}", "0x" . utf32String)
    if (isNumber(utf32Hex)){
      if (unicodeNameMap.has(utf32String)){
        charName := unicodeNameMap.get(utf32String)
        charInfo := lastChar " (" charName " )"
      } else {
        charName := getCharNameFromWeb(utf32String)
        charInfo := lastChar " (" charName ")"
        unicodeNameMap.Set(utf32String, charName)
        unicodeNameMapSave()
      }
      showHintColored(charInfo, 5000)
    } else {
      msgbox("Input guiParamBoxRow2 is not a valid number: " . utf32Hex)
    }
  } else {
    msgbox("Input guiParamBoxRow1 is empty!")
  }
}
;-------------------------- saveToInsertUnicodeFile --------------------------
saveToInsertUnicodeFile(*){
  global 
  local charName, charInfo, value4, value6
  
  OnClipboardChange(OnClipboardChangeFunction, 0)
  
  charName := ""
  charInfo := ""
  
  readInsertableRaw()
  
  lastChar  := SubStr(guiParamBoxRow1.value, 1, 1)
  
  utf32String := guiParamBoxRow2.Value
    
  if (unicodeNameMap.has(utf32String)){
    charName := unicodeNameMap.get(utf32String)
  } else {
    charName := getCharNameFromWeb(utf32String)
    unicodeNameMap.Set(utf32String, charName)
    unicodeNameMapSave()
  }

  InBox := InputBox("Character is : " lastChar ", please verify the character name!", "Unicode character export to the file `"insertUnicode.txt`" ", "w400 h100", charName)
  if (InBox.Result = "ok"){
    InsertableValues.Set(lastChar, InBox.value)
    exportInsertable()
    readInsertable() ; reread, generate MainMenuInsert
    showHintColored("Ok, appended character: " lastChar " char name: " InBox.value)
    refresh()
  } else {
    showHintColored("Cancelled!")
  }
  OnClipboardChange(OnClipboardChangeFunction, 1)
}
;---------------------------- getCharNameFromWeb ----------------------------
getCharNameFromWeb(utfString){
; https://www.autohotkey.com/boards/viewtopic.php?t=80466
  global
  local ret
  
  ret := "unknown"

  if (utfString != ""){
    utfString := RegExReplace(utfString, "^0+", "")
    url := "https://www.compart.com/de/unicode/U+" . utfString

    oHTTP := ComObject("MSXML2.XMLHTTP.6.0")

    oHTTP.open("GET", url, false)

    oHTTP.setRequestHeader("Content-Type", "text/plain")
    oHTTP.setRequestHeader("Cache-Control", "no-cache")
    oHTTP.setRequestHeader("User-Agent", "Mozilla/5.0")
    
    oHTTP.send()

    if(oHTTP.statusText = "OK") {
      oDocument := ComObject("HTMLfile")
      oDocument.write(oHTTP.responseText)
      oDocument.close()

      while !(oDocument.readyState = "Complete")
        Sleep 1000

      ret := oDocument.getElementsByTagName("td").item(3).firstChild.data
    }
  } else {
      msgbox("getCharNameFromWeb got an empty parameter!")
  }

  return ret
}
;----------------------------- exportInsertable -----------------------------
exportInsertable(){
  global 
  local file, name, key, value
  
  file := "insertUnicode.txt"
  if (FileExist(file))
    FileDelete(file)
    
  for key, value in InsertableValues {
    toAppend := key "|" value "`n"
    FileAppend toAppend, file, "`n"
  }
}
;----------------------------- readInsertableRaw -----------------------------
readInsertableRaw(){
  global 
  local file, name, value
  
  MainMenuInsert := Menu()
  
  file := "insertUnicode.txt"

  InsertableValues := Map()
  
  if (FileExist(file)){
    Loop read, file
    {
      name := ""
      value := ""
      Loop Parse, A_LoopReadLine, "`"|`""
      {
        switch A_Index
        {
          case "1":
            value := A_LoopField
          case "2":
            name := A_LoopField
        }
      }
      InsertableValues.Set(value, name)
     }
  }
}
;------------------------------ readInsertable ------------------------------
readInsertable(){
  global 
  local file, name, value
  
  MainMenuInsert := Menu()
  MainMenuInsert.Add("Edit list (ext)", editInsertUnicode)
  
  file := "insertUnicode.txt"
  InsertableArray := []
  value := ""
  name := ""
  if (FileExist(file)){
    Loop read, file
    {
      Loop Parse, A_LoopReadLine, "`"|`""
      {
        switch A_Index
        {
          case "1":
            value := A_LoopField
          case "2":
            name := A_LoopField
        }
      }
      MainMenuInsert.Add(value . "`t(" . name . ")", insertValue)
      InsertableArray.push(value)
      value := ""
      name := ""
    }
  }
}
;----------------------------- editInsertUnicode -----------------------------
editInsertUnicode(*){
  global
  
  runWait "insertUnicode.txt"
  msgbox "If changes are made, please clickthe `"refresh`" button!"
}
;-------------------------------- insertValue --------------------------------
insertValue(p, p1, *){
  global
  local value, index
  
  index := p1 - 1 ; due to "edit" top entry
  value := InsertableArray[index]
  A_Clipboard := value
  ToolTip("Clipboard contains: " value)
  SetTimer ()=> ToolTip(), -6000
}
;-------------------------------- inversInput --------------------------------
inversInput(*){
  global
  local v, f, r
  
  inversInputRunning := 1
  v := guiParamBoxRow10.Value
  r := ""
   
  v := StrReplace(v, "0x","")
  v := RegExReplace(v, "[^0-9a-fA-F ]","")
  v := StrUpper(v)
  guiParamBoxRow10.Value := v
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
;------------------------------ toggleParamBox ------------------------------
toggleParamBox(*){
  global
  
  if (!paramBoxVisible){
    guiParamBox.Show("Restore")
    paramBoxVisible := 1
  } else {
    guiParamBox.Hide()
    paramBoxVisible := 0
  }
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
  AutoXYWH2("w", guiParamBoxRow10)
  AutoXYWH2("x", guiParamBoxButton10)
  
  ; reset height
  WinMove ,,, guiParamBoxClientHeight, guiParamBox
}
;------------------------------ guiParamBoxMove ------------------------------
guiParamBoxMove(){
  global
  local posX, posY

  guiParamBox.GetPos(&posX, &posY)

  if (posX != 0 && posY != 0){  
    guiParamBoxPosX := min(posX, maxPosLeft)
    guiParamBoxPosX := max(posX, minPosLeft)
    
    guiParamBoxPosY := min(posY, maxPosTop)
    guiParamBoxPosY := max(posY, minPosTop)
    
    IniWrite guiParamBoxPosX, configFile, "gui", "guiParamBoxPosX"
    IniWrite guiParamBoxPosY, configFile, "gui", "guiParamBoxPosY"
  }
}




;----------------------------------------------------------------------------


