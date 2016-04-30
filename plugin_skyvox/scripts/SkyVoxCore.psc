scriptName SkyVoxCore extends Quest hidden
{displays a multiple choice menu}

import Game

SkyVoxCommandAlias[] property commands auto Conditional

event OnInit()    
	print("game init 0")	
	Run()	
endevent 

Event OnPlayerLoadGame()
	print("game load 0")
	Run()	
endEvent

function Run()
	string command
	int nbCommands = commands.Length
   	While(True)
		command = SkyVoxScript.SkyPop()
		if(StringUtil.GetLength(command) > 1)
			print(command)
			int idCmd = 0
			string[] args = StringUtil.split(command, " ")
			while idCmd < nbCommands
				commands[idCmd].OnSkyVoxCommand(args)
				idCmd+=1
			endwhile
	   	endif
    	Utility.Wait(0.1)
   	EndWhile
endfunction
	


;====================================
;     Debugging and notification
function dbg(string m) Global
	if !Debug.traceUser("SkyVox", m)
		Debug.openUserLog("SkyVox")
		if !Debug.traceUser("SkyVox", m)
			Debug.trace("SkyVox: " + m)
		endif
	endif
endfunction

function print(string m) Global
	Debug.notification(m)
	dbg(m)
endfunction
;     Debugging and notification
;====================================



Form function GetFormById(int idItem) global
	Form item = Game.GetFormFromFile(idItem, "Skyrim.esm")
	if !item
		item = Game.GetFormFromFile(idItem, "Update.esm")
	endif
	if !item
		item = Game.GetFormFromFile(idItem, "HearthFires.esm")
	endif
	if !item
		item = Game.GetFormFromFile(idItem, "Dragonborn.esm")
	endif
	if !item
		item = Game.GetFormFromFile(idItem, "Dawnguard.esm")
	endif
	return item
endfunction


; If(StringUtil.Find(command, "moveto") == 0)
;			If(StringUtil.Find(command, "maison") > 0);
;				Game.GetPlayer().MoveTo(_HomeHijerim);
;			elseIf(StringUtil.Find(command, "maison blancherive") > 0)
;				Game.GetPlayer().MoveTo(_HomeHijerim)
	;		elseIf(StringUtil.Find(command, "blanche rive") > 0)
;				Game.GetPlayer().MoveTo(_WhiteRun)
;			EndIf
;		
;		elseIf(StringUtil.Find(command, "shout") == 0)
 ;       ;Game.GetPlayer().DoCombatSpellApply(_SHOUT_LOKVAHKOOR, Game.GetPlayer())

  ;  else