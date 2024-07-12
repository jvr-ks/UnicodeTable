; UnicodeTableShow.ahk
; Part of unicodeTable.ahk

;--------------------------- showUnicodeTableFunc ---------------------------
showUTF32Table(tableStart, *){
  global 
  local allUniStrings, uniString, n, i, j, v
  
  tableStart := 0x0 + RegExReplace(tableStart,"[^xX0-9a-fA-F]","")
  if (tableStart > 0x10FFFE){
    msgbox "The value entered is greater 0x10FFFE!"
    tableStart := 0x10FFF0
  }
  if (tableStart < 0x0){
    tableStart := 0x0
  }
  
  currentTableStartPosition := tableStart
  IniWrite currentTableStartPosition, configFile, "config", "currentTableStartPosition"
  
  if (indexVisible){
    allUniStrings := "Help:F1`t"
  
    Loop 16 {
      n := tableStart + A_Index - 1 ; 00 to FF shifted by tableStart
      allUniStrings .= SubStr(Format("{:2.2X}", n), -1, 1) "`t"
    }
    allUniStrings .= "`n"
  }
  
  Loop 32 {
    i := A_Index - 1
    h := tableStart + i * 16
    if (indexVisible){
      allUniStrings .= Format("{:06.6X}", h) "`t"
    } else {
      allUniStrings .= ""
    }
    
    Loop 16 {
      j := A_Index - 1
      v := tableStart + (i * 16 + j)
      uniString := ""
      if (tableStart == 0 && v == 0){
        uniString := ""
      } else {
        if (v < 0x10FFFE){
          uniString := Chr(v)
        } else {
          uniString := "OVF"
          if (v == 0x10FFFE)
            uniString := "END"
        }
      }
      if (v < 0xFF) uniString := encodeSingleCtrlChar(uniString, v)
      
      allUniStrings .= uniString "`t"
    }
    allUniStrings .= "`n"
  }
  
  guiMainEdit.ReadOnly := false
  
  if (tableStart != 0)
    guiMainEdit.Text := allUniStrings
  else
    guiMainEdit.Text := allUniStrings controlCharacters()
    
  guiMainEdit.ReadOnly := !tableIsWritable
  
  return
}
;--------------------------- showUnicodeTableDown ---------------------------
showUnicodeTableUp(*){
  global 
  
  currentTableStartPosition -= 512
  currentTableStartPosition := Max(currentTableStartPosition, 0)
  showUTF32Table(currentTableStartPosition)

  return
}
;---------------------------- showUnicodeTableUp ---------------------------- 
showUnicodeTableDown(*){
  global 
  
  currentTableStartPosition += 512
  currentTableStartPosition := Min(currentTableStartPosition,1114111) ; => 0X10FFFF max
  showUTF32Table(currentTableStartPosition)

  return
}
controlCharacters(){

ctrlChr := "
(


Unicode			Abbreviation			Description

U+000000			NUL				Null character (Editor Control-character)
U+000001			SOH				Start of Heading
U+000002			STX				Start of Text
U+000003			ETX				End-of-text character
U+000004			EOT				End-of-transmission character
U+000005			ENQ				Enquiry character
U+000006			ACK				Acknowledge character
U+000007			BEL				Bell character
U+000008			BS				Backspace (Editor Control-character)
U+000009			HT				Horizontal tab (Editor Control-character)
U+00000A			LF				Line feed (Editor Control-character)
U+00000B			VT				Vertical tab
U+00000C			FF				Form feed
U+00000D			CR				Carriage return (Editor Control-character)
U+00000E			SO				Shift Out
U+00000F			SI				Shift In
U+000010			DLE				Data Link Escape
U+000011			DC1				Device Control 1
U+000012			DC2				Device Control 2
U+000013			DC3				Device Control 3
U+000014			DC4				Device Control 4
U+000015			NAK				Negative-acknowledge character
U+000016			SYN				Synchronous Idle
U+000017			ETB				End of Transmission Block
U+000018			CAN	0			Cancel character
U+000019			EM				End of Medium
U+00001A			SUB	1			Substitute character
U+00001B			ESC				Escape character
U+00001C			FS				File Separator
U+00001D			GS				Group Separator
U+00001E			RS				Record Separator
U+00001F			US				Unit Separator
U+00007F			DEL				Delete
U+000080			PAD				Padding Character
U+000081			HOP				High Octet Preset
U+000082			BPH				Break Permitted Here
U+000083			NBH				No Break Here
U+000084			IND				Index
U+000085			NEL				Next Line
U+000086			SSA				Start of Selected Area
U+000087			ESA				End of Selected Area
U+000088			HTS				Character Tabulation Set
U+000089			HTJ				Character Tabulation with Justification
U+00008A			VTS				Line Tabulation Set
U+00008B			PLD				Partial Line Forward
U+00008C			PLU				Partial Line Backward
U+00008D			RI				Reverse Line Feed
U+00008E			SS2				Single-Shift Two
U+00008F			SS3				Single-Shift Three
U+000090			DCS				Device Control String
U+000091			PU1				Private Use 1
U+000092			PU2				Private Use 2
U+000093			STS				Set Transmit State
U+000094			CCH				Cancel character
U+000095			MW				Message Waiting
U+000096			SPA				Start of Protected Area
U+000097			EPA				End of Protected Area
U+000098			SOS				Start of String
U+000099			SGCI				Single Graphic Character Introducer
U+00009A			SCI				Single Character Intro Introducer
U+00009B			CSI				Control Sequence Introducer
U+00009C			ST				String Terminator
U+00009D			OSC				Operating System Command
U+00009E			PM				Private Message
U+00009F			APC				Application Program Command
U+10FFFE			END				Last Character
> U+10FFFE		OVF				Overflow (undefined)

)"

  return ctrlChr
}



















