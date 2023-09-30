#Include %A_LineFile%\..\String.ahk

;Tooltip函式
Tooltip(str,t=1,x=32,y=0)
{
MouseGetPos, xPos, yPos,,1
ToolTip, %str%, % xPos+x, % yPos+y, 1
SetTimer, ToolTipOff, % 1000*t
return

ToolTipOff:
SetTimer, ToolTipOff, Off
ToolTip
return
}

;ProgressText函式
ProgressText(str,t=1,CW="Yellow",CT="Black",FS=9,F="Meiryo UI",OSD="")
{
Array:=StrSplit(str,"`n")
Loop % Array.MaxIndex()
    Array[A_Index]:=StringWidth(Array[A_Index],F,FS)
W:=Max(Array*)+20>600 ? 600 : Max(Array*)+20
Progress, zh0 b1 w%W% zx10 zy2 cw%CW% ct%CT% fs%FS%, %str%, , ProgressTitle, %F%
if (OSD)
{
    WinSet, Style, -0x800000, ProgressTitle
    WinSet, TransColor, %CW%, ProgressTitle
}
SetTimer, ProgressTextOff, % 1000*t
return

ProgressTextOff:
SetTimer, ProgressTextOff, Off
Progress, Off
return
}

;ProgressTextXY函式
ProgressTextXY(str,t=1,CW="Yellow",CT="Black",FS=9,F="Meiryo UI",OSD="",X="",Y="")
{
Array:=StrSplit(str,"`n")
Loop % Array.MaxIndex()
    Array[A_Index]:=StringWidth(Array[A_Index],F,FS)
W:=Max(Array*)+20>600 ? 600 : Max(Array*)+20
Progress, zh0 b1 x%X% y%Y% w%W% zx10 zy2 cw%CW% ct%CT% fs%FS%, %str%, , ProgressTitle, %F%
if (OSD)
{
    WinSet, Style, -0x800000, ProgressTitle
    WinSet, TransColor, %CW%, ProgressTitle
}
SetTimer, ProgressTextOff, % 1000*t
}

;顯現Splash
SplashImageGUI(Picture, X, Y, Duration, Transparent=false, TransColor="Black")
{
Gui, Splash:Margin , 0, 0
Gui, Splash:Add, Picture,, %Picture%
Gui, Splash:Color, %TransColor%
Gui, Splash:+LastFound -Caption +AlwaysOnTop +ToolWindow -Border
if Transparent
    Winset, TransColor, %TransColor%
Gui, Splash:Show, x%X% y%Y% NoActivate
SetTimer, SplashImageGUI, -%Duration%
return

SplashImageGUI:
Gui, Splash:Destroy
return
}

;顯現Splash
SplashMascot(file="",t=2)
{
Run, D:\App\AutoHotkey\AutoHotkeyU64.exe "D:\App\Misc\Mascot\Mascot.ahk" %file%
Loop
    Sleep, 100
Until HWND:=WinExist("Mascot")
WinGetPos, , , Width, Height, ahk_id %HWND%
WinMove, ahk_id %HWND%, , % (A_ScreenWidth-Width)/2, % (A_ScreenHeight-Height)/2
SetTimer, SplashMascotOff, % 1000*t
return

SplashMascotOff:
SetTimer, SplashMascotOff, Off
WinClose, Mascot
return
}