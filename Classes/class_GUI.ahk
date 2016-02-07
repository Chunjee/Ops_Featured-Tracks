
Class GUI {
	
	__New(para_Name) 
	{
		this.Info_Array := []
		this.Track_Array := []
		this.Info_Array["Name"] := para_Name

		global FeaturedCheckbox1
		global FeaturedCheckbox2
		global FeaturedCheckbox3
		global FeaturedCheckbox4
		global FeaturedCheckbox5
		global FeaturedCheckbox6
		global FeaturedCheckbox7
		global FeaturedCheckbox8
		global FeaturedCheckbox9
		global FeaturedCheckbox10
		global FeaturedCheckbox11
		global FeaturedCheckbox12
		global FeaturedCheckbox13
		global FeaturedCheckbox14
		global FeaturedCheckbox15
		global FeaturedCheckbox16
		global FeaturedCheckbox17
		global FeaturedCheckbox18
		global FeaturedCheckbox19
		global FeaturedCheckbox20

		global Text1
		global Text2
		global Text3
		global Text4
		global Text5
		global Text6
		global Text7
		global Text8
		global Text9
		global Text10
		global Text11
		global Text12
		global Text13
		global Text14
		global Text15
		global Text16
		global Text17
		global Text18
		global Text19
		global Text20
	}
	
	Build()
	{
		global
		
		;GUI Always on top variable
		;GUI_AOT := 1
		;Gui +AlwaysOnTop
		
		;Title
		Gui, Font, s14 w70, Arial
		Gui, Add, Text, x10 y4, Check Each Track to be featured (Max 9)
		Gui, Add, Text, x500 y20 vSelectedTracksCounter, 0 Selected
		;version
		Gui, Font, s10 w70, Arial
		Gui, Add, Text, x540 y0 w50 h20 +Right, %The_VersionName%
		
		;Menu
		Menu, FileMenu, Add, R&estart`tCtrl+R, Menu_File-Restart
		Menu, FileMenu, Add, E&xit`tCtrl+Q, Menu_File-Exit
		Menu, MyMenuBar, Add, &File, :FileMenu  ; Attach the sub-menu that was created above
		;Menu, Default , FileMenu
		
		Menu, HelpMenu, Add, &About, Menu_About
		Menu, HelpMenu, Add, &Confluence`tCtrl+H, Menu_Confluence
		Menu, MyMenuBar, Add, &Help, :HelpMenu
		Gui, Menu, MyMenuBar
		
		;Buttons
		Gui, Add, Button, x10 y30 gReadRDB, Read from DB
		;Gui, Add, Button, x130 y30 gAddTrack, Add Track
		;2nd row of buttons
		Gui, Add, Button, x10 y60 gSendToAllRDBs Default, Send to all DBs
		Gui, Add, Button, x130 y60 gCopyToClipBoard, Copy to ClipBoard

		;Create the size of the GUI
		Gui, Show, h700 w600 , %The_ProjectName%
		Return
		
		;Menu Shortcuts
		Menu_Confluence:
		Run http://confluence.tvg.com/
		Return
		
		Menu_About:
		Msgbox, changes featured tracks
		Return

		ReadRDB:
		Msgbox, Oops this does nothing at the moment. RDB Read/Write access is undefined.
		Return
	}

	Restart() {
		Menu_File-Restart:
		Reload
		Return
	}

	Close() {
		Menu_File-Exit:
		ExitApp
		GuiClose:
		ExitApp, 1
		Return
	}

	AddTrack() {
		global

		AddTrack:
		InputBox, OutputVar, Add Track, Type the Track Code Only please,,,400
		if (OutputVar != "") {
			FeaturedTracks_Obj.AddTrack(OutputVar)
			MainGUI.Update(FeaturedTracks_Obj.GiveAllTracks())
		}
		return
	}

	Resize(para_h, para_w) {
		Gui, Show, h%para_h% w%para_w% , %The_ProjectName%
		return
	}

	Update(para_Obj) {
		Update:
		;recieves an object with various information, redraws the gui
		Gui, Font, s20 w40, Arial
		;add each track to the GUI
		Loop, % para_Obj.MaxIndex() {
			
			gui_y := (A_Index * 40) + 80 ;+80 for some space up top
			Gui, Add, Checkbox, x20 y%gui_y% vFeaturedCheckbox%A_Index% gCheckBoxToggled,
			Gui, Add, Text, x80 y%gui_y% vText%A_Index%, % para_Obj[A_Index,"TrackCode"]
			Gui, Add, Text, x140 y%gui_y%, % "  -  " para_Obj[A_Index,"TrackName"]
			Gui, Add, Text, x500 y%gui_y%, % para_Obj[A_Index,"DayNight"]
		}
	}


	CheckBoxToggled() {
		global

		CheckBoxToggled:
		Gui, Submit, NoHide ;Save all Checkbox statuses

		;Count all the checkboxes and send any changes to ToggleFeatured method
		Counter := 0
		Loop, 20 {
			If (FeaturedCheckbox%A_Index% = 1) {
				GuiControlGet, OutputCheckStatus,,FeaturedCheckbox%A_Index%
				GuiControlGet, OutputTrackCode,,Text%A_Index%
				FeaturedTracks_Obj.ToggleFeatured(OutputTrackCode, OutputCheckStatus)
				Counter++
			}
		}
		;update the GUI with the total number of tracks selected
		GuiControl, Text, SelectedTracksCounter, %Counter% Selected
		return
	}

	SendToAllRDBs() {
		SendToAllRDBs:
		Msgbox, Oops this does nothing at the moment. RDB Read/Write access is undefined.
		return
	}



	CopyToClipBoard() {
		global

		CopyToClipBoard:
		;Array_GUI(FeaturedTracks_Obj.GiveAllTracks())
		FeaturedTracks_Obj.CreateClipboard()
		msgbox, % "Copied all this to your clipboard: `n" Clipboard
		return
	}
	



	;NOT NEEDED
	CopyObject(para_Obj) {
		Loop, para_Obj.MaxIndex() {
			this.Track_Array[A_Index,"TrackCode"] := para_Obj[A_Index,"TrackCode"]
			this.Track_Array[A_Index,"TrackName"] := para_Obj[A_Index,"TrackName"]
		}
	}
}