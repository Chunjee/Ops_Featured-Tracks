
Class FeaturedTracks {
	
	__New(para_Name)
	{
		this.Info_Array := []
	}
	

	ReadPDF(para_pdflocation) {
		txt_location = %A_ScriptDir%\Data\current.txt 
		FileDelete, txt_location
		Sleep, 800
		;msgbox, % txt_location " - " para_pdflocation
		RunWait, %comspec% /c %A_ScriptDir%\Data\PDFtoTEXT.exe "%para_pdflocation%" "%txt_location%",,Hide

		X := 0
		Loop, Read, %txt_location%
		{
			if (InStr(A_LoopReadLine,"TOTAL TRACKS")) {
			Break
			}
			DayNight := Fn_QuickRegEx(A_LoopReadLine,"(D|N|D\/N) ([A-Z0-9]+) (.*)")
			TrackCode := Fn_QuickRegEx(A_LoopReadLine,"(D|N|D\/N) ([A-Z0-9]+) (.*)", 2)
			TrackName := Fn_QuickRegEx(A_LoopReadLine,"(D|N|D\/N) ([A-Z0-9]+) (.*)", 3)
			if (TrackCode != "null") {
				X++
				this.Info_Array[X,"TrackCode"] := TrackCode
				this.Info_Array[X,"TrackName"] := TrackName
				this.Info_Array[X,"DayNight"] := DayNight
				;Msgbox, % this.Info_Array[X,"TrackName"] " " this.Info_Array[X,"TrackCode"]
			}
		}
	}

	AddTrack(para_TrackCode) {
		;used to add a track manually
		this.Info_Array[this.Info_Array.MaxIndex() += 1,"TrackCode"] := para_TrackCode
	}

	GiveAllTracks()	{
		return % this.Info_Array
	}

	ToggleFeatured(para_TrackCode, para_Status) {
		Loop, % this.Info_Array.MaxIndex() {
			if (para_TrackCode = this.Info_Array[A_Index,"TrackCode"]) {
				;set according to 2nd parameter
				if (para_Status = 1) {
					this.Info_Array[A_Index,"Featured"] := true
				} else {
					this.Info_Array[A_Index,"Featured"] := false
				}
			}
		}
	}


	CreateClipboard() {

		ReturnString := "--EDIT FEATURED TRACKS HERE. DO NOT REMOVE LINES. DELETE UNEEDED TRACK CODES"

		X := 0
		Loop, % this.Info_Array.MaxIndex() {
			;do stuff for all "Featured" Tracks
			if (this.Info_Array[A_Index,"Featured"]) {	;if = true
				X++
				if (X = 10) {
					msgbox, more than 10 tracks selected. check your work.
					break
				}
				ReturnString .= "`nselect @featured" X " = '" this.Info_Array[A_Index,"TrackCode"] "'    --"  this.Info_Array[A_Index,"TrackName"]
			}
		}

		Loop, 20 {
			X++
			if (X = 16) {
				break
			}
			ReturnString .= "`nselect @featured" X " = ''"
		}
		Clipboard := ReturnString
	}
}