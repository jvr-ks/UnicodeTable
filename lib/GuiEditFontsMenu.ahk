; GuiEditFontsMenu.ahk (lib)
; #Include lib\GuiEditFontsMenu.ahk


;----------------------------- generateGuiEditFontsMenu -----------------------------
generateGuiEditFontsMenu(){
  global
  local font
  
  font := ""
  GuiEditFontsMenu := Menu()
  Loop 20 {
    if (IsSet(preferredFont%A_Index%Default))
      font := iniReadSave("preferredFont%A_Index%", "preferedFonts", preferredFont%A_Index%Default)
    else
      font := iniReadSave("preferredFont%A_Index%", "preferedFonts", "")
    
    if (font != "")
      GuiEditFontsMenu.Add(font, selectTextFont.Bind(font), "Radio")
  }
  
  GuiEditFontsMenu.Add()
  
  Loop Parse allFontsList, "`n" {
    if (A_LoopField != "") {
      GuiEditFontsMenu.Add(A_LoopField, selectTextFont.Bind(A_LoopField), "Radio")
    }
  }
}
;------------------------------ selectTextFont ------------------------------
selectTextFont(fn, *){
  global
  
  if (IsSet(guiMainEdit)){
    GuiEditFontsMenu.UnCheck(guiMainEditFontName) 
    guiMainEditFontName := fn
    guiMainEdit.Style.Font := guiMainEditFontName
    GuiEditFontsMenu.Check(guiMainEditFontName) 
    
    IniWrite("`"" guiMainEditFontName "`"", configFile, "config", "guiMainEditFontName")
    updateMainSB()
    reload
  }
}
;----------------------- generateGuiEditFontSizeMenu -----------------------
generateGuiEditFontSizeMenu(){
  global 
  
  GuiEditFontSizeMenu := Menu()
  Loop 16 {
    GuiEditFontSizeMenu.Add(A_Index + 3, selectGuiEditFontSize.Bind(A_Index + 3), "Radio")
  }
}
;----------------------------- selectGuiFontSize -----------------------------
selectGuiEditFontSize(fs, *){
  global
  
    guiMainEditFontsize := fs
    guiMainEdit.SetFont("s" . guiMainEditFontsize, guiMainEditFontName)
    GuiEditFontSizeMenu.Check(guiMainEditFontsize) 
    
    IniWrite guiMainEditFontsize, configFile, "config", "guiMainEditFontsize"
    
    reload
}
;----------------------------------------------------------------------------

