; UnicodeTableFonts.ahk
; Part of unicodeTable.ahk

;----------------------------- generateTableFontsMenu -----------------------------
generateTableFontsMenu(){
  global
  
  TableFontsMenu := Menu()
  
  for k, v in usableFonts {
    TableFontsMenu.Add(v, selectFont.Bind(v))
  }
}






















