; Compresses data by removing repeated characters
Compress(str) {
   StringCaseSense On
   ;tmp := A_FormatInteger
   Prev=
   Nstr=
   Count=0
   Loop, Parse, str
   {
      If (A_Index > 1) {
         If (A_LoopField != Prev || Count == 15) {
            If (Count > 3) {
               SetFormat, Integer, H
               Count+=0
               SetFormat, Integer, D
               Nstr.="_" . Prev . SubStr(Count,3)
            }
            Else If (Count == 3)
               Nstr.="#" . Prev
            Else {
               Loop, % Count
                  Nstr.=Prev
            }
            Count := 0
         }
      }
      Prev := A_LoopField
      Count++
   }
   SetFormat, Integer, H
   Count+=0
   SetFormat, Integer, D
   Nstr.=Prev . SubStr(Count,3)
   E:=SubStr(Nstr,-1,1)
   N:=SubStr(Nstr,0)
   Loop % N
      S.=E
   Nstr:=SubStr(Nstr,1,StrLen(Nstr)-2) . S
   ;SetFormat, Integer, %tmp%
   Return Nstr
}

; De-compresses data
Expand(str) {
   str := RegExReplace(str,"#(.)","$1$1$1")
   BeginRepeat := 0
   Char=
   Count=
   NStr=
   Loop, Parse, str
   {
      C := A_LoopField
      If (BeginRepeat == 1) {
         Char := A_LoopField
         BeginRepeat++
      }
      Else If (BeginRepeat == 2) {
         Count:= A_LoopField
         BeginRepeat := 0
         Loop, 0x%Count%
            NStr.=Char
      }
      Else If (C == "_")
         BeginRepeat := 1
      Else
         NStr.=C
   }
   Return NStr
}

; Performs a Burrows-Wheeler transform on given hex string.
BWT(Hstr,EOF="!",DEL=",") {
   if (InStr(HStr,EOF) || InStr(HStr,DEL) || EOF == DEL) {
      MsgBox BWT ERROR!
      ExitApp
   }
   HStr.=EOF
   Loop, % StrLen(Hstr)
   {
      Row .= (A_Index > 1 ? DEL : "") . HStr
      HStr := SubStr(HStr,0,1) . SubStr(HStr,1,StrLen(HStr)-1)
   }
   Sort, Row, D%DEL% R C
   StringSplit, Row, Row, %DEL%
   Loop, % Row0
      New.=SubStr(Row%A_Index%,0,1)
   Return New
}

; Reverses Burrows-Wheeler transform on given
; string
UnBWT(STR,EOF="!",DEL=",") {
   if (!InStr(STR,EOF) || InStr(STR,DEL) || EOF == DEL) {
      MsgBox UnBWT ERROR!
      ExitApp
   }
   Loop, % StrLen(STR)
   {
      if (A_Index > 1)
         StringSplit, Row, Row, %DEL%
      Row =
      Loop, % StrLen(STR)
         Row .= (A_Index > 1 ? DEL : "") . SubStr(STR,A_Index,1) . Row%A_Index%
      Sort, Row, D%DEL% R C
   }
   StringSplit, Row, Row, %DEL%
   Loop, % StrLen(STR)
   {
      If (SubStr(Row%A_Index%,0,1) == EOF) {
         NStr := Row%A_Index%
         Break
      }
   }
   Return SubStr(NStr,1,StrLen(NStr)-1) ;ascStr(SubStr(NStr,1,StrLen(NStr)-1))
}
