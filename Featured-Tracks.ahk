;/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\
;Description
;\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/
; Changes featured tracks
;


;~~~~~~~~~~~~~~~~~~~~~
;Compile Options
;~~~~~~~~~~~~~~~~~~~~~
SetBatchLines -1 ;Go as fast as CPU will allow
#NoTrayIcon ;No tray icon
#SingleInstance Force ;Do not allow running more then one instance at a time
ComObjError(False) ; Ignore any http timeouts

The_ProjectName := "Featured Tracks"
The_VersionName = v0.0.1

;Classes
#Include %A_ScriptDir%\Classes
#Include class_GUI.ahk
#Include class_FeaturedTracks.ahk

;Dependencies
#Include %A_ScriptDir%\Functions
#Include inireadwrite.ahk
#Include class_GDI.ahk
#Include util_misc.ahk
#Include util_json.ahk
;#Include ping.ahk
#Include ping4.ahk
#Include internet_fileread.ahk



;For Debug Only
#Include util_arrays.ahk
Sb_RemoteShutDown() ;Allows for remote shutdown

;Hide CMD window
;DllCall("AllocConsole")
;WinHide % "ahk_id " DllCall("GetConsoleWindow", "ptr")


;/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\
;StartUp
;\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/

;;Create GUI Object
MainGUI := new GUI(The_ProjectName)
MainGUI.Build()



;Find today's date and create featured tracks object
FormatTime, pdf_date, , yy
A_YY := pdf_date
pdf_location = \\tvgops\pdxshares\wagerops\Daily Recaps and Pool Defs\%A_MM%-%A_DD%-%A_YY% Reports\%A_MM%%A_DD%%A_YY% Calendar-PDX.pdf

;read today's PDF for all tracks
FeaturedTracks_Obj := new FeaturedTracks(The_ProjectName)
FeaturedTracks_Obj.ReadPDF(pdf_location)


;Give all Featured Tracks to the GUI
MainGUI.Update(FeaturedTracks_Obj.GiveAllTracks())






;MainGUI.Resize(1000,1000)


;Actual End
Return


;/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\
;Functions
;\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/

UriEncode(Uri)
{
	VarSetCapacity(Var, StrPut(Uri, "UTF-8"), 0), StrPut(Uri, &Var, "UTF-8")
	f := A_FormatInteger
	SetFormat, IntegerFast, H
	While Code := NumGet(Var, A_Index - 1, "UChar")
		If (Code >= 0x30 && Code <= 0x39 ; 0-9
			|| Code >= 0x41 && Code <= 0x5A ; A-Z
	|| Code >= 0x61 && Code <= 0x7A) ; a-z
	Res .= Chr(Code)
	Else
		Res .= "%" . SubStr(Code + 0x100, -1)
	SetFormat, IntegerFast, %f%
	Return, Res
}


;/--\--/--\--/--\--/--\--/--\
; Subroutines
;\--/--\--/--\--/--\--/--\--/


Sb_GlobalNameSpace() {
	
}


Sb_InstallFiles()
{
	FileCreateDir, %A_ScriptDir%\Data\Temp\
}

Sb_EmailOps()
{
	;Currently Does nothing
}
