scriptName SkyVoxCommandShout extends SkyVoxCommandAlias hidden

import SkyVoxCore
import Game

; -------------------------------------
;
; > shout [id shout] [id sub-spell]
;
function OnSkyVoxCommand(string[] args)
	if(args[0] == "shout")
        processShout(args)
	endif
endfunction

Function processShout(string[] args) 
	if Game.GetPlayer().GetVoiceRecoveryTime()  == 0
		int idShout = args[1] as int
		int nthSpell = args[2] as int
		Shout shoutFound = SkyVoxCore.GetFormById(idShout) as Shout
		if Game.GetPlayer().HasSpell(shoutFound)
			Game.GetPlayer().DoCombatSpellApply(shoutFound.GetNthSpell(nthSpell), none)
			Game.GetPlayer().SetVoiceRecoveryTime(shoutFound.GetNthRecoveryTime(nthSpell))
		endif
	endif
EndFunction