; UnicodeTableConvert.ahk
; Part of unicodeTable.ahk

;---------------------------- stringUTF16ToUTF32 ----------------------------
stringUTF16ToUTF32(s){
  local UTFCode32, result, surrogateSecondRun, sH, sL
  
  UTFCode32 := ""
  result := []
  surrogateSecondRun := 0
  sH := 0
  sL := 0
  
  if (isControlCharacter(s)){
    showHintColored("String contains Control characters!")
    return result
  }
  
  Loop Parse, s,, " `t`r" {
    if (!surrogateSecondRun){
      if (!isSurrogate(A_LoopField)){
        UTFCode32 := Ord(A_LoopField)
        result.push(UTFCode32)
      } else {
        sH := Ord(A_LoopField)
        ; msgbox isSurrogate(A_LoopField) " sh: " sH
        surrogateSecondRun := 1
      }
    } else {
      ; S = ((H - 0xD800) * 0x400) + (L - 0xDC00) + 0x10000;
      sL := Ord(A_LoopField)
      UTFCode32 := ((sH - 0xD800) * 0x400) + (sL - 0xDC00) + 0x10000
      result.push(UTFCode32)
      surrogateSecondRun := 0
    }
  }
  
  return result
}
;-------------------------------- isSurrogate --------------------------------
isSurrogate(s){
  local ret
  
  ret := 0
  v := Ord(s)
  if (v >= 0xD800 && v <= 0xDBFF){
    ret := 1
  } else {
    ret := 0
  }
  return ret
}
;---------------------------------- asUTF16 ----------------------------------
asUTF16(s){
  local result
  
  result := ""
  
  if (isControlCharacter(s)){
    return result
  }
  
  Loop Parse, s,, " `t`r" {
    result .= format("{1:6.6X}", Ord(A_LoopField)) " "
  }
 
  return result
}
;---------------------------------- asUTF8 ----------------------------------
asUTF8(s){
; based on: https://rosettacode.org/wiki/UTF-8_encode_and_decode#AutoHotkey
  local result, UTFCode8, hex
  
  result := ""
  UTFCode8 := ""
  hex := 0
  
  Loop Parse, s,, " `t`r" {
    UTFCode8 := ""
    hex := Ord(s)
    Bytes :=  hex>=0x10000 ? 4 : hex>=0x0800 ? 3 : hex>=0x0080 ? 2 : hex>=0x0001 ? 1 : 0
    Prefix := [0, 0xC0, 0xE0, 0xF0]
    
    Loop Bytes
    {
      if (A_Index < Bytes)
        UTFCode8 := Format("{:X}", (hex&0x3F) + 0x80) " " UTFCode8    ; 3F=00111111, 80=10000000
      else
        UTFCode8 := Format("{:02.2X}", hex + Prefix[Bytes]) " " UTFCode8  ; C0=11000000, E0=11100000, F0=11110000
      hex := hex>>6
    }
    
    result .= UTFCode8 . " " 
  }
  
  return result
}
;--------------------------------- asBinary ---------------------------------
asBinary(s){
  
  static b0 := "0000"
  static b1 := "0001"
  static b2 := "0010"
  static b3 := "0011"
  static b4 := "0100"
  static b5 := "0101"
  static b6 := "0110"
  static b7 := "0111"
  static b8 := "1000"
  static b9 := "1001"
  static ba := "1010"
  static bb := "1011"
  static bc := "1100"
  static bd := "1101"
  static be := "1110"
  static bf := "1111"
  
  ret := ""
  binary := ""
  Loop Parse, s, " `t", "`r" {
    Loop parse, A_LoopField {
      binary .= b%A_Loopfield% . " "
    }
    ret .= binary "| "
    binary := ""
  }
  
  return SubStr(ret, 1, -2)
}
;---------------------------------- toHex6 ----------------------------------
toHex6(s){
  return format("{:06.6X}", s)
}
;---------------------------------- toHex4 ----------------------------------
toHex4(s){
  return format("{:04.4X}", s)
}
;---------------------------------- toHex2 ----------------------------------
toHex2(s){
  return format("{:02.2X}", s)
}
;---------------------------------- asHTML ----------------------------------
asHTML(s){
  return stringToHTML(s)
}
;----------------------------------- asURI -----------------------------------
asURI(s){
  return stringToURI(s)
}
;--------------------------- encodeSingleCtrlChar ---------------------------
encodeSingleCtrlChar(s, v){
  ; 
  ret := s
  
  if (v == 0x00)
    ret := "NUL"
  if (v == 0x09)
    ret := "HT"
  if (v == 0x0A)
    ret := "LF"
  if (v == 0x0D)
    ret := "CR"
    
  return ret
}
;--------------------------- decodeSingleCtrlChar ---------------------------
decodeCtrlCharAsString(s){
  ret := s

  if (s = "NUL")
    ret := "000000"
  if (s = "HT")
    ret := "000009"
  if (s = "CR")
    ret := "00000D"
  if (s = "LF")
    ret := "00000A"
  if (s = "END")
    ret := "10FFFE"
  if (s = "OVF")
    ret := "00FFFF" 

  return ret
}
;---------------------------- decodeCtrlCharAsHex ----------------------------
decodeCtrlCharAsHex(s){
  return "0x" decodeCtrlCharAsString(s)
}
;----------------------------------------------------------------------------








