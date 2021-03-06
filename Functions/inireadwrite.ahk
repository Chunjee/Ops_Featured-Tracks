;/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\
;Ini Read/Write
;\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/
;Imports settings.ini or Argument specified file

Fn_InitializeIni(inifile = "settings.ini")
{
global
local key,temp
inisections:=0
 
	Loop,read,%inifile%
	{
		;Skip line if it contains a ; because it is a comment
		IfInString, A_LoopReadLine, `;
		{
		Continue
		}
		If regexmatch(A_Loopreadline,"\[(.*)?]")
		{
		inisections+= 1
		section%inisections%:=regexreplace(A_loopreadline,"(\[)(.*)?(])","$2")
		section%inisections%_keys:=0
		}
		Else If regexmatch(A_LoopReadLine,"(\w+)=(.*)")
		{
		section%inisections%_keys+= 1
		key:=section%inisections%_keys
		section%inisections%_key%key%:=regexreplace(A_LoopReadLine,"(\w+)=(.*)","$1")
		}
	}
}

Fn_LoadIni(inifile="settings.ini"){
global
local sec,var
	Loop,%inisections%
	{
	sec:=A_index
		Loop,% section%a_index%_keys
		{
		var:=section%sec% "_" section%sec%_key%A_index%,
		Stringreplace,var,var,%a_space%,,All
		iniread,%var%,%inifile%,% section%sec%,% section%sec%_key%A_index%
		}
	}
}

Fn_WriteIni(inifile="settings.ini"){
global
local sec,var
	Loop,%inisections%
	{
	sec:=A_index
		Loop,% section%a_index%_keys
		{
		var:=section%sec% "_" section%sec%_key%A_index%
		Stringreplace,var,var,%a_space%,,All
		var:=%var%
		iniwrite,%var%,%inifile%,% section%sec%,% section%sec%_key%A_index%
		}
	}
}