; UnicodeTableMenuGen.ahk
; Part of unicodeTable.ahk


;--------------------------- generateSettingsMenu ---------------------------
generateSettingsMenu(){
  global
  
  
  guiEditFontsSubMenu := Menu()
  guiEditFontsSubMenu.Add("Font", GuiEditFontsMenu)
  guiEditFontsSubMenu.Add("Font size", GuiEditFontSizeMenu)
  
  guiFontsSubMenu := Menu()
  guiFontsSubMenu.Add("Font", GuiFontsMenu)
  guiFontsSubMenu.Add("Font size", GuiFontSizeMenu)
  
  SettingsMenu := Menu()
  SettingsMenu.Add("Show index", toggleIndexVisibility)
  SettingsMenu.Add("Catch characters outside the app", toggleCatchAll)
  SettingsMenu.Add("Table is writable", toggleTableWritable)
  SettingsMenu.Add("Auto Open ParamBox", toggleAutoOpenParamBox)
  SettingsMenu.Add("Enable voice", toggleVoiceEnabled)
  SettingsMenu.Add("Font of table", guiEditFontsSubMenu)
  SettingsMenu.Add("Font of gui", guiFontsSubMenu)
  SettingsMenu.Add()
  SettingsMenu.Add("Edit Favorites File", editFavFile)
}
;-------------------------- generateMainMenuInsert --------------------------
generateMainMenuInsert(){
  global
  
  MainMenuInsert := Menu()
  readInsertable()
}
;--------------------------- toggleIndexVisibility ---------------------------
toggleIndexVisibility(*){
  global

  indexVisible := !indexVisible
  SettingsMenu.ToggleCheck("Show index")
  showUTF32Table(currentTableStartPosition)
  IniWrite indexVisible, configFile, "gui", "indexVisible"
}
;---------------------------- toggleVoiceEnabled ----------------------------
toggleVoiceEnabled(*){
  global

  voiceEnabled := !voiceEnabled
  SettingsMenu.ToggleCheck("Enable voice")
  IniWrite voiceEnabled, configFile, "config", "voiceEnabled"
}
;-------------------------- toggleAutoOpenParamBox --------------------------
toggleAutoOpenParamBox(*){
  global

  autoOpenParamBox := !autoOpenParamBox
  SettingsMenu.ToggleCheck("Auto Open ParamBox")
  IniWrite autoOpenParamBox, configFile, "config", "autoOpenParamBox"
}
;------------------------------ toggleCatchAll ------------------------------
toggleCatchAll(*){
  global

  catchAll := !catchAll
  SettingsMenu.ToggleCheck("Catch characters outside the app")
  IniWrite catchAll, configFile, "config", "catchAll"
}
;---------------------------- toggleTableWritable ----------------------------
toggleTableWritable(*){
  global

  tableIsWritable := !tableIsWritable
  SettingsMenu.ToggleCheck("Table is writable")
  IniWrite tableIsWritable, configFile, "config", "tableIsWritable"
  guiMainEdit.ReadOnly := !tableIsWritable
}
;---------------------------- generateBlocksMenu ----------------------------
generateBlocksMenu(){
  global
  local k, v, found, m
  
; FavoritesMenu -------------------------------
  FavoritesMenu := Menu()
  
  for k, v in tableStartPositionFavorites {
  
    if (v != ""){
      found := RegExMatch(v, "0x([\dA-Fa-f]+)", &m)
      if (found){
        FavoritesMenu.Add(v, showUTF32Table.Bind("0x" m.1))
      }
    }
  }
  
; BlocksMenu --------------------------------
  BlocksMenu := Menu()
  
  BlocksMenuAB := Menu()
  BlocksMenuAB.Add("Adlam	0x1E900 - 0x1E95F", showUTF32Table.Bind("0x1E900"))
  BlocksMenuAB.Add("Aegean Numbers	0x10100 - 0x1013F", showUTF32Table.Bind("0x10100"))
  BlocksMenuAB.Add("Aho	0x11700 - 0x1173F", showUTF32Table.Bind("0x11700"))
  BlocksMenuAB.Add("Alchemical Symbol	0x1F700 - 0x1F77F", showUTF32Table.Bind("0x1F700"))
  BlocksMenuAB.Add("Alphabetic Presentation Form	0xFB00 - 0xFB4F", showUTF32Table.Bind("0xFB00"))
  BlocksMenuAB.Add("Anatolian Hieroglyph	0x14400 - 0x1467F", showUTF32Table.Bind("0x14400"))
  BlocksMenuAB.Add("Ancient Greek Musical Notatio	0x1D200 - 0x1D24F", showUTF32Table.Bind("0x1D200"))
  BlocksMenuAB.Add("Ancient Greek Number	0x10140 - 0x1018F", showUTF32Table.Bind("0x10140"))
  BlocksMenuAB.Add("Ancient Symbol	0x10190 - 0x101CF", showUTF32Table.Bind("0x10190"))
  BlocksMenuAB.Add("Arabi	0x0600 - 0x06FF", showUTF32Table.Bind("0x0600"))
  BlocksMenuAB.Add("Arabic Extended-	0x08A0 - 0x08FF", showUTF32Table.Bind("0x08A0"))
  BlocksMenuAB.Add("Arabic Mathematical Alphabetic Symbol	0x1EE00 - 0x1EEFF", showUTF32Table.Bind("0x1EE00"))
  BlocksMenuAB.Add("Arabic Presentation Forms-	0xFB50 - 0xFDFF", showUTF32Table.Bind("0xFB50"))
  BlocksMenuAB.Add("Arabic Presentation Forms-	0xFE70 - 0xFEFF", showUTF32Table.Bind("0xFE70"))
  BlocksMenuAB.Add("Arabic Supplemen	0x0750 - 0x077F", showUTF32Table.Bind("0x0750"))
  BlocksMenuAB.Add("Armenia	0x0530 - 0x058F", showUTF32Table.Bind("0x0530"))
  BlocksMenuAB.Add("Arrow	0x2190 - 0x21FF", showUTF32Table.Bind("0x2190"))
  BlocksMenuAB.Add("Avesta	0x10B00 - 0x10B3F", showUTF32Table.Bind("0x10B00"))
  BlocksMenuAB.Add("Balines	0x1B00 - 0x1B7F", showUTF32Table.Bind("0x1B00"))
  BlocksMenuAB.Add("Bamu	0xA6A0 - 0xA6FF", showUTF32Table.Bind("0xA6A0"))
  BlocksMenuAB.Add("Bamum Supplemen	0x16800 - 0x16A3F", showUTF32Table.Bind("0x16800"))
  BlocksMenuAB.Add("Basic Lati	0x0000 - 0x007F", showUTF32Table.Bind("0x0000"))
  BlocksMenuAB.Add("Bassa Va	0x16AD0 - 0x16AFF", showUTF32Table.Bind("0x16AD0"))
  BlocksMenuAB.Add("Bata	0x1BC0 - 0x1BFF", showUTF32Table.Bind("0x1BC0"))
  BlocksMenuAB.Add("Bengal	0x0980 - 0x09FF", showUTF32Table.Bind("0x0980"))
  BlocksMenuAB.Add("Bhaiksuk	0x11C00 - 0x11C6F", showUTF32Table.Bind("0x11C00"))
  BlocksMenuAB.Add("Block Element	0x2580 - 0x259F", showUTF32Table.Bind("0x2580"))
  BlocksMenuAB.Add("Bopomof	0x3100 - 0x312F", showUTF32Table.Bind("0x3100"))
  BlocksMenuAB.Add("Bopomofo Extende	0x31A0 - 0x31BF", showUTF32Table.Bind("0x31A0"))
  BlocksMenuAB.Add("Box Drawin	0x2500 - 0x257F", showUTF32Table.Bind("0x2500"))
  BlocksMenuAB.Add("Brahm	0x11000 - 0x1107F", showUTF32Table.Bind("0x11000"))
  BlocksMenuAB.Add("Braille Pattern	0x2800 - 0x28FF", showUTF32Table.Bind("0x2800"))
  BlocksMenuAB.Add("Bugines	0x1A00 - 0x1A1F", showUTF32Table.Bind("0x1A00"))
  BlocksMenuAB.Add("Buhi	0x1740 - 0x175F", showUTF32Table.Bind("0x1740"))
  BlocksMenuAB.Add("Byzantine Musical Symbol	0x1D000 - 0x1D0FF", showUTF32Table.Bind("0x1D000"))

  BlocksMenu.Add("Blocks A-B", BlocksMenuAB)


  BlocksMenuC := Menu()
  BlocksMenuC.Add("Caria	0x102A0 - 0x102DF", showUTF32Table.Bind("0x102A0"))
  BlocksMenuC.Add("Caucasian Albania	0x10530 - 0x1056F", showUTF32Table.Bind("0x10530"))
  BlocksMenuC.Add("Chakm	0x11100 - 0x1114F", showUTF32Table.Bind("0x11100"))
  BlocksMenuC.Add("Cha	0xAA00 - 0xAA5F", showUTF32Table.Bind("0xAA00"))
  BlocksMenuC.Add("Cheroke	0x13A0 - 0x13FF", showUTF32Table.Bind("0x13A0"))
  BlocksMenuC.Add("Cherokee Supplemen	0xAB70 - 0xABBF", showUTF32Table.Bind("0xAB70"))
  BlocksMenuC.Add("Chess Symbol	0x1FA00 - 0x1FA6F", showUTF32Table.Bind("0x1FA00"))
  BlocksMenuC.Add("Chorasmia	0x10FB0 - 0x10FDF", showUTF32Table.Bind("0x10FB0"))
  BlocksMenuC.Add("CJK Compatibilit	0x3300 - 0x33FF", showUTF32Table.Bind("0x3300"))
  BlocksMenuC.Add("CJK Compatibility Form	0xFE30 - 0xFE4F", showUTF32Table.Bind("0xFE30"))
  BlocksMenuC.Add("CJK Compatibility Ideograph	0xF900 - 0xFAFF", showUTF32Table.Bind("0xF900"))
  BlocksMenuC.Add("CJK Compatibility Ideographs Supplemen	0x2F800 - 0x2FA1F", showUTF32Table.Bind("0x2F800"))
  BlocksMenuC.Add("CJK Radicals Supplemen	0x2E80 - 0x2EFF", showUTF32Table.Bind("0x2E80"))
  BlocksMenuC.Add("CJK Stroke	0x31C0 - 0x31EF", showUTF32Table.Bind("0x31C0"))
  BlocksMenuC.Add("CJK Symbols and Punctuatio	0x3000 - 0x303F", showUTF32Table.Bind("0x3000"))
  BlocksMenuC.Add("CJK Unified Ideograph	0x4E00 - 0x9FFF", showUTF32Table.Bind("0x4E00"))
  BlocksMenuC.Add("CJK Unified Ideographs Extension 	0x3400 - 0x4DBF", showUTF32Table.Bind("0x3400"))
  BlocksMenuC.Add("CJK Unified Ideographs Extension 	0x20000 - 0x2A6DF", showUTF32Table.Bind("0x20000"))
  BlocksMenuC.Add("CJK Unified Ideographs Extension 	0x2A700 - 0x2B73F", showUTF32Table.Bind("0x2A700"))
  BlocksMenuC.Add("CJK Unified Ideographs Extension 	0x2B740 - 0x2B81F", showUTF32Table.Bind("0x2B740"))
  BlocksMenuC.Add("CJK Unified Ideographs Extension 	0x2B820 - 0x2CEAF", showUTF32Table.Bind("0x2B820"))
  BlocksMenuC.Add("CJK Unified Ideographs Extension 	0x2CEB0 - 0x2EBEF", showUTF32Table.Bind("0x2CEB0"))
  BlocksMenuC.Add("CJK Unified Ideographs Extension 	0x30000 - 0x3134F", showUTF32Table.Bind("0x30000"))
  BlocksMenuC.Add("Combining Diacritical Mark	0x0300 - 0x036F", showUTF32Table.Bind("0x0300"))
  BlocksMenuC.Add("Combining Diacritical Marks Extende	0x1AB0 - 0x1AFF", showUTF32Table.Bind("0x1AB0"))
  BlocksMenuC.Add("Combining Diacritical Marks for Symbol	0x20D0 - 0x20FF", showUTF32Table.Bind("0x20D0"))
  BlocksMenuC.Add("Combining Diacritical Marks Supplemen	0x1DC0 - 0x1DFF", showUTF32Table.Bind("0x1DC0"))
  BlocksMenuC.Add("Combining Half Mark	0xFE20 - 0xFE2F", showUTF32Table.Bind("0xFE20"))
  BlocksMenuC.Add("Common Indic Number Form	0xA830 - 0xA83F", showUTF32Table.Bind("0xA830"))
  BlocksMenuC.Add("Control Picture	0x2400 - 0x243F", showUTF32Table.Bind("0x2400"))
  BlocksMenuC.Add("Copti	0x2C80 - 0x2CFF", showUTF32Table.Bind("0x2C80"))
  BlocksMenuC.Add("Coptic Epact Number	0x102E0 - 0x102FF", showUTF32Table.Bind("0x102E0"))
  BlocksMenuC.Add("Counting Rod Numeral	0x1D360 - 0x1D37F", showUTF32Table.Bind("0x1D360"))
  BlocksMenuC.Add("Cuneifor	0x12000 - 0x123FF", showUTF32Table.Bind("0x12000"))
  BlocksMenuC.Add("Cuneiform Numbers and Punctuatio	0x12400 - 0x1247F", showUTF32Table.Bind("0x12400"))
  BlocksMenuC.Add("Currency Symbol	0x20A0 - 0x20CF", showUTF32Table.Bind("0x20A0"))
  BlocksMenuC.Add("Cypriot Syllabar	0x10800 - 0x1083F", showUTF32Table.Bind("0x10800"))
  BlocksMenuC.Add("Cyrilli	0x0400 - 0x04FF", showUTF32Table.Bind("0x0400"))
  BlocksMenuC.Add("Cyrillic Extended-	0x2DE0 - 0x2DFF", showUTF32Table.Bind("0x2DE0"))
  BlocksMenuC.Add("Cyrillic Extended-	0xA640 - 0xA69F", showUTF32Table.Bind("0xA640"))
  BlocksMenuC.Add("Cyrillic Extended-	0x1C80 - 0x1C8F", showUTF32Table.Bind("0x1C80"))
  BlocksMenuC.Add("Cyrillic Supplemen	0x0500 - 0x052F", showUTF32Table.Bind("0x0500"))
  
  BlocksMenu.Add("Blocks C", BlocksMenuC)
  
  
  BlocksMenuDJ := Menu()
  BlocksMenuDJ.Add("Desere	0x10400 - 0x1044F", showUTF32Table.Bind("0x10400"))
  BlocksMenuDJ.Add("Devanagar	0x0900 - 0x097F", showUTF32Table.Bind("0x0900"))
  BlocksMenuDJ.Add("Devanagari Extende	0xA8E0 - 0xA8FF", showUTF32Table.Bind("0xA8E0"))
  BlocksMenuDJ.Add("Dingbat	0x2700 - 0x27BF", showUTF32Table.Bind("0x2700"))
  BlocksMenuDJ.Add("Dives Akur	0x11900 - 0x1195F", showUTF32Table.Bind("0x11900"))
  BlocksMenuDJ.Add("Dogr	0x11800 - 0x1184F", showUTF32Table.Bind("0x11800"))
  BlocksMenuDJ.Add("Domino Tile	0x1F030 - 0x1F09F", showUTF32Table.Bind("0x1F030"))
  BlocksMenuDJ.Add("Duploya	0x1BC00 - 0x1BC9F", showUTF32Table.Bind("0x1BC00"))
  BlocksMenuDJ.Add("Early Dynastic Cuneifor	0x12480 - 0x1254F", showUTF32Table.Bind("0x12480"))
  BlocksMenuDJ.Add("Egyptian Hieroglyph Format Control	0x13430 - 0x1343F", showUTF32Table.Bind("0x13430"))
  BlocksMenuDJ.Add("Egyptian Hieroglyph	0x13000 - 0x1342F", showUTF32Table.Bind("0x13000"))
  BlocksMenuDJ.Add("Elbasa	0x10500 - 0x1052F", showUTF32Table.Bind("0x10500"))
  BlocksMenuDJ.Add("Elymai	0x10FE0 - 0x10FFF", showUTF32Table.Bind("0x10FE0"))
  BlocksMenuDJ.Add("Emoticon	0x1F600 - 0x1F64F", showUTF32Table.Bind("0x1F600"))
  BlocksMenuDJ.Add("Enclosed Alphanumeric Supplemen	0x1F100 - 0x1F1FF", showUTF32Table.Bind("0x1F100"))
  BlocksMenuDJ.Add("Enclosed Alphanumeric	0x2460 - 0x24FF", showUTF32Table.Bind("0x2460"))
  BlocksMenuDJ.Add("Enclosed CJK Letters and Month	0x3200 - 0x32FF", showUTF32Table.Bind("0x3200"))
  BlocksMenuDJ.Add("Enclosed Ideographic Supplemen	0x1F200 - 0x1F2FF", showUTF32Table.Bind("0x1F200"))
  BlocksMenuDJ.Add("Ethiopi	0x1200 - 0x137F", showUTF32Table.Bind("0x1200"))
  BlocksMenuDJ.Add("Ethiopic Extende	0x2D80 - 0x2DDF", showUTF32Table.Bind("0x2D80"))
  BlocksMenuDJ.Add("Ethiopic Extended-	0xAB00 - 0xAB2F", showUTF32Table.Bind("0xAB00"))
  BlocksMenuDJ.Add("Ethiopic Supplemen	0x1380 - 0x139F", showUTF32Table.Bind("0x1380"))
  BlocksMenuDJ.Add("General Punctuatio	0x2000 - 0x206F", showUTF32Table.Bind("0x2000"))
  BlocksMenuDJ.Add("Geometric Shape	0x25A0 - 0x25FF", showUTF32Table.Bind("0x25A0"))
  BlocksMenuDJ.Add("Geometric Shapes Extende	0x1F780 - 0x1F7FF", showUTF32Table.Bind("0x1F780"))
  BlocksMenuDJ.Add("Georgia	0x10A0 - 0x10FF", showUTF32Table.Bind("0x10A0"))
  BlocksMenuDJ.Add("Georgian Extende	0x1C90 - 0x1CBF", showUTF32Table.Bind("0x1C90"))
  BlocksMenuDJ.Add("Georgian Supplemen	0x2D00 - 0x2D2F", showUTF32Table.Bind("0x2D00"))
  BlocksMenuDJ.Add("Glagoliti	0x2C00 - 0x2C5F", showUTF32Table.Bind("0x2C00"))
  BlocksMenuDJ.Add("Glagolitic Supplemen	0x1E000 - 0x1E02F", showUTF32Table.Bind("0x1E000"))
  BlocksMenuDJ.Add("Gothi	0x10330 - 0x1034F", showUTF32Table.Bind("0x10330"))
  BlocksMenuDJ.Add("Granth	0x11300 - 0x1137F", showUTF32Table.Bind("0x11300"))
  BlocksMenuDJ.Add("Greek and Copti	0x0370 - 0x03FF", showUTF32Table.Bind("0x0370"))
  BlocksMenuDJ.Add("Greek Extende	0x1F00 - 0x1FFF", showUTF32Table.Bind("0x1F00"))
  BlocksMenuDJ.Add("Gujarat	0x0A80 - 0x0AFF", showUTF32Table.Bind("0x0A80"))
  BlocksMenuDJ.Add("Gunjala Gond	0x11D60 - 0x11DAF", showUTF32Table.Bind("0x11D60"))
  BlocksMenuDJ.Add("Gurmukh	0x0A00 - 0x0A7F", showUTF32Table.Bind("0x0A00"))
  BlocksMenuDJ.Add("Halfwidth and Fullwidth Form	0xFF00 - 0xFFEF", showUTF32Table.Bind("0xFF00"))
  BlocksMenuDJ.Add("Hangul Compatibility Jam	0x3130 - 0x318F", showUTF32Table.Bind("0x3130"))
  BlocksMenuDJ.Add("Hangul Jam	0x1100 - 0x11FF", showUTF32Table.Bind("0x1100"))
  BlocksMenuDJ.Add("Hangul Jamo Extended-	0xA960 - 0xA97F", showUTF32Table.Bind("0xA960"))
  BlocksMenuDJ.Add("Hangul Jamo Extended-	0xD7B0 - 0xD7FF", showUTF32Table.Bind("0xD7B0"))
  BlocksMenuDJ.Add("Hangul Syllable	0xAC00 - 0xD7AF", showUTF32Table.Bind("0xAC00"))
  BlocksMenuDJ.Add("Hanifi Rohingy	0x10D00 - 0x10D3F", showUTF32Table.Bind("0x10D00"))
  BlocksMenuDJ.Add("Hanuno	0x1720 - 0x173F", showUTF32Table.Bind("0x1720"))
  BlocksMenuDJ.Add("Hatra	0x108E0 - 0x108FF", showUTF32Table.Bind("0x108E0"))
  BlocksMenuDJ.Add("Hebre	0x0590 - 0x05FF", showUTF32Table.Bind("0x0590"))
  BlocksMenuDJ.Add("High Private Use Surrogate	0xDB80 - 0xDBFF", showUTF32Table.Bind("0xDB80"))
  BlocksMenuDJ.Add("High Surrogate	0xD800 - 0xDB7F", showUTF32Table.Bind("0xD800"))
  BlocksMenuDJ.Add("Hiragan	0x3040 - 0x309F", showUTF32Table.Bind("0x3040"))
  BlocksMenuDJ.Add("Ideographic Description Character	0x2FF0 - 0x2FFF", showUTF32Table.Bind("0x2FF0"))
  BlocksMenuDJ.Add("Ideographic Symbols and Punctuatio	0x16FE0 - 0x16FFF", showUTF32Table.Bind("0x16FE0"))
  BlocksMenuDJ.Add("Imperial Aramai	0x10840 - 0x1085F", showUTF32Table.Bind("0x10840"))
  BlocksMenuDJ.Add("Indic Siyaq Number	0x1EC70 - 0x1ECBF", showUTF32Table.Bind("0x1EC70"))
  BlocksMenuDJ.Add("Inscriptional Pahlav	0x10B60 - 0x10B7F", showUTF32Table.Bind("0x10B60"))
  BlocksMenuDJ.Add("Inscriptional Parthia	0x10B40 - 0x10B5F", showUTF32Table.Bind("0x10B40"))
  BlocksMenuDJ.Add("IPA Extension	0x0250 - 0x02AF", showUTF32Table.Bind("0x0250"))
  BlocksMenuDJ.Add("Javanes	0xA980 - 0xA9DF", showUTF32Table.Bind("0xA980"))

  BlocksMenu.Add("Blocks D-J", BlocksMenuDJ)


  BlocksMenuKL := Menu()
  BlocksMenuKL.Add("Kaith	0x11080 - 0x110CF", showUTF32Table.Bind("0x11080"))
  BlocksMenuKL.Add("Kana Extended-	0x1B100 - 0x1B12F", showUTF32Table.Bind("0x1B100"))
  BlocksMenuKL.Add("Kana Supplemen	0x1B000 - 0x1B0FF", showUTF32Table.Bind("0x1B000"))
  BlocksMenuKL.Add("Kanbu	0x3190 - 0x319F", showUTF32Table.Bind("0x3190"))
  BlocksMenuKL.Add("Kangxi Radical	0x2F00 - 0x2FDF", showUTF32Table.Bind("0x2F00"))
  BlocksMenuKL.Add("Kannad	0x0C80 - 0x0CFF", showUTF32Table.Bind("0x0C80"))
  BlocksMenuKL.Add("Katakan	0x30A0 - 0x30FF", showUTF32Table.Bind("0x30A0"))
  BlocksMenuKL.Add("Katakana Phonetic Extension	0x31F0 - 0x31FF", showUTF32Table.Bind("0x31F0"))
  BlocksMenuKL.Add("Kayah L	0xA900 - 0xA92F", showUTF32Table.Bind("0xA900"))
  BlocksMenuKL.Add("Kharoshth	0x10A00 - 0x10A5F", showUTF32Table.Bind("0x10A00"))
  BlocksMenuKL.Add("Khitan Small Scrip	0x18B00 - 0x18CFF", showUTF32Table.Bind("0x18B00"))
  BlocksMenuKL.Add("Khme	0x1780 - 0x17FF", showUTF32Table.Bind("0x1780"))
  BlocksMenuKL.Add("Khmer Symbol	0x19E0 - 0x19FF", showUTF32Table.Bind("0x19E0"))
  BlocksMenuKL.Add("Khojk	0x11200 - 0x1124F", showUTF32Table.Bind("0x11200"))
  BlocksMenuKL.Add("Khudawad	0x112B0 - 0x112FF", showUTF32Table.Bind("0x112B0"))
  BlocksMenuKL.Add("La	0x0E80 - 0x0EFF", showUTF32Table.Bind("0x0E80"))
  BlocksMenuKL.Add("Latin Extended Additiona	0x1E00 - 0x1EFF", showUTF32Table.Bind("0x1E00"))
  BlocksMenuKL.Add("Latin Extended-	0x0100 - 0x017F", showUTF32Table.Bind("0x0100"))
  BlocksMenuKL.Add("Latin Extended-	0x0180 - 0x024F", showUTF32Table.Bind("0x0180"))
  BlocksMenuKL.Add("Latin Extended-	0x2C60 - 0x2C7F", showUTF32Table.Bind("0x2C60"))
  BlocksMenuKL.Add("Latin Extended-	0xA720 - 0xA7FF", showUTF32Table.Bind("0xA720"))
  BlocksMenuKL.Add("Latin Extended-	0xAB30 - 0xAB6F", showUTF32Table.Bind("0xAB30"))
  BlocksMenuKL.Add("Latin-1 Supplemen	0x0080 - 0x00FF", showUTF32Table.Bind("0x0080"))
  BlocksMenuKL.Add("Lepch	0x1C00 - 0x1C4F", showUTF32Table.Bind("0x1C00"))
  BlocksMenuKL.Add("Letterlike Symbol	0x2100 - 0x214F", showUTF32Table.Bind("0x2100"))
  BlocksMenuKL.Add("Limb	0x1900 - 0x194F", showUTF32Table.Bind("0x1900"))
  BlocksMenuKL.Add("Linear 	0x10600 - 0x1077F", showUTF32Table.Bind("0x10600"))
  BlocksMenuKL.Add("Linear B Ideogram	0x10080 - 0x100FF", showUTF32Table.Bind("0x10080"))
  BlocksMenuKL.Add("Linear B Syllabar	0x10000 - 0x1007F", showUTF32Table.Bind("0x10000"))
  BlocksMenuKL.Add("Lis	0xA4D0 - 0xA4FF", showUTF32Table.Bind("0xA4D0"))
  BlocksMenuKL.Add("Lisu Supplemen	0x11FB0 - 0x11FBF", showUTF32Table.Bind("0x11FB0"))
  BlocksMenuKL.Add("Low Surrogate	0xDC00 - 0xDFFF", showUTF32Table.Bind("0xDC00"))
  BlocksMenuKL.Add("Lycia	0x10280 - 0x1029F", showUTF32Table.Bind("0x10280"))
  BlocksMenuKL.Add("Lydia	0x10920 - 0x1093F", showUTF32Table.Bind("0x10920"))
  
  BlocksMenu.Add("Blocks K-L", BlocksMenuKL)

  BlocksMenuMO := Menu()
  BlocksMenuMO.Add("Mahajan	0x11150 - 0x1117F", showUTF32Table.Bind("0x11150"))
  BlocksMenuMO.Add("Mahjong Tile	0x1F000 - 0x1F02F", showUTF32Table.Bind("0x1F000"))
  BlocksMenuMO.Add("Makasa	0x11EE0 - 0x11EFF", showUTF32Table.Bind("0x11EE0"))
  BlocksMenuMO.Add("Malayala	0x0D00 - 0x0D7F", showUTF32Table.Bind("0x0D00"))
  BlocksMenuMO.Add("Mandai	0x0840 - 0x085F", showUTF32Table.Bind("0x0840"))
  BlocksMenuMO.Add("Manichaea	0x10AC0 - 0x10AFF", showUTF32Table.Bind("0x10AC0"))
  BlocksMenuMO.Add("Marche	0x11C70 - 0x11CBF", showUTF32Table.Bind("0x11C70"))
  BlocksMenuMO.Add("Masaram Gond	0x11D00 - 0x11D5F", showUTF32Table.Bind("0x11D00"))
  BlocksMenuMO.Add("Mathematical Alphanumeric Symbol	0x1D400 - 0x1D7FF", showUTF32Table.Bind("0x1D400"))
  BlocksMenuMO.Add("Mathematical Operator	0x2200 - 0x22FF", showUTF32Table.Bind("0x2200"))
  BlocksMenuMO.Add("Mayan Numeral	0x1D2E0 - 0x1D2FF", showUTF32Table.Bind("0x1D2E0"))
  BlocksMenuMO.Add("Medefaidri	0x16E40 - 0x16E9F", showUTF32Table.Bind("0x16E40"))
  BlocksMenuMO.Add("Meetei Maye	0xABC0 - 0xABFF", showUTF32Table.Bind("0xABC0"))
  BlocksMenuMO.Add("Meetei Mayek Extension	0xAAE0 - 0xAAFF", showUTF32Table.Bind("0xAAE0"))
  BlocksMenuMO.Add("Mende Kikaku	0x1E800 - 0x1E8DF", showUTF32Table.Bind("0x1E800"))
  BlocksMenuMO.Add("Meroitic Cursiv	0x109A0 - 0x109FF", showUTF32Table.Bind("0x109A0"))
  BlocksMenuMO.Add("Meroitic Hieroglyph	0x10980 - 0x1099F", showUTF32Table.Bind("0x10980"))
  BlocksMenuMO.Add("Mia	0x16F00 - 0x16F9F", showUTF32Table.Bind("0x16F00"))
  BlocksMenuMO.Add("Miscellaneous Mathematical Symbols-A	0x27C0 - 0x27EF", showUTF32Table.Bind("0x27C0"))
  BlocksMenuMO.Add("Miscellaneous Mathematical Symbols-B	0x2980 - 0x29FF", showUTF32Table.Bind("0x2980"))
  BlocksMenuMO.Add("Miscellaneous Symbol	0x2600 - 0x26FF", showUTF32Table.Bind("0x2600"))
  BlocksMenuMO.Add("Miscellaneous Symbols and Arrow	0x2B00 - 0x2BFF", showUTF32Table.Bind("0x2B00"))
  BlocksMenuMO.Add("Miscellaneous Symbols and Pictograph	0x1F300 - 0x1F5FF", showUTF32Table.Bind("0x1F300"))
  BlocksMenuMO.Add("Miscellaneous Technica	0x2300 - 0x23FF", showUTF32Table.Bind("0x2300"))
  BlocksMenuMO.Add("Mod	0x11600 - 0x1165F", showUTF32Table.Bind("0x11600"))
  BlocksMenuMO.Add("Modifier Tone Letter	0xA700 - 0xA71F", showUTF32Table.Bind("0xA700"))
  BlocksMenuMO.Add("Mongolia	0x1800 - 0x18AF", showUTF32Table.Bind("0x1800"))
  BlocksMenuMO.Add("Mongolian Supplemen	0x11660 - 0x1167F", showUTF32Table.Bind("0x11660"))
  BlocksMenuMO.Add("Mr	0x16A40 - 0x16A6F", showUTF32Table.Bind("0x16A40"))
  BlocksMenuMO.Add("Multan	0x11280 - 0x112AF", showUTF32Table.Bind("0x11280"))
  BlocksMenuMO.Add("Musical Symbol	0x1D100 - 0x1D1FF", showUTF32Table.Bind("0x1D100"))
  BlocksMenuMO.Add("Myanma	0x1000 - 0x109F", showUTF32Table.Bind("0x1000"))
  BlocksMenuMO.Add("Myanmar Extended-	0xAA60 - 0xAA7F", showUTF32Table.Bind("0xAA60"))
  BlocksMenuMO.Add("Myanmar Extended-	0xA9E0 - 0xA9FF", showUTF32Table.Bind("0xA9E0"))
  BlocksMenuMO.Add("Nabataea	0x10880 - 0x108AF", showUTF32Table.Bind("0x10880"))
  BlocksMenuMO.Add("Nandinagar	0x119A0 - 0x119FF", showUTF32Table.Bind("0x119A0"))
  BlocksMenuMO.Add("New Tai Lu	0x1980 - 0x19DF", showUTF32Table.Bind("0x1980"))
  BlocksMenuMO.Add("New	0x11400 - 0x1147F", showUTF32Table.Bind("0x11400"))
  BlocksMenuMO.Add("NK	0x07C0 - 0x07FF", showUTF32Table.Bind("0x07C0"))
  BlocksMenuMO.Add("Number Form	0x2150 - 0x218F", showUTF32Table.Bind("0x2150"))
  BlocksMenuMO.Add("Nush	0x1B170 - 0x1B2FF", showUTF32Table.Bind("0x1B170"))
  BlocksMenuMO.Add("Nyiakeng Puachue Hmon	0x1E100 - 0x1E14F", showUTF32Table.Bind("0x1E100"))
  BlocksMenuMO.Add("Ogha	0x1680 - 0x169F", showUTF32Table.Bind("0x1680"))
  BlocksMenuMO.Add("Ol Chik	0x1C50 - 0x1C7F", showUTF32Table.Bind("0x1C50"))
  BlocksMenuMO.Add("Old Hungaria	0x10C80 - 0x10CFF", showUTF32Table.Bind("0x10C80"))
  BlocksMenuMO.Add("Old Itali	0x10300 - 0x1032F", showUTF32Table.Bind("0x10300"))
  BlocksMenuMO.Add("Old North Arabia	0x10A80 - 0x10A9F", showUTF32Table.Bind("0x10A80"))
  BlocksMenuMO.Add("Old Permi	0x10350 - 0x1037F", showUTF32Table.Bind("0x10350"))
  BlocksMenuMO.Add("Old Persia	0x103A0 - 0x103DF", showUTF32Table.Bind("0x103A0"))
  BlocksMenuMO.Add("Old Sogdia	0x10F00 - 0x10F2F", showUTF32Table.Bind("0x10F00"))
  BlocksMenuMO.Add("Old South Arabia	0x10A60 - 0x10A7F", showUTF32Table.Bind("0x10A60"))
  BlocksMenuMO.Add("Old Turki	0x10C00 - 0x10C4F", showUTF32Table.Bind("0x10C00"))
  BlocksMenuMO.Add("Optical Character Recognitio	0x2440 - 0x245F", showUTF32Table.Bind("0x2440"))
  BlocksMenuMO.Add("Oriy	0x0B00 - 0x0B7F", showUTF32Table.Bind("0x0B00"))
  BlocksMenuMO.Add("Ornamental Dingbat	0x1F650 - 0x1F67F", showUTF32Table.Bind("0x1F650"))
  BlocksMenuMO.Add("Osag	0x104B0 - 0x104FF", showUTF32Table.Bind("0x104B0"))
  BlocksMenuMO.Add("Osmany	0x10480 - 0x104AF", showUTF32Table.Bind("0x10480"))
  BlocksMenuMO.Add("Ottoman Siyaq Number	0x1ED00 - 0x1ED4F", showUTF32Table.Bind("0x1ED00"))
  
  BlocksMenu.Add("Blocks M-O", BlocksMenuMO)

  BlocksMenuPT := Menu()
  BlocksMenuPT.Add("Pahawh Hmon	0x16B00 - 0x16B8F", showUTF32Table.Bind("0x16B00"))
  BlocksMenuPT.Add("Palmyren	0x10860 - 0x1087F", showUTF32Table.Bind("0x10860"))
  BlocksMenuPT.Add("Pau Cin Ha	0x11AC0 - 0x11AFF", showUTF32Table.Bind("0x11AC0"))
  BlocksMenuPT.Add("Phags-p	0xA840 - 0xA87F", showUTF32Table.Bind("0xA840"))
  BlocksMenuPT.Add("Phaistos Dis	0x101D0 - 0x101FF", showUTF32Table.Bind("0x101D0"))
  BlocksMenuPT.Add("Phoenicia	0x10900 - 0x1091F", showUTF32Table.Bind("0x10900"))
  BlocksMenuPT.Add("Phonetic Extension	0x1D00 - 0x1D7F", showUTF32Table.Bind("0x1D00"))
  BlocksMenuPT.Add("Phonetic Extensions Supplemen	0x1D80 - 0x1DBF", showUTF32Table.Bind("0x1D80"))
  BlocksMenuPT.Add("Playing Card	0x1F0A0 - 0x1F0FF", showUTF32Table.Bind("0x1F0A0"))
  BlocksMenuPT.Add("Private Use Are	0xE000 - 0xF8FF", showUTF32Table.Bind("0xE000"))
  BlocksMenuPT.Add("Psalter Pahlav	0x10B80 - 0x10BAF", showUTF32Table.Bind("0x10B80"))
  BlocksMenuPT.Add("Rejan	0xA930 - 0xA95F", showUTF32Table.Bind("0xA930"))
  BlocksMenuPT.Add("Rumi Numeral Symbol	0x10E60 - 0x10E7F", showUTF32Table.Bind("0x10E60"))
  BlocksMenuPT.Add("Runi	0x16A0 - 0x16FF", showUTF32Table.Bind("0x16A0"))
  BlocksMenuPT.Add("Samarita	0x0800 - 0x083F", showUTF32Table.Bind("0x0800"))
  BlocksMenuPT.Add("Saurashtr	0xA880 - 0xA8DF", showUTF32Table.Bind("0xA880"))
  BlocksMenuPT.Add("Sharad	0x11180 - 0x111DF", showUTF32Table.Bind("0x11180"))
  BlocksMenuPT.Add("Shavia	0x10450 - 0x1047F", showUTF32Table.Bind("0x10450"))
  BlocksMenuPT.Add("Shorthand Format Control	0x1BCA0 - 0x1BCAF", showUTF32Table.Bind("0x1BCA0"))
  BlocksMenuPT.Add("Siddha	0x11580 - 0x115FF", showUTF32Table.Bind("0x11580"))
  BlocksMenuPT.Add("Sinhal	0x0D80 - 0x0DFF", showUTF32Table.Bind("0x0D80"))
  BlocksMenuPT.Add("Sinhala Archaic Number	0x111E0 - 0x111FF", showUTF32Table.Bind("0x111E0"))
  BlocksMenuPT.Add("Small Form Variant	0xFE50 - 0xFE6F", showUTF32Table.Bind("0xFE50"))
  BlocksMenuPT.Add("Small Kana Extensio	0x1B130 - 0x1B16F", showUTF32Table.Bind("0x1B130"))
  BlocksMenuPT.Add("Sogdia	0x10F30 - 0x10F6F", showUTF32Table.Bind("0x10F30"))
  BlocksMenuPT.Add("Sora Sompen	0x110D0 - 0x110FF", showUTF32Table.Bind("0x110D0"))
  BlocksMenuPT.Add("Soyomb	0x11A50 - 0x11AAF", showUTF32Table.Bind("0x11A50"))
  BlocksMenuPT.Add("Spacing Modifier Letter	0x02B0 - 0x02FF", showUTF32Table.Bind("0x02B0"))
  BlocksMenuPT.Add("Special	0xFFF0 - 0xFFFF", showUTF32Table.Bind("0xFFF0"))
  BlocksMenuPT.Add("Sundanes	0x1B80 - 0x1BBF", showUTF32Table.Bind("0x1B80"))
  BlocksMenuPT.Add("Sundanese Supplemen	0x1CC0 - 0x1CCF", showUTF32Table.Bind("0x1CC0"))
  BlocksMenuPT.Add("Superscripts and Subscript	0x2070 - 0x209F", showUTF32Table.Bind("0x2070"))
  BlocksMenuPT.Add("Supplemental Arrows-	0x27F0 - 0x27FF", showUTF32Table.Bind("0x27F0"))
  BlocksMenuPT.Add("Supplemental Arrows-	0x2900 - 0x297F", showUTF32Table.Bind("0x2900"))
  BlocksMenuPT.Add("Supplemental Arrows-	0x1F800 - 0x1F8FF", showUTF32Table.Bind("0x1F800"))
  BlocksMenuPT.Add("Supplemental Mathematical Operator	0x2A00 - 0x2AFF", showUTF32Table.Bind("0x2A00"))
  BlocksMenuPT.Add("Supplemental Punctuatio	0x2E00 - 0x2E7F", showUTF32Table.Bind("0x2E00"))
  BlocksMenuPT.Add("Supplemental Symbols and Pictograph	0x1F900 - 0x1F9FF", showUTF32Table.Bind("0x1F900"))
  BlocksMenuPT.Add("Supplementary Private Use Area-	0xF0000 - 0xFFFFF", showUTF32Table.Bind("0xF0000"))
  BlocksMenuPT.Add("Supplementary Private Use Area-	0x100000 - 0x10FFFF", showUTF32Table.Bind("0x100000"))
  BlocksMenuPT.Add("Sutton SignWritin	0x1D800 - 0x1DAAF", showUTF32Table.Bind("0x1D800"))
  BlocksMenuPT.Add("Syloti Nagr	0xA800 - 0xA82F", showUTF32Table.Bind("0xA800"))
  BlocksMenuPT.Add("Symbols and Pictographs Extended-	0x1FA70 - 0x1FAFF", showUTF32Table.Bind("0x1FA70"))
  BlocksMenuPT.Add("Symbols for Legacy Computin	0x1FB00 - 0x1FBFF", showUTF32Table.Bind("0x1FB00"))
  BlocksMenuPT.Add("Syria	0x0700 - 0x074F", showUTF32Table.Bind("0x0700"))
  BlocksMenuPT.Add("Syriac Supplemen	0x0860 - 0x086F", showUTF32Table.Bind("0x0860"))
  BlocksMenuPT.Add("Tagalo	0x1700 - 0x171F", showUTF32Table.Bind("0x1700"))
  BlocksMenuPT.Add("Tagbanw	0x1760 - 0x177F", showUTF32Table.Bind("0x1760"))
  BlocksMenuPT.Add("Tag	0xE0000 - 0xE007F", showUTF32Table.Bind("0xE0000"))
  BlocksMenuPT.Add("Tai L	0x1950 - 0x197F", showUTF32Table.Bind("0x1950"))
  BlocksMenuPT.Add("Tai Tha	0x1A20 - 0x1AAF", showUTF32Table.Bind("0x1A20"))
  BlocksMenuPT.Add("Tai Vie	0xAA80 - 0xAADF", showUTF32Table.Bind("0xAA80"))
  BlocksMenuPT.Add("Tai Xuan Jing Symbol	0x1D300 - 0x1D35F", showUTF32Table.Bind("0x1D300"))
  BlocksMenuPT.Add("Takr	0x11680 - 0x116CF", showUTF32Table.Bind("0x11680"))
  BlocksMenuPT.Add("Tami	0x0B80 - 0x0BFF", showUTF32Table.Bind("0x0B80"))
  BlocksMenuPT.Add("Tamil Supplemen	0x11FC0 - 0x11FFF", showUTF32Table.Bind("0x11FC0"))
  BlocksMenuPT.Add("Tangu	0x17000 - 0x187FF", showUTF32Table.Bind("0x17000"))
  BlocksMenuPT.Add("Tangut Component	0x18800 - 0x18AFF", showUTF32Table.Bind("0x18800"))
  BlocksMenuPT.Add("Tangut Supplemen	0x18D00 - 0x18D8F", showUTF32Table.Bind("0x18D00"))
  BlocksMenuPT.Add("Telug	0x0C00 - 0x0C7F", showUTF32Table.Bind("0x0C00"))
  BlocksMenuPT.Add("Thaan	0x0780 - 0x07BF", showUTF32Table.Bind("0x0780"))
  BlocksMenuPT.Add("Tha	0x0E00 - 0x0E7F", showUTF32Table.Bind("0x0E00"))
  BlocksMenuPT.Add("Tibeta	0x0F00 - 0x0FFF", showUTF32Table.Bind("0x0F00"))
  BlocksMenuPT.Add("Tifinag	0x2D30 - 0x2D7F", showUTF32Table.Bind("0x2D30"))
  BlocksMenuPT.Add("Tirhut	0x11480 - 0x114DF", showUTF32Table.Bind("0x11480"))
  BlocksMenuPT.Add("Transport and Map Symbol	0x1F680 - 0x1F6FF", showUTF32Table.Bind("0x1F680"))
  
  BlocksMenu.Add("Blocks P-T", BlocksMenuPT)


  BlocksMenuUZ := Menu()
  BlocksMenuUZ.Add("Ugariti	0x10380 - 0x1039F", showUTF32Table.Bind("0x10380"))
  BlocksMenuUZ.Add("Unified Canadian Aboriginal Syllabic	0x1400 - 0x167F", showUTF32Table.Bind("0x1400"))
  BlocksMenuUZ.Add("Unified Canadian Aboriginal Syllabics Extende	0x18B0 - 0x18FF", showUTF32Table.Bind("0x18B0"))
  BlocksMenuUZ.Add("Vai	0xA500 - 0xA63F", showUTF32Table.Bind("0xA500"))
  BlocksMenuUZ.Add("Variation Selector	0xFE00 - 0xFE0F", showUTF32Table.Bind("0xFE00"))
  BlocksMenuUZ.Add("Variation Selectors Supplemen	0xE0100 - 0xE01EF", showUTF32Table.Bind("0xE0100"))
  BlocksMenuUZ.Add("Vedic Extension	0x1CD0 - 0x1CFF", showUTF32Table.Bind("0x1CD0"))
  BlocksMenuUZ.Add("Vertical Form	0xFE10 - 0xFE1F", showUTF32Table.Bind("0xFE10"))
  BlocksMenuUZ.Add("Wanch	0x1E2C0 - 0x1E2FF", showUTF32Table.Bind("0x1E2C0"))
  BlocksMenuUZ.Add("Warang Cit	0x118A0 - 0x118FF", showUTF32Table.Bind("0x118A0"))
  BlocksMenuUZ.Add("Yezid	0x10E80 - 0x10EBF", showUTF32Table.Bind("0x10E80"))
  BlocksMenuUZ.Add("Yi Radical	0xA490 - 0xA4CF", showUTF32Table.Bind("0xA490"))
  BlocksMenuUZ.Add("Yi Syllable	0xA000 - 0xA48F", showUTF32Table.Bind("0xA000"))
  BlocksMenuUZ.Add("Yijing Hexagram Symbol	0x4DC0 - 0x4DFF", showUTF32Table.Bind("0x4DC0"))
  BlocksMenuUZ.Add("Zanabazar Squar	0x11A00 - 0x11A4F", showUTF32Table.Bind("0x11A00"))
  
  BlocksMenu.Add("Blocks U-Z", BlocksMenuUZ)

}