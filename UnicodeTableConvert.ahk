; UnicodeTableConvert.ahk
; Part of unicodeTable.ahk

;---------------------------------- asUTF8 ----------------------------------
asUTF8(s, &resultHex){
; based on: https://rosettacode.org/wiki/UTF-8_encode_and_decode#AutoHotkey
  local UTFCode8, result
  
  UTFCode8 := ""
  result := ""
  
  Loop Parse, s, " `t", "`r" {
    UTFCode8 := ""
    if (isControlCharacter(A_LoopField)){
      hex := format("{1:#6.6X}", decodeCtrlCharAsHex(A_LoopField))
      resultHex .= format("{1:6.6X}", decodeCtrlCharAsHex(A_LoopField)) " "
    } else {
      hex := format("{1:#6.6X}", Ord(A_LoopField))
      resultHex .= format("{1:6.6X}", Ord(A_LoopField)) " "
    }
    Bytes :=  hex>=0x10000 ? 4 : hex>=0x0800 ? 3 : hex>=0x0080 ? 2 : hex>=0x0001 ? 1 : 0
    Prefix := [0, 0xC0, 0xE0, 0xF0]
    
    Loop Bytes
    {
      if (A_Index < Bytes)
        UTFCode8 := Format("{:X}", (hex&0x3F) + 0x80) . UTFCode8    ; 3F=00111111, 80=10000000
      else
        UTFCode8 := Format("{:02.2X}", hex + Prefix[Bytes]) . UTFCode8  ; C0=11000000, E0=11100000, F0=11110000
      hex := hex>>6
    }
    result .= UTFCode8 . " "
  }
  
  return Trim(result)
}
;---------------------------------- asUTF16 ----------------------------------
asUTF16(s){
  local result, hex, hS, lS, s1
  
  result := ""

  Loop Parse, s, " `t", "`r" {
    if (isControlCharacter(A_LoopField)){
      hex := format("{1:#6.6X}", decodeCtrlCharAsHex(A_LoopField))
    } else {
      hex := format("{1:#6.6X}", Ord(A_LoopField))
    }
    
    if (hex > 0x0 && hex < 0xD7FF || hex > 0xE000 && hex < 0xFFFF){
      result .= SubStr(hex, 5, 2) . SubStr(hex,7, 2) . " "
    } else {
      hS := ""
      lS:= ""
      s1 := hex - 0x10000 ; minus BMP size, result is between 0x00000 and 0xFFFFF, size is 20-Bit
      
      ; High-Surrogate:
      ; 11111111110000000000 = 0xFFC00
      hS := (s1 & 0xFFC00) >>10
      
      ; 1101100000000000 = 0xD800
      hS := hS + 0xD800
      
      ; Low-Surrogate:
      ; 00000000001111111111 = 0x3FF
      lS := s1 & 0x3FF
      ; 1101110000000000 = 0xDC00
      lS := lS + 0xDC00
      
      result .= toHex4(hS) . toHex4(lS) . " "
    }
  }

  return Trim(result)
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








